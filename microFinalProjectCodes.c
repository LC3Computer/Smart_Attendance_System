#include <io.h>
#include <delay.h>
#include <mega32.h>
#include <stdlib.h>
#include <string.h>
#include <eeprom.h>

#define LCD_PRT PORTB // LCD DATA PORT
#define LCD_DDR DDRB  // LCD DATA DDR
#define LCD_PIN PINB  // LCD DATA PIN
#define LCD_RS 0      // LCD RS
#define LCD_RW 1      // LCD RW
#define LCD_EN 2      // LCD EN
#define KEY_PRT PORTC // keyboard PORT
#define KEY_DDR DDRC  // keyboard DDR
#define KEY_PIN PINC  // keyboard PIN

void lcdCommand(unsigned char cmnd);
void lcdData(unsigned char data);
void lcd_init();
void lcd_gotoxy(unsigned char x, unsigned char y);
void lcd_print(char *str);
void LCM35_init();
void show_temp();
void show_menu();

/* keypad mapping :
C : Cancel
O : On/Clear
D : Delete
L : Left
R : Right
E : Enter  */
unsigned char keypad[4][4] = {'7', '8', '9', 'O',
                              '4', '5', '6', 'D',
                              '1', '2', '3', 'C',
                              'L', '0', 'R', 'E'};

unsigned int stage = 0;
char buffer[32] = "";

char EEMEM eepromStudentCodes[200] = "";
unsigned char studentCounts = 0;

enum stages
{
    STAGE_INIT_MENU,
    STAGE_ATTENDENC_MENU,
    STAGE_SUBMIT_CODE,
    STAGE_TEMPERATURE_MONITORING,
    STAGE_VIEW_PRESENT_STUDENTS,
};
enum menu_options
{
    OPTION_ATTENDENCE = 1,
    OPTION_STUDENT_MANAGEMENT = 2,
    OPTION_VIEW_PRESENT_STUDENTS = 3,
    OPTION_TEMPERATURE_MONITORING = 4,
    OPTION_RETRIEVE_STUDENT_DATA = 5,
    OPTION_TRAFFIC_MONITORING = 6,
};

void main(void)
{
    unsigned char i;
    KEY_DDR = 0xF0;
    KEY_PRT = 0xFF;
    KEY_PRT &= 0x0F;    // ground all rows at once
    MCUCR = 0x02;       // make INT0 falling edge triggered
    GICR = (1 << INT0); // enable external interrupt 0
    lcd_init();

#asm("sei")           // enable interrupts
    lcdCommand(0x01); // clear LCD
    LCM35_init();
    while (1)
    {
        if (stage == STAGE_INIT_MENU)
        {
            show_menu();
        }
        else if (stage == STAGE_ATTENDENC_MENU)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("1:submit student code");
            lcd_gotoxy(1, 2);
            lcd_print("press cancel to back");
            while (stage == STAGE_ATTENDENC_MENU)
                ;
        }
        else if (stage == STAGE_SUBMIT_CODE)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Enter your student code:");
            lcd_gotoxy(1, 2);
            lcdCommand(0x0f);  // display on, cursor blinking
            delay_us(100 * 8); // wait
            while (stage == STAGE_SUBMIT_CODE)
                ;
            lcdCommand(0x0c);  // display on, cursor off
            delay_us(100 * 8); // wait
        }
        else if (stage == STAGE_TEMPERATURE_MONITORING)
        {
            show_temp();
        }
        else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Number of students : ");

            for (i = 0; i < studentCounts; i++)
            {
                eeprom_read_block(buffer, (&eepromStudentCodes)+i, 9);

                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print(buffer);
                delay_ms(300);
            }
            lcd_print("Press cancel to go back");
            while (stage == STAGE_VIEW_PRESENT_STUDENTS)
                ;
        }
    }
}

// int0 (keypad) service routine
interrupt[EXT_INT0] void int0_routine(void)
{
    unsigned char colloc, rowloc, cl , i;

    // detect the key
    while (1)
    {
        KEY_PRT = 0xEF;            // ground row 0
        colloc = (KEY_PIN & 0x0F); // read the columns
        if (colloc != 0x0F)        // column detected
        {
            rowloc = 0; // save row location
            break;      // exit while loop
        }
        KEY_PRT = 0xDF;            // ground row 1
        colloc = (KEY_PIN & 0x0F); // read the columns
        if (colloc != 0x0F)        // column detected
        {
            rowloc = 1; // save row location
            break;      // exit while loop
        }
        KEY_PRT = 0xBF;            // ground row 2
        colloc = (KEY_PIN & 0x0F); // read the columns
        if (colloc != 0x0F)        // column detected
        {
            rowloc = 2; // save row location
            break;      // exit while loop
        }
        KEY_PRT = 0x7F;            // ground row 3
        colloc = (KEY_PIN & 0x0F); // read the columns
        rowloc = 3;                // save row location
        break;                     // exit while loop
    }
    // check column and send result to Port D
    if (colloc == 0x0E)
        cl = 0;
    else if (colloc == 0x0D)
        cl = 1;
    else if (colloc == 0x0B)
        cl = 2;
    else
        cl = 3;

    KEY_PRT &= 0x0F; // ground all rows at once

    // inside menu level 1
    if (stage == STAGE_INIT_MENU)
    {
        switch (keypad[rowloc][cl] - '0')
        {
        case OPTION_ATTENDENCE:
            stage = STAGE_ATTENDENC_MENU;
            break;

        case OPTION_TEMPERATURE_MONITORING:
            stage = STAGE_TEMPERATURE_MONITORING;
            break;
        case OPTION_VIEW_PRESENT_STUDENTS:
            stage = STAGE_VIEW_PRESENT_STUDENTS;
            break;

        default:
            break;
        }
    }
    else if (stage == STAGE_ATTENDENC_MENU)
    {
        switch (keypad[rowloc][cl])
        {
        case 'C':
            stage = STAGE_INIT_MENU;
            break;
        case '1':
            stage = STAGE_SUBMIT_CODE;
            break;
        default:
            break;
        }
    }
    else if (stage == STAGE_SUBMIT_CODE)
    {

        if ((keypad[rowloc][cl] - '0') < 10)
        {

            if (strlen(buffer) <= 30)
            {
                buffer[strlen(buffer)] = keypad[rowloc][cl];
                buffer[strlen(buffer) + 1] = '\0';
                lcdData(keypad[rowloc][cl]);
            }
        }
        else if (keypad[rowloc][cl] == 'E')
        {
            // save the buffer to EEPROM
            eeprom_write_block((const void *)buffer, (eeprom void *)((&eepromStudentCodes)+studentCounts), 9);
            studentCounts++;
            stage = STAGE_INIT_MENU;
        }
        else if (keypad[rowloc][cl] == 'C')
            stage = STAGE_ATTENDENC_MENU;
    }
    else if (stage == STAGE_TEMPERATURE_MONITORING)
    {

        if (keypad[rowloc][cl] == 'C')
            stage = STAGE_INIT_MENU;
    }
    else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
    {
        if (keypad[rowloc][cl] == 'C')
            stage = STAGE_INIT_MENU;
    }
}

void lcdCommand(unsigned char cmnd)
{
    LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
    LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
    LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1);               // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
    delay_us(20);              // wait
    LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1);               // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
}
void lcdData(unsigned char data)
{
    LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
    LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
    LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1);               // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
    LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1);               // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
}
void lcd_init()
{
    LCD_DDR = 0xFF;            // LCD port is output
    LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
    delay_us(2000);            // wait for stable power
    lcdCommand(0x33);          //$33 for 4-bit mode
    delay_us(100 * 8);         // wait
    lcdCommand(0x32);          //$32 for 4-bit mode
    delay_us(100 * 8);         // wait
    lcdCommand(0x28);          //$28 for 4-bit mode
    delay_us(100 * 8);         // wait
    lcdCommand(0x0c);          // display on, cursor off
    delay_us(100 * 8);         // wait
    lcdCommand(0x01);          // clear LCD
    delay_us(2000);            // wait
    lcdCommand(0x06);          // shift cursor right
    delay_us(100 * 8);
}
void lcd_gotoxy(unsigned char x, unsigned char y)
{
    unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
    lcdCommand(firstCharAdr[y - 1] + x - 1);
    delay_us(100 * 8);
}
void lcd_print(char *str)
{
    unsigned char i = 0;
    while (str[i] != 0)
    {
        lcdData(str[i]);
        i++;
    }
}

void LCM35_init()
{
    ADMUX = 0xE0;
    ADCSRA = 0x87;
}

void show_temp()
{
    unsigned char temperatureVal = 0;
    unsigned char temperatureRep[3];

    while (stage == STAGE_TEMPERATURE_MONITORING)
    {
        lcdCommand(0x01);
        lcd_gotoxy(1, 1);
        lcd_print("Temp(C):");
        ADCSRA |= (1 << ADSC);
        while ((ADCSRA & (1 << ADIF)) == 0)
            ;
        temperatureVal = ADCH;
        itoa(temperatureVal, temperatureRep);
        lcd_print(temperatureRep);
        delay_ms(100);
    }
}

void show_menu()
{
    unsigned char page_num = 0;
    while (stage == STAGE_INIT_MENU)
    {
        lcdCommand(0x01);
        lcd_gotoxy(1, 1);
        if (page_num == 0)
        {
            lcd_print("1: Attendance Initialization");
            lcd_gotoxy(1, 2);
            lcd_print("2: Student Management");
            if (stage == STAGE_INIT_MENU)
                delay_ms(250);
            page_num = (page_num + 1) % 3;
        }
        else if (page_num == 1)
        {
            lcd_print("3: View Present Students ");
            lcd_gotoxy(1, 2);
            lcd_print("4: Temperature Monitoring");
            if (stage == STAGE_INIT_MENU)
                delay_ms(250);
            page_num = (page_num + 1) % 3;
        }
        else if (page_num == 2)
        {
            lcd_print("5: Retrieve Student Data");
            lcd_gotoxy(1, 2);
            lcd_print("6: Traffic Monitoring");
            if (stage == STAGE_INIT_MENU)
                delay_ms(250);
            page_num = (page_num + 1) % 3;
        }
    }
}
