
# Smart Attendance System with AVR Microcontroller  

![System Demo Screenshot](https://github.com/user-attachments/assets/138f18fb-b7a5-4655-9aaa-a492bd696e6b)  
[![Project Demo Video](https://img.shields.io/badge/Watch-Demo-red)](https://github.com/user-attachments/assets/b59a6b9f-54ea-471e-b054-7dbb25250943)

## 📋 Table of Contents
1. [Project Overview](#-project-overview)
2. [Key Features](#-key-features)
3. [Hardware Components](#-hardware-components)
4. [Setup & Simulation](#-setup--simulation)
5. [Course Information](#-course-information)

---

## 🚀 Project Overview
An intelligent attendance tracking system built around the ATmega32 microcontroller that combines:  

✅ **Automated attendance management** with time-limited registration  
✅ **Environmental monitoring** (temperature & room occupancy)  
✅ **Multiple input methods** (Keypad + Simulated RFID)  
✅ **Persistent data storage** using EEPROM and USART communication  

Designed for educational environments to streamline attendance while monitoring classroom conditions.

---

## ✨ Key Features

### ⏱ Smart Attendance Tracking
- Configurable registration time window
- Dual input methods:
  - 8-digit keypad entry
  - RFID simulation (via virtual terminal)
- Real-time validation with audio/visual feedback

### 👨‍🎓 Student Management
- **Search function**: Check individual attendance status
- **Data maintenance**: Delete student records
- **Attendance reports**: View present students with timestamps

### 🌡 Environmental Monitoring
- Real-time temperature readings (LM35 sensor)
- Classroom traffic analysis (Ultrasonic sensor)
- Continuous LCD display of sensor data

### 🔄 Data Handling
- EEPROM storage for persistent records
- USART communication for data export
- System status feedback via LCD messages

---

## 🔧 Hardware Components
| Component | Usage |
|-----------|-------|
| ATmega32 MCU | System brain |
| LM017L LCD | User interface display |
| 4x4 Keypad | Student ID input |
| Buzzer | Audio feedback |
| HCSR04 Ultrasonic | People counting |
| LM35 | Temperature sensing |
| DS1307 RTC | Timekeeping |
| Virtual Terminals | RFID simulation & data monitoring |

---


## 💻 Setup & Simulation

### Requirements
- Proteus 8 Professional
- CodeVisionAVR (or compatible compiler)

### Step-by-Step Guide
1. **Clone the repository**:
   ```bash
   git clone https://github.com/LC3Computer/Smart_Attendance_System.git
   cd Smart_Attendance_System
   ```

2. **Open the Proteus simulation**:
   - Launch `microFinalProjectProteusSimulate.pdsprj`

3. **Compile the source code**:
   - Open in CodeVisionAVR
   - Generate new `.hex` file

4. **Configure the MCU**:
   - Set clock frequency to **8MHz**
   - Load the compiled `.hex` file

5. **Run the simulation**:
   - Interact via keypad
   - Monitor LCD and virtual terminals
   - Observe sensor responses

> **Note**: The RFID functionality is simulated through virtual terminals in the Proteus environment.

---

## 🎓 Course Information
**Microprocessor Course**  
Isfahan University of Technology  
Electrical Engineering Department  

*Project demonstrates practical application of:*
- AVR microcontroller programming
- Peripheral interfacing (sensors, displays)
- Real-time system design
- Embedded data management
```

