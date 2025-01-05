
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
	.DB  0x0,0x0,0x1,0x0
	.DB  0x0,0x5

_0x3:
	.DB  0x37,0x38,0x39,0x4F,0x34,0x35,0x36,0x44
	.DB  0x31,0x32,0x33,0x43,0x4C,0x30,0x52,0x45
_0x5:
	.DB  LOW(_0x4),HIGH(_0x4),LOW(_0x4+4),HIGH(_0x4+4),LOW(_0x4+8),HIGH(_0x4+8),LOW(_0x4+12),HIGH(_0x4+12)
	.DB  LOW(_0x4+16),HIGH(_0x4+16),LOW(_0x4+20),HIGH(_0x4+20),LOW(_0x4+24),HIGH(_0x4+24)
_0x6:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x19D:
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
	.DB  0x25,0x30,0x32,0x78,0x25,0x30,0x32,0x78
	.DB  0x0,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x61,0x64,0x64,0x65,0x64,0x20,0x77
	.DB  0x69,0x74,0x68,0x20,0x49,0x44,0x3A,0x0
	.DB  0x4E,0x75,0x6D,0x62,0x65,0x72,0x20,0x6F
	.DB  0x66,0x20,0x73,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x73,0x20,0x3A,0x20,0x0,0x25,0x73
	.DB  0x0,0x2F,0x0,0x50,0x72,0x65,0x73,0x73
	.DB  0x20,0x43,0x61,0x6E,0x63,0x65,0x6C,0x20
	.DB  0x54,0x6F,0x20,0x47,0x6F,0x20,0x42,0x61
	.DB  0x63,0x6B,0x0,0x53,0x74,0x61,0x72,0x74
	.DB  0x20,0x54,0x72,0x61,0x6E,0x73,0x66,0x65
	.DB  0x72,0x72,0x69,0x6E,0x67,0x2E,0x2E,0x2E
	.DB  0x0,0x55,0x73,0x61,0x72,0x74,0x20,0x54
	.DB  0x72,0x61,0x6E,0x73,0x6D,0x69,0x74,0x20
	.DB  0x46,0x69,0x6E,0x69,0x73,0x68,0x65,0x64
	.DB  0x0,0x31,0x3A,0x20,0x53,0x65,0x61,0x72
	.DB  0x63,0x68,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x0,0x32,0x3A,0x20,0x44,0x65
	.DB  0x6C,0x65,0x74,0x65,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x46,0x6F,0x72,0x20,0x53,0x65,0x61,0x72
	.DB  0x63,0x68,0x3A,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x46
	.DB  0x6F,0x72,0x20,0x44,0x65,0x6C,0x65,0x74
	.DB  0x65,0x3A,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x53,0x65,0x63,0x72,0x65,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x28,0x6F,0x72
	.DB  0x20,0x63,0x61,0x6E,0x63,0x65,0x6C,0x29
	.DB  0x0,0x31,0x20,0x3A,0x20,0x43,0x6C,0x65
	.DB  0x61,0x72,0x20,0x45,0x45,0x50,0x52,0x4F
	.DB  0x4D,0x0,0x20,0x20,0x20,0x20,0x70,0x72
	.DB  0x65,0x73,0x73,0x20,0x63,0x61,0x6E,0x63
	.DB  0x65,0x6C,0x20,0x74,0x6F,0x20,0x62,0x61
	.DB  0x63,0x6B,0x0,0x53,0x65,0x74,0x20,0x54
	.DB  0x69,0x6D,0x65,0x72,0x28,0x6D,0x69,0x6E
	.DB  0x75,0x74,0x65,0x73,0x29,0x3A,0x20,0x0
	.DB  0x25,0x30,0x32,0x78,0x3A,0x25,0x30,0x32
	.DB  0x78,0x3A,0x25,0x30,0x32,0x78,0x20,0x20
	.DB  0x0,0x32,0x30,0x25,0x30,0x32,0x78,0x2F
	.DB  0x25,0x30,0x32,0x78,0x2F,0x25,0x30,0x32
	.DB  0x78,0x20,0x20,0x25,0x33,0x73,0x0,0x4C
	.DB  0x6F,0x67,0x6F,0x75,0x74,0x20,0x2E,0x2E
	.DB  0x2E,0x0,0x47,0x6F,0x69,0x6E,0x67,0x20
	.DB  0x54,0x6F,0x20,0x41,0x64,0x6D,0x69,0x6E
	.DB  0x20,0x50,0x61,0x67,0x65,0x20,0x49,0x6E
	.DB  0x20,0x32,0x20,0x53,0x65,0x63,0x0,0x49
	.DB  0x6E,0x63,0x6F,0x72,0x72,0x65,0x63,0x74
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x46,0x6F
	.DB  0x72,0x6D,0x61,0x74,0x0,0x59,0x6F,0x75
	.DB  0x20,0x57,0x69,0x6C,0x6C,0x20,0x42,0x61
	.DB  0x63,0x6B,0x20,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x49,0x6E,0x20,0x32,0x20,0x53,0x65,0x63
	.DB  0x6F,0x6E,0x64,0x0,0x44,0x75,0x70,0x6C
	.DB  0x69,0x63,0x61,0x74,0x65,0x20,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x20,0x45,0x6E,0x74,0x65,0x72
	.DB  0x65,0x64,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x53,0x75,0x63,0x63,0x65,0x73,0x73,0x66
	.DB  0x75,0x6C,0x6C,0x79,0x20,0x41,0x64,0x64
	.DB  0x65,0x64,0x0,0x59,0x6F,0x75,0x20,0x4D
	.DB  0x75,0x73,0x74,0x20,0x46,0x69,0x72,0x73
	.DB  0x74,0x20,0x4C,0x6F,0x67,0x69,0x6E,0x0
	.DB  0x59,0x6F,0x75,0x20,0x57,0x69,0x6C,0x6C
	.DB  0x20,0x47,0x6F,0x20,0x41,0x64,0x6D,0x69
	.DB  0x6E,0x20,0x50,0x61,0x67,0x65,0x20,0x32
	.DB  0x20,0x53,0x65,0x63,0x0,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x43,0x6F,0x64
	.DB  0x65,0x20,0x46,0x6F,0x75,0x6E,0x64,0x0
	.DB  0x4F,0x70,0x73,0x20,0x2C,0x20,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x20,0x4E,0x6F,0x74,0x20,0x46
	.DB  0x6F,0x75,0x6E,0x64,0x0,0x57,0x61,0x69
	.DB  0x74,0x20,0x46,0x6F,0x72,0x20,0x44,0x65
	.DB  0x6C,0x65,0x74,0x65,0x2E,0x2E,0x2E,0x0
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x57,0x61,0x73
	.DB  0x20,0x44,0x65,0x6C,0x65,0x74,0x65,0x64
	.DB  0x0,0x54,0x69,0x6D,0x65,0x72,0x20,0x73
	.DB  0x74,0x61,0x72,0x74,0x65,0x64,0x0,0x4C
	.DB  0x6F,0x67,0x69,0x6E,0x20,0x53,0x75,0x63
	.DB  0x63,0x65,0x73,0x73,0x66,0x75,0x6C,0x6C
	.DB  0x79,0x0,0x57,0x61,0x69,0x74,0x2E,0x2E
	.DB  0x2E,0x0,0x4F,0x70,0x73,0x20,0x2C,0x20
	.DB  0x73,0x65,0x63,0x72,0x65,0x74,0x20,0x69
	.DB  0x73,0x20,0x69,0x6E,0x63,0x6F,0x72,0x72
	.DB  0x65,0x63,0x74,0x0,0x43,0x6C,0x65,0x61
	.DB  0x72,0x69,0x6E,0x67,0x20,0x45,0x45,0x50
	.DB  0x52,0x4F,0x4D,0x20,0x2E,0x2E,0x2E,0x0
	.DB  0x54,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
	.DB  0x75,0x72,0x65,0x28,0x43,0x29,0x3A,0x0
	.DB  0x31,0x3A,0x20,0x41,0x74,0x74,0x65,0x6E
	.DB  0x64,0x61,0x6E,0x63,0x65,0x20,0x49,0x6E
	.DB  0x69,0x74,0x69,0x61,0x6C,0x69,0x7A,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x0,0x32,0x3A,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x4D,0x61,0x6E,0x61,0x67,0x65,0x6D,0x65
	.DB  0x6E,0x74,0x0,0x33,0x3A,0x20,0x56,0x69
	.DB  0x65,0x77,0x20,0x50,0x72,0x65,0x73,0x65
	.DB  0x6E,0x74,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x73,0x20,0x0,0x34,0x3A,0x20
	.DB  0x54,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
	.DB  0x75,0x72,0x65,0x20,0x4D,0x6F,0x6E,0x69
	.DB  0x74,0x6F,0x72,0x69,0x6E,0x67,0x0,0x35
	.DB  0x3A,0x20,0x52,0x65,0x74,0x72,0x69,0x65
	.DB  0x76,0x65,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x44,0x61,0x74,0x61,0x0
	.DB  0x36,0x3A,0x20,0x54,0x72,0x61,0x66,0x66
	.DB  0x69,0x63,0x20,0x4D,0x6F,0x6E,0x69,0x74
	.DB  0x6F,0x72,0x69,0x6E,0x67,0x0,0x37,0x3A
	.DB  0x20,0x4C,0x6F,0x67,0x69,0x6E,0x20,0x57
	.DB  0x69,0x74,0x68,0x20,0x41,0x64,0x6D,0x69
	.DB  0x6E,0x0,0x38,0x3A,0x20,0x4C,0x6F,0x67
	.DB  0x6F,0x75,0x74,0x0,0x39,0x3A,0x20,0x53
	.DB  0x65,0x74,0x20,0x54,0x69,0x6D,0x65,0x72
	.DB  0x0,0x44,0x69,0x73,0x74,0x61,0x6E,0x63
	.DB  0x65,0x3A,0x20,0x0,0x45,0x72,0x72,0x6F
	.DB  0x72,0x0,0x4E,0x6F,0x20,0x4F,0x62,0x73
	.DB  0x74,0x61,0x63,0x6C,0x65,0x0,0x20,0x63
	.DB  0x6D,0x20,0x0,0x43,0x6F,0x75,0x6E,0x74
	.DB  0x3A,0x20,0x0
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
	.DW  _0xD
	.DW  _0x0*2+28

	.DW  0x14
	.DW  _0xD+23
	.DW  _0x0*2+51

	.DW  0x1C
	.DW  _0xD+43
	.DW  _0x0*2+71

	.DW  0x19
	.DW  _0xD+71
	.DW  _0x0*2+99

	.DW  0x1C
	.DW  _0xD+96
	.DW  _0x0*2+71

	.DW  0x1D
	.DW  _0xD+124
	.DW  _0x0*2+124

	.DW  0x03
	.DW  _0xD+153
	.DW  _0x0*2+153

	.DW  0x0D
	.DW  _0xD+156
	.DW  _0x0*2+156

	.DW  0x17
	.DW  _0xD+169
	.DW  _0x0*2+169

	.DW  0x17
	.DW  _0xD+192
	.DW  _0x0*2+201

	.DW  0x16
	.DW  _0xD+215
	.DW  _0x0*2+224

	.DW  0x02
	.DW  _0xD+237
	.DW  _0x0*2+122

	.DW  0x02
	.DW  _0xD+239
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0xD+241
	.DW  _0x0*2+249

	.DW  0x18
	.DW  _0xD+243
	.DW  _0x0*2+251

	.DW  0x16
	.DW  _0xD+267
	.DW  _0x0*2+275

	.DW  0x18
	.DW  _0xD+289
	.DW  _0x0*2+297

	.DW  0x12
	.DW  _0xD+313
	.DW  _0x0*2+321

	.DW  0x12
	.DW  _0xD+331
	.DW  _0x0*2+339

	.DW  0x1F
	.DW  _0xD+349
	.DW  _0x0*2+357

	.DW  0x1F
	.DW  _0xD+380
	.DW  _0x0*2+388

	.DW  0x1E
	.DW  _0xD+411
	.DW  _0x0*2+419

	.DW  0x11
	.DW  _0xD+441
	.DW  _0x0*2+449

	.DW  0x19
	.DW  _0xD+458
	.DW  _0x0*2+466

	.DW  0x15
	.DW  _0xD+483
	.DW  _0x0*2+491

	.DW  0x0B
	.DW  _0x9D
	.DW  _0x0*2+551

	.DW  0x1D
	.DW  _0x9D+11
	.DW  _0x0*2+562

	.DW  0x02
	.DW  _0x9D+40
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9D+42
	.DW  _0x0*2+244

	.DW  0x03
	.DW  _0x9D+44
	.DW  _0x0*2+153

	.DW  0x1E
	.DW  _0x9D+47
	.DW  _0x0*2+591

	.DW  0x1F
	.DW  _0x9D+77
	.DW  _0x0*2+621

	.DW  0x1F
	.DW  _0x9D+108
	.DW  _0x0*2+652

	.DW  0x1F
	.DW  _0x9D+139
	.DW  _0x0*2+621

	.DW  0x20
	.DW  _0x9D+170
	.DW  _0x0*2+683

	.DW  0x1F
	.DW  _0x9D+202
	.DW  _0x0*2+621

	.DW  0x15
	.DW  _0x9D+233
	.DW  _0x0*2+715

	.DW  0x1D
	.DW  _0x9D+254
	.DW  _0x0*2+736

	.DW  0x02
	.DW  _0x9D+283
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9D+285
	.DW  _0x0*2+244

	.DW  0x13
	.DW  _0x9D+287
	.DW  _0x0*2+765

	.DW  0x1F
	.DW  _0x9D+306
	.DW  _0x0*2+621

	.DW  0x1D
	.DW  _0x9D+337
	.DW  _0x0*2+784

	.DW  0x1F
	.DW  _0x9D+366
	.DW  _0x0*2+621

	.DW  0x02
	.DW  _0x9D+397
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9D+399
	.DW  _0x0*2+244

	.DW  0x13
	.DW  _0x9D+401
	.DW  _0x0*2+765

	.DW  0x13
	.DW  _0x9D+420
	.DW  _0x0*2+813

	.DW  0x19
	.DW  _0x9D+439
	.DW  _0x0*2+832

	.DW  0x1F
	.DW  _0x9D+464
	.DW  _0x0*2+621

	.DW  0x1D
	.DW  _0x9D+495
	.DW  _0x0*2+784

	.DW  0x1F
	.DW  _0x9D+524
	.DW  _0x0*2+621

	.DW  0x03
	.DW  _0x9D+555
	.DW  _0x0*2+526

	.DW  0x03
	.DW  _0x9D+558
	.DW  _0x0*2+526

	.DW  0x0E
	.DW  _0x9D+561
	.DW  _0x0*2+857

	.DW  0x02
	.DW  _0x9D+575
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9D+577
	.DW  _0x0*2+244

	.DW  0x13
	.DW  _0x9D+579
	.DW  _0x0*2+871

	.DW  0x08
	.DW  _0x9D+598
	.DW  _0x0*2+890

	.DW  0x1A
	.DW  _0x9D+606
	.DW  _0x0*2+898

	.DW  0x1F
	.DW  _0x9D+632
	.DW  _0x0*2+621

	.DW  0x14
	.DW  _0x9D+663
	.DW  _0x0*2+924

	.DW  0x10
	.DW  _0x13E
	.DW  _0x0*2+944

	.DW  0x02
	.DW  _0x13E+16
	.DW  _0x0*2+244

	.DW  0x1D
	.DW  _0x14A
	.DW  _0x0*2+960

	.DW  0x16
	.DW  _0x14A+29
	.DW  _0x0*2+989

	.DW  0x1A
	.DW  _0x14A+51
	.DW  _0x0*2+1011

	.DW  0x1A
	.DW  _0x14A+77
	.DW  _0x0*2+1037

	.DW  0x19
	.DW  _0x14A+103
	.DW  _0x0*2+1063

	.DW  0x16
	.DW  _0x14A+128
	.DW  _0x0*2+1088

	.DW  0x14
	.DW  _0x14A+150
	.DW  _0x0*2+1110

	.DW  0x0A
	.DW  _0x14A+170
	.DW  _0x0*2+1130

	.DW  0x0D
	.DW  _0x14A+180
	.DW  _0x0*2+1140

	.DW  0x02
	.DW  _previous_count_S0000015000
	.DW  _0x19D*2

	.DW  0x0B
	.DW  _0x19E
	.DW  _0x0*2+1153

	.DW  0x06
	.DW  _0x19E+11
	.DW  _0x0*2+1164

	.DW  0x0C
	.DW  _0x19E+17
	.DW  _0x0*2+1170

	.DW  0x05
	.DW  _0x19E+29
	.DW  _0x0*2+1182

	.DW  0x08
	.DW  _0x19E+34
	.DW  _0x0*2+1187

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
;char logged_in = 1;
;char* days[7]= {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
_0x4:
	.BYTE 0x1C
;char time[20] = "";
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
; 0000 007B     char Date[20] = "";
; 0000 007C 
; 0000 007D     KEY_DDR = 0xF0;
	SBIW R28,27
	LDI  R24,20
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x6*2)
	LDI  R31,HIGH(_0x6*2)
	CALL __INITLOCB
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
;	data -> R20
;	second -> Y+26
;	minute -> Y+25
;	hour -> Y+24
;	day -> Y+23
;	date -> Y+22
;	month -> Y+21
;	year -> Y+20
;	Date -> Y+0
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 007E     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 007F     KEY_PRT &= 0x0F;                  // ground all rows at once
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 0080     MCUCR = 0x02;                     // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0081     GICR = (1 << INT0);               // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0082     BUZZER_DDR |= (1 << BUZZER_NUM);  // make buzzer pin output
	SBI  0x11,7
; 0000 0083     BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
	CBI  0x12,7
; 0000 0084     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	CALL _USART_init
; 0000 0085     HCSR04Init(); // Initialize ultrasonic sensor
	CALL _HCSR04Init
; 0000 0086     lcd_init();
	CALL _lcd_init
; 0000 0087     rtc_init();
	CALL _rtc_init
; 0000 0088 
; 0000 0089 #asm("sei")           // enable interrupts
	sei
; 0000 008A     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	CALL _lcdCommand
; 0000 008B     while (1)
_0x7:
; 0000 008C     {
; 0000 008D         if (stage == STAGE_INIT_MENU)
	TST  R5
	BRNE _0xA
; 0000 008E         {
; 0000 008F             show_menu();
	CALL _show_menu
; 0000 0090         }
; 0000 0091         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0xB
_0xA:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xC
; 0000 0092         {
; 0000 0093             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0094             lcd_gotoxy(1, 1);
; 0000 0095             lcd_print("1: Submit Student Code");
	__POINTW2MN _0xD,0
	CALL SUBOPT_0x1
; 0000 0096             lcd_gotoxy(1, 2);
; 0000 0097             lcd_print("2: Submit With Card");
	__POINTW2MN _0xD,23
	CALL _lcd_print
; 0000 0098             while (stage == STAGE_ATTENDENC_MENU)
_0xE:
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0xE
; 0000 0099                 ;
; 0000 009A         }
; 0000 009B         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x11
_0xC:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x12
; 0000 009C         {
; 0000 009D             if(submitTime == 0)
	TST  R9
	BRNE _0x13
; 0000 009E             {
; 0000 009F                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00A0                 lcd_gotoxy(1, 1);
; 0000 00A1                 lcd_print("Time for submit is finished");
	__POINTW2MN _0xD,43
	CALL SUBOPT_0x2
; 0000 00A2                 delay_ms(2000);
; 0000 00A3                 stage = STAGE_INIT_MENU;
; 0000 00A4             }
; 0000 00A5             lcdCommand(0x01);
_0x13:
	CALL SUBOPT_0x0
; 0000 00A6             lcd_gotoxy(1, 1);
; 0000 00A7             lcd_print("Enter your student code:");
	__POINTW2MN _0xD,71
	CALL SUBOPT_0x1
; 0000 00A8             lcd_gotoxy(1, 2);
; 0000 00A9             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 00AA             delay_us(100 * 16); // wait
; 0000 00AB             while (stage == STAGE_SUBMIT_CODE)
_0x14:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ _0x14
; 0000 00AC                 ;
; 0000 00AD             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x4
; 0000 00AE             delay_us(100 * 16); // wait
; 0000 00AF         }
; 0000 00B0         else if(stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0x17
_0x12:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x18
; 0000 00B1         {
; 0000 00B2             memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00B3             while (stage == STAGE_SUBMIT_WITH_CARD)
_0x19:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x1B
; 0000 00B4             {
; 0000 00B5                 if(submitTime == 0)
	TST  R9
	BRNE _0x1C
; 0000 00B6                 {
; 0000 00B7                     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00B8                     lcd_gotoxy(1, 1);
; 0000 00B9                     lcd_print("Time for submit is finished");
	__POINTW2MN _0xD,96
	CALL SUBOPT_0x2
; 0000 00BA                     delay_ms(2000);
; 0000 00BB                     stage = STAGE_INIT_MENU;
; 0000 00BC                     break;
	RJMP _0x1B
; 0000 00BD                 }
; 0000 00BE                 lcdCommand(0x01);
_0x1C:
	CALL SUBOPT_0x0
; 0000 00BF                 lcd_gotoxy(1, 1);
; 0000 00C0                 lcd_print("Bring your card near device:");
	__POINTW2MN _0xD,124
	CALL SUBOPT_0x1
; 0000 00C1                 lcd_gotoxy(1, 2);
; 0000 00C2                 delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 00C3                 while((data = USART_Receive()) != '\r'){
_0x1D:
	CALL _USART_Receive
	MOV  R20,R30
	CPI  R30,LOW(0xD)
	BREQ _0x1F
; 0000 00C4                     if(stage != STAGE_SUBMIT_WITH_CARD)
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x1F
; 0000 00C5                         break;
; 0000 00C6                     buffer[strlen(buffer)] = data;
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	ST   Z,R20
; 0000 00C7                 }
	RJMP _0x1D
_0x1F:
; 0000 00C8                 if(stage != STAGE_SUBMIT_WITH_CARD){
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x21
; 0000 00C9                     memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00CA                     break;
	RJMP _0x1B
; 0000 00CB                 }
; 0000 00CC                 if (strncmp(buffer, "40", 2) != 0 ||
_0x21:
; 0000 00CD                         strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0xD,153
	CALL SUBOPT_0x9
	BRNE _0x23
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x22
_0x23:
; 0000 00CE                 {
; 0000 00CF                     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00D0                     lcd_gotoxy(1, 1);
; 0000 00D1                     lcd_print("Invalid Card");
	__POINTW2MN _0xD,156
	CALL _lcd_print
; 0000 00D2                     BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00D3                     delay_ms(2000);
	CALL SUBOPT_0xA
; 0000 00D4                     BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00D5                 }
; 0000 00D6                 else{
	RJMP _0x25
_0x22:
; 0000 00D7                     if (search_student_code() > 0){
	CALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x26
; 0000 00D8                         BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00D9                         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00DA                         lcd_gotoxy(1, 1);
; 0000 00DB                         lcd_print("Duplicate Student Code");
	__POINTW2MN _0xD,169
	CALL SUBOPT_0xB
; 0000 00DC                         delay_ms(2000);
; 0000 00DD                         BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00DE                     }
; 0000 00DF                     else{
	RJMP _0x27
_0x26:
; 0000 00E0                         // save the buffer to EEPROM
; 0000 00E1                         st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 00E2                         for (i = 0; i < 8; i++)
	__GETWRN 16,17,0
_0x29:
	__CPWRN 16,17,8
	BRGE _0x2A
; 0000 00E3                         {
; 0000 00E4                             write_byte_to_eeprom(i + ((st_counts + 1) * 16), buffer[i]);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _write_byte_to_eeprom
; 0000 00E5                         }
	__ADDWRN 16,17,1
	RJMP _0x29
_0x2A:
; 0000 00E6                         rtc_getTime(&hour, &minute, &second);
	CALL SUBOPT_0xF
; 0000 00E7                         sprintf(time, "%02x%02x", hour, minute);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0000 00E8                         for (i = 0; i < 4; i++)
	__GETWRN 16,17,0
_0x2C:
	__CPWRN 16,17,4
	BRGE _0x2D
; 0000 00E9                         {
; 0000 00EA                             write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i]);
	CALL SUBOPT_0xD
	ADIW R30,8
	CALL SUBOPT_0xE
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _write_byte_to_eeprom
; 0000 00EB                         }
	__ADDWRN 16,17,1
	RJMP _0x2C
_0x2D:
; 0000 00EC                         rtc_getDate(&year, &month, &date, &day);
	CALL SUBOPT_0x13
; 0000 00ED                         sprintf(time, "%02x%02x", month, date);
	CALL SUBOPT_0x10
	LDD  R30,Y+25
	CALL SUBOPT_0x14
	LDD  R30,Y+30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
; 0000 00EE                         for (i = 4; i < 8; i++)
	__GETWRN 16,17,4
_0x2F:
	__CPWRN 16,17,8
	BRGE _0x30
; 0000 00EF                         {
; 0000 00F0                             write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i - 4]);
	CALL SUBOPT_0xD
	ADIW R30,8
	CALL SUBOPT_0xE
	MOVW R30,R16
	CALL SUBOPT_0x15
; 0000 00F1                         }
	__ADDWRN 16,17,1
	RJMP _0x2F
_0x30:
; 0000 00F2                         write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0x16
	MOV  R26,R21
	SUBI R26,-LOW(1)
	CALL _write_byte_to_eeprom
; 0000 00F3                         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00F4                         lcd_gotoxy(1, 1);
; 0000 00F5                         lcd_print("Student added with ID:");
	__POINTW2MN _0xD,192
	CALL SUBOPT_0x1
; 0000 00F6                         lcd_gotoxy(1, 2);
; 0000 00F7                         lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 00F8                         delay_ms(3000); // wait
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00F9                     }
_0x27:
; 0000 00FA                 }
_0x25:
; 0000 00FB                 memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00FC             }
	RJMP _0x19
_0x1B:
; 0000 00FD         }
; 0000 00FE         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x31
_0x18:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x32
; 0000 00FF         {
; 0000 0100             show_temperature();
	CALL _show_temperature
; 0000 0101         }
; 0000 0102         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x33
_0x32:
	LDI  R30,LOW(5)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x34
; 0000 0103         {
; 0000 0104             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0105             lcd_gotoxy(1, 1);
; 0000 0106             lcd_print("Number of students : ");
	__POINTW2MN _0xD,215
	CALL SUBOPT_0x1
; 0000 0107             lcd_gotoxy(1, 2);
; 0000 0108             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 0109             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 010A             itoa(st_counts, buffer);
	MOV  R30,R21
	CALL SUBOPT_0x18
; 0000 010B             lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 010C             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 010D 
; 0000 010E             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x36:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+2
	RJMP _0x37
; 0000 010F             {
; 0000 0110                 memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0111                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x39:
	__CPWRN 18,19,8
	BRGE _0x3A
; 0000 0112                 {
; 0000 0113                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 16));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x19
	MOVW R26,R30
	CALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0114                 }
	__ADDWRN 18,19,1
	RJMP _0x39
_0x3A:
; 0000 0115                 buffer[j] = '\0';
	CALL SUBOPT_0x1A
; 0000 0116                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0117                 lcd_gotoxy(1, 1);
; 0000 0118                 lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 0119 
; 0000 011A                 memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 011B                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3C:
	__CPWRN 18,19,8
	BRGE _0x3D
; 0000 011C                 {
; 0000 011D                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 16) + 8);
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	POP  R26
	POP  R27
	ST   X,R30
; 0000 011E                 }
	__ADDWRN 18,19,1
	RJMP _0x3C
_0x3D:
; 0000 011F                 buffer[j] = '\0';
	CALL SUBOPT_0x1A
; 0000 0120                 lcd_gotoxy(1, 2);
	CALL SUBOPT_0x1C
; 0000 0121                 snprintf(time, 3, "%s", buffer);
	CALL SUBOPT_0x1D
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	CALL SUBOPT_0x1E
; 0000 0122                 lcd_print(time);
; 0000 0123                 lcd_print(":");
	__POINTW2MN _0xD,237
	CALL SUBOPT_0x1F
; 0000 0124                 snprintf(time, 3, "%s", buffer + 2);
	__POINTW1MN _buffer,2
	CALL SUBOPT_0x1E
; 0000 0125                 lcd_print(time);
; 0000 0126                 lcd_print(" ");
	__POINTW2MN _0xD,239
	CALL SUBOPT_0x1F
; 0000 0127                 snprintf(time, 3, "%s", buffer + 4);
	__POINTW1MN _buffer,4
	CALL SUBOPT_0x1E
; 0000 0128                 lcd_print(time);
; 0000 0129                 lcd_print("/");
	__POINTW2MN _0xD,241
	CALL SUBOPT_0x1F
; 0000 012A                 snprintf(time, 3, "%s", buffer + 6);
	__POINTW1MN _buffer,6
	CALL SUBOPT_0x1E
; 0000 012B                 lcd_print(time);
; 0000 012C                 delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 012D             }
	__ADDWRN 16,17,1
	RJMP _0x36
_0x37:
; 0000 012E 
; 0000 012F             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0130             lcd_gotoxy(1, 1);
; 0000 0131             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xD,243
	CALL _lcd_print
; 0000 0132             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x3E:
	LDI  R30,LOW(5)
	CP   R30,R5
	BREQ _0x3E
; 0000 0133                 ;
; 0000 0134         }
; 0000 0135         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x41
_0x34:
	LDI  R30,LOW(6)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x42
; 0000 0136         {
; 0000 0137             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0138             lcd_gotoxy(1, 1);
; 0000 0139             lcd_print("Start Transferring...");
	__POINTW2MN _0xD,267
	CALL _lcd_print
; 0000 013A             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 013B             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x44:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+2
	RJMP _0x45
; 0000 013C             {
; 0000 013D                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x47:
	__CPWRN 18,19,8
	BRGE _0x48
; 0000 013E                 {
; 0000 013F                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16)));
	CALL SUBOPT_0x19
	MOVW R26,R30
	CALL _read_byte_from_eeprom
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0140                 }
	__ADDWRN 18,19,1
	RJMP _0x47
_0x48:
; 0000 0141 
; 0000 0142                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	CALL _USART_Transmit
; 0000 0143 
; 0000 0144                 for (j = 0; j < 2; j++)
	__GETWRN 18,19,0
_0x4A:
	__CPWRN 18,19,2
	BRGE _0x4B
; 0000 0145                 {
; 0000 0146                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0147                 }
	__ADDWRN 18,19,1
	RJMP _0x4A
_0x4B:
; 0000 0148                 USART_Transmit(':');
	LDI  R26,LOW(58)
	CALL _USART_Transmit
; 0000 0149                 for (j = 2; j < 4; j++)
	__GETWRN 18,19,2
_0x4D:
	__CPWRN 18,19,4
	BRGE _0x4E
; 0000 014A                 {
; 0000 014B                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 014C                 }
	__ADDWRN 18,19,1
	RJMP _0x4D
_0x4E:
; 0000 014D                 USART_Transmit(' ');
	LDI  R26,LOW(32)
	CALL _USART_Transmit
; 0000 014E                 for (j = 4; j < 6; j++)
	__GETWRN 18,19,4
_0x50:
	__CPWRN 18,19,6
	BRGE _0x51
; 0000 014F                 {
; 0000 0150                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0151                 }
	__ADDWRN 18,19,1
	RJMP _0x50
_0x51:
; 0000 0152                 USART_Transmit('/');
	LDI  R26,LOW(47)
	CALL _USART_Transmit
; 0000 0153                 for (j = 6; j < 8; j++)
	__GETWRN 18,19,6
_0x53:
	__CPWRN 18,19,8
	BRGE _0x54
; 0000 0154                 {
; 0000 0155                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0156                 }
	__ADDWRN 18,19,1
	RJMP _0x53
_0x54:
; 0000 0157 
; 0000 0158                 USART_Transmit('\r');
	CALL SUBOPT_0x21
; 0000 0159                 USART_Transmit('\r');
; 0000 015A 
; 0000 015B                 delay_ms(500);
; 0000 015C             }
	__ADDWRN 16,17,1
	RJMP _0x44
_0x45:
; 0000 015D             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x56:
	__CPWRN 18,19,8
	BRGE _0x57
; 0000 015E             {
; 0000 015F                 USART_Transmit('=');
	LDI  R26,LOW(61)
	CALL _USART_Transmit
; 0000 0160             }
	__ADDWRN 18,19,1
	RJMP _0x56
_0x57:
; 0000 0161 
; 0000 0162             USART_Transmit('\r');
	CALL SUBOPT_0x21
; 0000 0163             USART_Transmit('\r');
; 0000 0164             delay_ms(500);
; 0000 0165 
; 0000 0166             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0167             lcd_gotoxy(1, 1);
; 0000 0168             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xD,289
	CALL SUBOPT_0x2
; 0000 0169             delay_ms(2000);
; 0000 016A             stage = STAGE_INIT_MENU;
; 0000 016B         }
; 0000 016C         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x58
_0x42:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0x59
; 0000 016D         {
; 0000 016E             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 016F             lcd_gotoxy(1, 1);
; 0000 0170             lcd_print("1: Search Student");
	__POINTW2MN _0xD,313
	CALL SUBOPT_0x1
; 0000 0171             lcd_gotoxy(1, 2);
; 0000 0172             lcd_print("2: Delete Student");
	__POINTW2MN _0xD,331
	RCALL _lcd_print
; 0000 0173             while (stage == STAGE_STUDENT_MANAGMENT)
_0x5A:
	LDI  R30,LOW(7)
	CP   R30,R5
	BREQ _0x5A
; 0000 0174                 ;
; 0000 0175         }
; 0000 0176         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x5D
_0x59:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5E
; 0000 0177         {
; 0000 0178             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0179             lcd_gotoxy(1, 1);
; 0000 017A             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xD,349
	CALL SUBOPT_0x1
; 0000 017B             lcd_gotoxy(1, 2);
; 0000 017C             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 017D             delay_us(100 * 16); // wait
; 0000 017E             while (stage == STAGE_SEARCH_STUDENT)
_0x5F:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ _0x5F
; 0000 017F                 ;
; 0000 0180             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x4
; 0000 0181             delay_us(100 * 16); // wait
; 0000 0182         }
; 0000 0183         else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0x62
_0x5E:
	LDI  R30,LOW(9)
	CP   R30,R5
	BRNE _0x63
; 0000 0184         {
; 0000 0185             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0186             lcd_gotoxy(1, 1);
; 0000 0187             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xD,380
	CALL SUBOPT_0x1
; 0000 0188             lcd_gotoxy(1, 2);
; 0000 0189             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 018A             delay_us(100 * 16); // wait
; 0000 018B             while (stage == STAGE_DELETE_STUDENT)
_0x64:
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ _0x64
; 0000 018C                 ;
; 0000 018D             lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 018E             delay_us(100 * 16);
; 0000 018F         }
; 0000 0190         else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x67
_0x63:
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x68
; 0000 0191         {
; 0000 0192             startSonar();
	CALL _startSonar
; 0000 0193             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0194         }
; 0000 0195         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x69
_0x68:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x6A
; 0000 0196         {
; 0000 0197             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0198             lcd_gotoxy(1, 1);
; 0000 0199             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xD,411
	CALL SUBOPT_0x1
; 0000 019A             lcd_gotoxy(1, 2);
; 0000 019B             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 019C             delay_us(100 * 16); // wait
; 0000 019D             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x6B:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x6E
	TST  R6
	BREQ _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
; 0000 019E                 ;
	RJMP _0x6B
_0x6D:
; 0000 019F             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x70
; 0000 01A0             {
; 0000 01A1                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 01A2                 delay_us(100 * 16);
; 0000 01A3                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 01A4                 lcd_gotoxy(1, 1);
; 0000 01A5                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xD,441
	CALL SUBOPT_0x1
; 0000 01A6                 lcd_gotoxy(1, 2);
; 0000 01A7                 lcd_print("    press cancel to back");
	__POINTW2MN _0xD,458
	RCALL _lcd_print
; 0000 01A8                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x71:
	LDI  R30,LOW(11)
	CP   R30,R5
	BREQ _0x71
; 0000 01A9                     ;
; 0000 01AA             }
; 0000 01AB             else
	RJMP _0x74
_0x70:
; 0000 01AC             {
; 0000 01AD                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 01AE                 delay_us(100 * 16);
; 0000 01AF             }
_0x74:
; 0000 01B0         }
; 0000 01B1         else if (stage == STAGE_SET_TIMER)
	RJMP _0x75
_0x6A:
	LDI  R30,LOW(14)
	CP   R30,R5
	BRNE _0x76
; 0000 01B2         {
; 0000 01B3             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 01B4             lcd_gotoxy(1, 1);
; 0000 01B5             lcdCommand(0x0c); // display on, cursor off
	LDI  R26,LOW(12)
	RCALL _lcdCommand
; 0000 01B6             itoa(submitTime, buffer);
	MOV  R30,R9
	CALL SUBOPT_0x18
; 0000 01B7             lcd_print("Set Timer(minutes): ");
	__POINTW2MN _0xD,483
	RCALL _lcd_print
; 0000 01B8             lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 01B9             delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 01BA             while(stage == STAGE_SET_TIMER);
_0x77:
	LDI  R30,LOW(14)
	CP   R30,R5
	BREQ _0x77
; 0000 01BB             delay_us(100 * 16);
	CALL SUBOPT_0x6
; 0000 01BC         }
; 0000 01BD         else if(stage == STAGE_SHOW_CLOCK)
	RJMP _0x7A
_0x76:
	LDI  R30,LOW(13)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x7B
; 0000 01BE         {
; 0000 01BF             lcdCommand(0x01);
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 01C0             memset(Date, 0, 20);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _memset
; 0000 01C1             while(stage == STAGE_SHOW_CLOCK){
_0x7C:
	LDI  R30,LOW(13)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x7E
; 0000 01C2                 rtc_getTime(&hour, &minute, &second);
	CALL SUBOPT_0xF
; 0000 01C3                 sprintf(time, "%02x:%02x:%02x  ", hour, minute, second);
	__POINTW1FN _0x0,512
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	LDD  R30,Y+38
	CALL SUBOPT_0x14
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01C4                 lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x22
; 0000 01C5                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 01C6                 rtc_getDate(&year, &month, &date, &day);
	CALL SUBOPT_0x13
; 0000 01C7                 sprintf(time, "20%02x/%02x/%02x  %3s", year, month, date, days[day - 1]);
	__POINTW1FN _0x0,529
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+24
	CALL SUBOPT_0x14
	LDD  R30,Y+29
	CALL SUBOPT_0x14
	LDD  R30,Y+34
	CALL SUBOPT_0x14
	LDD  R30,Y+39
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
; 0000 01C8                 if(strcmp(time, Date) != 0){
	CALL SUBOPT_0x23
	MOVW R26,R28
	ADIW R26,2
	CALL _strcmp
	CPI  R30,0
	BREQ _0x7F
; 0000 01C9                     lcd_gotoxy(1,2);
	CALL SUBOPT_0x1C
; 0000 01CA                     lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 01CB                     strcpy(Date, time);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	CALL _strcpy
; 0000 01CC                 }
; 0000 01CD                 delay_ms(1000);
_0x7F:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 01CE             }
	RJMP _0x7C
_0x7E:
; 0000 01CF         }
; 0000 01D0     }
_0x7B:
_0x7A:
_0x75:
_0x69:
_0x67:
_0x62:
_0x5D:
_0x58:
_0x41:
_0x33:
_0x31:
_0x17:
_0x11:
_0xB:
	RJMP _0x7
; 0000 01D1 }
_0x80:
	RJMP _0x80
; .FEND

	.DSEG
_0xD:
	.BYTE 0x1F8
;
;interrupt[TIM2_OVF] void timer2_ovf_isr(void)
; 0000 01D4 {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 01D5     timerCount++;
	INC  R8
; 0000 01D6     if(timerCount == 60){
	LDI  R30,LOW(60)
	CP   R30,R8
	BRNE _0x81
; 0000 01D7         submitTime--;
	DEC  R9
; 0000 01D8         timerCount = 0;
	CLR  R8
; 0000 01D9     }
; 0000 01DA     TCNT2 = 0;
_0x81:
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01DB     if(submitTime == 0)
	TST  R9
	BRNE _0x82
; 0000 01DC         TIMSK = 0;
	OUT  0x39,R30
; 0000 01DD }
_0x82:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 01E1 {
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
; 0000 01E2     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 01E3     int i;
; 0000 01E4     unsigned char second, minute, hour;
; 0000 01E5     unsigned char day, date, month, year;
; 0000 01E6 
; 0000 01E7     // detect the key
; 0000 01E8     while (1)
	SBIW R28,8
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	i -> Y+12
;	second -> R20
;	minute -> Y+11
;	hour -> Y+10
;	day -> Y+9
;	date -> Y+8
;	month -> Y+7
;	year -> Y+6
; 0000 01E9     {
; 0000 01EA         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x24
; 0000 01EB         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01EC         if (colloc != 0x0F)        // column detected
	BREQ _0x86
; 0000 01ED         {
; 0000 01EE             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 01EF             break;      // exit while loop
	RJMP _0x85
; 0000 01F0         }
; 0000 01F1         KEY_PRT = 0xDF;            // ground row 1
_0x86:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x24
; 0000 01F2         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01F3         if (colloc != 0x0F)        // column detected
	BREQ _0x87
; 0000 01F4         {
; 0000 01F5             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 01F6             break;      // exit while loop
	RJMP _0x85
; 0000 01F7         }
; 0000 01F8         KEY_PRT = 0xBF;            // ground row 2
_0x87:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x24
; 0000 01F9         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01FA         if (colloc != 0x0F)        // column detected
	BREQ _0x88
; 0000 01FB         {
; 0000 01FC             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 01FD             break;      // exit while loop
	RJMP _0x85
; 0000 01FE         }
; 0000 01FF         KEY_PRT = 0x7F;            // ground row 3
_0x88:
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 0200         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 0201         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 0202         break;                     // exit while loop
; 0000 0203     }
_0x85:
; 0000 0204     // check column and send result to Port D
; 0000 0205     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x89
; 0000 0206         cl = 0;
	LDI  R19,LOW(0)
; 0000 0207     else if (colloc == 0x0D)
	RJMP _0x8A
_0x89:
	CPI  R17,13
	BRNE _0x8B
; 0000 0208         cl = 1;
	LDI  R19,LOW(1)
; 0000 0209     else if (colloc == 0x0B)
	RJMP _0x8C
_0x8B:
	CPI  R17,11
	BRNE _0x8D
; 0000 020A         cl = 2;
	LDI  R19,LOW(2)
; 0000 020B     else
	RJMP _0x8E
_0x8D:
; 0000 020C         cl = 3;
	LDI  R19,LOW(3)
; 0000 020D 
; 0000 020E     KEY_PRT &= 0x0F; // ground all rows at once
_0x8E:
_0x8C:
_0x8A:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 020F 
; 0000 0210     // inside menu level 1
; 0000 0211     if (stage == STAGE_INIT_MENU)
	TST  R5
	BREQ PC+2
	RJMP _0x8F
; 0000 0212     {
; 0000 0213         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 0214         {
; 0000 0215         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x93
; 0000 0216             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0217             break;
	RJMP _0x92
; 0000 0218         case OPTION_TEMPERATURE_MONITORING:
_0x93:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x94
; 0000 0219             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 021A             break;
	RJMP _0x92
; 0000 021B         case OPTION_VIEW_PRESENT_STUDENTS:
_0x94:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x95
; 0000 021C             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 021D             break;
	RJMP _0x92
; 0000 021E         case OPTION_RETRIEVE_STUDENT_DATA:
_0x95:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x96
; 0000 021F             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 0220             break;
	RJMP _0x92
; 0000 0221         case OPTION_STUDENT_MANAGEMENT:
_0x96:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x97
; 0000 0222             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0223             break;
	RJMP _0x92
; 0000 0224         case OPTION_TRAFFIC_MONITORING:
_0x97:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x98
; 0000 0225             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 0226             break;
	RJMP _0x92
; 0000 0227         case OPTION_LOGIN_WITH_ADMIN:
_0x98:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x99
; 0000 0228             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 0229             break;
	RJMP _0x92
; 0000 022A         case OPTION_SET_TIMER:
_0x99:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x9A
; 0000 022B             stage = STAGE_SET_TIMER;
	LDI  R30,LOW(14)
	MOV  R5,R30
; 0000 022C             break;
	RJMP _0x92
; 0000 022D         case OPTION_LOGOUT:
_0x9A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x9E
; 0000 022E #asm("cli") // disable interrupts
	cli
; 0000 022F             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x9C
; 0000 0230             {
; 0000 0231                 lcdCommand(0x1);
	CALL SUBOPT_0x0
; 0000 0232                 lcd_gotoxy(1, 1);
; 0000 0233                 lcd_print("Logout ...");
	__POINTW2MN _0x9D,0
	CALL SUBOPT_0x1
; 0000 0234                 lcd_gotoxy(1, 2);
; 0000 0235                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x9D,11
	CALL SUBOPT_0x26
; 0000 0236                 delay_ms(2000);
; 0000 0237                 logged_in = 0;
	CLR  R6
; 0000 0238 #asm("sei")
	sei
; 0000 0239                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 023A             }
; 0000 023B             break;
_0x9C:
; 0000 023C         default:
_0x9E:
; 0000 023D             break;
; 0000 023E         }
_0x92:
; 0000 023F 
; 0000 0240         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x9F
; 0000 0241         {
; 0000 0242             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0xA0
	MOV  R30,R4
	LDI  R31,0
	SBIW R30,1
	RJMP _0xA1
_0xA0:
	LDI  R30,LOW(4)
_0xA1:
	MOV  R4,R30
; 0000 0243         }
; 0000 0244         else if (keypad[rowloc][cl] == 'R')
	RJMP _0xA3
_0x9F:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0xA4
; 0000 0245         {
; 0000 0246             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	MOV  R4,R30
; 0000 0247         }
; 0000 0248         else if(keypad[rowloc][cl] == 'O')
	RJMP _0xA5
_0xA4:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xA6
; 0000 0249         {
; 0000 024A             stage = STAGE_SHOW_CLOCK;
	LDI  R30,LOW(13)
	MOV  R5,R30
; 0000 024B         }
; 0000 024C     }
_0xA6:
_0xA5:
_0xA3:
; 0000 024D     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0xA7
_0x8F:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xA8
; 0000 024E     {
; 0000 024F         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
; 0000 0250         {
; 0000 0251         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xAC
; 0000 0252             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0253             break;
	RJMP _0xAB
; 0000 0254         case '1':
_0xAC:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xAD
; 0000 0255             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0256             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0257             break;
	RJMP _0xAB
; 0000 0258         case '2':
_0xAD:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xAF
; 0000 0259             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 025A             stage = STAGE_SUBMIT_WITH_CARD;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 025B             break;
; 0000 025C         default:
_0xAF:
; 0000 025D             break;
; 0000 025E         }
_0xAB:
; 0000 025F     }
; 0000 0260     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0xB0
_0xA8:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xB1
; 0000 0261     {
; 0000 0262         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB2
; 0000 0263         {
; 0000 0264             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0265             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0266         }
; 0000 0267         if ((keypad[rowloc][cl] - '0') < 10)
_0xB2:
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xB3
; 0000 0268         {
; 0000 0269             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xB4
; 0000 026A             {
; 0000 026B                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0000 026C                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x29
; 0000 026D                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 026E             }
; 0000 026F         }
_0xB4:
; 0000 0270         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xB5
_0xB3:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xB6
; 0000 0271         {
; 0000 0272             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 0273             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xB7
; 0000 0274             {
; 0000 0275                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x2A
; 0000 0276                 lcdCommand(0x10);
; 0000 0277                 lcd_print(" ");
	__POINTW2MN _0x9D,40
	CALL SUBOPT_0x2B
; 0000 0278                 lcdCommand(0x10);
; 0000 0279             }
; 0000 027A         }
_0xB7:
; 0000 027B         else if(keypad[rowloc][cl] == 'O')
	RJMP _0xB8
_0xB6:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xB9
; 0000 027C         {
; 0000 027D             lcdCommand(0xC0);
	CALL SUBOPT_0x2C
; 0000 027E             for(i = 0; i < strlen(buffer); i++)
_0xBB:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2D
	BRSH _0xBC
; 0000 027F                 lcd_print(" ");
	__POINTW2MN _0x9D,42
	RCALL _lcd_print
	CALL SUBOPT_0x2E
	RJMP _0xBB
_0xBC:
; 0000 0280 lcdCommand(0xC0);
	CALL SUBOPT_0x2F
; 0000 0281             memset(buffer, 0, 32);
; 0000 0282         }
; 0000 0283         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xBD
_0xB9:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0xBE
; 0000 0284         {
; 0000 0285 
; 0000 0286 #asm("cli")
	cli
; 0000 0287 
; 0000 0288             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 0289                 strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0x9D,44
	CALL SUBOPT_0x9
	BRNE _0xC0
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0xBF
_0xC0:
; 0000 028A             {
; 0000 028B                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 028C                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 028D                 lcd_gotoxy(1, 1);
; 0000 028E                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x9D,47
	CALL SUBOPT_0x1
; 0000 028F                 lcd_gotoxy(1, 2);
; 0000 0290                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,77
	CALL SUBOPT_0xB
; 0000 0291                 delay_ms(2000);
; 0000 0292                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 0293             }
; 0000 0294             else if (search_student_code() > 0)
	RJMP _0xC2
_0xBF:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0xC3
; 0000 0295             {
; 0000 0296                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0297                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0298                 lcd_gotoxy(1, 1);
; 0000 0299                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x9D,108
	CALL SUBOPT_0x1
; 0000 029A                 lcd_gotoxy(1, 2);
; 0000 029B                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,139
	CALL SUBOPT_0xB
; 0000 029C                 delay_ms(2000);
; 0000 029D                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 029E             }
; 0000 029F             else
	RJMP _0xC4
_0xC3:
; 0000 02A0             {
; 0000 02A1                 // save the buffer to EEPROM
; 0000 02A2                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0x30
	MOV  R18,R30
; 0000 02A3                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
_0xC6:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,8
	BRGE _0xC7
; 0000 02A4                 {
; 0000 02A5                     write_byte_to_eeprom(i + ((st_counts + 1) * 16), buffer[i]);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LD   R26,Z
	RCALL _write_byte_to_eeprom
; 0000 02A6                 }
	CALL SUBOPT_0x2E
	RJMP _0xC6
_0xC7:
; 0000 02A7                 rtc_getTime(&hour, &minute, &second);
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R20
	RCALL _rtc_getTime
	POP  R20
; 0000 02A8                 sprintf(time, "%02x%02x", hour, minute);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x10
	LDD  R30,Y+14
	CALL SUBOPT_0x14
	LDD  R30,Y+19
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
; 0000 02A9                 for (i = 0; i < 4; i++)
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
_0xC9:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,4
	BRGE _0xCA
; 0000 02AA                 {
; 0000 02AB                     write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i]);
	CALL SUBOPT_0x31
	ADIW R30,8
	CALL SUBOPT_0x32
	SUBI R30,LOW(-_time)
	SBCI R31,HIGH(-_time)
	LD   R26,Z
	RCALL _write_byte_to_eeprom
; 0000 02AC                 }
	CALL SUBOPT_0x2E
	RJMP _0xC9
_0xCA:
; 0000 02AD                 rtc_getDate(&year, &month, &date, &day);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,9
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,15
	RCALL _rtc_getDate
; 0000 02AE                 sprintf(time, "%02x%02x", month, date);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x10
	LDD  R30,Y+11
	CALL SUBOPT_0x14
	LDD  R30,Y+16
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
; 0000 02AF                 for (i = 4; i < 8; i++)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+12,R30
	STD  Y+12+1,R31
_0xCC:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,8
	BRGE _0xCD
; 0000 02B0                 {
; 0000 02B1                     write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i - 4]);
	CALL SUBOPT_0x31
	ADIW R30,8
	CALL SUBOPT_0x32
	CALL SUBOPT_0x15
; 0000 02B2                 }
	CALL SUBOPT_0x2E
	RJMP _0xCC
_0xCD:
; 0000 02B3                 write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0x16
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 02B4 
; 0000 02B5                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 02B6                 lcd_gotoxy(1, 1);
; 0000 02B7                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x9D,170
	CALL SUBOPT_0x1
; 0000 02B8                 lcd_gotoxy(1, 2);
; 0000 02B9                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,202
	CALL SUBOPT_0x26
; 0000 02BA                 delay_ms(2000);
; 0000 02BB             }
_0xC4:
_0xC2:
; 0000 02BC             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02BD #asm("sei")
	sei
; 0000 02BE             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x1BB
; 0000 02BF         }
; 0000 02C0         else if (keypad[rowloc][cl] == 'C')
_0xBE:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCF
; 0000 02C1             stage = STAGE_ATTENDENC_MENU;
_0x1BB:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 02C2     }
_0xCF:
_0xBD:
_0xB8:
_0xB5:
; 0000 02C3     else if (stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0xD0
_0xB1:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0xD1
; 0000 02C4     {
; 0000 02C5         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD2
; 0000 02C6         {
; 0000 02C7             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02C8             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 02C9         }
; 0000 02CA     }
_0xD2:
; 0000 02CB     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0xD3
_0xD1:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0xD4
; 0000 02CC     {
; 0000 02CD         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD5
; 0000 02CE             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 02CF     }
_0xD5:
; 0000 02D0     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0xD6
_0xD4:
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0xD7
; 0000 02D1     {
; 0000 02D2         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD8
; 0000 02D3             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 02D4     }
_0xD8:
; 0000 02D5     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0xD9
_0xD7:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0xDA
; 0000 02D6     {
; 0000 02D7         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xDB
; 0000 02D8             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 02D9         else if (keypad[rowloc][cl] == '1')
	RJMP _0xDC
_0xDB:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0xDD
; 0000 02DA             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(8)
	RJMP _0x1BC
; 0000 02DB         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0xDD:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xE0
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0xE1
_0xE0:
	RJMP _0xDF
_0xE1:
; 0000 02DC             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(9)
	RJMP _0x1BC
; 0000 02DD         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0xDF:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xE4
	TST  R6
	BREQ _0xE5
_0xE4:
	RJMP _0xE3
_0xE5:
; 0000 02DE         {
; 0000 02DF             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 02E0             lcd_gotoxy(1, 1);
; 0000 02E1             lcd_print("You Must First Login");
	__POINTW2MN _0x9D,233
	CALL SUBOPT_0x1
; 0000 02E2             lcd_gotoxy(1, 2);
; 0000 02E3             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x9D,254
	CALL SUBOPT_0x26
; 0000 02E4             delay_ms(2000);
; 0000 02E5             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
_0x1BC:
	MOV  R5,R30
; 0000 02E6         }
; 0000 02E7     }
_0xE3:
_0xDC:
; 0000 02E8     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0xE6
_0xDA:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xE7
; 0000 02E9     {
; 0000 02EA         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xE8
; 0000 02EB         {
; 0000 02EC             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02ED             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x1BD
; 0000 02EE         }
; 0000 02EF         else if ((keypad[rowloc][cl] - '0') < 10)
_0xE8:
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xEA
; 0000 02F0         {
; 0000 02F1             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xEB
; 0000 02F2             {
; 0000 02F3                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0000 02F4                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x29
; 0000 02F5                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02F6             }
; 0000 02F7         }
_0xEB:
; 0000 02F8         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xEC
_0xEA:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xED
; 0000 02F9         {
; 0000 02FA             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 02FB             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xEE
; 0000 02FC             {
; 0000 02FD                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x2A
; 0000 02FE                 lcdCommand(0x10);
; 0000 02FF                 lcd_print(" ");
	__POINTW2MN _0x9D,283
	CALL SUBOPT_0x2B
; 0000 0300                 lcdCommand(0x10);
; 0000 0301             }
; 0000 0302         }
_0xEE:
; 0000 0303         else if (keypad[rowloc][cl] == 'O')
	RJMP _0xEF
_0xED:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xF0
; 0000 0304         {
; 0000 0305             lcdCommand(0xC0);
	CALL SUBOPT_0x2C
; 0000 0306             for(i = 0; i < strlen(buffer); i++)
_0xF2:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2D
	BRSH _0xF3
; 0000 0307                 lcd_print(" ");
	__POINTW2MN _0x9D,285
	RCALL _lcd_print
	CALL SUBOPT_0x2E
	RJMP _0xF2
_0xF3:
; 0000 0308 lcdCommand(0xC0);
	CALL SUBOPT_0x2F
; 0000 0309             memset(buffer, 0, 32);
; 0000 030A         }
; 0000 030B         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xF4
_0xF0:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xF5
; 0000 030C         {
; 0000 030D             // search from eeprom data
; 0000 030E             unsigned char result = search_student_code();
; 0000 030F 
; 0000 0310             if (result > 0)
	CALL SUBOPT_0x33
;	i -> Y+13
;	minute -> Y+12
;	hour -> Y+11
;	day -> Y+10
;	date -> Y+9
;	month -> Y+8
;	year -> Y+7
;	result -> Y+0
	BRLO _0xF6
; 0000 0311             {
; 0000 0312                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0313                 lcd_gotoxy(1, 1);
; 0000 0314                 lcd_print("Student Code Found");
	__POINTW2MN _0x9D,287
	CALL SUBOPT_0x1
; 0000 0315                 lcd_gotoxy(1, 2);
; 0000 0316                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,306
	RJMP _0x1BE
; 0000 0317                 delay_ms(2000);
; 0000 0318             }
; 0000 0319             else
_0xF6:
; 0000 031A             {
; 0000 031B                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 031C                 lcd_gotoxy(1, 1);
; 0000 031D                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x9D,337
	CALL SUBOPT_0x1
; 0000 031E                 lcd_gotoxy(1, 2);
; 0000 031F                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,366
_0x1BE:
	RCALL _lcd_print
; 0000 0320                 delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 0321             }
; 0000 0322             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0323             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0324         }
	ADIW R28,1
; 0000 0325         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xF8
_0xF5:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xF9
; 0000 0326             stage = STAGE_STUDENT_MANAGMENT;
_0x1BD:
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0327     }
_0xF9:
_0xF8:
_0xF4:
_0xEF:
_0xEC:
; 0000 0328     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xFA
_0xE7:
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xFB
; 0000 0329     {
; 0000 032A         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xFC
; 0000 032B         {
; 0000 032C             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 032D             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 032E         }
; 0000 032F         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xFD
_0xFC:
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xFE
; 0000 0330         {
; 0000 0331             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xFF
; 0000 0332             {
; 0000 0333                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0000 0334                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x29
; 0000 0335                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0336             }
; 0000 0337         }
_0xFF:
; 0000 0338         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x100
_0xFE:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x101
; 0000 0339         {
; 0000 033A             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 033B             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x102
; 0000 033C             {
; 0000 033D                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x2A
; 0000 033E                 lcdCommand(0x10);
; 0000 033F                 lcd_print(" ");
	__POINTW2MN _0x9D,397
	CALL SUBOPT_0x2B
; 0000 0340                 lcdCommand(0x10);
; 0000 0341             }
; 0000 0342         }
_0x102:
; 0000 0343         else if (keypad[rowloc][cl] == 'O')
	RJMP _0x103
_0x101:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x104
; 0000 0344         {
; 0000 0345             lcdCommand(0xC0);
	CALL SUBOPT_0x2C
; 0000 0346             for(i = 0; i < strlen(buffer); i++)
_0x106:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2D
	BRSH _0x107
; 0000 0347                 lcd_print(" ");
	__POINTW2MN _0x9D,399
	RCALL _lcd_print
	CALL SUBOPT_0x2E
	RJMP _0x106
_0x107:
; 0000 0348 lcdCommand(0xC0);
	CALL SUBOPT_0x2F
; 0000 0349             memset(buffer, 0, 32);
; 0000 034A         }
; 0000 034B         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x108
_0x104:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x109
; 0000 034C         {
; 0000 034D             // search from eeprom data
; 0000 034E             unsigned char result = search_student_code();
; 0000 034F 
; 0000 0350             if (result > 0)
	CALL SUBOPT_0x33
;	i -> Y+13
;	minute -> Y+12
;	hour -> Y+11
;	day -> Y+10
;	date -> Y+9
;	month -> Y+8
;	year -> Y+7
;	result -> Y+0
	BRLO _0x10A
; 0000 0351             {
; 0000 0352                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0353                 lcd_gotoxy(1, 1);
; 0000 0354                 lcd_print("Student Code Found");
	__POINTW2MN _0x9D,401
	CALL SUBOPT_0x1
; 0000 0355                 lcd_gotoxy(1, 2);
; 0000 0356                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x9D,420
	RCALL _lcd_print
; 0000 0357                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 0358                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0359                 lcd_gotoxy(1, 1);
; 0000 035A                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x9D,439
	CALL SUBOPT_0x1
; 0000 035B                 lcd_gotoxy(1, 2);
; 0000 035C                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,464
	RJMP _0x1BF
; 0000 035D                 delay_ms(2000);
; 0000 035E             }
; 0000 035F             else
_0x10A:
; 0000 0360             {
; 0000 0361                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0362                 lcd_gotoxy(1, 1);
; 0000 0363                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x9D,495
	CALL SUBOPT_0x1
; 0000 0364                 lcd_gotoxy(1, 2);
; 0000 0365                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,524
_0x1BF:
	RCALL _lcd_print
; 0000 0366                 delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 0367             }
; 0000 0368             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0369             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 036A         }
	ADIW R28,1
; 0000 036B     }
_0x109:
_0x108:
_0x103:
_0x100:
_0xFD:
; 0000 036C     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x10C
_0xFB:
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x10D
; 0000 036D     {
; 0000 036E         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x10E
; 0000 036F             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0370     }
_0x10E:
; 0000 0371     else if (stage == STAGE_SHOW_CLOCK)
	RJMP _0x10F
_0x10D:
	LDI  R30,LOW(13)
	CP   R30,R5
	BRNE _0x110
; 0000 0372     {
; 0000 0373         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x111
; 0000 0374             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0375     }
_0x111:
; 0000 0376     else if (stage == STAGE_SET_TIMER)
	RJMP _0x112
_0x110:
	LDI  R30,LOW(14)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x113
; 0000 0377     {
; 0000 0378         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x114
; 0000 0379         {
; 0000 037A             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 037B             stage = STAGE_INIT_MENU;
	RJMP _0x1C0
; 0000 037C         }
; 0000 037D 
; 0000 037E         else if(keypad[rowloc][cl] == 'R')
_0x114:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x116
; 0000 037F         {
; 0000 0380             if(submitTime < 20){
	LDI  R30,LOW(20)
	CP   R9,R30
	BRSH _0x117
; 0000 0381                 submitTime++;
	INC  R9
; 0000 0382                 itoa(submitTime, buffer);
	MOV  R30,R9
	CALL SUBOPT_0x18
; 0000 0383                 lcd_gotoxy(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x22
; 0000 0384                 lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 0385                 lcd_print("  ");
	__POINTW2MN _0x9D,555
	RCALL _lcd_print
; 0000 0386             }
; 0000 0387         }
_0x117:
; 0000 0388         else if(keypad[rowloc][cl] == 'L')
	RJMP _0x118
_0x116:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x119
; 0000 0389         {
; 0000 038A             if(submitTime > 1){
	LDI  R30,LOW(1)
	CP   R30,R9
	BRSH _0x11A
; 0000 038B                 submitTime--;
	DEC  R9
; 0000 038C                 itoa(submitTime, buffer);
	MOV  R30,R9
	CALL SUBOPT_0x18
; 0000 038D                 lcd_gotoxy(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x22
; 0000 038E                 lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 038F                 lcd_print("  ");
	__POINTW2MN _0x9D,558
	RCALL _lcd_print
; 0000 0390             }
; 0000 0391         }
_0x11A:
; 0000 0392         else if(keypad[rowloc][cl] == 'E')
	RJMP _0x11B
_0x119:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x11C
; 0000 0393         {
; 0000 0394             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0395             lcd_gotoxy(1,1);
; 0000 0396             lcd_print("Timer started");
	__POINTW2MN _0x9D,561
	RCALL _lcd_print
; 0000 0397             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0398             delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 0399             Timer2_Init();
	RCALL _Timer2_Init
; 0000 039A             stage = STAGE_INIT_MENU;
_0x1C0:
	CLR  R5
; 0000 039B         }
; 0000 039C 
; 0000 039D     }
_0x11C:
_0x11B:
_0x118:
; 0000 039E     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0x11D
_0x113:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x11F
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x120
_0x11F:
	RJMP _0x11E
_0x120:
; 0000 039F     {
; 0000 03A0         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x121
; 0000 03A1         {
; 0000 03A2             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 03A3             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03A4         }
; 0000 03A5 
; 0000 03A6         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0x122
_0x121:
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x123
; 0000 03A7         {
; 0000 03A8             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0x124
; 0000 03A9             {
; 0000 03AA                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0000 03AB                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x29
; 0000 03AC                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 03AD             }
; 0000 03AE         }
_0x124:
; 0000 03AF         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x125
_0x123:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x126
; 0000 03B0         {
; 0000 03B1             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 03B2             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x127
; 0000 03B3             {
; 0000 03B4                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x2A
; 0000 03B5                 lcdCommand(0x10);
; 0000 03B6                 lcd_print(" ");
	__POINTW2MN _0x9D,575
	CALL SUBOPT_0x2B
; 0000 03B7                 lcdCommand(0x10);
; 0000 03B8             }
; 0000 03B9         }
_0x127:
; 0000 03BA         else if (keypad[rowloc][cl] == 'O')
	RJMP _0x128
_0x126:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x129
; 0000 03BB         {
; 0000 03BC             lcdCommand(0xC0);
	CALL SUBOPT_0x2C
; 0000 03BD             for(i = 0; i < strlen(buffer); i++)
_0x12B:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2D
	BRSH _0x12C
; 0000 03BE                 lcd_print(" ");
	__POINTW2MN _0x9D,577
	RCALL _lcd_print
	CALL SUBOPT_0x2E
	RJMP _0x12B
_0x12C:
; 0000 03BF lcdCommand(0xC0);
	CALL SUBOPT_0x2F
; 0000 03C0             memset(buffer, 0, 32);
; 0000 03C1         }
; 0000 03C2         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x12D
_0x129:
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x12E
; 0000 03C3         {
; 0000 03C4             // search from eeprom data
; 0000 03C5             unsigned int input_hash = simple_hash(buffer);
; 0000 03C6 
; 0000 03C7             if (input_hash == secret)
	SBIW R28,2
;	i -> Y+14
;	minute -> Y+13
;	hour -> Y+12
;	day -> Y+11
;	date -> Y+10
;	month -> Y+9
;	year -> Y+8
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
	BRNE _0x12F
; 0000 03C8             {
; 0000 03C9                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 03CA                 lcd_gotoxy(1, 1);
; 0000 03CB                 lcd_print("Login Successfully");
	__POINTW2MN _0x9D,579
	CALL SUBOPT_0x1
; 0000 03CC                 lcd_gotoxy(1, 2);
; 0000 03CD                 lcd_print("Wait...");
	__POINTW2MN _0x9D,598
	CALL SUBOPT_0x26
; 0000 03CE                 delay_ms(2000);
; 0000 03CF                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 03D0             }
; 0000 03D1             else
	RJMP _0x130
_0x12F:
; 0000 03D2             {
; 0000 03D3                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 03D4                 lcd_gotoxy(1, 1);
; 0000 03D5                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x9D,606
	CALL SUBOPT_0x1
; 0000 03D6                 lcd_gotoxy(1, 2);
; 0000 03D7                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9D,632
	CALL SUBOPT_0x26
; 0000 03D8                 delay_ms(2000);
; 0000 03D9             }
_0x130:
; 0000 03DA             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 03DB             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03DC         }
	ADIW R28,2
; 0000 03DD     }
_0x12E:
_0x12D:
_0x128:
_0x125:
_0x122:
; 0000 03DE     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0x131
_0x11E:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x133
	TST  R6
	BRNE _0x134
_0x133:
	RJMP _0x132
_0x134:
; 0000 03DF     {
; 0000 03E0         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x25
	LD   R30,X
	LDI  R31,0
; 0000 03E1         {
; 0000 03E2         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x138
; 0000 03E3             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03E4             break;
	RJMP _0x137
; 0000 03E5         case '1':
_0x138:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x13A
; 0000 03E6 #asm("cli") // disable interrupts
	cli
; 0000 03E7             lcdCommand(0x1);
	CALL SUBOPT_0x0
; 0000 03E8             lcd_gotoxy(1, 1);
; 0000 03E9             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x9D,663
	RCALL _lcd_print
; 0000 03EA             clear_eeprom();
	RCALL _clear_eeprom
; 0000 03EB #asm("sei") // enable interrupts
	sei
; 0000 03EC             break;
; 0000 03ED         default:
_0x13A:
; 0000 03EE             break;
; 0000 03EF         }
_0x137:
; 0000 03F0         memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 03F1         stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03F2     }
; 0000 03F3 }
_0x132:
_0x131:
_0x11D:
_0x112:
_0x10F:
_0x10C:
_0xFA:
_0xE6:
_0xD9:
_0xD6:
_0xD3:
_0xD0:
_0xB0:
_0xA7:
	CALL __LOADLOCR6
	ADIW R28,14
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
_0x9D:
	.BYTE 0x2AB
;
;void lcdCommand(unsigned char cmnd)
; 0000 03F6 {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 03F7     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x34
;	cmnd -> Y+0
; 0000 03F8     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x1B,0
; 0000 03F9     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x35
; 0000 03FA     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03FB     delay_us(1 * 16);          // wait to make EN wider
; 0000 03FC     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03FD     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 03FE     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x36
; 0000 03FF     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0400     delay_us(1 * 16);          // wait to make EN wider
; 0000 0401     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0402 }
	RJMP _0x20C0006
; .FEND
;void lcdData(unsigned char data)
; 0000 0404 {
_lcdData:
; .FSTART _lcdData
; 0000 0405     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x34
;	data -> Y+0
; 0000 0406     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x1B,0
; 0000 0407     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x35
; 0000 0408     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0409     delay_us(1 * 16);          // wait to make EN wider
; 0000 040A     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 040B     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x36
; 0000 040C     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 040D     delay_us(1 * 16);          // wait to make EN wider
; 0000 040E     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 040F }
	RJMP _0x20C0006
; .FEND
;void lcd_init()
; 0000 0411 {
_lcd_init:
; .FSTART _lcd_init
; 0000 0412     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0413     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x1B,2
; 0000 0414     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 0415     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x37
; 0000 0416     delay_us(100 * 16);        // wait
; 0000 0417     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x37
; 0000 0418     delay_us(100 * 16);        // wait
; 0000 0419     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x37
; 0000 041A     delay_us(100 * 16);        // wait
; 0000 041B     lcdCommand(0x0c);          // display on, cursor off
	CALL SUBOPT_0x4
; 0000 041C     delay_us(100 * 16);        // wait
; 0000 041D     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 041E     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 041F     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x37
; 0000 0420     delay_us(100 * 16);
; 0000 0421 }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 0423 {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 0424     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 0425     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0x37
; 0000 0426     delay_us(100 * 16);
; 0000 0427 }
	RJMP _0x20C0005
; .FEND
;void lcd_print(char *str)
; 0000 0429 {
_lcd_print:
; .FSTART _lcd_print
; 0000 042A     unsigned char i = 0;
; 0000 042B     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x13B:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x13D
; 0000 042C     {
; 0000 042D         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 042E         i++;
	SUBI R17,-1
; 0000 042F     }
	RJMP _0x13B
_0x13D:
; 0000 0430 }
	LDD  R17,Y+0
	RJMP _0x20C0009
; .FEND
;
;void show_temperature()
; 0000 0433 {
_show_temperature:
; .FSTART _show_temperature
; 0000 0434     unsigned char temperatureVal = 0;
; 0000 0435     unsigned char temperatureRep[3];
; 0000 0436 
; 0000 0437     DDRA &= ~(1 << 3);
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	CBI  0x1A,3
; 0000 0438     ADMUX = 0xE3;
	LDI  R30,LOW(227)
	OUT  0x7,R30
; 0000 0439     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 043A 
; 0000 043B     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 043C     lcd_gotoxy(1, 1);
; 0000 043D     lcd_print("Temperature(C):");
	__POINTW2MN _0x13E,0
	RCALL _lcd_print
; 0000 043E 
; 0000 043F     while (stage == STAGE_TEMPERATURE_MONITORING)
_0x13F:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x141
; 0000 0440     {
; 0000 0441         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 0442         while ((ADCSRA & (1 << ADIF)) == 0)
_0x142:
	SBIS 0x6,4
; 0000 0443             ;
	RJMP _0x142
; 0000 0444         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0x145
; 0000 0445         {
; 0000 0446             temperatureVal = ADCH;
	IN   R17,5
; 0000 0447             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 0448             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	CALL SUBOPT_0x22
; 0000 0449             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 044A             lcd_print(" ");
	__POINTW2MN _0x13E,16
	RCALL _lcd_print
; 0000 044B         }
; 0000 044C         delay_ms(500);
_0x145:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 044D     }
	RJMP _0x13F
_0x141:
; 0000 044E 
; 0000 044F     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0450 }
	LDD  R17,Y+0
	RJMP _0x20C0007
; .FEND

	.DSEG
_0x13E:
	.BYTE 0x12
;
;void show_menu()
; 0000 0453 {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 0454     while (stage == STAGE_INIT_MENU)
_0x146:
	TST  R5
	BREQ PC+2
	RJMP _0x148
; 0000 0455     {
; 0000 0456         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0457         lcd_gotoxy(1, 1);
; 0000 0458         if (page_num == 0)
	TST  R4
	BRNE _0x149
; 0000 0459         {
; 0000 045A             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0x14A,0
	CALL SUBOPT_0x1
; 0000 045B             lcd_gotoxy(1, 2);
; 0000 045C             lcd_print("2: Student Management");
	__POINTW2MN _0x14A,29
	RCALL _lcd_print
; 0000 045D             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0x14B:
	TST  R4
	BRNE _0x14E
	TST  R5
	BREQ _0x14F
_0x14E:
	RJMP _0x14D
_0x14F:
; 0000 045E                 ;
	RJMP _0x14B
_0x14D:
; 0000 045F         }
; 0000 0460         else if (page_num == 1)
	RJMP _0x150
_0x149:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x151
; 0000 0461         {
; 0000 0462             lcd_print("3: View Present Students ");
	__POINTW2MN _0x14A,51
	CALL SUBOPT_0x1
; 0000 0463             lcd_gotoxy(1, 2);
; 0000 0464             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0x14A,77
	RCALL _lcd_print
; 0000 0465             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0x152:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x155
	TST  R5
	BREQ _0x156
_0x155:
	RJMP _0x154
_0x156:
; 0000 0466                 ;
	RJMP _0x152
_0x154:
; 0000 0467         }
; 0000 0468         else if (page_num == 2)
	RJMP _0x157
_0x151:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x158
; 0000 0469         {
; 0000 046A             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0x14A,103
	CALL SUBOPT_0x1
; 0000 046B             lcd_gotoxy(1, 2);
; 0000 046C             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0x14A,128
	RCALL _lcd_print
; 0000 046D             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0x159:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x15C
	TST  R5
	BREQ _0x15D
_0x15C:
	RJMP _0x15B
_0x15D:
; 0000 046E                 ;
	RJMP _0x159
_0x15B:
; 0000 046F         }
; 0000 0470         else if (page_num == 3)
	RJMP _0x15E
_0x158:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x15F
; 0000 0471         {
; 0000 0472             lcd_print("7: Login With Admin");
	__POINTW2MN _0x14A,150
	CALL SUBOPT_0x1
; 0000 0473             lcd_gotoxy(1, 2);
; 0000 0474             lcd_print("8: Logout");
	__POINTW2MN _0x14A,170
	RCALL _lcd_print
; 0000 0475             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0x160:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x163
	TST  R5
	BREQ _0x164
_0x163:
	RJMP _0x162
_0x164:
; 0000 0476                 ;
	RJMP _0x160
_0x162:
; 0000 0477         }
; 0000 0478         else if (page_num == 4)
	RJMP _0x165
_0x15F:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x166
; 0000 0479         {
; 0000 047A             lcd_print("9: Set Timer");
	__POINTW2MN _0x14A,180
	RCALL _lcd_print
; 0000 047B             while (page_num == 4 && stage == STAGE_INIT_MENU)
_0x167:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x16A
	TST  R5
	BREQ _0x16B
_0x16A:
	RJMP _0x169
_0x16B:
; 0000 047C                 ;
	RJMP _0x167
_0x169:
; 0000 047D         }
; 0000 047E     }
_0x166:
_0x165:
_0x15E:
_0x157:
_0x150:
	RJMP _0x146
_0x148:
; 0000 047F }
	RET
; .FEND

	.DSEG
_0x14A:
	.BYTE 0xC1
;
;void clear_eeprom()
; 0000 0482 {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 0483     unsigned int i;
; 0000 0484 
; 0000 0485     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x16D:
	__CPWRN 16,17,1024
	BRSH _0x16E
; 0000 0486     {
; 0000 0487         // Wait for the previous write to complete
; 0000 0488         while (EECR & (1 << EEWE))
_0x16F:
	SBIC 0x1C,1
; 0000 0489             ;
	RJMP _0x16F
; 0000 048A 
; 0000 048B         // Set up address registers
; 0000 048C         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 048D         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 048E 
; 0000 048F         // Set up data register
; 0000 0490         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 0491 
; 0000 0492         // Enable write
; 0000 0493         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 0494         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0495     }
	__ADDWRN 16,17,1
	RJMP _0x16D
_0x16E:
; 0000 0496 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 0499 {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 049A     unsigned char x;
; 0000 049B     // Wait for the previous write to complete
; 0000 049C     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x172:
	SBIC 0x1C,1
; 0000 049D         ;
	RJMP _0x172
; 0000 049E 
; 0000 049F     // Set up address registers
; 0000 04A0     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x38
; 0000 04A1     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 04A2     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 04A3     x = EEDR;
	IN   R17,29
; 0000 04A4     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0009
; 0000 04A5 }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 04A8 {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 04A9     // Wait for the previous write to complete
; 0000 04AA     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x175:
	SBIC 0x1C,1
; 0000 04AB         ;
	RJMP _0x175
; 0000 04AC 
; 0000 04AD     // Set up address registers
; 0000 04AE     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x38
; 0000 04AF     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 04B0 
; 0000 04B1     // Set up data register
; 0000 04B2     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 04B3 
; 0000 04B4     // Enable write
; 0000 04B5     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 04B6     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 04B7 }
_0x20C0009:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 04BA {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 04BB     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x178:
	SBIS 0xB,5
; 0000 04BC         ;
	RJMP _0x178
; 0000 04BD     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 04BE }
	RJMP _0x20C0006
; .FEND
;
;unsigned char USART_Receive()
; 0000 04C1 {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 04C2     while(!(UCSRA & (1 << RXC)) && stage == STAGE_SUBMIT_WITH_CARD);
_0x17B:
	SBIC 0xB,7
	RJMP _0x17E
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x17F
_0x17E:
	RJMP _0x17D
_0x17F:
	RJMP _0x17B
_0x17D:
; 0000 04C3     return UDR;
	IN   R30,0xC
	RET
; 0000 04C4 }
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 04C7 {
_USART_init:
; .FSTART _USART_init
; 0000 04C8     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 04C9     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 04CA     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 04CB     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 04CC }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 04CF {
_search_student_code:
; .FSTART _search_student_code
; 0000 04D0     unsigned char st_counts, i, j;
; 0000 04D1     char temp[10];
; 0000 04D2 
; 0000 04D3     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0x30
	MOV  R17,R30
; 0000 04D4 
; 0000 04D5     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x181:
	CP   R16,R17
	BRSH _0x182
; 0000 04D6     {
; 0000 04D7         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 04D8         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x184:
	CPI  R19,8
	BRSH _0x185
; 0000 04D9         {
; 0000 04DA             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 16));
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x39
	POP  R26
	POP  R27
	ST   X,R30
; 0000 04DB         }
	SUBI R19,-1
	RJMP _0x184
_0x185:
; 0000 04DC         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 04DD         if (strncmp(temp, buffer, 8) == 0)
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x186
; 0000 04DE             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20C0008
; 0000 04DF     }
_0x186:
	SUBI R16,-1
	RJMP _0x181
_0x182:
; 0000 04E0 
; 0000 04E1     return 0;
	LDI  R30,LOW(0)
_0x20C0008:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 04E2 }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 04E5 {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 04E6     unsigned char st_counts, i, j;
; 0000 04E7     unsigned char temp;
; 0000 04E8 
; 0000 04E9     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0x30
	MOV  R17,R30
; 0000 04EA 
; 0000 04EB     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x188:
	CP   R17,R16
	BRLO _0x189
; 0000 04EC     {
; 0000 04ED         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x18B:
	CPI  R19,8
	BRSH _0x18C
; 0000 04EE         {
; 0000 04EF             temp = read_byte_from_eeprom(j + ((i + 1) * 16));
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
; 0000 04F0             write_byte_to_eeprom(j + (i * 16), temp);
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	RCALL _write_byte_to_eeprom
; 0000 04F1         }
	SUBI R19,-1
	RJMP _0x18B
_0x18C:
; 0000 04F2         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x18E:
	CPI  R19,8
	BRSH _0x18F
; 0000 04F3         {
; 0000 04F4             temp = read_byte_from_eeprom(j + ((i + 1) * 16) + 8);
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW4
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,8
	RCALL _read_byte_from_eeprom
	CALL SUBOPT_0x3A
; 0000 04F5             write_byte_to_eeprom(j + (i * 16) + 8, temp);
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	RCALL _write_byte_to_eeprom
; 0000 04F6         }
	SUBI R19,-1
	RJMP _0x18E
_0x18F:
; 0000 04F7     }
	SUBI R16,-1
	RJMP _0x188
_0x189:
; 0000 04F8     write_byte_to_eeprom(0x0, st_counts - 1);
	CALL SUBOPT_0x16
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 04F9 }
	CALL __LOADLOCR4
	JMP  _0x20C0003
; .FEND
;
;void HCSR04Init()
; 0000 04FC {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 04FD     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 04FE     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 04FF }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 0502 {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 0503     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 0504     delay_us(15 * 16);              // Wait for 15 microseconds
	__DELAY_USW 480
; 0000 0505     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 0506 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 0509 {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 050A     uint32_t i, result;
; 0000 050B 
; 0000 050C     // Wait for rising edge on Echo pin
; 0000 050D     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x191:
	CALL SUBOPT_0x3B
	BRSH _0x192
; 0000 050E     {
; 0000 050F         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 0510             continue;
	RJMP _0x190
; 0000 0511         else
; 0000 0512             break;
	RJMP _0x192
; 0000 0513     }
_0x190:
	CALL SUBOPT_0x3C
	RJMP _0x191
_0x192:
; 0000 0514 
; 0000 0515     if (i == 600000)
	CALL SUBOPT_0x3B
	BRNE _0x195
; 0000 0516         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
; 0000 0517 
; 0000 0518     // Start timer with prescaler 64
; 0000 0519     TCCR1A = 0x00;
_0x195:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 051A     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 051B     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 051C 
; 0000 051D     // Wait for falling edge on Echo pin
; 0000 051E     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x197:
	CALL SUBOPT_0x3B
	BRSH _0x198
; 0000 051F     {
; 0000 0520         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 0521             break; // Falling edge detected
	RJMP _0x198
; 0000 0522         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x19A
; 0000 0523             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0004
; 0000 0524     }
_0x19A:
	CALL SUBOPT_0x3C
	RJMP _0x197
_0x198:
; 0000 0525 
; 0000 0526     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 0527     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0528 
; 0000 0529     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x19B
; 0000 052A         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0004
; 0000 052B     else
_0x19B:
; 0000 052C         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
	RJMP _0x20C0004
; 0000 052D }
; .FEND
;
;void startSonar()
; 0000 0530 {
_startSonar:
; .FSTART _startSonar
; 0000 0531     char numberString[16];
; 0000 0532     uint16_t pulseWidth; // Pulse width from echo
; 0000 0533     int distance, previous_distance = -1;
; 0000 0534     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 0535 
; 0000 0536     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x0
; 0000 0537     lcd_gotoxy(1, 1);
; 0000 0538     lcd_print("Distance: ");
	__POINTW2MN _0x19E,0
	RCALL _lcd_print
; 0000 0539 
; 0000 053A     while (stage == STAGE_TRAFFIC_MONITORING)
_0x19F:
	LDI  R30,LOW(10)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x1A1
; 0000 053B     {
; 0000 053C         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 053D         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 053E 
; 0000 053F         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1A2
; 0000 0540         {
; 0000 0541             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0542             lcd_gotoxy(1, 1);
; 0000 0543             lcd_print("Error"); // Display error message
	__POINTW2MN _0x19E,11
	RJMP _0x1C1
; 0000 0544         }
; 0000 0545         else if (pulseWidth == US_NO_OBSTACLE)
_0x1A2:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1A4
; 0000 0546         {
; 0000 0547             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0548             lcd_gotoxy(1, 1);
; 0000 0549             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x19E,17
	RJMP _0x1C1
; 0000 054A         }
; 0000 054B         else
_0x1A4:
; 0000 054C         {
; 0000 054D             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 054E 
; 0000 054F             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x1A6
; 0000 0550             {
; 0000 0551                 previous_distance = distance;
	MOVW R20,R18
; 0000 0552                 // Display distance on LCD
; 0000 0553                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0554                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x22
; 0000 0555                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 0556                 lcd_print(" cm ");
	__POINTW2MN _0x19E,29
	RCALL _lcd_print
; 0000 0557             }
; 0000 0558             // Counting logic based on distance
; 0000 0559             if (distance < 6)
_0x1A6:
	__CPWRN 18,19,6
	BRGE _0x1A7
; 0000 055A             {
; 0000 055B                 US_count++; // Increment count if distance is below threshold
	INC  R7
; 0000 055C             }
; 0000 055D 
; 0000 055E             // Update count on LCD only if it changes
; 0000 055F             if (US_count != previous_count)
_0x1A7:
	LDS  R30,_previous_count_S0000015000
	LDS  R31,_previous_count_S0000015000+1
	MOV  R26,R7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x1A8
; 0000 0560             {
; 0000 0561                 previous_count = US_count;
	MOV  R30,R7
	LDI  R31,0
	STS  _previous_count_S0000015000,R30
	STS  _previous_count_S0000015000+1,R31
; 0000 0562                 lcd_gotoxy(1, 2); // Move to second line
	CALL SUBOPT_0x1C
; 0000 0563                 itoa(US_count, numberString);
	MOV  R30,R7
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0564                 lcd_print("Count: ");
	__POINTW2MN _0x19E,34
	RCALL _lcd_print
; 0000 0565                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x1C1:
	RCALL _lcd_print
; 0000 0566             }
; 0000 0567         }
_0x1A8:
; 0000 0568         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0569     }
	RJMP _0x19F
_0x1A1:
; 0000 056A }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x19E:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 056D {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 056E     unsigned int hash = 0;
; 0000 056F     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x1A9:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x1AB
; 0000 0570     {
; 0000 0571         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 0572         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0573     }
	RJMP _0x1A9
_0x1AB:
; 0000 0574     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0007:
	ADIW R28,4
	RET
; 0000 0575 }
; .FEND
;
;void I2C_init()
; 0000 0578 {
_I2C_init:
; .FSTART _I2C_init
; 0000 0579     TWSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 057A     TWBR = 0x47;
	LDI  R30,LOW(71)
	OUT  0x0,R30
; 0000 057B     TWCR = 0x04;
	LDI  R30,LOW(4)
	OUT  0x36,R30
; 0000 057C }
	RET
; .FEND
;
;void I2C_start()
; 0000 057F {
_I2C_start:
; .FSTART _I2C_start
; 0000 0580     TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0000 0581     while(!(TWCR & (1 << TWINT)));
_0x1AC:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1AC
; 0000 0582 }
	RET
; .FEND
;
;void I2C_write(unsigned char data)
; 0000 0585 {
_I2C_write:
; .FSTART _I2C_write
; 0000 0586     TWDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0000 0587     TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0000 0588     while(!(TWCR & (1 << TWINT)));
_0x1AF:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1AF
; 0000 0589 }
	RJMP _0x20C0006
; .FEND
;
;unsigned char I2C_read(unsigned char ackVal)
; 0000 058C {
_I2C_read:
; .FSTART _I2C_read
; 0000 058D     TWCR = (1 << TWINT) | (1 << TWEN) | (ackVal << TWEA);
	ST   -Y,R26
;	ackVal -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
; 0000 058E     while(!(TWCR & (1 << TWINT)));
_0x1B2:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1B2
; 0000 058F     return TWDR;
	IN   R30,0x3
_0x20C0006:
	ADIW R28,1
	RET
; 0000 0590 }
; .FEND
;
;void I2C_stop()
; 0000 0593 {
_I2C_stop:
; .FSTART _I2C_stop
; 0000 0594     TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0000 0595     while(TWCR & (1 << TWSTO));
_0x1B5:
	IN   R30,0x36
	SBRC R30,4
	RJMP _0x1B5
; 0000 0596 }
	RET
; .FEND
;
;void rtc_init()
; 0000 0599 {
_rtc_init:
; .FSTART _rtc_init
; 0000 059A     I2C_init();
	RCALL _I2C_init
; 0000 059B     I2C_start();
	CALL SUBOPT_0x3D
; 0000 059C     I2C_write(0xD0);
; 0000 059D     I2C_write(0x07);
	LDI  R26,LOW(7)
	RCALL _I2C_write
; 0000 059E     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x3E
; 0000 059F     I2C_stop();
; 0000 05A0 }
	RET
; .FEND
;
;void rtc_getTime(unsigned char* hour, unsigned char* minute, unsigned char* second)
; 0000 05A3 {
_rtc_getTime:
; .FSTART _rtc_getTime
; 0000 05A4     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*hour -> Y+4
;	*minute -> Y+2
;	*second -> Y+0
	CALL SUBOPT_0x3D
; 0000 05A5     I2C_write(0xD0);
; 0000 05A6     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x3E
; 0000 05A7     I2C_stop();
; 0000 05A8 
; 0000 05A9     I2C_start();
	CALL SUBOPT_0x3F
; 0000 05AA     I2C_write(0xD1);
; 0000 05AB     *second = I2C_read(1);
; 0000 05AC     *minute = I2C_read(1);
; 0000 05AD     *hour = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 05AE     I2C_stop();
	RCALL _I2C_stop
; 0000 05AF }
_0x20C0005:
	ADIW R28,6
	RET
; .FEND
;
;void rtc_getDate(unsigned char* year, unsigned char* month, unsigned char* date, unsigned char* day)
; 0000 05B2 {
_rtc_getDate:
; .FSTART _rtc_getDate
; 0000 05B3     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*year -> Y+6
;	*month -> Y+4
;	*date -> Y+2
;	*day -> Y+0
	CALL SUBOPT_0x3D
; 0000 05B4     I2C_write(0xD0);
; 0000 05B5     I2C_write(0x03);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x3E
; 0000 05B6     I2C_stop();
; 0000 05B7 
; 0000 05B8     I2C_start();
	CALL SUBOPT_0x3F
; 0000 05B9     I2C_write(0xD1);
; 0000 05BA     *day = I2C_read(1);
; 0000 05BB     *date = I2C_read(1);
; 0000 05BC     *month = I2C_read(1);
	LDI  R26,LOW(1)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 05BD     *year = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
; 0000 05BE     I2C_stop();
	RCALL _I2C_stop
; 0000 05BF }
_0x20C0004:
	ADIW R28,8
	RET
; .FEND
;
;void Timer2_Init()
; 0000 05C2 {
_Timer2_Init:
; .FSTART _Timer2_Init
; 0000 05C3     //Disable timer2 interrupts
; 0000 05C4     TIMSK = 0;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 05C5     //Enable asynchronous mode
; 0000 05C6     ASSR = (1 << AS2);
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 05C7     //set initial counter value
; 0000 05C8     TCNT2 = 0;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 05C9     //set prescaller 128
; 0000 05CA     TCCR2 = 0;
	OUT  0x25,R30
; 0000 05CB     TCCR2 |= (1 << CS22) | ( 1 << CS00);
	IN   R30,0x25
	ORI  R30,LOW(0x5)
	OUT  0x25,R30
; 0000 05CC     //wait for registers update
; 0000 05CD     while (ASSR & ((1 << TCN2UB) | (1 << TCR2UB)));
_0x1B8:
	IN   R30,0x22
	ANDI R30,LOW(0x5)
	BRNE _0x1B8
; 0000 05CE     //clear interrupt flags
; 0000 05CF     TIFR = (1 << TOV2);
	LDI  R30,LOW(64)
	OUT  0x38,R30
; 0000 05D0     //enable TOV2 interrupt
; 0000 05D1     TIMSK  = (1 << TOIE2);
	OUT  0x39,R30
; 0000 05D2 }
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
	JMP  _0x20C0003
; .FEND
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
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
_0x20C0003:
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
	CALL SUBOPT_0x40
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x41
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x42
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
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
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x42
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x45
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	CALL SUBOPT_0x46
	RJMP _0x20C0002
; .FEND
_snprintf:
; .FSTART _snprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	__GETWRN 18,19,0
	CALL SUBOPT_0x47
	SBIW R30,0
	BRNE _0x2060073
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2060073:
	CALL SUBOPT_0x45
	SBIW R30,0
	BREQ _0x2060074
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x47
	STD  Y+6,R30
	STD  Y+6+1,R31
	CALL SUBOPT_0x45
	STD  Y+8,R30
	STD  Y+8+1,R31
	CALL SUBOPT_0x46
_0x2060074:
_0x20C0002:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:181 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOV  R30,R21
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ADD  R30,R16
	ADC  R31,R17
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF:
	MOVW R30,R28
	ADIW R30,24
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,30
	CALL _rtc_getTime
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	__POINTW1FN _0x0,192
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDD  R30,Y+28
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+33
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13:
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,23
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,26
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,29
	CALL _rtc_getDate
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x14:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	SBIW R30,4
	SUBI R30,LOW(-_time)
	SBCI R31,HIGH(-_time)
	LD   R26,Z
	JMP  _write_byte_to_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _lcd_print

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW4
	ADD  R30,R18
	ADC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	ADIW R30,8
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,246
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1E:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _snprintf
	ADIW R28,10
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	JMP  _lcd_print

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CALL _lcd_print
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:429 WORDS
SUBOPT_0x25:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL _lcd_print
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
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
SUBOPT_0x2B:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(192)
	CALL _lcdCommand
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(192)
	CALL _lcdCommand
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	MOV  R30,R18
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
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
SUBOPT_0x35:
	CBI  0x1B,1
	SBI  0x1B,2
	__DELAY_USB 43
	CBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x36:
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
SUBOPT_0x37:
	CALL _lcdCommand
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW4
	ADD  R26,R30
	ADC  R27,R31
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	MOV  R18,R30
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(16)
	MUL  R30,R16
	MOVW R30,R0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3B:
	__GETD2S 4
	__CPD2N 0x927C0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	__GETD1S 4
	__SUBD1N -1
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	CALL _I2C_start
	LDI  R26,LOW(208)
	JMP  _I2C_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	CALL _I2C_write
	JMP  _I2C_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3F:
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
SUBOPT_0x40:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
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
SUBOPT_0x44:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x46:
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
	CALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	MOVW R26,R28
	ADIW R26,14
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

__LSLW4:
	LSL  R30
	ROL  R31
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
