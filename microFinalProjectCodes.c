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
#define BUZZER_DDR DDRD
#define BUZZER_PRT PORTD
#define BUZZER_NUM 7
#define MENU_PAGE_COUNT 3

void lcdCommand(unsigned char cmnd);
void lcdData(unsigned char data);
void lcd_init();
void lcd_gotoxy(unsigned char x, unsigned char y);
void lcd_print(char *str);
void LCM35_init();
void show_temp();
void show_menu();
void clear_eeprom();
unsigned char read_byte_from_eeprom(unsigned int addr);
void write_byte_to_eeprom(unsigned int addr, unsigned char value);
void USART_init(unsigned int ubrr);
void USART_Transmit(unsigned char data);
unsigned char search_student_code();

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
unsigned char page_num = 0;

enum stages
{
    STAGE_INIT_MENU,
    STAGE_ATTENDENC_MENU,
    STAGE_SUBMIT_CODE,
    STAGE_TEMPERATURE_MONITORING,
    STAGE_VIEW_PRESENT_STUDENTS,
    STAGE_RETRIEVE_STUDENT_DATA,
    STAGE_STUDENT_MANAGMENT,
    STAGE_SEARCH_STUDENT,
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
    int i, j;
    unsigned char st_counts;
    KEY_DDR = 0xF0;
    KEY_PRT = 0xFF;
    KEY_PRT &= 0x0F;    // ground all rows at once
    MCUCR = 0x02;       // make INT0 falling edge triggered
    GICR = (1 << INT0); // enable external interrupt 0
    BUZZER_DDR |= (1 << BUZZER_NUM); //make buzzer pin output
    BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
    lcd_init();
    USART_init(0x33);
    

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
            lcd_print("1 : Submit Student Code");
            lcd_gotoxy(1, 2);
            lcd_print("    press cancel to back");
            while (stage == STAGE_ATTENDENC_MENU)
                ;
        }
        else if (stage == STAGE_SUBMIT_CODE)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Enter your student code:");
            lcd_gotoxy(1, 2);
            lcdCommand(0x0f);   // display on, cursor blinking
            delay_us(100 * 16); // wait
            while (stage == STAGE_SUBMIT_CODE)
                ;
            lcdCommand(0x0c);   // display on, cursor off
            delay_us(100 * 16); // wait
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
            lcd_gotoxy(1, 2);
            st_counts = read_byte_from_eeprom(0x0);
            memset(buffer, 0, 32);
            itoa(st_counts, buffer);
            lcd_print(buffer);
            delay_ms(1000);

            for (i = 0; i < st_counts; i++)
            {
                memset(buffer, 0, 32);
                for (j = 0; j < 8; j++)
                {
                    buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
                }
                buffer[j] = '\0';
                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print(buffer);
                delay_ms(1000);
            }

            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Press Cancel To Go Back");
            while (stage == STAGE_VIEW_PRESENT_STUDENTS)
                ;
        }
        else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Start Transferring...");
            st_counts = read_byte_from_eeprom(0x0);
            for (i = 0; i < st_counts; i++)
            {
                for (j = 0; j < 8; j++)
                {
                    USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
                }
                USART_Transmit('\r');
                USART_Transmit('\r');
                delay_ms(500);
            }
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Usart Transmit Finished");
            delay_ms(2000);
            stage = STAGE_INIT_MENU;
        }
        else if (stage == STAGE_STUDENT_MANAGMENT)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("1 : Search Student");
            lcd_gotoxy(1, 2);
            lcd_print("    Press Cancel To Back");
            while (stage == STAGE_STUDENT_MANAGMENT)
                ;
        }
        else if (stage == STAGE_SEARCH_STUDENT)
        {
            lcdCommand(0x01);
            lcd_gotoxy(1, 1);
            lcd_print("Enter Student Code For Search:");
            lcd_gotoxy(1, 2);
            lcdCommand(0x0f);   // display on, cursor blinking
            delay_us(100 * 16); // wait
            while (stage == STAGE_SEARCH_STUDENT)
                ;
            lcdCommand(0x0c);   // display on, cursor off
            delay_us(100 * 16); // wait
        }
    }
}

// int0 (keypad) service routine
interrupt[EXT_INT0] void int0_routine(void)
{
    unsigned char colloc, rowloc, cl, st_counts;
    int i;

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
        case OPTION_RETRIEVE_STUDENT_DATA:
            stage = STAGE_RETRIEVE_STUDENT_DATA;
            break;
        case OPTION_STUDENT_MANAGEMENT:
            stage = STAGE_STUDENT_MANAGMENT;
            break;
        case 9:
#asm("cli") // disable interrupts

            lcdCommand(0x1);
            lcd_gotoxy(1, 1);
            lcd_print("Clearing EEPROM ...");
            clear_eeprom();
#asm("sei") // enable interrupts

        default:
            break;
        }
        
        
        if(keypad[rowloc][cl] == 'L'){
            page_num = page_num > 0 ? page_num -1 : (MENU_PAGE_COUNT -1);
        }
         if(keypad[rowloc][cl] == 'R'){
            page_num = (page_num +1) % MENU_PAGE_COUNT;
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
            memset(buffer, 0, 32);
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
        
        #asm("cli")

            if (strncmp(buffer, "40", 2) != 0 ||
                strlen(buffer) != 8)
            {   
               
                BUZZER_PRT |= (1<<BUZZER_NUM); //turn on buzzer
                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print("Incorrect Suudent Code Format");
                lcd_gotoxy(1, 2);
                lcd_print("You Will Back Menu In 2 Second");
                delay_ms(2000);
                BUZZER_PRT &= ~(1<<BUZZER_NUM); //turn off buzzer
            }
            else if (search_student_code())
            { 
                BUZZER_PRT |= (1<<BUZZER_NUM); //turn on buzzer
                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print("Duplicate Suudent Code Entered");
                lcd_gotoxy(1, 2);
                lcd_print("You Will Back Menu In 2 Second");
                delay_ms(2000);
                BUZZER_PRT &= ~(1<<BUZZER_NUM); //turn off buzzer
            }
            else
            {
                // save the buffer to EEPROM
                st_counts = read_byte_from_eeprom(0x0);
                for (i = 0; i < 8; i++)
                {
                    write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
                }
                write_byte_to_eeprom(0x0, st_counts + 1);

                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print("Student Code Successfully Added");
                lcd_gotoxy(1, 2);
                lcd_print("You Will Back Menu In 2 Second");
                delay_ms(2000);
            }
            memset(buffer, 0, 32);
             #asm("sei")
            stage = STAGE_ATTENDENC_MENU;
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
    else if (stage == STAGE_STUDENT_MANAGMENT)
    {
        if (keypad[rowloc][cl] == 'C')
            stage = STAGE_INIT_MENU;
        else if (keypad[rowloc][cl] == '1')
            stage = STAGE_SEARCH_STUDENT;
    }
    else if (stage == STAGE_SEARCH_STUDENT)
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
            // search from eeprom data
            unsigned char result = search_student_code();

            if (result == 1)
            {
                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print("Student Code Found");
                lcd_gotoxy(1, 2);
                lcd_print("You Will Back Menu In 5 Second");
                delay_ms(5000);
            }
            else
            {
                lcdCommand(0x01);
                lcd_gotoxy(1, 1);
                lcd_print("Ops , Student Code Not Found");
                lcd_gotoxy(1, 2);
                lcd_print("You Will Back Menu In 5 Second");
                delay_ms(5000);
            }
            memset(buffer, 0, 32);
            stage = STAGE_STUDENT_MANAGMENT;
        }
        else if (keypad[rowloc][cl] == 'C')
            stage = STAGE_STUDENT_MANAGMENT;
    }
}

void lcdCommand(unsigned char cmnd)
{
    LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
    LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
    LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1 * 16);          // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
    delay_us(20 * 16);         // wait
    LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1 * 16);          // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
}
void lcdData(unsigned char data)
{
    LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
    LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
    LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1 * 16);          // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
    LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
    LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
    delay_us(1 * 16);          // wait to make EN wider
    LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
}
void lcd_init()
{
    LCD_DDR = 0xFF;            // LCD port is output
    LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
    delay_us(2000 * 16);       // wait for stable power
    lcdCommand(0x33);          //$33 for 4-bit mode
    delay_us(100 * 16);        // wait
    lcdCommand(0x32);          //$32 for 4-bit mode
    delay_us(100 * 16);        // wait
    lcdCommand(0x28);          //$28 for 4-bit mode
    delay_us(100 * 16);        // wait
    lcdCommand(0x0c);          // display on, cursor off
    delay_us(100 * 16);        // wait
    lcdCommand(0x01);          // clear LCD
    delay_us(2000 * 16);       // wait
    lcdCommand(0x06);          // shift cursor right
    delay_us(100 * 16);
}
void lcd_gotoxy(unsigned char x, unsigned char y)
{
    unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
    lcdCommand(firstCharAdr[y - 1] + x - 1);
    delay_us(100 * 16);
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
        delay_ms(500);
    }
}

void show_menu()
{
    
    while (stage == STAGE_INIT_MENU)
    {
        lcdCommand(0x01);
        lcd_gotoxy(1, 1);
        if (page_num == 0)
        {
            lcd_print("1: Attendance Initialization");
            lcd_gotoxy(1, 2);
            lcd_print("2: Student Management");
            while(page_num==0 && stage == STAGE_INIT_MENU);
            
        }
        else if (page_num == 1)
        {
            lcd_print("3: View Present Students ");
            lcd_gotoxy(1, 2);
            lcd_print("4: Temperature Monitoring");
             while(page_num==1 && stage == STAGE_INIT_MENU);
           
        }
        else if (page_num == 2)
        {
            lcd_print("5: Retrieve Student Data");
            lcd_gotoxy(1, 2);
            lcd_print("6: Traffic Monitoring");
            while(page_num==2 && stage == STAGE_INIT_MENU);
           
        }
    }
}

void clear_eeprom()
{
    unsigned int i;
    for (i = 0; i <= 1023; i++)
    {
        // Wait for the previous write to complete
        while (EECR & (1 << EEWE))
            ;

        // Set up address registers
        EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
        EEARL = i & 0xFF;        // Low byte (bits 0-7)

        // Set up data register
        EEDR = 0; // Write 0 to EEPROM

        // Enable write
        EECR |= (1 << EEMWE); // Master write enable
        EECR |= (1 << EEWE);  // Start EEPROM write
    }
}

unsigned char read_byte_from_eeprom(unsigned int addr)
{
    unsigned char x;
    // Wait for the previous write to complete
    while (EECR & (1 << EEWE))
        ;

    // Set up address registers
    EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
    EEARL = addr & 0xFF;        // Low byte (bits 0-7)
    EECR |= (1 << EERE);        // Read Enable
    x = EEDR;
    return x;
}

void write_byte_to_eeprom(unsigned int addr, unsigned char value)
{
    // Wait for the previous write to complete
    while (EECR & (1 << EEWE))
        ;

    // Set up address registers
    EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
    EEARL = addr & 0xFF;        // Low byte (bits 0-7)

    // Set up data register
    EEDR = value; // Write 0 to EEPROM

    // Enable write
    EECR |= (1 << EEMWE); // Master write enable
    EECR |= (1 << EEWE);  // Start EEPROM write
}

void USART_Transmit(unsigned char data)
{
    while (!(UCSRA & (1 << UDRE)))
        ;
    UDR = data;
}

void USART_init(unsigned int ubrr)
{
    UBRRL = (unsigned char)ubrr;
    UBRRH = (unsigned char)(ubrr >> 8);
    UCSRB = (1 << RXEN) | (1 << TXEN);
    UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
}

unsigned char search_student_code()
{
    unsigned char st_counts, i, j;
    char temp[32];

    st_counts = read_byte_from_eeprom(0x0);

    for (i = 0; i < st_counts; i++)
    {
        memset(temp, 0, 32);
        for (j = 0; j < 8; j++)
        {
            temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
        }
        temp[j] = '\0';
        if (strcmp(temp, buffer) == 0)
            return 1;
    }

    return 0;
}
