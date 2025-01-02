
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 450 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x01C2
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _stage=R5
	.DEF _page_num=R4
	.DEF _US_count=R7
	.DEF _logged_in=R6
	.DEF _submitTime=R9
	.DEF _timerCount=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _int0_routine
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x5

_0x3:
	.DB  0x37,0x38,0x39,0x4F,0x34,0x35,0x36,0x44
	.DB  0x31,0x32,0x33,0x43,0x4C,0x30,0x52,0x45
_0x5:
	.DB  LOW(_0x4),HIGH(_0x4),LOW(_0x4+4),HIGH(_0x4+4),LOW(_0x4+8),HIGH(_0x4+8),LOW(_0x4+12),HIGH(_0x4+12)
	.DB  LOW(_0x4+16),HIGH(_0x4+16),LOW(_0x4+20),HIGH(_0x4+20),LOW(_0x4+24),HIGH(_0x4+24)
_0x17D:
	.DB  0xFF,0xFF
_0x0:
	.DB  0x53,0x75,0x6E,0x0,0x4D,0x6F,0x6E,0x0
	.DB  0x54,0x75,0x65,0x0,0x57,0x65,0x64,0x0
	.DB  0x54,0x68,0x75,0x0,0x46,0x72,0x69,0x0
	.DB  0x53,0x61,0x74,0x0,0x31,0x3A,0x20,0x53
	.DB  0x75,0x62,0x6D,0x69,0x74,0x20,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x0,0x32,0x3A,0x20,0x53,0x75
	.DB  0x62,0x6D,0x69,0x74,0x20,0x57,0x69,0x74
	.DB  0x68,0x20,0x43,0x61,0x72,0x64,0x0,0x54
	.DB  0x69,0x6D,0x65,0x20,0x66,0x6F,0x72,0x20
	.DB  0x73,0x75,0x62,0x6D,0x69,0x74,0x20,0x69
	.DB  0x73,0x20,0x66,0x69,0x6E,0x69,0x73,0x68
	.DB  0x65,0x64,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x79,0x6F,0x75,0x72,0x20,0x73,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x63,0x6F
	.DB  0x64,0x65,0x3A,0x0,0x42,0x72,0x69,0x6E
	.DB  0x67,0x20,0x79,0x6F,0x75,0x72,0x20,0x63
	.DB  0x61,0x72,0x64,0x20,0x6E,0x65,0x61,0x72
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x3A
	.DB  0x0,0x34,0x30,0x0,0x49,0x6E,0x76,0x61
	.DB  0x6C,0x69,0x64,0x20,0x43,0x61,0x72,0x64
	.DB  0x0,0x44,0x75,0x70,0x6C,0x69,0x63,0x61
	.DB  0x74,0x65,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x0
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x61,0x64,0x64,0x65,0x64,0x20,0x77,0x69
	.DB  0x74,0x68,0x20,0x49,0x44,0x3A,0x0,0x4E
	.DB  0x75,0x6D,0x62,0x65,0x72,0x20,0x6F,0x66
	.DB  0x20,0x73,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x73,0x20,0x3A,0x20,0x0,0x50,0x72,0x65
	.DB  0x73,0x73,0x20,0x43,0x61,0x6E,0x63,0x65
	.DB  0x6C,0x20,0x54,0x6F,0x20,0x47,0x6F,0x20
	.DB  0x42,0x61,0x63,0x6B,0x0,0x53,0x74,0x61
	.DB  0x72,0x74,0x20,0x54,0x72,0x61,0x6E,0x73
	.DB  0x66,0x65,0x72,0x72,0x69,0x6E,0x67,0x2E
	.DB  0x2E,0x2E,0x0,0x55,0x73,0x61,0x72,0x74
	.DB  0x20,0x54,0x72,0x61,0x6E,0x73,0x6D,0x69
	.DB  0x74,0x20,0x46,0x69,0x6E,0x69,0x73,0x68
	.DB  0x65,0x64,0x0,0x31,0x3A,0x20,0x53,0x65
	.DB  0x61,0x72,0x63,0x68,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x0,0x32,0x3A,0x20
	.DB  0x44,0x65,0x6C,0x65,0x74,0x65,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x43,0x6F,0x64
	.DB  0x65,0x20,0x46,0x6F,0x72,0x20,0x53,0x65
	.DB  0x61,0x72,0x63,0x68,0x3A,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x46,0x6F,0x72,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x3A,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x53,0x65,0x63,0x72,0x65
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x28
	.DB  0x6F,0x72,0x20,0x63,0x61,0x6E,0x63,0x65
	.DB  0x6C,0x29,0x0,0x31,0x20,0x3A,0x20,0x43
	.DB  0x6C,0x65,0x61,0x72,0x20,0x45,0x45,0x50
	.DB  0x52,0x4F,0x4D,0x0,0x20,0x20,0x20,0x20
	.DB  0x70,0x72,0x65,0x73,0x73,0x20,0x63,0x61
	.DB  0x6E,0x63,0x65,0x6C,0x20,0x74,0x6F,0x20
	.DB  0x62,0x61,0x63,0x6B,0x0,0x53,0x65,0x74
	.DB  0x20,0x54,0x69,0x6D,0x65,0x72,0x28,0x6D
	.DB  0x69,0x6E,0x75,0x74,0x65,0x73,0x29,0x3A
	.DB  0x20,0x0,0x25,0x30,0x32,0x78,0x3A,0x25
	.DB  0x30,0x32,0x78,0x3A,0x25,0x30,0x32,0x78
	.DB  0x20,0x20,0x0,0x32,0x30,0x25,0x30,0x32
	.DB  0x78,0x2F,0x25,0x30,0x32,0x78,0x2F,0x25
	.DB  0x30,0x32,0x78,0x20,0x20,0x25,0x33,0x73
	.DB  0x0,0x4C,0x6F,0x67,0x6F,0x75,0x74,0x20
	.DB  0x2E,0x2E,0x2E,0x0,0x47,0x6F,0x69,0x6E
	.DB  0x67,0x20,0x54,0x6F,0x20,0x41,0x64,0x6D
	.DB  0x69,0x6E,0x20,0x50,0x61,0x67,0x65,0x20
	.DB  0x49,0x6E,0x20,0x32,0x20,0x53,0x65,0x63
	.DB  0x0,0x49,0x6E,0x63,0x6F,0x72,0x72,0x65
	.DB  0x63,0x74,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x46,0x6F,0x72,0x6D,0x61,0x74,0x0,0x59
	.DB  0x6F,0x75,0x20,0x57,0x69,0x6C,0x6C,0x20
	.DB  0x42,0x61,0x63,0x6B,0x20,0x4D,0x65,0x6E
	.DB  0x75,0x20,0x49,0x6E,0x20,0x32,0x20,0x53
	.DB  0x65,0x63,0x6F,0x6E,0x64,0x0,0x44,0x75
	.DB  0x70,0x6C,0x69,0x63,0x61,0x74,0x65,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x45,0x6E,0x74
	.DB  0x65,0x72,0x65,0x64,0x0,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x43,0x6F,0x64
	.DB  0x65,0x20,0x53,0x75,0x63,0x63,0x65,0x73
	.DB  0x73,0x66,0x75,0x6C,0x6C,0x79,0x20,0x41
	.DB  0x64,0x64,0x65,0x64,0x0,0x59,0x6F,0x75
	.DB  0x20,0x4D,0x75,0x73,0x74,0x20,0x46,0x69
	.DB  0x72,0x73,0x74,0x20,0x4C,0x6F,0x67,0x69
	.DB  0x6E,0x0,0x59,0x6F,0x75,0x20,0x57,0x69
	.DB  0x6C,0x6C,0x20,0x47,0x6F,0x20,0x41,0x64
	.DB  0x6D,0x69,0x6E,0x20,0x50,0x61,0x67,0x65
	.DB  0x20,0x32,0x20,0x53,0x65,0x63,0x0,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x46,0x6F,0x75,0x6E
	.DB  0x64,0x0,0x4F,0x70,0x73,0x20,0x2C,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x4E,0x6F,0x74
	.DB  0x20,0x46,0x6F,0x75,0x6E,0x64,0x0,0x57
	.DB  0x61,0x69,0x74,0x20,0x46,0x6F,0x72,0x20
	.DB  0x44,0x65,0x6C,0x65,0x74,0x65,0x2E,0x2E
	.DB  0x2E,0x0,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x57
	.DB  0x61,0x73,0x20,0x44,0x65,0x6C,0x65,0x74
	.DB  0x65,0x64,0x0,0x54,0x69,0x6D,0x65,0x72
	.DB  0x20,0x73,0x74,0x61,0x72,0x74,0x65,0x64
	.DB  0x0,0x4C,0x6F,0x67,0x69,0x6E,0x20,0x53
	.DB  0x75,0x63,0x63,0x65,0x73,0x73,0x66,0x75
	.DB  0x6C,0x6C,0x79,0x0,0x57,0x61,0x69,0x74
	.DB  0x2E,0x2E,0x2E,0x0,0x4F,0x70,0x73,0x20
	.DB  0x2C,0x20,0x73,0x65,0x63,0x72,0x65,0x74
	.DB  0x20,0x69,0x73,0x20,0x69,0x6E,0x63,0x6F
	.DB  0x72,0x72,0x65,0x63,0x74,0x0,0x43,0x6C
	.DB  0x65,0x61,0x72,0x69,0x6E,0x67,0x20,0x45
	.DB  0x45,0x50,0x52,0x4F,0x4D,0x20,0x2E,0x2E
	.DB  0x2E,0x0,0x54,0x65,0x6D,0x70,0x65,0x72
	.DB  0x61,0x74,0x75,0x72,0x65,0x28,0x43,0x29
	.DB  0x3A,0x0,0x31,0x3A,0x20,0x41,0x74,0x74
	.DB  0x65,0x6E,0x64,0x61,0x6E,0x63,0x65,0x20
	.DB  0x49,0x6E,0x69,0x74,0x69,0x61,0x6C,0x69
	.DB  0x7A,0x61,0x74,0x69,0x6F,0x6E,0x0,0x32
	.DB  0x3A,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x4D,0x61,0x6E,0x61,0x67,0x65
	.DB  0x6D,0x65,0x6E,0x74,0x0,0x33,0x3A,0x20
	.DB  0x56,0x69,0x65,0x77,0x20,0x50,0x72,0x65
	.DB  0x73,0x65,0x6E,0x74,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x73,0x20,0x0,0x34
	.DB  0x3A,0x20,0x54,0x65,0x6D,0x70,0x65,0x72
	.DB  0x61,0x74,0x75,0x72,0x65,0x20,0x4D,0x6F
	.DB  0x6E,0x69,0x74,0x6F,0x72,0x69,0x6E,0x67
	.DB  0x0,0x35,0x3A,0x20,0x52,0x65,0x74,0x72
	.DB  0x69,0x65,0x76,0x65,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x44,0x61,0x74
	.DB  0x61,0x0,0x36,0x3A,0x20,0x54,0x72,0x61
	.DB  0x66,0x66,0x69,0x63,0x20,0x4D,0x6F,0x6E
	.DB  0x69,0x74,0x6F,0x72,0x69,0x6E,0x67,0x0
	.DB  0x37,0x3A,0x20,0x4C,0x6F,0x67,0x69,0x6E
	.DB  0x20,0x57,0x69,0x74,0x68,0x20,0x41,0x64
	.DB  0x6D,0x69,0x6E,0x0,0x38,0x3A,0x20,0x4C
	.DB  0x6F,0x67,0x6F,0x75,0x74,0x0,0x39,0x3A
	.DB  0x20,0x53,0x65,0x74,0x20,0x54,0x69,0x6D
	.DB  0x65,0x72,0x0,0x44,0x69,0x73,0x74,0x61
	.DB  0x6E,0x63,0x65,0x3A,0x20,0x0,0x45,0x72
	.DB  0x72,0x6F,0x72,0x0,0x4E,0x6F,0x20,0x4F
	.DB  0x62,0x73,0x74,0x61,0x63,0x6C,0x65,0x0
	.DB  0x20,0x63,0x6D,0x20,0x0,0x43,0x6F,0x75
	.DB  0x6E,0x74,0x3A,0x20,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x04
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x4+4
	.DW  _0x0*2+4

	.DW  0x04
	.DW  _0x4+8
	.DW  _0x0*2+8

	.DW  0x04
	.DW  _0x4+12
	.DW  _0x0*2+12

	.DW  0x04
	.DW  _0x4+16
	.DW  _0x0*2+16

	.DW  0x04
	.DW  _0x4+20
	.DW  _0x0*2+20

	.DW  0x04
	.DW  _0x4+24
	.DW  _0x0*2+24

	.DW  0x0E
	.DW  _days
	.DW  _0x5*2

	.DW  0x17
	.DW  _0xC
	.DW  _0x0*2+28

	.DW  0x14
	.DW  _0xC+23
	.DW  _0x0*2+51

	.DW  0x1C
	.DW  _0xC+43
	.DW  _0x0*2+71

	.DW  0x19
	.DW  _0xC+71
	.DW  _0x0*2+99

	.DW  0x1C
	.DW  _0xC+96
	.DW  _0x0*2+71

	.DW  0x1D
	.DW  _0xC+124
	.DW  _0x0*2+124

	.DW  0x03
	.DW  _0xC+153
	.DW  _0x0*2+153

	.DW  0x0D
	.DW  _0xC+156
	.DW  _0x0*2+156

	.DW  0x17
	.DW  _0xC+169
	.DW  _0x0*2+169

	.DW  0x17
	.DW  _0xC+192
	.DW  _0x0*2+192

	.DW  0x16
	.DW  _0xC+215
	.DW  _0x0*2+215

	.DW  0x18
	.DW  _0xC+237
	.DW  _0x0*2+237

	.DW  0x16
	.DW  _0xC+261
	.DW  _0x0*2+261

	.DW  0x18
	.DW  _0xC+283
	.DW  _0x0*2+283

	.DW  0x12
	.DW  _0xC+307
	.DW  _0x0*2+307

	.DW  0x12
	.DW  _0xC+325
	.DW  _0x0*2+325

	.DW  0x1F
	.DW  _0xC+343
	.DW  _0x0*2+343

	.DW  0x1F
	.DW  _0xC+374
	.DW  _0x0*2+374

	.DW  0x1E
	.DW  _0xC+405
	.DW  _0x0*2+405

	.DW  0x11
	.DW  _0xC+435
	.DW  _0x0*2+435

	.DW  0x19
	.DW  _0xC+452
	.DW  _0x0*2+452

	.DW  0x15
	.DW  _0xC+477
	.DW  _0x0*2+477

	.DW  0x0B
	.DW  _0x86
	.DW  _0x0*2+537

	.DW  0x1D
	.DW  _0x86+11
	.DW  _0x0*2+548

	.DW  0x02
	.DW  _0x86+40
	.DW  _0x0*2+235

	.DW  0x02
	.DW  _0x86+42
	.DW  _0x0*2+235

	.DW  0x03
	.DW  _0x86+44
	.DW  _0x0*2+153

	.DW  0x1E
	.DW  _0x86+47
	.DW  _0x0*2+577

	.DW  0x1F
	.DW  _0x86+77
	.DW  _0x0*2+607

	.DW  0x1F
	.DW  _0x86+108
	.DW  _0x0*2+638

	.DW  0x1F
	.DW  _0x86+139
	.DW  _0x0*2+607

	.DW  0x20
	.DW  _0x86+170
	.DW  _0x0*2+669

	.DW  0x1F
	.DW  _0x86+202
	.DW  _0x0*2+607

	.DW  0x15
	.DW  _0x86+233
	.DW  _0x0*2+701

	.DW  0x1D
	.DW  _0x86+254
	.DW  _0x0*2+722

	.DW  0x02
	.DW  _0x86+283
	.DW  _0x0*2+235

	.DW  0x02
	.DW  _0x86+285
	.DW  _0x0*2+235

	.DW  0x13
	.DW  _0x86+287
	.DW  _0x0*2+751

	.DW  0x1F
	.DW  _0x86+306
	.DW  _0x0*2+607

	.DW  0x1D
	.DW  _0x86+337
	.DW  _0x0*2+770

	.DW  0x1F
	.DW  _0x86+366
	.DW  _0x0*2+607

	.DW  0x02
	.DW  _0x86+397
	.DW  _0x0*2+235

	.DW  0x02
	.DW  _0x86+399
	.DW  _0x0*2+235

	.DW  0x13
	.DW  _0x86+401
	.DW  _0x0*2+751

	.DW  0x13
	.DW  _0x86+420
	.DW  _0x0*2+799

	.DW  0x19
	.DW  _0x86+439
	.DW  _0x0*2+818

	.DW  0x1F
	.DW  _0x86+464
	.DW  _0x0*2+607

	.DW  0x1D
	.DW  _0x86+495
	.DW  _0x0*2+770

	.DW  0x1F
	.DW  _0x86+524
	.DW  _0x0*2+607

	.DW  0x03
	.DW  _0x86+555
	.DW  _0x0*2+512

	.DW  0x03
	.DW  _0x86+558
	.DW  _0x0*2+512

	.DW  0x0E
	.DW  _0x86+561
	.DW  _0x0*2+843

	.DW  0x02
	.DW  _0x86+575
	.DW  _0x0*2+235

	.DW  0x02
	.DW  _0x86+577
	.DW  _0x0*2+235

	.DW  0x13
	.DW  _0x86+579
	.DW  _0x0*2+857

	.DW  0x08
	.DW  _0x86+598
	.DW  _0x0*2+876

	.DW  0x1A
	.DW  _0x86+606
	.DW  _0x0*2+884

	.DW  0x1F
	.DW  _0x86+632
	.DW  _0x0*2+607

	.DW  0x14
	.DW  _0x86+663
	.DW  _0x0*2+910

	.DW  0x10
	.DW  _0x121
	.DW  _0x0*2+930

	.DW  0x02
	.DW  _0x121+16
	.DW  _0x0*2+235

	.DW  0x1D
	.DW  _0x12D
	.DW  _0x0*2+946

	.DW  0x16
	.DW  _0x12D+29
	.DW  _0x0*2+975

	.DW  0x1A
	.DW  _0x12D+51
	.DW  _0x0*2+997

	.DW  0x1A
	.DW  _0x12D+77
	.DW  _0x0*2+1023

	.DW  0x19
	.DW  _0x12D+103
	.DW  _0x0*2+1049

	.DW  0x16
	.DW  _0x12D+128
	.DW  _0x0*2+1074

	.DW  0x14
	.DW  _0x12D+150
	.DW  _0x0*2+1096

	.DW  0x0A
	.DW  _0x12D+170
	.DW  _0x0*2+1116

	.DW  0x0D
	.DW  _0x12D+180
	.DW  _0x0*2+1126

	.DW  0x02
	.DW  _previous_count_S0000015000
	.DW  _0x17D*2

	.DW  0x0B
	.DW  _0x17E
	.DW  _0x0*2+1139

	.DW  0x06
	.DW  _0x17E+11
	.DW  _0x0*2+1150

	.DW  0x0C
	.DW  _0x17E+17
	.DW  _0x0*2+1156

	.DW  0x05
	.DW  _0x17E+29
	.DW  _0x0*2+1168

	.DW  0x08
	.DW  _0x17E+34
	.DW  _0x0*2+1173

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x222

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <mega32.h>
;#include <stdlib.h>
;#include <string.h>
;#include <eeprom.h>
;#include <stdint.h>
;#include <stdio.h>
;
;#define LCD_PRT PORTA // LCD DATA PORT
;#define LCD_DDR DDRA  // LCD DATA DDR
;#define LCD_PIN PINA  // LCD DATA PIN
;#define LCD_RS 0      // LCD RS
;#define LCD_RW 1      // LCD RW
;#define LCD_EN 2      // LCD EN
;#define KEY_PRT PORTB // keyboard PORT
;#define KEY_DDR DDRB  // keyboard DDR
;#define KEY_PIN PINB  // keyboard PIN
;#define BUZZER_DDR DDRD
;#define BUZZER_PRT PORTD
;#define BUZZER_NUM 7
;#define MENU_PAGE_COUNT 5
;#define US_ERROR -1       // Error indicator
;#define US_NO_OBSTACLE -2 // No obstacle indicator
;#define US_PORT PORTD     // Ultrasonic sensor connected to PORTB
;#define US_PIN PIND       // Ultrasonic PIN register
;#define US_DDR DDRD       // Ultrasonic data direction register
;#define US_TRIG_POS 5     // Trigger pin connected to PD5
;#define US_ECHO_POS 6     // Echo pin connected to PD6
;
;void lcdCommand(unsigned char cmnd);
;void lcdData(unsigned char data);
;void lcd_init();
;void lcd_gotoxy(unsigned char x, unsigned char y);
;void lcd_print(char *str);
;void show_temperature();
;void show_menu();
;void clear_eeprom();
;unsigned char read_byte_from_eeprom(unsigned int addr);
;void write_byte_to_eeprom(unsigned int addr, unsigned char value);
;void USART_init(unsigned int ubrr);
;void USART_Transmit(unsigned char data);
;unsigned char USART_Receive();
;unsigned char search_student_code();
;void delete_student_code(unsigned char index);
;void HCSR04Init();
;void HCSR04Trigger();
;uint16_t GetPulseWidth();
;void startSonar();
;unsigned int simple_hash(const char *str);
;void I2C_init();
;void I2C_start();
;void I2C_write(unsigned char data);
;unsigned char I2C_read(unsigned char ackVal);
;void I2C_stop();
;void rtc_init();
;void rtc_getTime(unsigned char*, unsigned char*, unsigned char*);
;void rtc_getDate(unsigned char*, unsigned char*, unsigned char*, unsigned char*);
;void Timer2_Init();
;
;/* keypad mapping :
;C : Cancel
;O : On/Clear
;D : Delete
;L : Left
;R : Right
;E : Enter  */
;unsigned char keypad[4][4] = {{'7', '8', '9', 'O'},
;                              {'4', '5', '6', 'D'},
;                              {'1', '2', '3', 'C'},
;                              {'L', '0', 'R', 'E'}};

	.DSEG
;
;unsigned char stage = 0;
;char buffer[32] = "";
;unsigned char page_num = 0;
;unsigned char US_count = 0;
;const unsigned int secret = 3940;
;char logged_in = 0;
;char* days[7]= {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
_0x4:
	.BYTE 0x1C
;char time[20];
;unsigned char submitTime = 5;
;unsigned char timerCount = 0;
;
;enum stages
;{
;    STAGE_INIT_MENU,
;    STAGE_ATTENDENC_MENU,
;    STAGE_SUBMIT_CODE,
;    STAGE_SUBMIT_WITH_CARD,
;    STAGE_TEMPERATURE_MONITORING,
;    STAGE_VIEW_PRESENT_STUDENTS,
;    STAGE_RETRIEVE_STUDENT_DATA,
;    STAGE_STUDENT_MANAGMENT,
;    STAGE_SEARCH_STUDENT,
;    STAGE_DELETE_STUDENT,
;    STAGE_TRAFFIC_MONITORING,
;    STAGE_LOGIN_WITH_ADMIN,
;    STAGE_CLEAR_EEPROM,
;    STAGE_SHOW_CLOCK,
;    STAGE_SET_TIMER,
;};
;
;enum menu_options
;{
;    OPTION_ATTENDENCE = 1,
;    OPTION_STUDENT_MANAGEMENT = 2,
;    OPTION_VIEW_PRESENT_STUDENTS = 3,
;    OPTION_TEMPERATURE_MONITORING = 4,
;    OPTION_RETRIEVE_STUDENT_DATA = 5,
;    OPTION_TRAFFIC_MONITORING = 6,
;    OPTION_LOGIN_WITH_ADMIN = 7,
;    OPTION_LOGOUT = 8,
;    OPTION_SET_TIMER = 9,
;};
;
;void main(void)
; 0000 0075 {

	.CSEG
_main:
; .FSTART _main
; 0000 0076     int i, j;
; 0000 0077     unsigned char st_counts;
; 0000 0078     unsigned char data;
; 0000 0079     unsigned char second, minute, hour;
; 0000 007A     unsigned char day, date, month, year;
; 0000 007B 
; 0000 007C     KEY_DDR = 0xF0;
	SBIW R28,7
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
;	data -> R20
;	second -> Y+6
;	minute -> Y+5
;	hour -> Y+4
;	day -> Y+3
;	date -> Y+2
;	month -> Y+1
;	year -> Y+0
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 007D     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 007E     KEY_PRT &= 0x0F;                  // ground all rows at once
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 007F     MCUCR = 0x02;                     // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0080     GICR = (1 << INT0);               // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0081     BUZZER_DDR |= (1 << BUZZER_NUM);  // make buzzer pin output
	SBI  0x11,7
; 0000 0082     BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
	CBI  0x12,7
; 0000 0083     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	CALL _USART_init
; 0000 0084     HCSR04Init(); // Initialize ultrasonic sensor
	CALL _HCSR04Init
; 0000 0085     lcd_init();
	CALL _lcd_init
; 0000 0086     rtc_init();
	CALL _rtc_init
; 0000 0087 
; 0000 0088 #asm("sei")           // enable interrupts
	sei
; 0000 0089     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	CALL _lcdCommand
; 0000 008A     while (1)
_0x6:
; 0000 008B     {
; 0000 008C         if (stage == STAGE_INIT_MENU)
	TST  R5
	BRNE _0x9
; 0000 008D         {
; 0000 008E             show_menu();
	CALL _show_menu
; 0000 008F         }
; 0000 0090         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0xA
_0x9:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xB
; 0000 0091         {
; 0000 0092             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0093             lcd_gotoxy(1, 1);
; 0000 0094             lcd_print("1: Submit Student Code");
	__POINTW2MN _0xC,0
	CALL SUBOPT_0x1
; 0000 0095             lcd_gotoxy(1, 2);
; 0000 0096             lcd_print("2: Submit With Card");
	__POINTW2MN _0xC,23
	CALL _lcd_print
; 0000 0097             while (stage == STAGE_ATTENDENC_MENU)
_0xD:
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0xD
; 0000 0098                 ;
; 0000 0099         }
; 0000 009A         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x10
_0xB:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x11
; 0000 009B         {
; 0000 009C             if(submitTime == 0)
	TST  R9
	BRNE _0x12
; 0000 009D             {
; 0000 009E                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 009F                 lcd_gotoxy(1, 1);
; 0000 00A0                 lcd_print("Time for submit is finished");
	__POINTW2MN _0xC,43
	CALL SUBOPT_0x2
; 0000 00A1                 delay_ms(2000);
; 0000 00A2                 stage = STAGE_INIT_MENU;
; 0000 00A3             }
; 0000 00A4             lcdCommand(0x01);
_0x12:
	CALL SUBOPT_0x0
; 0000 00A5             lcd_gotoxy(1, 1);
; 0000 00A6             lcd_print("Enter your student code:");
	__POINTW2MN _0xC,71
	CALL SUBOPT_0x1
; 0000 00A7             lcd_gotoxy(1, 2);
; 0000 00A8             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 00A9             delay_us(100 * 16); // wait
; 0000 00AA             while (stage == STAGE_SUBMIT_CODE)
_0x13:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ _0x13
; 0000 00AB                 ;
; 0000 00AC             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x4
; 0000 00AD             delay_us(100 * 16); // wait
; 0000 00AE         }
; 0000 00AF         else if(stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0x16
_0x11:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x17
; 0000 00B0         {
; 0000 00B1             memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00B2             while (stage == STAGE_SUBMIT_WITH_CARD)
_0x18:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x1A
; 0000 00B3             {
; 0000 00B4                 if(submitTime == 0)
	TST  R9
	BRNE _0x1B
; 0000 00B5                 {
; 0000 00B6                     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00B7                     lcd_gotoxy(1, 1);
; 0000 00B8                     lcd_print("Time for submit is finished");
	__POINTW2MN _0xC,96
	CALL SUBOPT_0x2
; 0000 00B9                     delay_ms(2000);
; 0000 00BA                     stage = STAGE_INIT_MENU;
; 0000 00BB                     break;
	RJMP _0x1A
; 0000 00BC                 }
; 0000 00BD                 lcdCommand(0x01);
_0x1B:
	CALL SUBOPT_0x0
; 0000 00BE                 lcd_gotoxy(1, 1);
; 0000 00BF                 lcd_print("Bring your card near device:");
	__POINTW2MN _0xC,124
	CALL SUBOPT_0x1
; 0000 00C0                 lcd_gotoxy(1, 2);
; 0000 00C1                 delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 00C2                 while((data = USART_Receive()) != '\r'){
_0x1C:
	CALL _USART_Receive
	MOV  R20,R30
	CPI  R30,LOW(0xD)
	BREQ _0x1E
; 0000 00C3                     if(stage != STAGE_SUBMIT_WITH_CARD)
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x1E
; 0000 00C4                         break;
; 0000 00C5                     buffer[strlen(buffer)] = data;
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	ST   Z,R20
; 0000 00C6                 }
	RJMP _0x1C
_0x1E:
; 0000 00C7                 if(stage != STAGE_SUBMIT_WITH_CARD){
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x20
; 0000 00C8                     memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00C9                     break;
	RJMP _0x1A
; 0000 00CA                 }
; 0000 00CB                 if (strncmp(buffer, "40", 2) != 0 ||
_0x20:
; 0000 00CC                         strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0xC,153
	CALL SUBOPT_0x9
	BRNE _0x22
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x21
_0x22:
; 0000 00CD                 {
; 0000 00CE                     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00CF                     lcd_gotoxy(1, 1);
; 0000 00D0                     lcd_print("Invalid Card");
	__POINTW2MN _0xC,156
	CALL _lcd_print
; 0000 00D1                     BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00D2                     delay_ms(2000);
	CALL SUBOPT_0xA
; 0000 00D3                     BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00D4                 }
; 0000 00D5                 else{
	RJMP _0x24
_0x21:
; 0000 00D6                     if (search_student_code() > 0){
	CALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x25
; 0000 00D7                         BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00D8                         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00D9                         lcd_gotoxy(1, 1);
; 0000 00DA                         lcd_print("Duplicate Student Code");
	__POINTW2MN _0xC,169
	CALL SUBOPT_0xB
; 0000 00DB                         delay_ms(2000);
; 0000 00DC                         BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00DD                     }
; 0000 00DE                     else{
	RJMP _0x26
_0x25:
; 0000 00DF                         // save the buffer to EEPROM
; 0000 00E0                         st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 00E1                         for (i = 0; i < 8; i++)
	__GETWRN 16,17,0
_0x28:
	__CPWRN 16,17,8
	BRGE _0x29
; 0000 00E2                         {
; 0000 00E3                             write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R21
	CALL SUBOPT_0xD
	ADD  R30,R16
	ADC  R31,R17
	CALL SUBOPT_0xE
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _write_byte_to_eeprom
; 0000 00E4                         }
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
; 0000 00E5                         write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0xF
	MOV  R26,R21
	SUBI R26,-LOW(1)
	CALL _write_byte_to_eeprom
; 0000 00E6                         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00E7                         lcd_gotoxy(1, 1);
; 0000 00E8                         lcd_print("Student added with ID:");
	__POINTW2MN _0xC,192
	CALL SUBOPT_0x1
; 0000 00E9                         lcd_gotoxy(1, 2);
; 0000 00EA                         lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00EB                         delay_ms(3000); // wait
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00EC                     }
_0x26:
; 0000 00ED                 }
_0x24:
; 0000 00EE                 memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00EF             }
	RJMP _0x18
_0x1A:
; 0000 00F0         }
; 0000 00F1         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x2A
_0x17:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x2B
; 0000 00F2         {
; 0000 00F3             show_temperature();
	RCALL _show_temperature
; 0000 00F4         }
; 0000 00F5         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x2C
_0x2B:
	LDI  R30,LOW(5)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x2D
; 0000 00F6         {
; 0000 00F7             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00F8             lcd_gotoxy(1, 1);
; 0000 00F9             lcd_print("Number of students : ");
	__POINTW2MN _0xC,215
	CALL SUBOPT_0x1
; 0000 00FA             lcd_gotoxy(1, 2);
; 0000 00FB             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 00FC             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 00FD             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	CALL SUBOPT_0xE
	CALL _itoa
; 0000 00FE             lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00FF             delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0100 
; 0000 0101             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x2F:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x30
; 0000 0102             {
; 0000 0103                 memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0104                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x32:
	__CPWRN 18,19,8
	BRGE _0x33
; 0000 0105                 {
; 0000 0106                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0107                 }
	__ADDWRN 18,19,1
	RJMP _0x32
_0x33:
; 0000 0108                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0109                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 010A                 lcd_gotoxy(1, 1);
; 0000 010B                 lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 010C                 delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 010D             }
	__ADDWRN 16,17,1
	RJMP _0x2F
_0x30:
; 0000 010E 
; 0000 010F             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0110             lcd_gotoxy(1, 1);
; 0000 0111             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xC,237
	RCALL _lcd_print
; 0000 0112             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x34:
	LDI  R30,LOW(5)
	CP   R30,R5
	BREQ _0x34
; 0000 0113                 ;
; 0000 0114         }
; 0000 0115         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x37
_0x2D:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x38
; 0000 0116         {
; 0000 0117             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0118             lcd_gotoxy(1, 1);
; 0000 0119             lcd_print("Start Transferring...");
	__POINTW2MN _0xC,261
	RCALL _lcd_print
; 0000 011A             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 011B             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x3A:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x3B
; 0000 011C             {
; 0000 011D                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3D:
	__CPWRN 18,19,8
	BRGE _0x3E
; 0000 011E                 {
; 0000 011F                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0x12
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0120                 }
	__ADDWRN 18,19,1
	RJMP _0x3D
_0x3E:
; 0000 0121 
; 0000 0122                 USART_Transmit('\r');
	CALL SUBOPT_0x13
; 0000 0123                 USART_Transmit('\r');
; 0000 0124 
; 0000 0125                 delay_ms(500);
; 0000 0126             }
	__ADDWRN 16,17,1
	RJMP _0x3A
_0x3B:
; 0000 0127             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x40:
	__CPWRN 18,19,8
	BRGE _0x41
; 0000 0128             {
; 0000 0129                 USART_Transmit('=');
	LDI  R26,LOW(61)
	CALL _USART_Transmit
; 0000 012A             }
	__ADDWRN 18,19,1
	RJMP _0x40
_0x41:
; 0000 012B 
; 0000 012C             USART_Transmit('\r');
	CALL SUBOPT_0x13
; 0000 012D             USART_Transmit('\r');
; 0000 012E             delay_ms(500);
; 0000 012F 
; 0000 0130             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0131             lcd_gotoxy(1, 1);
; 0000 0132             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xC,283
	CALL SUBOPT_0x2
; 0000 0133             delay_ms(2000);
; 0000 0134             stage = STAGE_INIT_MENU;
; 0000 0135         }
; 0000 0136         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x42
_0x38:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0x43
; 0000 0137         {
; 0000 0138             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0139             lcd_gotoxy(1, 1);
; 0000 013A             lcd_print("1: Search Student");
	__POINTW2MN _0xC,307
	CALL SUBOPT_0x1
; 0000 013B             lcd_gotoxy(1, 2);
; 0000 013C             lcd_print("2: Delete Student");
	__POINTW2MN _0xC,325
	RCALL _lcd_print
; 0000 013D             while (stage == STAGE_STUDENT_MANAGMENT)
_0x44:
	LDI  R30,LOW(7)
	CP   R30,R5
	BREQ _0x44
; 0000 013E                 ;
; 0000 013F         }
; 0000 0140         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x47
_0x43:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x48
; 0000 0141         {
; 0000 0142             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0143             lcd_gotoxy(1, 1);
; 0000 0144             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xC,343
	CALL SUBOPT_0x1
; 0000 0145             lcd_gotoxy(1, 2);
; 0000 0146             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 0147             delay_us(100 * 16); // wait
; 0000 0148             while (stage == STAGE_SEARCH_STUDENT)
_0x49:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ _0x49
; 0000 0149                 ;
; 0000 014A             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x4
; 0000 014B             delay_us(100 * 16); // wait
; 0000 014C         }
; 0000 014D         else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0x4C
_0x48:
	LDI  R30,LOW(9)
	CP   R30,R5
	BRNE _0x4D
; 0000 014E         {
; 0000 014F             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0150             lcd_gotoxy(1, 1);
; 0000 0151             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xC,374
	CALL SUBOPT_0x1
; 0000 0152             lcd_gotoxy(1, 2);
; 0000 0153             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 0154             delay_us(100 * 16); // wait
; 0000 0155             while (stage == STAGE_DELETE_STUDENT)
_0x4E:
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ _0x4E
; 0000 0156                 ;
; 0000 0157             lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 0158             delay_us(100 * 16);
; 0000 0159         }
; 0000 015A         else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x51
_0x4D:
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x52
; 0000 015B         {
; 0000 015C             startSonar();
	CALL _startSonar
; 0000 015D             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 015E         }
; 0000 015F         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x53
_0x52:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x54
; 0000 0160         {
; 0000 0161             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0162             lcd_gotoxy(1, 1);
; 0000 0163             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xC,405
	CALL SUBOPT_0x1
; 0000 0164             lcd_gotoxy(1, 2);
; 0000 0165             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 0166             delay_us(100 * 16); // wait
; 0000 0167             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x55:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x58
	TST  R6
	BREQ _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 0168                 ;
	RJMP _0x55
_0x57:
; 0000 0169             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x5A
; 0000 016A             {
; 0000 016B                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 016C                 delay_us(100 * 16);
; 0000 016D                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 016E                 lcd_gotoxy(1, 1);
; 0000 016F                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xC,435
	CALL SUBOPT_0x1
; 0000 0170                 lcd_gotoxy(1, 2);
; 0000 0171                 lcd_print("    press cancel to back");
	__POINTW2MN _0xC,452
	RCALL _lcd_print
; 0000 0172                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x5B:
	LDI  R30,LOW(11)
	CP   R30,R5
	BREQ _0x5B
; 0000 0173                     ;
; 0000 0174             }
; 0000 0175             else
	RJMP _0x5E
_0x5A:
; 0000 0176             {
; 0000 0177                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 0178                 delay_us(100 * 16);
; 0000 0179             }
_0x5E:
; 0000 017A         }
; 0000 017B         else if (stage == STAGE_SET_TIMER)
	RJMP _0x5F
_0x54:
	LDI  R30,LOW(14)
	CP   R30,R5
	BRNE _0x60
; 0000 017C         {
; 0000 017D             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 017E             lcd_gotoxy(1, 1);
; 0000 017F             lcdCommand(0x0c); // display on, cursor off
	LDI  R26,LOW(12)
	RCALL _lcdCommand
; 0000 0180             itoa(submitTime, buffer);
	CALL SUBOPT_0x14
	CALL _itoa
; 0000 0181             lcd_print("Set Timer(minutes): ");
	__POINTW2MN _0xC,477
	RCALL _lcd_print
; 0000 0182             lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 0183             delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 0184             while(stage == STAGE_SET_TIMER);
_0x61:
	LDI  R30,LOW(14)
	CP   R30,R5
	BREQ _0x61
; 0000 0185             delay_us(100 * 16);
	CALL SUBOPT_0x6
; 0000 0186         }
; 0000 0187         else if(stage == STAGE_SHOW_CLOCK)
	RJMP _0x64
_0x60:
	LDI  R30,LOW(13)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x65
; 0000 0188         {
; 0000 0189             while(stage == STAGE_SHOW_CLOCK){
_0x66:
	LDI  R30,LOW(13)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x68
; 0000 018A                 lcdCommand(0x01);
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 018B                 rtc_getTime(&hour, &minute, &second);
	CALL SUBOPT_0x15
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	CALL _rtc_getTime
; 0000 018C                 sprintf(time, "%02x:%02x:%02x  ", hour, minute, second);
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,498
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	CALL SUBOPT_0x16
	LDD  R30,Y+13
	CALL SUBOPT_0x16
	LDD  R30,Y+18
	CALL SUBOPT_0x16
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 018D                 lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x17
; 0000 018E                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 018F                 rtc_getDate(&year, &month, &date, &day);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,9
	CALL _rtc_getDate
; 0000 0190                 sprintf(time, "20%02x/%02x/%02x  %3s", year, month, date, days[day - 1]);
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,515
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	CALL SUBOPT_0x16
	LDD  R30,Y+9
	CALL SUBOPT_0x16
	LDD  R30,Y+14
	CALL SUBOPT_0x16
	LDD  R30,Y+19
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_days)
	LDI  R27,HIGH(_days)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 0191                 lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0192                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 0193                 delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0194             }
	RJMP _0x66
_0x68:
; 0000 0195         }
; 0000 0196     }
_0x65:
_0x64:
_0x5F:
_0x53:
_0x51:
_0x4C:
_0x47:
_0x42:
_0x37:
_0x2C:
_0x2A:
_0x16:
_0x10:
_0xA:
	RJMP _0x6
; 0000 0197 }
_0x69:
	RJMP _0x69
; .FEND

	.DSEG
_0xC:
	.BYTE 0x1F2
;
;interrupt[TIM2_OVF] void timer2_ovf_isr(void)
; 0000 019A {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 019B     timerCount++;
	INC  R8
; 0000 019C     if(timerCount == 60){
	LDI  R30,LOW(60)
	CP   R30,R8
	BRNE _0x6A
; 0000 019D         submitTime--;
	DEC  R9
; 0000 019E         timerCount = 0;
	CLR  R8
; 0000 019F     }
; 0000 01A0     TCNT2 = 0;
_0x6A:
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01A1     if(submitTime == 0)
	TST  R9
	BRNE _0x6B
; 0000 01A2         TIMSK = 0;
	OUT  0x39,R30
; 0000 01A3 }
_0x6B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 01A7 {
_int0_routine:
; .FSTART _int0_routine
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 01A8     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 01A9     int i;
; 0000 01AA 
; 0000 01AB     // detect the key
; 0000 01AC     while (1)
	SBIW R28,2
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	i -> Y+6
; 0000 01AD     {
; 0000 01AE         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x18
; 0000 01AF         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01B0         if (colloc != 0x0F)        // column detected
	BREQ _0x6F
; 0000 01B1         {
; 0000 01B2             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 01B3             break;      // exit while loop
	RJMP _0x6E
; 0000 01B4         }
; 0000 01B5         KEY_PRT = 0xDF;            // ground row 1
_0x6F:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x18
; 0000 01B6         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01B7         if (colloc != 0x0F)        // column detected
	BREQ _0x70
; 0000 01B8         {
; 0000 01B9             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 01BA             break;      // exit while loop
	RJMP _0x6E
; 0000 01BB         }
; 0000 01BC         KEY_PRT = 0xBF;            // ground row 2
_0x70:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x18
; 0000 01BD         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01BE         if (colloc != 0x0F)        // column detected
	BREQ _0x71
; 0000 01BF         {
; 0000 01C0             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 01C1             break;      // exit while loop
	RJMP _0x6E
; 0000 01C2         }
; 0000 01C3         KEY_PRT = 0x7F;            // ground row 3
_0x71:
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 01C4         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 01C5         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 01C6         break;                     // exit while loop
; 0000 01C7     }
_0x6E:
; 0000 01C8     // check column and send result to Port D
; 0000 01C9     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x72
; 0000 01CA         cl = 0;
	LDI  R19,LOW(0)
; 0000 01CB     else if (colloc == 0x0D)
	RJMP _0x73
_0x72:
	CPI  R17,13
	BRNE _0x74
; 0000 01CC         cl = 1;
	LDI  R19,LOW(1)
; 0000 01CD     else if (colloc == 0x0B)
	RJMP _0x75
_0x74:
	CPI  R17,11
	BRNE _0x76
; 0000 01CE         cl = 2;
	LDI  R19,LOW(2)
; 0000 01CF     else
	RJMP _0x77
_0x76:
; 0000 01D0         cl = 3;
	LDI  R19,LOW(3)
; 0000 01D1 
; 0000 01D2     KEY_PRT &= 0x0F; // ground all rows at once
_0x77:
_0x75:
_0x73:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 01D3 
; 0000 01D4     // inside menu level 1
; 0000 01D5     if (stage == STAGE_INIT_MENU)
	TST  R5
	BREQ PC+2
	RJMP _0x78
; 0000 01D6     {
; 0000 01D7         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 01D8         {
; 0000 01D9         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7C
; 0000 01DA             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 01DB             break;
	RJMP _0x7B
; 0000 01DC         case OPTION_TEMPERATURE_MONITORING:
_0x7C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x7D
; 0000 01DD             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 01DE             break;
	RJMP _0x7B
; 0000 01DF         case OPTION_VIEW_PRESENT_STUDENTS:
_0x7D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7E
; 0000 01E0             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 01E1             break;
	RJMP _0x7B
; 0000 01E2         case OPTION_RETRIEVE_STUDENT_DATA:
_0x7E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x7F
; 0000 01E3             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 01E4             break;
	RJMP _0x7B
; 0000 01E5         case OPTION_STUDENT_MANAGEMENT:
_0x7F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x80
; 0000 01E6             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 01E7             break;
	RJMP _0x7B
; 0000 01E8         case OPTION_TRAFFIC_MONITORING:
_0x80:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x81
; 0000 01E9             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 01EA             break;
	RJMP _0x7B
; 0000 01EB         case OPTION_LOGIN_WITH_ADMIN:
_0x81:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x82
; 0000 01EC             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 01ED             break;
	RJMP _0x7B
; 0000 01EE         case OPTION_SET_TIMER:
_0x82:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x83
; 0000 01EF             stage = STAGE_SET_TIMER;
	LDI  R30,LOW(14)
	MOV  R5,R30
; 0000 01F0             break;
	RJMP _0x7B
; 0000 01F1         case OPTION_LOGOUT:
_0x83:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x87
; 0000 01F2 #asm("cli") // disable interrupts
	cli
; 0000 01F3             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x85
; 0000 01F4             {
; 0000 01F5                 lcdCommand(0x1);
	CALL SUBOPT_0x0
; 0000 01F6                 lcd_gotoxy(1, 1);
; 0000 01F7                 lcd_print("Logout ...");
	__POINTW2MN _0x86,0
	CALL SUBOPT_0x1
; 0000 01F8                 lcd_gotoxy(1, 2);
; 0000 01F9                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x86,11
	CALL SUBOPT_0x1A
; 0000 01FA                 delay_ms(2000);
; 0000 01FB                 logged_in = 0;
	CLR  R6
; 0000 01FC #asm("sei")
	sei
; 0000 01FD                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 01FE             }
; 0000 01FF             break;
_0x85:
; 0000 0200         default:
_0x87:
; 0000 0201             break;
; 0000 0202         }
_0x7B:
; 0000 0203 
; 0000 0204         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x88
; 0000 0205         {
; 0000 0206             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x89
	MOV  R30,R4
	LDI  R31,0
	SBIW R30,1
	RJMP _0x8A
_0x89:
	LDI  R30,LOW(4)
_0x8A:
	MOV  R4,R30
; 0000 0207         }
; 0000 0208         else if (keypad[rowloc][cl] == 'R')
	RJMP _0x8C
_0x88:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x8D
; 0000 0209         {
; 0000 020A             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	MOV  R4,R30
; 0000 020B         }
; 0000 020C         else if(keypad[rowloc][cl] == 'O')
	RJMP _0x8E
_0x8D:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x8F
; 0000 020D         {
; 0000 020E             stage = STAGE_SHOW_CLOCK;
	LDI  R30,LOW(13)
	MOV  R5,R30
; 0000 020F         }
; 0000 0210     }
_0x8F:
_0x8E:
_0x8C:
; 0000 0211     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x90
_0x78:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x91
; 0000 0212     {
; 0000 0213         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
; 0000 0214         {
; 0000 0215         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x95
; 0000 0216             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0217             break;
	RJMP _0x94
; 0000 0218         case '1':
_0x95:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x96
; 0000 0219             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 021A             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 021B             break;
	RJMP _0x94
; 0000 021C         case '2':
_0x96:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x98
; 0000 021D             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 021E             stage = STAGE_SUBMIT_WITH_CARD;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 021F             break;
; 0000 0220         default:
_0x98:
; 0000 0221             break;
; 0000 0222         }
_0x94:
; 0000 0223     }
; 0000 0224     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x99
_0x91:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x9A
; 0000 0225     {
; 0000 0226 
; 0000 0227         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9B
; 0000 0228         {
; 0000 0229             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 022A             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 022B         }
; 0000 022C         if ((keypad[rowloc][cl] - '0') < 10)
_0x9B:
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x9C
; 0000 022D         {
; 0000 022E             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0x9D
; 0000 022F             {
; 0000 0230                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 0231                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1D
; 0000 0232                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0233             }
; 0000 0234         }
_0x9D:
; 0000 0235         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x9E
_0x9C:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x9F
; 0000 0236         {
; 0000 0237             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 0238             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xA0
; 0000 0239             {
; 0000 023A                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1E
; 0000 023B                 lcdCommand(0x10);
; 0000 023C                 lcd_print(" ");
	__POINTW2MN _0x86,40
	CALL SUBOPT_0x1F
; 0000 023D                 lcdCommand(0x10);
; 0000 023E             }
; 0000 023F         }
_0xA0:
; 0000 0240         else if(keypad[rowloc][cl] == 'O')
	RJMP _0xA1
_0x9F:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xA2
; 0000 0241         {
; 0000 0242             lcdCommand(0xC0);
	CALL SUBOPT_0x20
; 0000 0243             for(i = 0; i < strlen(buffer); i++)
_0xA4:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x21
	BRSH _0xA5
; 0000 0244                 lcd_print(" ");
	__POINTW2MN _0x86,42
	RCALL _lcd_print
	CALL SUBOPT_0x22
	RJMP _0xA4
_0xA5:
; 0000 0245 lcdCommand(0xC0);
	CALL SUBOPT_0x23
; 0000 0246             memset(buffer, 0, 32);
; 0000 0247         }
; 0000 0248         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xA6
_0xA2:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0xA7
; 0000 0249         {
; 0000 024A 
; 0000 024B #asm("cli")
	cli
; 0000 024C 
; 0000 024D             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 024E                 strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0x86,44
	CALL SUBOPT_0x9
	BRNE _0xA9
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0xA8
_0xA9:
; 0000 024F             {
; 0000 0250 
; 0000 0251                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0252                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0253                 lcd_gotoxy(1, 1);
; 0000 0254                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x86,47
	CALL SUBOPT_0x1
; 0000 0255                 lcd_gotoxy(1, 2);
; 0000 0256                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,77
	CALL SUBOPT_0xB
; 0000 0257                 delay_ms(2000);
; 0000 0258                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 0259             }
; 0000 025A             else if (search_student_code() > 0)
	RJMP _0xAB
_0xA8:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0xAC
; 0000 025B             {
; 0000 025C                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 025D                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 025E                 lcd_gotoxy(1, 1);
; 0000 025F                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x86,108
	CALL SUBOPT_0x1
; 0000 0260                 lcd_gotoxy(1, 2);
; 0000 0261                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,139
	CALL SUBOPT_0xB
; 0000 0262                 delay_ms(2000);
; 0000 0263                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 0264             }
; 0000 0265             else
	RJMP _0xAD
_0xAC:
; 0000 0266             {
; 0000 0267                 // save the buffer to EEPROM
; 0000 0268                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0x24
	MOV  R18,R30
; 0000 0269                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xAF:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,8
	BRGE _0xB0
; 0000 026A                 {
; 0000 026B                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R18
	CALL SUBOPT_0xD
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LD   R26,Z
	RCALL _write_byte_to_eeprom
; 0000 026C                 }
	CALL SUBOPT_0x22
	RJMP _0xAF
_0xB0:
; 0000 026D                 write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0xF
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 026E 
; 0000 026F                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0270                 lcd_gotoxy(1, 1);
; 0000 0271                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x86,170
	CALL SUBOPT_0x1
; 0000 0272                 lcd_gotoxy(1, 2);
; 0000 0273                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,202
	CALL SUBOPT_0x1A
; 0000 0274                 delay_ms(2000);
; 0000 0275             }
_0xAD:
_0xAB:
; 0000 0276             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0277 #asm("sei")
	sei
; 0000 0278             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x19B
; 0000 0279         }
; 0000 027A         else if (keypad[rowloc][cl] == 'C')
_0xA7:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB2
; 0000 027B             stage = STAGE_ATTENDENC_MENU;
_0x19B:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 027C     }
_0xB2:
_0xA6:
_0xA1:
_0x9E:
; 0000 027D     else if (stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0xB3
_0x9A:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0xB4
; 0000 027E     {
; 0000 027F         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB5
; 0000 0280         {
; 0000 0281             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0282             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0283         }
; 0000 0284     }
_0xB5:
; 0000 0285     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0xB6
_0xB4:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0xB7
; 0000 0286     {
; 0000 0287         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB8
; 0000 0288             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0289     }
_0xB8:
; 0000 028A     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0xB9
_0xB7:
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0xBA
; 0000 028B     {
; 0000 028C         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBB
; 0000 028D             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 028E     }
_0xBB:
; 0000 028F     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0xBC
_0xBA:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0xBD
; 0000 0290     {
; 0000 0291         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBE
; 0000 0292             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0293         else if (keypad[rowloc][cl] == '1')
	RJMP _0xBF
_0xBE:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0xC0
; 0000 0294             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(8)
	RJMP _0x19C
; 0000 0295         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0xC0:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xC3
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0xC4
_0xC3:
	RJMP _0xC2
_0xC4:
; 0000 0296             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(9)
	RJMP _0x19C
; 0000 0297         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0xC2:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xC7
	TST  R6
	BREQ _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
; 0000 0298         {
; 0000 0299             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 029A             lcd_gotoxy(1, 1);
; 0000 029B             lcd_print("You Must First Login");
	__POINTW2MN _0x86,233
	CALL SUBOPT_0x1
; 0000 029C             lcd_gotoxy(1, 2);
; 0000 029D             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x86,254
	CALL SUBOPT_0x1A
; 0000 029E             delay_ms(2000);
; 0000 029F             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
_0x19C:
	MOV  R5,R30
; 0000 02A0         }
; 0000 02A1     }
_0xC6:
_0xBF:
; 0000 02A2     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0xC9
_0xBD:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xCA
; 0000 02A3     {
; 0000 02A4         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCB
; 0000 02A5         {
; 0000 02A6             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02A7             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x19D
; 0000 02A8         }
; 0000 02A9         else if ((keypad[rowloc][cl] - '0') < 10)
_0xCB:
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xCD
; 0000 02AA         {
; 0000 02AB             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xCE
; 0000 02AC             {
; 0000 02AD                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 02AE                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1D
; 0000 02AF                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02B0             }
; 0000 02B1         }
_0xCE:
; 0000 02B2         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xCF
_0xCD:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xD0
; 0000 02B3         {
; 0000 02B4             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 02B5             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xD1
; 0000 02B6             {
; 0000 02B7                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1E
; 0000 02B8                 lcdCommand(0x10);
; 0000 02B9                 lcd_print(" ");
	__POINTW2MN _0x86,283
	CALL SUBOPT_0x1F
; 0000 02BA                 lcdCommand(0x10);
; 0000 02BB             }
; 0000 02BC         }
_0xD1:
; 0000 02BD         else if (keypad[rowloc][cl] == 'O')
	RJMP _0xD2
_0xD0:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xD3
; 0000 02BE         {
; 0000 02BF             lcdCommand(0xC0);
	CALL SUBOPT_0x20
; 0000 02C0             for(i = 0; i < strlen(buffer); i++)
_0xD5:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x21
	BRSH _0xD6
; 0000 02C1                 lcd_print(" ");
	__POINTW2MN _0x86,285
	RCALL _lcd_print
	CALL SUBOPT_0x22
	RJMP _0xD5
_0xD6:
; 0000 02C2 lcdCommand(0xC0);
	CALL SUBOPT_0x23
; 0000 02C3             memset(buffer, 0, 32);
; 0000 02C4         }
; 0000 02C5         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xD7
_0xD3:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xD8
; 0000 02C6         {
; 0000 02C7             // search from eeprom data
; 0000 02C8             unsigned char result = search_student_code();
; 0000 02C9 
; 0000 02CA             if (result > 0)
	CALL SUBOPT_0x25
;	i -> Y+7
;	result -> Y+0
	BRLO _0xD9
; 0000 02CB             {
; 0000 02CC                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 02CD                 lcd_gotoxy(1, 1);
; 0000 02CE                 lcd_print("Student Code Found");
	__POINTW2MN _0x86,287
	CALL SUBOPT_0x1
; 0000 02CF                 lcd_gotoxy(1, 2);
; 0000 02D0                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,306
	RJMP _0x19E
; 0000 02D1                 delay_ms(2000);
; 0000 02D2             }
; 0000 02D3             else
_0xD9:
; 0000 02D4             {
; 0000 02D5                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 02D6                 lcd_gotoxy(1, 1);
; 0000 02D7                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x86,337
	CALL SUBOPT_0x1
; 0000 02D8                 lcd_gotoxy(1, 2);
; 0000 02D9                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,366
_0x19E:
	RCALL _lcd_print
; 0000 02DA                 delay_ms(2000);
	CALL SUBOPT_0x26
; 0000 02DB             }
; 0000 02DC             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02DD             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 02DE         }
	ADIW R28,1
; 0000 02DF         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xDB
_0xD8:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xDC
; 0000 02E0             stage = STAGE_STUDENT_MANAGMENT;
_0x19D:
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 02E1     }
_0xDC:
_0xDB:
_0xD7:
_0xD2:
_0xCF:
; 0000 02E2     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xDD
_0xCA:
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xDE
; 0000 02E3     {
; 0000 02E4         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xDF
; 0000 02E5         {
; 0000 02E6             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02E7             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 02E8         }
; 0000 02E9         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xE0
_0xDF:
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xE1
; 0000 02EA         {
; 0000 02EB             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xE2
; 0000 02EC             {
; 0000 02ED                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 02EE                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1D
; 0000 02EF                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02F0             }
; 0000 02F1         }
_0xE2:
; 0000 02F2         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xE3
_0xE1:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xE4
; 0000 02F3         {
; 0000 02F4             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 02F5             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xE5
; 0000 02F6             {
; 0000 02F7                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1E
; 0000 02F8                 lcdCommand(0x10);
; 0000 02F9                 lcd_print(" ");
	__POINTW2MN _0x86,397
	CALL SUBOPT_0x1F
; 0000 02FA                 lcdCommand(0x10);
; 0000 02FB             }
; 0000 02FC         }
_0xE5:
; 0000 02FD         else if (keypad[rowloc][cl] == 'O')
	RJMP _0xE6
_0xE4:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xE7
; 0000 02FE         {
; 0000 02FF             lcdCommand(0xC0);
	CALL SUBOPT_0x20
; 0000 0300             for(i = 0; i < strlen(buffer); i++)
_0xE9:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x21
	BRSH _0xEA
; 0000 0301                 lcd_print(" ");
	__POINTW2MN _0x86,399
	RCALL _lcd_print
	CALL SUBOPT_0x22
	RJMP _0xE9
_0xEA:
; 0000 0302 lcdCommand(0xC0);
	CALL SUBOPT_0x23
; 0000 0303             memset(buffer, 0, 32);
; 0000 0304         }
; 0000 0305         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xEB
_0xE7:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xEC
; 0000 0306         {
; 0000 0307             // search from eeprom data
; 0000 0308             unsigned char result = search_student_code();
; 0000 0309 
; 0000 030A             if (result > 0)
	CALL SUBOPT_0x25
;	i -> Y+7
;	result -> Y+0
	BRLO _0xED
; 0000 030B             {
; 0000 030C                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 030D                 lcd_gotoxy(1, 1);
; 0000 030E                 lcd_print("Student Code Found");
	__POINTW2MN _0x86,401
	CALL SUBOPT_0x1
; 0000 030F                 lcd_gotoxy(1, 2);
; 0000 0310                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x86,420
	RCALL _lcd_print
; 0000 0311                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 0312                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0313                 lcd_gotoxy(1, 1);
; 0000 0314                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x86,439
	CALL SUBOPT_0x1
; 0000 0315                 lcd_gotoxy(1, 2);
; 0000 0316                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,464
	RJMP _0x19F
; 0000 0317                 delay_ms(2000);
; 0000 0318             }
; 0000 0319             else
_0xED:
; 0000 031A             {
; 0000 031B                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 031C                 lcd_gotoxy(1, 1);
; 0000 031D                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x86,495
	CALL SUBOPT_0x1
; 0000 031E                 lcd_gotoxy(1, 2);
; 0000 031F                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,524
_0x19F:
	RCALL _lcd_print
; 0000 0320                 delay_ms(2000);
	CALL SUBOPT_0x26
; 0000 0321             }
; 0000 0322             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0323             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0324         }
	ADIW R28,1
; 0000 0325     }
_0xEC:
_0xEB:
_0xE6:
_0xE3:
_0xE0:
; 0000 0326     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0xEF
_0xDE:
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0xF0
; 0000 0327     {
; 0000 0328         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xF1
; 0000 0329             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 032A     }
_0xF1:
; 0000 032B     else if (stage == STAGE_SHOW_CLOCK)
	RJMP _0xF2
_0xF0:
	LDI  R30,LOW(13)
	CP   R30,R5
	BRNE _0xF3
; 0000 032C     {
; 0000 032D         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xF4
; 0000 032E             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 032F     }
_0xF4:
; 0000 0330     else if (stage == STAGE_SET_TIMER)
	RJMP _0xF5
_0xF3:
	LDI  R30,LOW(14)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xF6
; 0000 0331     {
; 0000 0332         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xF7
; 0000 0333         {
; 0000 0334             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0335             stage = STAGE_INIT_MENU;
	RJMP _0x1A0
; 0000 0336         }
; 0000 0337 
; 0000 0338         else if(keypad[rowloc][cl] == 'R')
_0xF7:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0xF9
; 0000 0339         {
; 0000 033A             if(submitTime < 20){
	LDI  R30,LOW(20)
	CP   R9,R30
	BRSH _0xFA
; 0000 033B                 submitTime++;
	INC  R9
; 0000 033C                 itoa(submitTime, buffer);
	CALL SUBOPT_0x14
	CALL _itoa
; 0000 033D                 lcd_gotoxy(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x17
; 0000 033E                 lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 033F                 lcd_print("  ");
	__POINTW2MN _0x86,555
	RCALL _lcd_print
; 0000 0340             }
; 0000 0341         }
_0xFA:
; 0000 0342         else if(keypad[rowloc][cl] == 'L')
	RJMP _0xFB
_0xF9:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0xFC
; 0000 0343         {
; 0000 0344             if(submitTime > 1){
	LDI  R30,LOW(1)
	CP   R30,R9
	BRSH _0xFD
; 0000 0345                 submitTime--;
	DEC  R9
; 0000 0346                 itoa(submitTime, buffer);
	CALL SUBOPT_0x14
	CALL _itoa
; 0000 0347                 lcd_gotoxy(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x17
; 0000 0348                 lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 0349                 lcd_print("  ");
	__POINTW2MN _0x86,558
	RCALL _lcd_print
; 0000 034A             }
; 0000 034B         }
_0xFD:
; 0000 034C         else if(keypad[rowloc][cl] == 'E')
	RJMP _0xFE
_0xFC:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xFF
; 0000 034D         {
; 0000 034E             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 034F             lcd_gotoxy(1,1);
; 0000 0350             lcd_print("Timer started");
	__POINTW2MN _0x86,561
	RCALL _lcd_print
; 0000 0351             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0352             delay_ms(2000);
	CALL SUBOPT_0x26
; 0000 0353             Timer2_Init();
	RCALL _Timer2_Init
; 0000 0354             stage = STAGE_INIT_MENU;
_0x1A0:
	CLR  R5
; 0000 0355         }
; 0000 0356 
; 0000 0357     }
_0xFF:
_0xFE:
_0xFB:
; 0000 0358     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0x100
_0xF6:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x102
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x103
_0x102:
	RJMP _0x101
_0x103:
; 0000 0359     {
; 0000 035A         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x104
; 0000 035B         {
; 0000 035C             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 035D             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 035E         }
; 0000 035F 
; 0000 0360         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0x105
_0x104:
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x106
; 0000 0361         {
; 0000 0362             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0x107
; 0000 0363             {
; 0000 0364                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 0365                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1D
; 0000 0366                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0367             }
; 0000 0368         }
_0x107:
; 0000 0369         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x108
_0x106:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x109
; 0000 036A         {
; 0000 036B             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 036C             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x10A
; 0000 036D             {
; 0000 036E                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1E
; 0000 036F                 lcdCommand(0x10);
; 0000 0370                 lcd_print(" ");
	__POINTW2MN _0x86,575
	CALL SUBOPT_0x1F
; 0000 0371                 lcdCommand(0x10);
; 0000 0372             }
; 0000 0373         }
_0x10A:
; 0000 0374         else if (keypad[rowloc][cl] == 'O')
	RJMP _0x10B
_0x109:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x10C
; 0000 0375         {
; 0000 0376             lcdCommand(0xC0);
	CALL SUBOPT_0x20
; 0000 0377             for(i = 0; i < strlen(buffer); i++)
_0x10E:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x21
	BRSH _0x10F
; 0000 0378                 lcd_print(" ");
	__POINTW2MN _0x86,577
	RCALL _lcd_print
	CALL SUBOPT_0x22
	RJMP _0x10E
_0x10F:
; 0000 0379 lcdCommand(0xC0);
	CALL SUBOPT_0x23
; 0000 037A             memset(buffer, 0, 32);
; 0000 037B         }
; 0000 037C         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x110
_0x10C:
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x111
; 0000 037D         {
; 0000 037E             // search from eeprom data
; 0000 037F             unsigned int input_hash = simple_hash(buffer);
; 0000 0380 
; 0000 0381             if (input_hash == secret)
	SBIW R28,2
;	i -> Y+8
;	input_hash -> Y+0
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RCALL _simple_hash
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xF64)
	LDI  R30,HIGH(0xF64)
	CPC  R27,R30
	BRNE _0x112
; 0000 0382             {
; 0000 0383                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0384                 lcd_gotoxy(1, 1);
; 0000 0385                 lcd_print("Login Successfully");
	__POINTW2MN _0x86,579
	CALL SUBOPT_0x1
; 0000 0386                 lcd_gotoxy(1, 2);
; 0000 0387                 lcd_print("Wait...");
	__POINTW2MN _0x86,598
	CALL SUBOPT_0x1A
; 0000 0388                 delay_ms(2000);
; 0000 0389                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 038A             }
; 0000 038B             else
	RJMP _0x113
_0x112:
; 0000 038C             {
; 0000 038D                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 038E                 lcd_gotoxy(1, 1);
; 0000 038F                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x86,606
	CALL SUBOPT_0x1
; 0000 0390                 lcd_gotoxy(1, 2);
; 0000 0391                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x86,632
	CALL SUBOPT_0x1A
; 0000 0392                 delay_ms(2000);
; 0000 0393             }
_0x113:
; 0000 0394             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0395             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0396         }
	ADIW R28,2
; 0000 0397     }
_0x111:
_0x110:
_0x10B:
_0x108:
_0x105:
; 0000 0398     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0x114
_0x101:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x116
	TST  R6
	BRNE _0x117
_0x116:
	RJMP _0x115
_0x117:
; 0000 0399     {
; 0000 039A         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x19
	LD   R30,X
	LDI  R31,0
; 0000 039B         {
; 0000 039C         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x11B
; 0000 039D             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 039E             break;
	RJMP _0x11A
; 0000 039F         case '1':
_0x11B:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x11D
; 0000 03A0 #asm("cli") // disable interrupts
	cli
; 0000 03A1             lcdCommand(0x1);
	CALL SUBOPT_0x0
; 0000 03A2             lcd_gotoxy(1, 1);
; 0000 03A3             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x86,663
	RCALL _lcd_print
; 0000 03A4             clear_eeprom();
	RCALL _clear_eeprom
; 0000 03A5 #asm("sei") // enable interrupts
	sei
; 0000 03A6             break;
; 0000 03A7         default:
_0x11D:
; 0000 03A8             break;
; 0000 03A9         }
_0x11A:
; 0000 03AA         memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 03AB         stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03AC     }
; 0000 03AD }
_0x115:
_0x114:
_0x100:
_0xF5:
_0xF2:
_0xEF:
_0xDD:
_0xC9:
_0xBC:
_0xB9:
_0xB6:
_0xB3:
_0x99:
_0x90:
	CALL __LOADLOCR6
	ADIW R28,8
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x86:
	.BYTE 0x2AB
;
;void lcdCommand(unsigned char cmnd)
; 0000 03B0 {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 03B1     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x27
;	cmnd -> Y+0
; 0000 03B2     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x1B,0
; 0000 03B3     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x28
; 0000 03B4     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03B5     delay_us(1 * 16);          // wait to make EN wider
; 0000 03B6     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03B7     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 03B8     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x29
; 0000 03B9     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03BA     delay_us(1 * 16);          // wait to make EN wider
; 0000 03BB     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03BC }
	RJMP _0x20C0005
; .FEND
;void lcdData(unsigned char data)
; 0000 03BE {
_lcdData:
; .FSTART _lcdData
; 0000 03BF     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x27
;	data -> Y+0
; 0000 03C0     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x1B,0
; 0000 03C1     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x28
; 0000 03C2     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03C3     delay_us(1 * 16);          // wait to make EN wider
; 0000 03C4     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03C5     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x29
; 0000 03C6     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03C7     delay_us(1 * 16);          // wait to make EN wider
; 0000 03C8     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03C9 }
	RJMP _0x20C0005
; .FEND
;void lcd_init()
; 0000 03CB {
_lcd_init:
; .FSTART _lcd_init
; 0000 03CC     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 03CD     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x1B,2
; 0000 03CE     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 03CF     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x2A
; 0000 03D0     delay_us(100 * 16);        // wait
; 0000 03D1     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x2A
; 0000 03D2     delay_us(100 * 16);        // wait
; 0000 03D3     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x2A
; 0000 03D4     delay_us(100 * 16);        // wait
; 0000 03D5     lcdCommand(0x0c);          // display on, cursor off
	CALL SUBOPT_0x4
; 0000 03D6     delay_us(100 * 16);        // wait
; 0000 03D7     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 03D8     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 03D9     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x2A
; 0000 03DA     delay_us(100 * 16);
; 0000 03DB }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 03DD {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 03DE     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 03DF     lcdCommand(firstCharAdr[y - 1] + x - 1);
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(128)
	ST   Y,R30
	LDI  R30,LOW(192)
	STD  Y+1,R30
	LDI  R30,LOW(148)
	STD  Y+2,R30
	LDI  R30,LOW(212)
	STD  Y+3,R30
;	x -> Y+5
;	y -> Y+4
;	firstCharAdr -> Y+0
	LDD  R30,Y+4
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDD  R26,Y+5
	ADD  R26,R30
	SUBI R26,LOW(1)
	CALL SUBOPT_0x2A
; 0000 03E0     delay_us(100 * 16);
; 0000 03E1 }
	RJMP _0x20C0004
; .FEND
;void lcd_print(char *str)
; 0000 03E3 {
_lcd_print:
; .FSTART _lcd_print
; 0000 03E4     unsigned char i = 0;
; 0000 03E5     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x11E:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x120
; 0000 03E6     {
; 0000 03E7         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 03E8         i++;
	SUBI R17,-1
; 0000 03E9     }
	RJMP _0x11E
_0x120:
; 0000 03EA }
	LDD  R17,Y+0
	RJMP _0x20C0008
; .FEND
;
;void show_temperature()
; 0000 03ED {
_show_temperature:
; .FSTART _show_temperature
; 0000 03EE     unsigned char temperatureVal = 0;
; 0000 03EF     unsigned char temperatureRep[3];
; 0000 03F0 
; 0000 03F1     DDRA &= ~(1 << 3);
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	CBI  0x1A,3
; 0000 03F2     ADMUX = 0xE3;
	LDI  R30,LOW(227)
	OUT  0x7,R30
; 0000 03F3     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 03F4 
; 0000 03F5     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 03F6     lcd_gotoxy(1, 1);
; 0000 03F7     lcd_print("Temperature(C):");
	__POINTW2MN _0x121,0
	RCALL _lcd_print
; 0000 03F8 
; 0000 03F9     while (stage == STAGE_TEMPERATURE_MONITORING)
_0x122:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x124
; 0000 03FA     {
; 0000 03FB         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 03FC         while ((ADCSRA & (1 << ADIF)) == 0)
_0x125:
	SBIS 0x6,4
; 0000 03FD             ;
	RJMP _0x125
; 0000 03FE         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0x128
; 0000 03FF         {
; 0000 0400             temperatureVal = ADCH;
	IN   R17,5
; 0000 0401             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 0402             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	CALL SUBOPT_0x17
; 0000 0403             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 0404             lcd_print(" ");
	__POINTW2MN _0x121,16
	RCALL _lcd_print
; 0000 0405         }
; 0000 0406         delay_ms(500);
_0x128:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0407     }
	RJMP _0x122
_0x124:
; 0000 0408 
; 0000 0409     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 040A }
	LDD  R17,Y+0
	RJMP _0x20C0006
; .FEND

	.DSEG
_0x121:
	.BYTE 0x12
;
;void show_menu()
; 0000 040D {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 040E     while (stage == STAGE_INIT_MENU)
_0x129:
	TST  R5
	BREQ PC+2
	RJMP _0x12B
; 0000 040F     {
; 0000 0410         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0411         lcd_gotoxy(1, 1);
; 0000 0412         if (page_num == 0)
	TST  R4
	BRNE _0x12C
; 0000 0413         {
; 0000 0414             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0x12D,0
	CALL SUBOPT_0x1
; 0000 0415             lcd_gotoxy(1, 2);
; 0000 0416             lcd_print("2: Student Management");
	__POINTW2MN _0x12D,29
	RCALL _lcd_print
; 0000 0417             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0x12E:
	TST  R4
	BRNE _0x131
	TST  R5
	BREQ _0x132
_0x131:
	RJMP _0x130
_0x132:
; 0000 0418                 ;
	RJMP _0x12E
_0x130:
; 0000 0419         }
; 0000 041A         else if (page_num == 1)
	RJMP _0x133
_0x12C:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x134
; 0000 041B         {
; 0000 041C             lcd_print("3: View Present Students ");
	__POINTW2MN _0x12D,51
	CALL SUBOPT_0x1
; 0000 041D             lcd_gotoxy(1, 2);
; 0000 041E             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0x12D,77
	RCALL _lcd_print
; 0000 041F             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0x135:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x138
	TST  R5
	BREQ _0x139
_0x138:
	RJMP _0x137
_0x139:
; 0000 0420                 ;
	RJMP _0x135
_0x137:
; 0000 0421         }
; 0000 0422         else if (page_num == 2)
	RJMP _0x13A
_0x134:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x13B
; 0000 0423         {
; 0000 0424             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0x12D,103
	CALL SUBOPT_0x1
; 0000 0425             lcd_gotoxy(1, 2);
; 0000 0426             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0x12D,128
	RCALL _lcd_print
; 0000 0427             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0x13C:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x13F
	TST  R5
	BREQ _0x140
_0x13F:
	RJMP _0x13E
_0x140:
; 0000 0428                 ;
	RJMP _0x13C
_0x13E:
; 0000 0429         }
; 0000 042A         else if (page_num == 3)
	RJMP _0x141
_0x13B:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x142
; 0000 042B         {
; 0000 042C             lcd_print("7: Login With Admin");
	__POINTW2MN _0x12D,150
	CALL SUBOPT_0x1
; 0000 042D             lcd_gotoxy(1, 2);
; 0000 042E             lcd_print("8: Logout");
	__POINTW2MN _0x12D,170
	RCALL _lcd_print
; 0000 042F             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0x143:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x146
	TST  R5
	BREQ _0x147
_0x146:
	RJMP _0x145
_0x147:
; 0000 0430                 ;
	RJMP _0x143
_0x145:
; 0000 0431         }
; 0000 0432         else if (page_num == 4)
	RJMP _0x148
_0x142:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x149
; 0000 0433         {
; 0000 0434             lcd_print("9: Set Timer");
	__POINTW2MN _0x12D,180
	RCALL _lcd_print
; 0000 0435             while (page_num == 4 && stage == STAGE_INIT_MENU)
_0x14A:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x14D
	TST  R5
	BREQ _0x14E
_0x14D:
	RJMP _0x14C
_0x14E:
; 0000 0436                 ;
	RJMP _0x14A
_0x14C:
; 0000 0437         }
; 0000 0438     }
_0x149:
_0x148:
_0x141:
_0x13A:
_0x133:
	RJMP _0x129
_0x12B:
; 0000 0439 }
	RET
; .FEND

	.DSEG
_0x12D:
	.BYTE 0xC1
;
;void clear_eeprom()
; 0000 043C {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 043D     unsigned int i;
; 0000 043E 
; 0000 043F     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x150:
	__CPWRN 16,17,1024
	BRSH _0x151
; 0000 0440     {
; 0000 0441         // Wait for the previous write to complete
; 0000 0442         while (EECR & (1 << EEWE))
_0x152:
	SBIC 0x1C,1
; 0000 0443             ;
	RJMP _0x152
; 0000 0444 
; 0000 0445         // Set up address registers
; 0000 0446         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 0447         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 0448 
; 0000 0449         // Set up data register
; 0000 044A         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 044B 
; 0000 044C         // Enable write
; 0000 044D         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 044E         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 044F     }
	__ADDWRN 16,17,1
	RJMP _0x150
_0x151:
; 0000 0450 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 0453 {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 0454     unsigned char x;
; 0000 0455     // Wait for the previous write to complete
; 0000 0456     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x155:
	SBIC 0x1C,1
; 0000 0457         ;
	RJMP _0x155
; 0000 0458 
; 0000 0459     // Set up address registers
; 0000 045A     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x2B
; 0000 045B     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 045C     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 045D     x = EEDR;
	IN   R17,29
; 0000 045E     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0008
; 0000 045F }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 0462 {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 0463     // Wait for the previous write to complete
; 0000 0464     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x158:
	SBIC 0x1C,1
; 0000 0465         ;
	RJMP _0x158
; 0000 0466 
; 0000 0467     // Set up address registers
; 0000 0468     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x2B
; 0000 0469     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 046A 
; 0000 046B     // Set up data register
; 0000 046C     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 046D 
; 0000 046E     // Enable write
; 0000 046F     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 0470     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0471 }
_0x20C0008:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 0474 {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 0475     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x15B:
	SBIS 0xB,5
; 0000 0476         ;
	RJMP _0x15B
; 0000 0477     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0478 }
	RJMP _0x20C0005
; .FEND
;
;unsigned char USART_Receive()
; 0000 047B {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 047C     while(!(UCSRA & (1 << RXC)) && stage == STAGE_SUBMIT_WITH_CARD);
_0x15E:
	SBIC 0xB,7
	RJMP _0x161
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x162
_0x161:
	RJMP _0x160
_0x162:
	RJMP _0x15E
_0x160:
; 0000 047D     return UDR;
	IN   R30,0xC
	RET
; 0000 047E }
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 0481 {
_USART_init:
; .FSTART _USART_init
; 0000 0482     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 0483     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 0484     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0485     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 0486 }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 0489 {
_search_student_code:
; .FSTART _search_student_code
; 0000 048A     unsigned char st_counts, i, j;
; 0000 048B     char temp[10];
; 0000 048C 
; 0000 048D     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0x24
	MOV  R17,R30
; 0000 048E 
; 0000 048F     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x164:
	CP   R16,R17
	BRSH _0x165
; 0000 0490     {
; 0000 0491         memset(temp, 0, 10);
	CALL SUBOPT_0x15
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 0492         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x167:
	CPI  R19,8
	BRSH _0x168
; 0000 0493         {
; 0000 0494             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0xD
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0495         }
	SUBI R19,-1
	RJMP _0x167
_0x168:
; 0000 0496         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0497         if (strncmp(temp, buffer, 8) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x8
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x169
; 0000 0498             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20C0007
; 0000 0499     }
_0x169:
	SUBI R16,-1
	RJMP _0x164
_0x165:
; 0000 049A 
; 0000 049B     return 0;
	LDI  R30,LOW(0)
_0x20C0007:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 049C }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 049F {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 04A0     unsigned char st_counts, i, j;
; 0000 04A1     unsigned char temp;
; 0000 04A2 
; 0000 04A3     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0x24
	MOV  R17,R30
; 0000 04A4 
; 0000 04A5     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x16B:
	CP   R17,R16
	BRLO _0x16C
; 0000 04A6     {
; 0000 04A7         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x16E:
	CPI  R19,8
	BRSH _0x16F
; 0000 04A8         {
; 0000 04A9             temp = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0xD
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	MOV  R18,R30
; 0000 04AA             write_byte_to_eeprom(j + ((i) * 8), temp);
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(8)
	MUL  R30,R16
	MOVW R30,R0
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	RCALL _write_byte_to_eeprom
; 0000 04AB         }
	SUBI R19,-1
	RJMP _0x16E
_0x16F:
; 0000 04AC     }
	SUBI R16,-1
	RJMP _0x16B
_0x16C:
; 0000 04AD     write_byte_to_eeprom(0x0, st_counts - 1);
	CALL SUBOPT_0xF
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 04AE }
	CALL __LOADLOCR4
	JMP  _0x20C0002
; .FEND
;
;void HCSR04Init()
; 0000 04B1 {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 04B2     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 04B3     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 04B4 }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 04B7 {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 04B8     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 04B9     delay_us(15 * 16);              // Wait for 15 microseconds
	__DELAY_USW 480
; 0000 04BA     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 04BB }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 04BE {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 04BF     uint32_t i, result;
; 0000 04C0 
; 0000 04C1     // Wait for rising edge on Echo pin
; 0000 04C2     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x171:
	CALL SUBOPT_0x2C
	BRSH _0x172
; 0000 04C3     {
; 0000 04C4         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 04C5             continue;
	RJMP _0x170
; 0000 04C6         else
; 0000 04C7             break;
	RJMP _0x172
; 0000 04C8     }
_0x170:
	CALL SUBOPT_0x2D
	RJMP _0x171
_0x172:
; 0000 04C9 
; 0000 04CA     if (i == 600000)
	CALL SUBOPT_0x2C
	BRNE _0x175
; 0000 04CB         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0003
; 0000 04CC 
; 0000 04CD     // Start timer with prescaler 64
; 0000 04CE     TCCR1A = 0x00;
_0x175:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 04CF     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 04D0     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 04D1 
; 0000 04D2     // Wait for falling edge on Echo pin
; 0000 04D3     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x177:
	CALL SUBOPT_0x2C
	BRSH _0x178
; 0000 04D4     {
; 0000 04D5         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 04D6             break; // Falling edge detected
	RJMP _0x178
; 0000 04D7         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x17A
; 0000 04D8             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0003
; 0000 04D9     }
_0x17A:
	CALL SUBOPT_0x2D
	RJMP _0x177
_0x178:
; 0000 04DA 
; 0000 04DB     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 04DC     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 04DD 
; 0000 04DE     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x17B
; 0000 04DF         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0003
; 0000 04E0     else
_0x17B:
; 0000 04E1         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
	RJMP _0x20C0003
; 0000 04E2 }
; .FEND
;
;void startSonar()
; 0000 04E5 {
_startSonar:
; .FSTART _startSonar
; 0000 04E6     char numberString[16];
; 0000 04E7     uint16_t pulseWidth; // Pulse width from echo
; 0000 04E8     int distance, previous_distance = -1;
; 0000 04E9     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 04EA 
; 0000 04EB     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x0
; 0000 04EC     lcd_gotoxy(1, 1);
; 0000 04ED     lcd_print("Distance: ");
	__POINTW2MN _0x17E,0
	RCALL _lcd_print
; 0000 04EE 
; 0000 04EF     while (stage == STAGE_TRAFFIC_MONITORING)
_0x17F:
	LDI  R30,LOW(10)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x181
; 0000 04F0     {
; 0000 04F1         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 04F2         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 04F3 
; 0000 04F4         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x182
; 0000 04F5         {
; 0000 04F6             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 04F7             lcd_gotoxy(1, 1);
; 0000 04F8             lcd_print("Error"); // Display error message
	__POINTW2MN _0x17E,11
	RJMP _0x1A1
; 0000 04F9         }
; 0000 04FA         else if (pulseWidth == US_NO_OBSTACLE)
_0x182:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x184
; 0000 04FB         {
; 0000 04FC             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 04FD             lcd_gotoxy(1, 1);
; 0000 04FE             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x17E,17
	RJMP _0x1A1
; 0000 04FF         }
; 0000 0500         else
_0x184:
; 0000 0501         {
; 0000 0502             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3D0B4396
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __CFD1
	MOVW R18,R30
; 0000 0503 
; 0000 0504             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x186
; 0000 0505             {
; 0000 0506                 previous_distance = distance;
	MOVW R20,R18
; 0000 0507                 // Display distance on LCD
; 0000 0508                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0509                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x17
; 0000 050A                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 050B                 lcd_print(" cm ");
	__POINTW2MN _0x17E,29
	RCALL _lcd_print
; 0000 050C             }
; 0000 050D             // Counting logic based on distance
; 0000 050E             if (distance < 6)
_0x186:
	__CPWRN 18,19,6
	BRGE _0x187
; 0000 050F             {
; 0000 0510                 US_count++; // Increment count if distance is below threshold
	INC  R7
; 0000 0511             }
; 0000 0512 
; 0000 0513             // Update count on LCD only if it changes
; 0000 0514             if (US_count != previous_count)
_0x187:
	LDS  R30,_previous_count_S0000015000
	LDS  R31,_previous_count_S0000015000+1
	MOV  R26,R7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x188
; 0000 0515             {
; 0000 0516                 previous_count = US_count;
	MOV  R30,R7
	LDI  R31,0
	STS  _previous_count_S0000015000,R30
	STS  _previous_count_S0000015000+1,R31
; 0000 0517                 lcd_gotoxy(1, 2); // Move to second line
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0518                 itoa(US_count, numberString);
	MOV  R30,R7
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0519                 lcd_print("Count: ");
	__POINTW2MN _0x17E,34
	RCALL _lcd_print
; 0000 051A                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x1A1:
	RCALL _lcd_print
; 0000 051B             }
; 0000 051C         }
_0x188:
; 0000 051D         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 051E     }
	RJMP _0x17F
_0x181:
; 0000 051F }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x17E:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 0522 {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 0523     unsigned int hash = 0;
; 0000 0524     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x189:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x18B
; 0000 0525     {
; 0000 0526         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 0527         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0528     }
	RJMP _0x189
_0x18B:
; 0000 0529     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0006:
	ADIW R28,4
	RET
; 0000 052A }
; .FEND
;
;void I2C_init()
; 0000 052D {
_I2C_init:
; .FSTART _I2C_init
; 0000 052E     TWSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 052F     TWBR = 0x47;
	LDI  R30,LOW(71)
	OUT  0x0,R30
; 0000 0530     TWCR = 0x04;
	LDI  R30,LOW(4)
	OUT  0x36,R30
; 0000 0531 }
	RET
; .FEND
;
;void I2C_start()
; 0000 0534 {
_I2C_start:
; .FSTART _I2C_start
; 0000 0535     TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0000 0536     while(!(TWCR & (1 << TWINT)));
_0x18C:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x18C
; 0000 0537 }
	RET
; .FEND
;
;void I2C_write(unsigned char data)
; 0000 053A {
_I2C_write:
; .FSTART _I2C_write
; 0000 053B     TWDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0000 053C     TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0000 053D     while(!(TWCR & (1 << TWINT)));
_0x18F:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x18F
; 0000 053E }
	RJMP _0x20C0005
; .FEND
;
;unsigned char I2C_read(unsigned char ackVal)
; 0000 0541 {
_I2C_read:
; .FSTART _I2C_read
; 0000 0542     TWCR = (1 << TWINT) | (1 << TWEN) | (ackVal << TWEA);
	ST   -Y,R26
;	ackVal -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
; 0000 0543     while(!(TWCR & (1 << TWINT)));
_0x192:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x192
; 0000 0544     return TWDR;
	IN   R30,0x3
_0x20C0005:
	ADIW R28,1
	RET
; 0000 0545 }
; .FEND
;
;void I2C_stop()
; 0000 0548 {
_I2C_stop:
; .FSTART _I2C_stop
; 0000 0549     TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0000 054A     while(TWCR & (1 << TWSTO));
_0x195:
	IN   R30,0x36
	SBRC R30,4
	RJMP _0x195
; 0000 054B }
	RET
; .FEND
;
;void rtc_init()
; 0000 054E {
_rtc_init:
; .FSTART _rtc_init
; 0000 054F     I2C_init();
	RCALL _I2C_init
; 0000 0550     I2C_start();
	CALL SUBOPT_0x2E
; 0000 0551     I2C_write(0xD0);
; 0000 0552     I2C_write(0x07);
	LDI  R26,LOW(7)
	RCALL _I2C_write
; 0000 0553     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x2F
; 0000 0554     I2C_stop();
; 0000 0555 }
	RET
; .FEND
;
;void rtc_getTime(unsigned char* hour, unsigned char* minute, unsigned char* second)
; 0000 0558 {
_rtc_getTime:
; .FSTART _rtc_getTime
; 0000 0559     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*hour -> Y+4
;	*minute -> Y+2
;	*second -> Y+0
	CALL SUBOPT_0x2E
; 0000 055A     I2C_write(0xD0);
; 0000 055B     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x2F
; 0000 055C     I2C_stop();
; 0000 055D 
; 0000 055E     I2C_start();
	CALL SUBOPT_0x30
; 0000 055F     I2C_write(0xD1);
; 0000 0560     *second = I2C_read(1);
; 0000 0561     *minute = I2C_read(1);
; 0000 0562     *hour = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 0563     I2C_stop();
	RCALL _I2C_stop
; 0000 0564 }
_0x20C0004:
	ADIW R28,6
	RET
; .FEND
;
;void rtc_getDate(unsigned char* year, unsigned char* month, unsigned char* date, unsigned char* day)
; 0000 0567 {
_rtc_getDate:
; .FSTART _rtc_getDate
; 0000 0568     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*year -> Y+6
;	*month -> Y+4
;	*date -> Y+2
;	*day -> Y+0
	CALL SUBOPT_0x2E
; 0000 0569     I2C_write(0xD0);
; 0000 056A     I2C_write(0x03);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x2F
; 0000 056B     I2C_stop();
; 0000 056C 
; 0000 056D     I2C_start();
	CALL SUBOPT_0x30
; 0000 056E     I2C_write(0xD1);
; 0000 056F     *day = I2C_read(1);
; 0000 0570     *date = I2C_read(1);
; 0000 0571     *month = I2C_read(1);
	LDI  R26,LOW(1)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 0572     *year = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
; 0000 0573     I2C_stop();
	RCALL _I2C_stop
; 0000 0574 }
_0x20C0003:
	ADIW R28,8
	RET
; .FEND
;
;void Timer2_Init()
; 0000 0577 {
_Timer2_Init:
; .FSTART _Timer2_Init
; 0000 0578     //Disable timer2 interrupts
; 0000 0579     TIMSK = 0;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 057A     //Enable asynchronous mode
; 0000 057B     ASSR = (1 << AS2);
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 057C     //set initial counter value
; 0000 057D     TCNT2 = 0;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 057E     //set prescaller 128
; 0000 057F     TCCR2 = 0;
	OUT  0x25,R30
; 0000 0580     TCCR2 |= (1 << CS22) | ( 1 << CS00);
	IN   R30,0x25
	ORI  R30,LOW(0x5)
	OUT  0x25,R30
; 0000 0581     //wait for registers update
; 0000 0582     while (ASSR & ((1 << TCN2UB) | (1 << TCR2UB)));
_0x198:
	IN   R30,0x22
	ANDI R30,LOW(0x5)
	BRNE _0x198
; 0000 0583     //clear interrupt flags
; 0000 0584     TIFR = (1 << TOV2);
	LDI  R30,LOW(64)
	OUT  0x38,R30
; 0000 0585     //enable TOV2 interrupt
; 0000 0586     TIMSK  = (1 << TOIE2);
	OUT  0x39,R30
; 0000 0587 }
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	JMP  _0x20C0002
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strncmp:
; .FSTART _strncmp
	ST   -Y,R26
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strncmp0:
    tst  r24
    breq strncmp1
    dec  r24
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strncmp1
    tst  r22
    brne strncmp0
strncmp3:
    clr  r30
    ret
strncmp1:
    sub  r22,r23
    breq strncmp3
    ldi  r30,1
    brcc strncmp2
    subi r30,2
strncmp2:
    ret
; .FEND

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0002:
	ADIW R28,5
	RET
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x31
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x31
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x32
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x33
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x31
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x31
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x31
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x33
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x36
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x36
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x10
_buffer:
	.BYTE 0x20
_days:
	.BYTE 0xE
_time:
	.BYTE 0x14
_previous_count_S0000015000:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:219 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(1)
	CALL _lcdCommand
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:122 WORDS
SUBOPT_0x1:
	CALL _lcd_print
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	CALL _lcd_print
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
	CLR  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(15)
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(12)
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:173 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(32)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _lcd_print
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _read_byte_from_eeprom
	MOV  R21,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _lcd_print

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOV  R30,R9
	LDI  R31,0
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:429 WORDS
SUBOPT_0x19:
	MOV  R30,R16
	LDI  R26,LOW(_keypad)
	LDI  R27,HIGH(_keypad)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R19
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	CALL _lcd_print
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1E:
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(192)
	CALL _lcdCommand
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(192)
	CALL _lcdCommand
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	CBI  0x1B,1
	SBI  0x1B,2
	__DELAY_USB 43
	CBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x29:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x1B,R30
	SBI  0x1B,2
	__DELAY_USB 43
	CBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	CALL _lcdCommand
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2C:
	__GETD2S 4
	__CPD2N 0x927C0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	__GETD1S 4
	__SUBD1N -1
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	CALL _I2C_start
	LDI  R26,LOW(208)
	JMP  _I2C_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	CALL _I2C_write
	JMP  _I2C_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x30:
	CALL _I2C_start
	LDI  R26,LOW(209)
	CALL _I2C_write
	LDI  R26,LOW(1)
	CALL _I2C_read
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	LDI  R26,LOW(1)
	CALL _I2C_read
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x31:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
