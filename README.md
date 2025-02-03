# Smart Attendance System Project

![bandicam 2025-01-28 13-49-44-641](https://github.com/user-attachments/assets/138f18fb-b7a5-4655-9aaa-a492bd696e6b)
---
## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Project Demo](#project-demo)
4. [Components Used](#components-used)
5. [Installation and Usage](#installation-and-usage)
---
## Project Overview

This project leverages the features of the AVR microcontroller (ATmega32) to create an efficient system for:
- **Tracking student attendance** during classes.
- **Monitoring traffic and temperature** in real-time.
- **Providing user-friendly interactions** through a keypad, LCD and also RFID.
- **Ensuring data persistence** with EEPROM storage and USART communication.
---

## Features

1. **Attendance Initialization**:
   - The system prompts the user to set a specific time limit for attendance registration. Students must register their attendance before the timer expires. Once the time is up, attendance registration will automatically close, and the system will display a summary of the registered students.
   - **Submit Student Code**:
     - Students can enter their unique 8-digit ID via the keypad or using RFID which is simulated via virtual terminal.
     - The system validates the ID format. If the input is invalid (e.g., incorrect length or format), an error message is displayed on the LCD, and the buzzer provides audio feedback.
   - **Exit**:
     - Allows users to return to the main menu without making any changes.

2. **Student Management**:
   - **Search Students**:
      - Enter a student ID to check if the student is present or absent.
   - **Delete Students**:
      - Enter a student ID to delete it from the records.
   - **Exit**:
     - This option allows users to return to the main menu.

3. **View Present Students**:
   - Displays the total number of present students along with the time of submit code.
   - Lists the IDs of present students on the LCD, updating dynamically.

4. **Temperature Monitoring**:
   - Displays real-time environmental temperature using the LM35 sensor.
   - Temperature values are converted from ADC readings and updated on the LCD.

5. **Retrieve Student Data**:
   - Fetch stored student data from EEPROM.
   - Transfer data via USART to external systems. Success or error messages are displayed on the LCD.

6. **Traffic Monitoring**:
   - Monitors real-time classroom traffic using an ultrasonic sensor.
   - Traffic data is displayed on the LCD for better classroom management.
---

## Project Demo


https://github.com/user-attachments/assets/b59a6b9f-54ea-471e-b054-7dbb25250943


---

## Components Used

- **Keypad**: For entering student IDs and navigating the menu. the keypad has been customized for this usage.
- **LCD (LM017L)**: For displaying system states and user instructions.
- **Buzzer**: For audio feedback and error notifications.
- **Ultrasonic Sensor (HCSR04)**: For monitoring traffic.
- **Temperature Sensor (LM35)**: For environmental temperature tracking.
- **Virtual Terminals**: For simulating RFID and also showing EEPROM data.
- **RTC (DS1307)**: For capturing time.
- **Crystal**: A 32.768kHz crystal has been used for RTC.
---

## Installation and Usage

1. **Clone this repository**:

   ```bash
   git clone https://github.com/LC3Computer/Smart_Attendance_System.git
   
2. **Open the Proteus Simulation**:

    Open the `microFinalProjectProteusSimulate.pdsprj` file in **Proteus** to view and simulate the project.

3. **Compile the Source Code**:

   - Open the source files in **Code Vision**.
   - Compile the project to generate a new `.hex` file.

4. **Load the Hex File**:

   - Inside the Proteus simulation, double-click on the ATmega32 microcontroller.
   - In the configuration window, browse to the location of the newly compiled `.hex` file.
   - Apply the settings and close the configuration window.
   - Pay attention that micro clock frequency should be set in 8 MHz.

5. **Run the Simulation**:

   - Press the play button in **Proteus** to run the simulation.
   - Interact with the system using the keypad and observe the LCD, buzzer, and other components.
