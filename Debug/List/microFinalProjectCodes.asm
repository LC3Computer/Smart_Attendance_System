
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
_0x19B:
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
	.DW  _0x0*2+201

	.DW  0x16
	.DW  _0xC+215
	.DW  _0x0*2+224

	.DW  0x02
	.DW  _0xC+237
	.DW  _0x0*2+122

	.DW  0x02
	.DW  _0xC+239
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0xC+241
	.DW  _0x0*2+249

	.DW  0x18
	.DW  _0xC+243
	.DW  _0x0*2+251

	.DW  0x16
	.DW  _0xC+267
	.DW  _0x0*2+275

	.DW  0x18
	.DW  _0xC+289
	.DW  _0x0*2+297

	.DW  0x12
	.DW  _0xC+313
	.DW  _0x0*2+321

	.DW  0x12
	.DW  _0xC+331
	.DW  _0x0*2+339

	.DW  0x1F
	.DW  _0xC+349
	.DW  _0x0*2+357

	.DW  0x1F
	.DW  _0xC+380
	.DW  _0x0*2+388

	.DW  0x1E
	.DW  _0xC+411
	.DW  _0x0*2+419

	.DW  0x11
	.DW  _0xC+441
	.DW  _0x0*2+449

	.DW  0x19
	.DW  _0xC+458
	.DW  _0x0*2+466

	.DW  0x15
	.DW  _0xC+483
	.DW  _0x0*2+491

	.DW  0x0B
	.DW  _0x9B
	.DW  _0x0*2+551

	.DW  0x1D
	.DW  _0x9B+11
	.DW  _0x0*2+562

	.DW  0x02
	.DW  _0x9B+40
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9B+42
	.DW  _0x0*2+244

	.DW  0x03
	.DW  _0x9B+44
	.DW  _0x0*2+153

	.DW  0x1E
	.DW  _0x9B+47
	.DW  _0x0*2+591

	.DW  0x1F
	.DW  _0x9B+77
	.DW  _0x0*2+621

	.DW  0x1F
	.DW  _0x9B+108
	.DW  _0x0*2+652

	.DW  0x1F
	.DW  _0x9B+139
	.DW  _0x0*2+621

	.DW  0x20
	.DW  _0x9B+170
	.DW  _0x0*2+683

	.DW  0x1F
	.DW  _0x9B+202
	.DW  _0x0*2+621

	.DW  0x15
	.DW  _0x9B+233
	.DW  _0x0*2+715

	.DW  0x1D
	.DW  _0x9B+254
	.DW  _0x0*2+736

	.DW  0x02
	.DW  _0x9B+283
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9B+285
	.DW  _0x0*2+244

	.DW  0x13
	.DW  _0x9B+287
	.DW  _0x0*2+765

	.DW  0x1F
	.DW  _0x9B+306
	.DW  _0x0*2+621

	.DW  0x1D
	.DW  _0x9B+337
	.DW  _0x0*2+784

	.DW  0x1F
	.DW  _0x9B+366
	.DW  _0x0*2+621

	.DW  0x02
	.DW  _0x9B+397
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9B+399
	.DW  _0x0*2+244

	.DW  0x13
	.DW  _0x9B+401
	.DW  _0x0*2+765

	.DW  0x13
	.DW  _0x9B+420
	.DW  _0x0*2+813

	.DW  0x19
	.DW  _0x9B+439
	.DW  _0x0*2+832

	.DW  0x1F
	.DW  _0x9B+464
	.DW  _0x0*2+621

	.DW  0x1D
	.DW  _0x9B+495
	.DW  _0x0*2+784

	.DW  0x1F
	.DW  _0x9B+524
	.DW  _0x0*2+621

	.DW  0x03
	.DW  _0x9B+555
	.DW  _0x0*2+526

	.DW  0x03
	.DW  _0x9B+558
	.DW  _0x0*2+526

	.DW  0x0E
	.DW  _0x9B+561
	.DW  _0x0*2+857

	.DW  0x02
	.DW  _0x9B+575
	.DW  _0x0*2+244

	.DW  0x02
	.DW  _0x9B+577
	.DW  _0x0*2+244

	.DW  0x13
	.DW  _0x9B+579
	.DW  _0x0*2+871

	.DW  0x08
	.DW  _0x9B+598
	.DW  _0x0*2+890

	.DW  0x1A
	.DW  _0x9B+606
	.DW  _0x0*2+898

	.DW  0x1F
	.DW  _0x9B+632
	.DW  _0x0*2+621

	.DW  0x14
	.DW  _0x9B+663
	.DW  _0x0*2+924

	.DW  0x10
	.DW  _0x13C
	.DW  _0x0*2+944

	.DW  0x02
	.DW  _0x13C+16
	.DW  _0x0*2+244

	.DW  0x1D
	.DW  _0x148
	.DW  _0x0*2+960

	.DW  0x16
	.DW  _0x148+29
	.DW  _0x0*2+989

	.DW  0x1A
	.DW  _0x148+51
	.DW  _0x0*2+1011

	.DW  0x1A
	.DW  _0x148+77
	.DW  _0x0*2+1037

	.DW  0x19
	.DW  _0x148+103
	.DW  _0x0*2+1063

	.DW  0x16
	.DW  _0x148+128
	.DW  _0x0*2+1088

	.DW  0x14
	.DW  _0x148+150
	.DW  _0x0*2+1110

	.DW  0x0A
	.DW  _0x148+170
	.DW  _0x0*2+1130

	.DW  0x0D
	.DW  _0x148+180
	.DW  _0x0*2+1140

	.DW  0x02
	.DW  _previous_count_S0000015000
	.DW  _0x19B*2

	.DW  0x0B
	.DW  _0x19C
	.DW  _0x0*2+1153

	.DW  0x06
	.DW  _0x19C+11
	.DW  _0x0*2+1164

	.DW  0x0C
	.DW  _0x19C+17
	.DW  _0x0*2+1170

	.DW  0x05
	.DW  _0x19C+29
	.DW  _0x0*2+1182

	.DW  0x08
	.DW  _0x19C+34
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
; 0000 00E3                             write_byte_to_eeprom(i + ((st_counts + 1) * 16), buffer[i]);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _write_byte_to_eeprom
; 0000 00E4                         }
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
; 0000 00E5                         rtc_getTime(&hour, &minute, &second);
	CALL SUBOPT_0xF
; 0000 00E6                         sprintf(time, "%02x%02x", hour, minute);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0000 00E7                         for (i = 0; i < 4; i++)
	__GETWRN 16,17,0
_0x2B:
	__CPWRN 16,17,4
	BRGE _0x2C
; 0000 00E8                         {
; 0000 00E9                             write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i]);
	CALL SUBOPT_0xD
	ADIW R30,8
	CALL SUBOPT_0xE
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _write_byte_to_eeprom
; 0000 00EA                         }
	__ADDWRN 16,17,1
	RJMP _0x2B
_0x2C:
; 0000 00EB                         rtc_getDate(&year, &month, &date, &day);
	CALL SUBOPT_0x13
; 0000 00EC                         sprintf(time, "%02x%02x", month, date);
	CALL SUBOPT_0x10
	LDD  R30,Y+5
	CALL SUBOPT_0x14
	LDD  R30,Y+10
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
; 0000 00ED                         for (i = 4; i < 8; i++)
	__GETWRN 16,17,4
_0x2E:
	__CPWRN 16,17,8
	BRGE _0x2F
; 0000 00EE                         {
; 0000 00EF                             write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i - 4]);
	CALL SUBOPT_0xD
	ADIW R30,8
	CALL SUBOPT_0xE
	MOVW R30,R16
	CALL SUBOPT_0x15
; 0000 00F0                         }
	__ADDWRN 16,17,1
	RJMP _0x2E
_0x2F:
; 0000 00F1                         write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0x16
	MOV  R26,R21
	SUBI R26,-LOW(1)
	CALL _write_byte_to_eeprom
; 0000 00F2                         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 00F3                         lcd_gotoxy(1, 1);
; 0000 00F4                         lcd_print("Student added with ID:");
	__POINTW2MN _0xC,192
	CALL SUBOPT_0x1
; 0000 00F5                         lcd_gotoxy(1, 2);
; 0000 00F6                         lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 00F7                         delay_ms(3000); // wait
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00F8                     }
_0x26:
; 0000 00F9                 }
_0x24:
; 0000 00FA                 memset(buffer,0,32);
	CALL SUBOPT_0x5
; 0000 00FB             }
	RJMP _0x18
_0x1A:
; 0000 00FC         }
; 0000 00FD         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x30
_0x17:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x31
; 0000 00FE         {
; 0000 00FF             show_temperature();
	CALL _show_temperature
; 0000 0100         }
; 0000 0101         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x32
_0x31:
	LDI  R30,LOW(5)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x33
; 0000 0102         {
; 0000 0103             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0104             lcd_gotoxy(1, 1);
; 0000 0105             lcd_print("Number of students : ");
	__POINTW2MN _0xC,215
	CALL SUBOPT_0x1
; 0000 0106             lcd_gotoxy(1, 2);
; 0000 0107             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 0108             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0109             itoa(st_counts, buffer);
	MOV  R30,R21
	CALL SUBOPT_0x18
; 0000 010A             lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 010B             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 010C 
; 0000 010D             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x35:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+2
	RJMP _0x36
; 0000 010E             {
; 0000 010F                 memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0110                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x38:
	__CPWRN 18,19,8
	BRGE _0x39
; 0000 0111                 {
; 0000 0112                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 16));
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
; 0000 0113                 }
	__ADDWRN 18,19,1
	RJMP _0x38
_0x39:
; 0000 0114                 buffer[j] = '\0';
	CALL SUBOPT_0x1A
; 0000 0115                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0116                 lcd_gotoxy(1, 1);
; 0000 0117                 lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 0118 
; 0000 0119                 memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 011A                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3B:
	__CPWRN 18,19,8
	BRGE _0x3C
; 0000 011B                 {
; 0000 011C                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 16) + 8);
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
; 0000 011D                 }
	__ADDWRN 18,19,1
	RJMP _0x3B
_0x3C:
; 0000 011E                 buffer[j] = '\0';
	CALL SUBOPT_0x1A
; 0000 011F                 lcd_gotoxy(1, 2);
	CALL SUBOPT_0x1C
; 0000 0120                 snprintf(time, 3, "%s", buffer);
	CALL SUBOPT_0x1D
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	CALL SUBOPT_0x1E
; 0000 0121                 lcd_print(time);
; 0000 0122                 lcd_print(":");
	__POINTW2MN _0xC,237
	CALL SUBOPT_0x1F
; 0000 0123                 snprintf(time, 3, "%s", buffer + 2);
	__POINTW1MN _buffer,2
	CALL SUBOPT_0x1E
; 0000 0124                 lcd_print(time);
; 0000 0125                 lcd_print(" ");
	__POINTW2MN _0xC,239
	CALL SUBOPT_0x1F
; 0000 0126                 snprintf(time, 3, "%s", buffer + 4);
	__POINTW1MN _buffer,4
	CALL SUBOPT_0x1E
; 0000 0127                 lcd_print(time);
; 0000 0128                 lcd_print("/");
	__POINTW2MN _0xC,241
	CALL SUBOPT_0x1F
; 0000 0129                 snprintf(time, 3, "%s", buffer + 6);
	__POINTW1MN _buffer,6
	CALL SUBOPT_0x1E
; 0000 012A                 lcd_print(time);
; 0000 012B                 delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 012C             }
	__ADDWRN 16,17,1
	RJMP _0x35
_0x36:
; 0000 012D 
; 0000 012E             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 012F             lcd_gotoxy(1, 1);
; 0000 0130             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xC,243
	CALL _lcd_print
; 0000 0131             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x3D:
	LDI  R30,LOW(5)
	CP   R30,R5
	BREQ _0x3D
; 0000 0132                 ;
; 0000 0133         }
; 0000 0134         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x40
_0x33:
	LDI  R30,LOW(6)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x41
; 0000 0135         {
; 0000 0136             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0137             lcd_gotoxy(1, 1);
; 0000 0138             lcd_print("Start Transferring...");
	__POINTW2MN _0xC,267
	RCALL _lcd_print
; 0000 0139             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xC
; 0000 013A             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x43:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+2
	RJMP _0x44
; 0000 013B             {
; 0000 013C                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x46:
	__CPWRN 18,19,8
	BRGE _0x47
; 0000 013D                 {
; 0000 013E                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16)));
	CALL SUBOPT_0x19
	MOVW R26,R30
	CALL _read_byte_from_eeprom
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 013F                 }
	__ADDWRN 18,19,1
	RJMP _0x46
_0x47:
; 0000 0140 
; 0000 0141                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	CALL _USART_Transmit
; 0000 0142 
; 0000 0143                 for (j = 0; j < 2; j++)
	__GETWRN 18,19,0
_0x49:
	__CPWRN 18,19,2
	BRGE _0x4A
; 0000 0144                 {
; 0000 0145                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0146                 }
	__ADDWRN 18,19,1
	RJMP _0x49
_0x4A:
; 0000 0147                 USART_Transmit(':');
	LDI  R26,LOW(58)
	CALL _USART_Transmit
; 0000 0148                 for (j = 2; j < 4; j++)
	__GETWRN 18,19,2
_0x4C:
	__CPWRN 18,19,4
	BRGE _0x4D
; 0000 0149                 {
; 0000 014A                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 014B                 }
	__ADDWRN 18,19,1
	RJMP _0x4C
_0x4D:
; 0000 014C                 USART_Transmit(' ');
	LDI  R26,LOW(32)
	CALL _USART_Transmit
; 0000 014D                 for (j = 4; j < 6; j++)
	__GETWRN 18,19,4
_0x4F:
	__CPWRN 18,19,6
	BRGE _0x50
; 0000 014E                 {
; 0000 014F                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0150                 }
	__ADDWRN 18,19,1
	RJMP _0x4F
_0x50:
; 0000 0151                 USART_Transmit('/');
	LDI  R26,LOW(47)
	CALL _USART_Transmit
; 0000 0152                 for (j = 6; j < 8; j++)
	__GETWRN 18,19,6
_0x52:
	__CPWRN 18,19,8
	BRGE _0x53
; 0000 0153                 {
; 0000 0154                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 16) + 8));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOV  R26,R30
	CALL _USART_Transmit
; 0000 0155                 }
	__ADDWRN 18,19,1
	RJMP _0x52
_0x53:
; 0000 0156 
; 0000 0157                 USART_Transmit('\r');
	CALL SUBOPT_0x21
; 0000 0158                 USART_Transmit('\r');
; 0000 0159 
; 0000 015A                 delay_ms(500);
; 0000 015B             }
	__ADDWRN 16,17,1
	RJMP _0x43
_0x44:
; 0000 015C             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x55:
	__CPWRN 18,19,8
	BRGE _0x56
; 0000 015D             {
; 0000 015E                 USART_Transmit('=');
	LDI  R26,LOW(61)
	CALL _USART_Transmit
; 0000 015F             }
	__ADDWRN 18,19,1
	RJMP _0x55
_0x56:
; 0000 0160 
; 0000 0161             USART_Transmit('\r');
	CALL SUBOPT_0x21
; 0000 0162             USART_Transmit('\r');
; 0000 0163             delay_ms(500);
; 0000 0164 
; 0000 0165             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0166             lcd_gotoxy(1, 1);
; 0000 0167             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xC,289
	CALL SUBOPT_0x2
; 0000 0168             delay_ms(2000);
; 0000 0169             stage = STAGE_INIT_MENU;
; 0000 016A         }
; 0000 016B         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x57
_0x41:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0x58
; 0000 016C         {
; 0000 016D             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 016E             lcd_gotoxy(1, 1);
; 0000 016F             lcd_print("1: Search Student");
	__POINTW2MN _0xC,313
	CALL SUBOPT_0x1
; 0000 0170             lcd_gotoxy(1, 2);
; 0000 0171             lcd_print("2: Delete Student");
	__POINTW2MN _0xC,331
	RCALL _lcd_print
; 0000 0172             while (stage == STAGE_STUDENT_MANAGMENT)
_0x59:
	LDI  R30,LOW(7)
	CP   R30,R5
	BREQ _0x59
; 0000 0173                 ;
; 0000 0174         }
; 0000 0175         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x5C
_0x58:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5D
; 0000 0176         {
; 0000 0177             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0178             lcd_gotoxy(1, 1);
; 0000 0179             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xC,349
	CALL SUBOPT_0x1
; 0000 017A             lcd_gotoxy(1, 2);
; 0000 017B             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 017C             delay_us(100 * 16); // wait
; 0000 017D             while (stage == STAGE_SEARCH_STUDENT)
_0x5E:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ _0x5E
; 0000 017E                 ;
; 0000 017F             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x4
; 0000 0180             delay_us(100 * 16); // wait
; 0000 0181         }
; 0000 0182         else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0x61
_0x5D:
	LDI  R30,LOW(9)
	CP   R30,R5
	BRNE _0x62
; 0000 0183         {
; 0000 0184             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0185             lcd_gotoxy(1, 1);
; 0000 0186             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xC,380
	CALL SUBOPT_0x1
; 0000 0187             lcd_gotoxy(1, 2);
; 0000 0188             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 0189             delay_us(100 * 16); // wait
; 0000 018A             while (stage == STAGE_DELETE_STUDENT)
_0x63:
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ _0x63
; 0000 018B                 ;
; 0000 018C             lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 018D             delay_us(100 * 16);
; 0000 018E         }
; 0000 018F         else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x66
_0x62:
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x67
; 0000 0190         {
; 0000 0191             startSonar();
	CALL _startSonar
; 0000 0192             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0193         }
; 0000 0194         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x68
_0x67:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x69
; 0000 0195         {
; 0000 0196             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0197             lcd_gotoxy(1, 1);
; 0000 0198             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xC,411
	CALL SUBOPT_0x1
; 0000 0199             lcd_gotoxy(1, 2);
; 0000 019A             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x3
; 0000 019B             delay_us(100 * 16); // wait
; 0000 019C             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x6A:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x6D
	TST  R6
	BREQ _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
; 0000 019D                 ;
	RJMP _0x6A
_0x6C:
; 0000 019E             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x6F
; 0000 019F             {
; 0000 01A0                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 01A1                 delay_us(100 * 16);
; 0000 01A2                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 01A3                 lcd_gotoxy(1, 1);
; 0000 01A4                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xC,441
	CALL SUBOPT_0x1
; 0000 01A5                 lcd_gotoxy(1, 2);
; 0000 01A6                 lcd_print("    press cancel to back");
	__POINTW2MN _0xC,458
	RCALL _lcd_print
; 0000 01A7                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x70:
	LDI  R30,LOW(11)
	CP   R30,R5
	BREQ _0x70
; 0000 01A8                     ;
; 0000 01A9             }
; 0000 01AA             else
	RJMP _0x73
_0x6F:
; 0000 01AB             {
; 0000 01AC                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x4
; 0000 01AD                 delay_us(100 * 16);
; 0000 01AE             }
_0x73:
; 0000 01AF         }
; 0000 01B0         else if (stage == STAGE_SET_TIMER)
	RJMP _0x74
_0x69:
	LDI  R30,LOW(14)
	CP   R30,R5
	BRNE _0x75
; 0000 01B1         {
; 0000 01B2             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 01B3             lcd_gotoxy(1, 1);
; 0000 01B4             lcdCommand(0x0c); // display on, cursor off
	LDI  R26,LOW(12)
	RCALL _lcdCommand
; 0000 01B5             itoa(submitTime, buffer);
	MOV  R30,R9
	CALL SUBOPT_0x18
; 0000 01B6             lcd_print("Set Timer(minutes): ");
	__POINTW2MN _0xC,483
	RCALL _lcd_print
; 0000 01B7             lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 01B8             delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 01B9             while(stage == STAGE_SET_TIMER);
_0x76:
	LDI  R30,LOW(14)
	CP   R30,R5
	BREQ _0x76
; 0000 01BA             delay_us(100 * 16);
	CALL SUBOPT_0x6
; 0000 01BB         }
; 0000 01BC         else if(stage == STAGE_SHOW_CLOCK)
	RJMP _0x79
_0x75:
	LDI  R30,LOW(13)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x7A
; 0000 01BD         {
; 0000 01BE             while(stage == STAGE_SHOW_CLOCK){
_0x7B:
	LDI  R30,LOW(13)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x7D
; 0000 01BF                 lcdCommand(0x01);
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 01C0                 rtc_getTime(&hour, &minute, &second);
	CALL SUBOPT_0xF
; 0000 01C1                 sprintf(time, "%02x:%02x:%02x  ", hour, minute, second);
	__POINTW1FN _0x0,512
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	LDD  R30,Y+18
	CALL SUBOPT_0x14
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01C2                 lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x22
; 0000 01C3                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 01C4                 rtc_getDate(&year, &month, &date, &day);
	CALL SUBOPT_0x13
; 0000 01C5                 sprintf(time, "20%02x/%02x/%02x  %3s", year, month, date, days[day - 1]);
	__POINTW1FN _0x0,529
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	CALL SUBOPT_0x14
	LDD  R30,Y+9
	CALL SUBOPT_0x14
	LDD  R30,Y+14
	CALL SUBOPT_0x14
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
; 0000 01C6                 lcd_gotoxy(1,2);
	CALL SUBOPT_0x1C
; 0000 01C7                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 01C8                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 01C9             }
	RJMP _0x7B
_0x7D:
; 0000 01CA         }
; 0000 01CB     }
_0x7A:
_0x79:
_0x74:
_0x68:
_0x66:
_0x61:
_0x5C:
_0x57:
_0x40:
_0x32:
_0x30:
_0x16:
_0x10:
_0xA:
	RJMP _0x6
; 0000 01CC }
_0x7E:
	RJMP _0x7E
; .FEND

	.DSEG
_0xC:
	.BYTE 0x1F8
;
;interrupt[TIM2_OVF] void timer2_ovf_isr(void)
; 0000 01CF {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 01D0     timerCount++;
	INC  R8
; 0000 01D1     if(timerCount == 60){
	LDI  R30,LOW(60)
	CP   R30,R8
	BRNE _0x7F
; 0000 01D2         submitTime--;
	DEC  R9
; 0000 01D3         timerCount = 0;
	CLR  R8
; 0000 01D4     }
; 0000 01D5     TCNT2 = 0;
_0x7F:
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01D6     if(submitTime == 0)
	TST  R9
	BRNE _0x80
; 0000 01D7         TIMSK = 0;
	OUT  0x39,R30
; 0000 01D8 }
_0x80:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 01DC {
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
; 0000 01DD     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 01DE     int i;
; 0000 01DF     unsigned char second, minute, hour;
; 0000 01E0     unsigned char day, date, month, year;
; 0000 01E1 
; 0000 01E2     // detect the key
; 0000 01E3     while (1)
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
; 0000 01E4     {
; 0000 01E5         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x23
; 0000 01E6         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01E7         if (colloc != 0x0F)        // column detected
	BREQ _0x84
; 0000 01E8         {
; 0000 01E9             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 01EA             break;      // exit while loop
	RJMP _0x83
; 0000 01EB         }
; 0000 01EC         KEY_PRT = 0xDF;            // ground row 1
_0x84:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x23
; 0000 01ED         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01EE         if (colloc != 0x0F)        // column detected
	BREQ _0x85
; 0000 01EF         {
; 0000 01F0             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 01F1             break;      // exit while loop
	RJMP _0x83
; 0000 01F2         }
; 0000 01F3         KEY_PRT = 0xBF;            // ground row 2
_0x85:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x23
; 0000 01F4         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 01F5         if (colloc != 0x0F)        // column detected
	BREQ _0x86
; 0000 01F6         {
; 0000 01F7             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 01F8             break;      // exit while loop
	RJMP _0x83
; 0000 01F9         }
; 0000 01FA         KEY_PRT = 0x7F;            // ground row 3
_0x86:
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 01FB         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 01FC         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 01FD         break;                     // exit while loop
; 0000 01FE     }
_0x83:
; 0000 01FF     // check column and send result to Port D
; 0000 0200     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x87
; 0000 0201         cl = 0;
	LDI  R19,LOW(0)
; 0000 0202     else if (colloc == 0x0D)
	RJMP _0x88
_0x87:
	CPI  R17,13
	BRNE _0x89
; 0000 0203         cl = 1;
	LDI  R19,LOW(1)
; 0000 0204     else if (colloc == 0x0B)
	RJMP _0x8A
_0x89:
	CPI  R17,11
	BRNE _0x8B
; 0000 0205         cl = 2;
	LDI  R19,LOW(2)
; 0000 0206     else
	RJMP _0x8C
_0x8B:
; 0000 0207         cl = 3;
	LDI  R19,LOW(3)
; 0000 0208 
; 0000 0209     KEY_PRT &= 0x0F; // ground all rows at once
_0x8C:
_0x8A:
_0x88:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 020A 
; 0000 020B     // inside menu level 1
; 0000 020C     if (stage == STAGE_INIT_MENU)
	TST  R5
	BREQ PC+2
	RJMP _0x8D
; 0000 020D     {
; 0000 020E         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 020F         {
; 0000 0210         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x91
; 0000 0211             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0212             break;
	RJMP _0x90
; 0000 0213         case OPTION_TEMPERATURE_MONITORING:
_0x91:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x92
; 0000 0214             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 0215             break;
	RJMP _0x90
; 0000 0216         case OPTION_VIEW_PRESENT_STUDENTS:
_0x92:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x93
; 0000 0217             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 0218             break;
	RJMP _0x90
; 0000 0219         case OPTION_RETRIEVE_STUDENT_DATA:
_0x93:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x94
; 0000 021A             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 021B             break;
	RJMP _0x90
; 0000 021C         case OPTION_STUDENT_MANAGEMENT:
_0x94:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x95
; 0000 021D             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 021E             break;
	RJMP _0x90
; 0000 021F         case OPTION_TRAFFIC_MONITORING:
_0x95:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x96
; 0000 0220             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 0221             break;
	RJMP _0x90
; 0000 0222         case OPTION_LOGIN_WITH_ADMIN:
_0x96:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x97
; 0000 0223             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 0224             break;
	RJMP _0x90
; 0000 0225         case OPTION_SET_TIMER:
_0x97:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x98
; 0000 0226             stage = STAGE_SET_TIMER;
	LDI  R30,LOW(14)
	MOV  R5,R30
; 0000 0227             break;
	RJMP _0x90
; 0000 0228         case OPTION_LOGOUT:
_0x98:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x9C
; 0000 0229 #asm("cli") // disable interrupts
	cli
; 0000 022A             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x9A
; 0000 022B             {
; 0000 022C                 lcdCommand(0x1);
	CALL SUBOPT_0x0
; 0000 022D                 lcd_gotoxy(1, 1);
; 0000 022E                 lcd_print("Logout ...");
	__POINTW2MN _0x9B,0
	CALL SUBOPT_0x1
; 0000 022F                 lcd_gotoxy(1, 2);
; 0000 0230                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x9B,11
	CALL SUBOPT_0x25
; 0000 0231                 delay_ms(2000);
; 0000 0232                 logged_in = 0;
	CLR  R6
; 0000 0233 #asm("sei")
	sei
; 0000 0234                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 0235             }
; 0000 0236             break;
_0x9A:
; 0000 0237         default:
_0x9C:
; 0000 0238             break;
; 0000 0239         }
_0x90:
; 0000 023A 
; 0000 023B         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x9D
; 0000 023C         {
; 0000 023D             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x9E
	MOV  R30,R4
	LDI  R31,0
	SBIW R30,1
	RJMP _0x9F
_0x9E:
	LDI  R30,LOW(4)
_0x9F:
	MOV  R4,R30
; 0000 023E         }
; 0000 023F         else if (keypad[rowloc][cl] == 'R')
	RJMP _0xA1
_0x9D:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0xA2
; 0000 0240         {
; 0000 0241             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	MOV  R4,R30
; 0000 0242         }
; 0000 0243         else if(keypad[rowloc][cl] == 'O')
	RJMP _0xA3
_0xA2:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xA4
; 0000 0244         {
; 0000 0245             stage = STAGE_SHOW_CLOCK;
	LDI  R30,LOW(13)
	MOV  R5,R30
; 0000 0246         }
; 0000 0247     }
_0xA4:
_0xA3:
_0xA1:
; 0000 0248     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0xA5
_0x8D:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xA6
; 0000 0249     {
; 0000 024A         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
; 0000 024B         {
; 0000 024C         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xAA
; 0000 024D             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 024E             break;
	RJMP _0xA9
; 0000 024F         case '1':
_0xAA:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xAB
; 0000 0250             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0251             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0252             break;
	RJMP _0xA9
; 0000 0253         case '2':
_0xAB:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xAD
; 0000 0254             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0255             stage = STAGE_SUBMIT_WITH_CARD;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0256             break;
; 0000 0257         default:
_0xAD:
; 0000 0258             break;
; 0000 0259         }
_0xA9:
; 0000 025A     }
; 0000 025B     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0xAE
_0xA6:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xAF
; 0000 025C     {
; 0000 025D         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB0
; 0000 025E         {
; 0000 025F             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0260             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0261         }
; 0000 0262         if ((keypad[rowloc][cl] - '0') < 10)
_0xB0:
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xB1
; 0000 0263         {
; 0000 0264             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xB2
; 0000 0265             {
; 0000 0266                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 0267                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x28
; 0000 0268                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0269             }
; 0000 026A         }
_0xB2:
; 0000 026B         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xB3
_0xB1:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xB4
; 0000 026C         {
; 0000 026D             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 026E             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xB5
; 0000 026F             {
; 0000 0270                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x29
; 0000 0271                 lcdCommand(0x10);
; 0000 0272                 lcd_print(" ");
	__POINTW2MN _0x9B,40
	CALL SUBOPT_0x2A
; 0000 0273                 lcdCommand(0x10);
; 0000 0274             }
; 0000 0275         }
_0xB5:
; 0000 0276         else if(keypad[rowloc][cl] == 'O')
	RJMP _0xB6
_0xB4:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xB7
; 0000 0277         {
; 0000 0278             lcdCommand(0xC0);
	CALL SUBOPT_0x2B
; 0000 0279             for(i = 0; i < strlen(buffer); i++)
_0xB9:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2C
	BRSH _0xBA
; 0000 027A                 lcd_print(" ");
	__POINTW2MN _0x9B,42
	RCALL _lcd_print
	CALL SUBOPT_0x2D
	RJMP _0xB9
_0xBA:
; 0000 027B lcdCommand(0xC0);
	CALL SUBOPT_0x2E
; 0000 027C             memset(buffer, 0, 32);
; 0000 027D         }
; 0000 027E         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xBB
_0xB7:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0xBC
; 0000 027F         {
; 0000 0280 
; 0000 0281 #asm("cli")
	cli
; 0000 0282 
; 0000 0283             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 0284                 strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0x9B,44
	CALL SUBOPT_0x9
	BRNE _0xBE
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0xBD
_0xBE:
; 0000 0285             {
; 0000 0286                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0287                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0288                 lcd_gotoxy(1, 1);
; 0000 0289                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x9B,47
	CALL SUBOPT_0x1
; 0000 028A                 lcd_gotoxy(1, 2);
; 0000 028B                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,77
	CALL SUBOPT_0xB
; 0000 028C                 delay_ms(2000);
; 0000 028D                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 028E             }
; 0000 028F             else if (search_student_code() > 0)
	RJMP _0xC0
_0xBD:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0xC1
; 0000 0290             {
; 0000 0291                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0292                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0293                 lcd_gotoxy(1, 1);
; 0000 0294                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x9B,108
	CALL SUBOPT_0x1
; 0000 0295                 lcd_gotoxy(1, 2);
; 0000 0296                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,139
	CALL SUBOPT_0xB
; 0000 0297                 delay_ms(2000);
; 0000 0298                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 0299             }
; 0000 029A             else
	RJMP _0xC2
_0xC1:
; 0000 029B             {
; 0000 029C                 // save the buffer to EEPROM
; 0000 029D                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0x2F
	MOV  R18,R30
; 0000 029E                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
_0xC4:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,8
	BRGE _0xC5
; 0000 029F                 {
; 0000 02A0                     write_byte_to_eeprom(i + ((st_counts + 1) * 16), buffer[i]);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LD   R26,Z
	RCALL _write_byte_to_eeprom
; 0000 02A1                 }
	CALL SUBOPT_0x2D
	RJMP _0xC4
_0xC5:
; 0000 02A2                 rtc_getTime(&hour, &minute, &second);
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
; 0000 02A3                 sprintf(time, "%02x%02x", hour, minute);
	CALL SUBOPT_0x32
	LDD  R30,Y+14
	CALL SUBOPT_0x14
	LDD  R30,Y+19
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
; 0000 02A4                 for (i = 0; i < 4; i++)
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
_0xC7:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,4
	BRGE _0xC8
; 0000 02A5                 {
; 0000 02A6                     write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i]);
	CALL SUBOPT_0x30
	ADIW R30,8
	CALL SUBOPT_0x31
	SUBI R30,LOW(-_time)
	SBCI R31,HIGH(-_time)
	LD   R26,Z
	RCALL _write_byte_to_eeprom
; 0000 02A7                 }
	CALL SUBOPT_0x2D
	RJMP _0xC7
_0xC8:
; 0000 02A8                 rtc_getDate(&year, &month, &date, &day);
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
; 0000 02A9                 sprintf(time, "%02x%02x", month, date);
	CALL SUBOPT_0x32
	LDD  R30,Y+11
	CALL SUBOPT_0x14
	LDD  R30,Y+16
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
; 0000 02AA                 for (i = 4; i < 8; i++)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+12,R30
	STD  Y+12+1,R31
_0xCA:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,8
	BRGE _0xCB
; 0000 02AB                 {
; 0000 02AC                     write_byte_to_eeprom(i + ((st_counts + 1) * 16 + 8), time[i - 4]);
	CALL SUBOPT_0x30
	ADIW R30,8
	CALL SUBOPT_0x31
	CALL SUBOPT_0x15
; 0000 02AD                 }
	CALL SUBOPT_0x2D
	RJMP _0xCA
_0xCB:
; 0000 02AE                 write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0x16
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 02AF 
; 0000 02B0                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 02B1                 lcd_gotoxy(1, 1);
; 0000 02B2                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x9B,170
	CALL SUBOPT_0x1
; 0000 02B3                 lcd_gotoxy(1, 2);
; 0000 02B4                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,202
	CALL SUBOPT_0x25
; 0000 02B5                 delay_ms(2000);
; 0000 02B6             }
_0xC2:
_0xC0:
; 0000 02B7             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02B8 #asm("sei")
	sei
; 0000 02B9             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x1B9
; 0000 02BA         }
; 0000 02BB         else if (keypad[rowloc][cl] == 'C')
_0xBC:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCD
; 0000 02BC             stage = STAGE_ATTENDENC_MENU;
_0x1B9:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 02BD     }
_0xCD:
_0xBB:
_0xB6:
_0xB3:
; 0000 02BE     else if (stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0xCE
_0xAF:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0xCF
; 0000 02BF     {
; 0000 02C0         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD0
; 0000 02C1         {
; 0000 02C2             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02C3             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 02C4         }
; 0000 02C5     }
_0xD0:
; 0000 02C6     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0xD1
_0xCF:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0xD2
; 0000 02C7     {
; 0000 02C8         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD3
; 0000 02C9             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 02CA     }
_0xD3:
; 0000 02CB     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0xD4
_0xD2:
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0xD5
; 0000 02CC     {
; 0000 02CD         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD6
; 0000 02CE             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 02CF     }
_0xD6:
; 0000 02D0     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0xD7
_0xD5:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0xD8
; 0000 02D1     {
; 0000 02D2         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD9
; 0000 02D3             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 02D4         else if (keypad[rowloc][cl] == '1')
	RJMP _0xDA
_0xD9:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0xDB
; 0000 02D5             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(8)
	RJMP _0x1BA
; 0000 02D6         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0xDB:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xDE
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0xDF
_0xDE:
	RJMP _0xDD
_0xDF:
; 0000 02D7             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(9)
	RJMP _0x1BA
; 0000 02D8         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0xDD:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xE2
	TST  R6
	BREQ _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
; 0000 02D9         {
; 0000 02DA             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 02DB             lcd_gotoxy(1, 1);
; 0000 02DC             lcd_print("You Must First Login");
	__POINTW2MN _0x9B,233
	CALL SUBOPT_0x1
; 0000 02DD             lcd_gotoxy(1, 2);
; 0000 02DE             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x9B,254
	CALL SUBOPT_0x25
; 0000 02DF             delay_ms(2000);
; 0000 02E0             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
_0x1BA:
	MOV  R5,R30
; 0000 02E1         }
; 0000 02E2     }
_0xE1:
_0xDA:
; 0000 02E3     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0xE4
_0xD8:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xE5
; 0000 02E4     {
; 0000 02E5         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xE6
; 0000 02E6         {
; 0000 02E7             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 02E8             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x1BB
; 0000 02E9         }
; 0000 02EA         else if ((keypad[rowloc][cl] - '0') < 10)
_0xE6:
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xE8
; 0000 02EB         {
; 0000 02EC             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xE9
; 0000 02ED             {
; 0000 02EE                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 02EF                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x28
; 0000 02F0                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02F1             }
; 0000 02F2         }
_0xE9:
; 0000 02F3         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xEA
_0xE8:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xEB
; 0000 02F4         {
; 0000 02F5             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 02F6             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xEC
; 0000 02F7             {
; 0000 02F8                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x29
; 0000 02F9                 lcdCommand(0x10);
; 0000 02FA                 lcd_print(" ");
	__POINTW2MN _0x9B,283
	CALL SUBOPT_0x2A
; 0000 02FB                 lcdCommand(0x10);
; 0000 02FC             }
; 0000 02FD         }
_0xEC:
; 0000 02FE         else if (keypad[rowloc][cl] == 'O')
	RJMP _0xED
_0xEB:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0xEE
; 0000 02FF         {
; 0000 0300             lcdCommand(0xC0);
	CALL SUBOPT_0x2B
; 0000 0301             for(i = 0; i < strlen(buffer); i++)
_0xF0:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2C
	BRSH _0xF1
; 0000 0302                 lcd_print(" ");
	__POINTW2MN _0x9B,285
	RCALL _lcd_print
	CALL SUBOPT_0x2D
	RJMP _0xF0
_0xF1:
; 0000 0303 lcdCommand(0xC0);
	CALL SUBOPT_0x2E
; 0000 0304             memset(buffer, 0, 32);
; 0000 0305         }
; 0000 0306         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xF2
_0xEE:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xF3
; 0000 0307         {
; 0000 0308             // search from eeprom data
; 0000 0309             unsigned char result = search_student_code();
; 0000 030A 
; 0000 030B             if (result > 0)
	CALL SUBOPT_0x33
;	i -> Y+13
;	minute -> Y+12
;	hour -> Y+11
;	day -> Y+10
;	date -> Y+9
;	month -> Y+8
;	year -> Y+7
;	result -> Y+0
	BRLO _0xF4
; 0000 030C             {
; 0000 030D                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 030E                 lcd_gotoxy(1, 1);
; 0000 030F                 lcd_print("Student Code Found");
	__POINTW2MN _0x9B,287
	CALL SUBOPT_0x1
; 0000 0310                 lcd_gotoxy(1, 2);
; 0000 0311                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,306
	RJMP _0x1BC
; 0000 0312                 delay_ms(2000);
; 0000 0313             }
; 0000 0314             else
_0xF4:
; 0000 0315             {
; 0000 0316                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0317                 lcd_gotoxy(1, 1);
; 0000 0318                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x9B,337
	CALL SUBOPT_0x1
; 0000 0319                 lcd_gotoxy(1, 2);
; 0000 031A                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,366
_0x1BC:
	RCALL _lcd_print
; 0000 031B                 delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 031C             }
; 0000 031D             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 031E             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 031F         }
	ADIW R28,1
; 0000 0320         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xF6
_0xF3:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xF7
; 0000 0321             stage = STAGE_STUDENT_MANAGMENT;
_0x1BB:
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0322     }
_0xF7:
_0xF6:
_0xF2:
_0xED:
_0xEA:
; 0000 0323     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xF8
_0xE5:
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xF9
; 0000 0324     {
; 0000 0325         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xFA
; 0000 0326         {
; 0000 0327             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0328             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0329         }
; 0000 032A         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xFB
_0xFA:
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xFC
; 0000 032B         {
; 0000 032C             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xFD
; 0000 032D             {
; 0000 032E                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 032F                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x28
; 0000 0330                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0331             }
; 0000 0332         }
_0xFD:
; 0000 0333         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xFE
_0xFC:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xFF
; 0000 0334         {
; 0000 0335             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 0336             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x100
; 0000 0337             {
; 0000 0338                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x29
; 0000 0339                 lcdCommand(0x10);
; 0000 033A                 lcd_print(" ");
	__POINTW2MN _0x9B,397
	CALL SUBOPT_0x2A
; 0000 033B                 lcdCommand(0x10);
; 0000 033C             }
; 0000 033D         }
_0x100:
; 0000 033E         else if (keypad[rowloc][cl] == 'O')
	RJMP _0x101
_0xFF:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x102
; 0000 033F         {
; 0000 0340             lcdCommand(0xC0);
	CALL SUBOPT_0x2B
; 0000 0341             for(i = 0; i < strlen(buffer); i++)
_0x104:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2C
	BRSH _0x105
; 0000 0342                 lcd_print(" ");
	__POINTW2MN _0x9B,399
	RCALL _lcd_print
	CALL SUBOPT_0x2D
	RJMP _0x104
_0x105:
; 0000 0343 lcdCommand(0xC0);
	CALL SUBOPT_0x2E
; 0000 0344             memset(buffer, 0, 32);
; 0000 0345         }
; 0000 0346         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x106
_0x102:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x107
; 0000 0347         {
; 0000 0348             // search from eeprom data
; 0000 0349             unsigned char result = search_student_code();
; 0000 034A 
; 0000 034B             if (result > 0)
	CALL SUBOPT_0x33
;	i -> Y+13
;	minute -> Y+12
;	hour -> Y+11
;	day -> Y+10
;	date -> Y+9
;	month -> Y+8
;	year -> Y+7
;	result -> Y+0
	BRLO _0x108
; 0000 034C             {
; 0000 034D                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 034E                 lcd_gotoxy(1, 1);
; 0000 034F                 lcd_print("Student Code Found");
	__POINTW2MN _0x9B,401
	CALL SUBOPT_0x1
; 0000 0350                 lcd_gotoxy(1, 2);
; 0000 0351                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x9B,420
	RCALL _lcd_print
; 0000 0352                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 0353                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0354                 lcd_gotoxy(1, 1);
; 0000 0355                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x9B,439
	CALL SUBOPT_0x1
; 0000 0356                 lcd_gotoxy(1, 2);
; 0000 0357                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,464
	RJMP _0x1BD
; 0000 0358                 delay_ms(2000);
; 0000 0359             }
; 0000 035A             else
_0x108:
; 0000 035B             {
; 0000 035C                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 035D                 lcd_gotoxy(1, 1);
; 0000 035E                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x9B,495
	CALL SUBOPT_0x1
; 0000 035F                 lcd_gotoxy(1, 2);
; 0000 0360                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,524
_0x1BD:
	RCALL _lcd_print
; 0000 0361                 delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 0362             }
; 0000 0363             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0364             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0365         }
	ADIW R28,1
; 0000 0366     }
_0x107:
_0x106:
_0x101:
_0xFE:
_0xFB:
; 0000 0367     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x10A
_0xF9:
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x10B
; 0000 0368     {
; 0000 0369         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x10C
; 0000 036A             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 036B     }
_0x10C:
; 0000 036C     else if (stage == STAGE_SHOW_CLOCK)
	RJMP _0x10D
_0x10B:
	LDI  R30,LOW(13)
	CP   R30,R5
	BRNE _0x10E
; 0000 036D     {
; 0000 036E         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x10F
; 0000 036F             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 0370     }
_0x10F:
; 0000 0371     else if (stage == STAGE_SET_TIMER)
	RJMP _0x110
_0x10E:
	LDI  R30,LOW(14)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x111
; 0000 0372     {
; 0000 0373         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x112
; 0000 0374         {
; 0000 0375             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0376             stage = STAGE_INIT_MENU;
	RJMP _0x1BE
; 0000 0377         }
; 0000 0378 
; 0000 0379         else if(keypad[rowloc][cl] == 'R')
_0x112:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x114
; 0000 037A         {
; 0000 037B             if(submitTime < 20){
	LDI  R30,LOW(20)
	CP   R9,R30
	BRSH _0x115
; 0000 037C                 submitTime++;
	INC  R9
; 0000 037D                 itoa(submitTime, buffer);
	MOV  R30,R9
	CALL SUBOPT_0x18
; 0000 037E                 lcd_gotoxy(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x22
; 0000 037F                 lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 0380                 lcd_print("  ");
	__POINTW2MN _0x9B,555
	RCALL _lcd_print
; 0000 0381             }
; 0000 0382         }
_0x115:
; 0000 0383         else if(keypad[rowloc][cl] == 'L')
	RJMP _0x116
_0x114:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x117
; 0000 0384         {
; 0000 0385             if(submitTime > 1){
	LDI  R30,LOW(1)
	CP   R30,R9
	BRSH _0x118
; 0000 0386                 submitTime--;
	DEC  R9
; 0000 0387                 itoa(submitTime, buffer);
	MOV  R30,R9
	CALL SUBOPT_0x18
; 0000 0388                 lcd_gotoxy(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x22
; 0000 0389                 lcd_print(buffer);
	CALL SUBOPT_0x17
; 0000 038A                 lcd_print("  ");
	__POINTW2MN _0x9B,558
	RCALL _lcd_print
; 0000 038B             }
; 0000 038C         }
_0x118:
; 0000 038D         else if(keypad[rowloc][cl] == 'E')
	RJMP _0x119
_0x117:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x11A
; 0000 038E         {
; 0000 038F             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0390             lcd_gotoxy(1,1);
; 0000 0391             lcd_print("Timer started");
	__POINTW2MN _0x9B,561
	RCALL _lcd_print
; 0000 0392             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 0393             delay_ms(2000);
	CALL SUBOPT_0x20
; 0000 0394             Timer2_Init();
	RCALL _Timer2_Init
; 0000 0395             stage = STAGE_INIT_MENU;
_0x1BE:
	CLR  R5
; 0000 0396         }
; 0000 0397 
; 0000 0398     }
_0x11A:
_0x119:
_0x116:
; 0000 0399     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0x11B
_0x111:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x11D
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x11E
_0x11D:
	RJMP _0x11C
_0x11E:
; 0000 039A     {
; 0000 039B         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x11F
; 0000 039C         {
; 0000 039D             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 039E             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 039F         }
; 0000 03A0 
; 0000 03A1         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0x120
_0x11F:
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x121
; 0000 03A2         {
; 0000 03A3             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0x122
; 0000 03A4             {
; 0000 03A5                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 03A6                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x28
; 0000 03A7                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 03A8             }
; 0000 03A9         }
_0x122:
; 0000 03AA         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x123
_0x121:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x124
; 0000 03AB         {
; 0000 03AC             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 03AD             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x125
; 0000 03AE             {
; 0000 03AF                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x29
; 0000 03B0                 lcdCommand(0x10);
; 0000 03B1                 lcd_print(" ");
	__POINTW2MN _0x9B,575
	CALL SUBOPT_0x2A
; 0000 03B2                 lcdCommand(0x10);
; 0000 03B3             }
; 0000 03B4         }
_0x125:
; 0000 03B5         else if (keypad[rowloc][cl] == 'O')
	RJMP _0x126
_0x124:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x127
; 0000 03B6         {
; 0000 03B7             lcdCommand(0xC0);
	CALL SUBOPT_0x2B
; 0000 03B8             for(i = 0; i < strlen(buffer); i++)
_0x129:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2C
	BRSH _0x12A
; 0000 03B9                 lcd_print(" ");
	__POINTW2MN _0x9B,577
	RCALL _lcd_print
	CALL SUBOPT_0x2D
	RJMP _0x129
_0x12A:
; 0000 03BA lcdCommand(0xC0);
	CALL SUBOPT_0x2E
; 0000 03BB             memset(buffer, 0, 32);
; 0000 03BC         }
; 0000 03BD         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x12B
_0x127:
	CALL SUBOPT_0x24
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x12C
; 0000 03BE         {
; 0000 03BF             // search from eeprom data
; 0000 03C0             unsigned int input_hash = simple_hash(buffer);
; 0000 03C1 
; 0000 03C2             if (input_hash == secret)
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
	BRNE _0x12D
; 0000 03C3             {
; 0000 03C4                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 03C5                 lcd_gotoxy(1, 1);
; 0000 03C6                 lcd_print("Login Successfully");
	__POINTW2MN _0x9B,579
	CALL SUBOPT_0x1
; 0000 03C7                 lcd_gotoxy(1, 2);
; 0000 03C8                 lcd_print("Wait...");
	__POINTW2MN _0x9B,598
	CALL SUBOPT_0x25
; 0000 03C9                 delay_ms(2000);
; 0000 03CA                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 03CB             }
; 0000 03CC             else
	RJMP _0x12E
_0x12D:
; 0000 03CD             {
; 0000 03CE                 lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 03CF                 lcd_gotoxy(1, 1);
; 0000 03D0                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x9B,606
	CALL SUBOPT_0x1
; 0000 03D1                 lcd_gotoxy(1, 2);
; 0000 03D2                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x9B,632
	CALL SUBOPT_0x25
; 0000 03D3                 delay_ms(2000);
; 0000 03D4             }
_0x12E:
; 0000 03D5             memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 03D6             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03D7         }
	ADIW R28,2
; 0000 03D8     }
_0x12C:
_0x12B:
_0x126:
_0x123:
_0x120:
; 0000 03D9     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0x12F
_0x11C:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x131
	TST  R6
	BRNE _0x132
_0x131:
	RJMP _0x130
_0x132:
; 0000 03DA     {
; 0000 03DB         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x24
	LD   R30,X
	LDI  R31,0
; 0000 03DC         {
; 0000 03DD         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x136
; 0000 03DE             stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03DF             break;
	RJMP _0x135
; 0000 03E0         case '1':
_0x136:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x138
; 0000 03E1 #asm("cli") // disable interrupts
	cli
; 0000 03E2             lcdCommand(0x1);
	CALL SUBOPT_0x0
; 0000 03E3             lcd_gotoxy(1, 1);
; 0000 03E4             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x9B,663
	RCALL _lcd_print
; 0000 03E5             clear_eeprom();
	RCALL _clear_eeprom
; 0000 03E6 #asm("sei") // enable interrupts
	sei
; 0000 03E7             break;
; 0000 03E8         default:
_0x138:
; 0000 03E9             break;
; 0000 03EA         }
_0x135:
; 0000 03EB         memset(buffer, 0, 32);
	CALL SUBOPT_0x5
; 0000 03EC         stage = STAGE_INIT_MENU;
	CLR  R5
; 0000 03ED     }
; 0000 03EE }
_0x130:
_0x12F:
_0x11B:
_0x110:
_0x10D:
_0x10A:
_0xF8:
_0xE4:
_0xD7:
_0xD4:
_0xD1:
_0xCE:
_0xAE:
_0xA5:
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
_0x9B:
	.BYTE 0x2AB
;
;void lcdCommand(unsigned char cmnd)
; 0000 03F1 {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 03F2     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x34
;	cmnd -> Y+0
; 0000 03F3     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x1B,0
; 0000 03F4     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x35
; 0000 03F5     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03F6     delay_us(1 * 16);          // wait to make EN wider
; 0000 03F7     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03F8     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 03F9     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x36
; 0000 03FA     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 03FB     delay_us(1 * 16);          // wait to make EN wider
; 0000 03FC     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 03FD }
	RJMP _0x20C0006
; .FEND
;void lcdData(unsigned char data)
; 0000 03FF {
_lcdData:
; .FSTART _lcdData
; 0000 0400     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x34
;	data -> Y+0
; 0000 0401     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x1B,0
; 0000 0402     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x35
; 0000 0403     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0404     delay_us(1 * 16);          // wait to make EN wider
; 0000 0405     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0406     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x36
; 0000 0407     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0408     delay_us(1 * 16);          // wait to make EN wider
; 0000 0409     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 040A }
	RJMP _0x20C0006
; .FEND
;void lcd_init()
; 0000 040C {
_lcd_init:
; .FSTART _lcd_init
; 0000 040D     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 040E     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x1B,2
; 0000 040F     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 0410     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x37
; 0000 0411     delay_us(100 * 16);        // wait
; 0000 0412     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x37
; 0000 0413     delay_us(100 * 16);        // wait
; 0000 0414     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x37
; 0000 0415     delay_us(100 * 16);        // wait
; 0000 0416     lcdCommand(0x0c);          // display on, cursor off
	CALL SUBOPT_0x4
; 0000 0417     delay_us(100 * 16);        // wait
; 0000 0418     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0419     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 041A     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x37
; 0000 041B     delay_us(100 * 16);
; 0000 041C }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 041E {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 041F     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 0420     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
; 0000 0421     delay_us(100 * 16);
; 0000 0422 }
	RJMP _0x20C0005
; .FEND
;void lcd_print(char *str)
; 0000 0424 {
_lcd_print:
; .FSTART _lcd_print
; 0000 0425     unsigned char i = 0;
; 0000 0426     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x139:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x13B
; 0000 0427     {
; 0000 0428         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 0429         i++;
	SUBI R17,-1
; 0000 042A     }
	RJMP _0x139
_0x13B:
; 0000 042B }
	LDD  R17,Y+0
	RJMP _0x20C0009
; .FEND
;
;void show_temperature()
; 0000 042E {
_show_temperature:
; .FSTART _show_temperature
; 0000 042F     unsigned char temperatureVal = 0;
; 0000 0430     unsigned char temperatureRep[3];
; 0000 0431 
; 0000 0432     DDRA &= ~(1 << 3);
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	CBI  0x1A,3
; 0000 0433     ADMUX = 0xE3;
	LDI  R30,LOW(227)
	OUT  0x7,R30
; 0000 0434     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0435 
; 0000 0436     lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0437     lcd_gotoxy(1, 1);
; 0000 0438     lcd_print("Temperature(C):");
	__POINTW2MN _0x13C,0
	RCALL _lcd_print
; 0000 0439 
; 0000 043A     while (stage == STAGE_TEMPERATURE_MONITORING)
_0x13D:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x13F
; 0000 043B     {
; 0000 043C         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 043D         while ((ADCSRA & (1 << ADIF)) == 0)
_0x140:
	SBIS 0x6,4
; 0000 043E             ;
	RJMP _0x140
; 0000 043F         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0x143
; 0000 0440         {
; 0000 0441             temperatureVal = ADCH;
	IN   R17,5
; 0000 0442             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 0443             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	CALL SUBOPT_0x22
; 0000 0444             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 0445             lcd_print(" ");
	__POINTW2MN _0x13C,16
	RCALL _lcd_print
; 0000 0446         }
; 0000 0447         delay_ms(500);
_0x143:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0448     }
	RJMP _0x13D
_0x13F:
; 0000 0449 
; 0000 044A     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 044B }
	LDD  R17,Y+0
	RJMP _0x20C0007
; .FEND

	.DSEG
_0x13C:
	.BYTE 0x12
;
;void show_menu()
; 0000 044E {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 044F     while (stage == STAGE_INIT_MENU)
_0x144:
	TST  R5
	BREQ PC+2
	RJMP _0x146
; 0000 0450     {
; 0000 0451         lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0452         lcd_gotoxy(1, 1);
; 0000 0453         if (page_num == 0)
	TST  R4
	BRNE _0x147
; 0000 0454         {
; 0000 0455             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0x148,0
	CALL SUBOPT_0x1
; 0000 0456             lcd_gotoxy(1, 2);
; 0000 0457             lcd_print("2: Student Management");
	__POINTW2MN _0x148,29
	RCALL _lcd_print
; 0000 0458             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0x149:
	TST  R4
	BRNE _0x14C
	TST  R5
	BREQ _0x14D
_0x14C:
	RJMP _0x14B
_0x14D:
; 0000 0459                 ;
	RJMP _0x149
_0x14B:
; 0000 045A         }
; 0000 045B         else if (page_num == 1)
	RJMP _0x14E
_0x147:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x14F
; 0000 045C         {
; 0000 045D             lcd_print("3: View Present Students ");
	__POINTW2MN _0x148,51
	CALL SUBOPT_0x1
; 0000 045E             lcd_gotoxy(1, 2);
; 0000 045F             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0x148,77
	RCALL _lcd_print
; 0000 0460             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0x150:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x153
	TST  R5
	BREQ _0x154
_0x153:
	RJMP _0x152
_0x154:
; 0000 0461                 ;
	RJMP _0x150
_0x152:
; 0000 0462         }
; 0000 0463         else if (page_num == 2)
	RJMP _0x155
_0x14F:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x156
; 0000 0464         {
; 0000 0465             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0x148,103
	CALL SUBOPT_0x1
; 0000 0466             lcd_gotoxy(1, 2);
; 0000 0467             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0x148,128
	RCALL _lcd_print
; 0000 0468             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0x157:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x15A
	TST  R5
	BREQ _0x15B
_0x15A:
	RJMP _0x159
_0x15B:
; 0000 0469                 ;
	RJMP _0x157
_0x159:
; 0000 046A         }
; 0000 046B         else if (page_num == 3)
	RJMP _0x15C
_0x156:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x15D
; 0000 046C         {
; 0000 046D             lcd_print("7: Login With Admin");
	__POINTW2MN _0x148,150
	CALL SUBOPT_0x1
; 0000 046E             lcd_gotoxy(1, 2);
; 0000 046F             lcd_print("8: Logout");
	__POINTW2MN _0x148,170
	RCALL _lcd_print
; 0000 0470             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0x15E:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x161
	TST  R5
	BREQ _0x162
_0x161:
	RJMP _0x160
_0x162:
; 0000 0471                 ;
	RJMP _0x15E
_0x160:
; 0000 0472         }
; 0000 0473         else if (page_num == 4)
	RJMP _0x163
_0x15D:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x164
; 0000 0474         {
; 0000 0475             lcd_print("9: Set Timer");
	__POINTW2MN _0x148,180
	RCALL _lcd_print
; 0000 0476             while (page_num == 4 && stage == STAGE_INIT_MENU)
_0x165:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x168
	TST  R5
	BREQ _0x169
_0x168:
	RJMP _0x167
_0x169:
; 0000 0477                 ;
	RJMP _0x165
_0x167:
; 0000 0478         }
; 0000 0479     }
_0x164:
_0x163:
_0x15C:
_0x155:
_0x14E:
	RJMP _0x144
_0x146:
; 0000 047A }
	RET
; .FEND

	.DSEG
_0x148:
	.BYTE 0xC1
;
;void clear_eeprom()
; 0000 047D {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 047E     unsigned int i;
; 0000 047F 
; 0000 0480     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x16B:
	__CPWRN 16,17,1024
	BRSH _0x16C
; 0000 0481     {
; 0000 0482         // Wait for the previous write to complete
; 0000 0483         while (EECR & (1 << EEWE))
_0x16D:
	SBIC 0x1C,1
; 0000 0484             ;
	RJMP _0x16D
; 0000 0485 
; 0000 0486         // Set up address registers
; 0000 0487         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 0488         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 0489 
; 0000 048A         // Set up data register
; 0000 048B         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 048C 
; 0000 048D         // Enable write
; 0000 048E         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 048F         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0490     }
	__ADDWRN 16,17,1
	RJMP _0x16B
_0x16C:
; 0000 0491 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 0494 {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 0495     unsigned char x;
; 0000 0496     // Wait for the previous write to complete
; 0000 0497     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x170:
	SBIC 0x1C,1
; 0000 0498         ;
	RJMP _0x170
; 0000 0499 
; 0000 049A     // Set up address registers
; 0000 049B     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x38
; 0000 049C     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 049D     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 049E     x = EEDR;
	IN   R17,29
; 0000 049F     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0009
; 0000 04A0 }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 04A3 {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 04A4     // Wait for the previous write to complete
; 0000 04A5     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x173:
	SBIC 0x1C,1
; 0000 04A6         ;
	RJMP _0x173
; 0000 04A7 
; 0000 04A8     // Set up address registers
; 0000 04A9     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x38
; 0000 04AA     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 04AB 
; 0000 04AC     // Set up data register
; 0000 04AD     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 04AE 
; 0000 04AF     // Enable write
; 0000 04B0     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 04B1     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 04B2 }
_0x20C0009:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 04B5 {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 04B6     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x176:
	SBIS 0xB,5
; 0000 04B7         ;
	RJMP _0x176
; 0000 04B8     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 04B9 }
	RJMP _0x20C0006
; .FEND
;
;unsigned char USART_Receive()
; 0000 04BC {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 04BD     while(!(UCSRA & (1 << RXC)) && stage == STAGE_SUBMIT_WITH_CARD);
_0x179:
	SBIC 0xB,7
	RJMP _0x17C
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x17D
_0x17C:
	RJMP _0x17B
_0x17D:
	RJMP _0x179
_0x17B:
; 0000 04BE     return UDR;
	IN   R30,0xC
	RET
; 0000 04BF }
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 04C2 {
_USART_init:
; .FSTART _USART_init
; 0000 04C3     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 04C4     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 04C5     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 04C6     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 04C7 }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 04CA {
_search_student_code:
; .FSTART _search_student_code
; 0000 04CB     unsigned char st_counts, i, j;
; 0000 04CC     char temp[10];
; 0000 04CD 
; 0000 04CE     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0x2F
	MOV  R17,R30
; 0000 04CF 
; 0000 04D0     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x17F:
	CP   R16,R17
	BRSH _0x180
; 0000 04D1     {
; 0000 04D2         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 04D3         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x182:
	CPI  R19,8
	BRSH _0x183
; 0000 04D4         {
; 0000 04D5             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 16));
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
; 0000 04D6         }
	SUBI R19,-1
	RJMP _0x182
_0x183:
; 0000 04D7         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 04D8         if (strncmp(temp, buffer, 8) == 0)
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x184
; 0000 04D9             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20C0008
; 0000 04DA     }
_0x184:
	SUBI R16,-1
	RJMP _0x17F
_0x180:
; 0000 04DB 
; 0000 04DC     return 0;
	LDI  R30,LOW(0)
_0x20C0008:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 04DD }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 04E0 {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 04E1     unsigned char st_counts, i, j;
; 0000 04E2     unsigned char temp;
; 0000 04E3 
; 0000 04E4     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0x2F
	MOV  R17,R30
; 0000 04E5 
; 0000 04E6     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x186:
	CP   R17,R16
	BRLO _0x187
; 0000 04E7     {
; 0000 04E8         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x189:
	CPI  R19,8
	BRSH _0x18A
; 0000 04E9         {
; 0000 04EA             temp = read_byte_from_eeprom(j + ((i + 1) * 16));
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
; 0000 04EB             write_byte_to_eeprom(j + (i * 16), temp);
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	RCALL _write_byte_to_eeprom
; 0000 04EC         }
	SUBI R19,-1
	RJMP _0x189
_0x18A:
; 0000 04ED         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x18C:
	CPI  R19,8
	BRSH _0x18D
; 0000 04EE         {
; 0000 04EF             temp = read_byte_from_eeprom(j + ((i + 1) * 16) + 8);
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
; 0000 04F0             write_byte_to_eeprom(j + (i * 16) + 8, temp);
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	RCALL _write_byte_to_eeprom
; 0000 04F1         }
	SUBI R19,-1
	RJMP _0x18C
_0x18D:
; 0000 04F2     }
	SUBI R16,-1
	RJMP _0x186
_0x187:
; 0000 04F3     write_byte_to_eeprom(0x0, st_counts - 1);
	CALL SUBOPT_0x16
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 04F4 }
	CALL __LOADLOCR4
	JMP  _0x20C0003
; .FEND
;
;void HCSR04Init()
; 0000 04F7 {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 04F8     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 04F9     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 04FA }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 04FD {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 04FE     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 04FF     delay_us(15 * 16);              // Wait for 15 microseconds
	__DELAY_USW 480
; 0000 0500     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 0501 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 0504 {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 0505     uint32_t i, result;
; 0000 0506 
; 0000 0507     // Wait for rising edge on Echo pin
; 0000 0508     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x18F:
	CALL SUBOPT_0x3B
	BRSH _0x190
; 0000 0509     {
; 0000 050A         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 050B             continue;
	RJMP _0x18E
; 0000 050C         else
; 0000 050D             break;
	RJMP _0x190
; 0000 050E     }
_0x18E:
	CALL SUBOPT_0x3C
	RJMP _0x18F
_0x190:
; 0000 050F 
; 0000 0510     if (i == 600000)
	CALL SUBOPT_0x3B
	BRNE _0x193
; 0000 0511         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
; 0000 0512 
; 0000 0513     // Start timer with prescaler 64
; 0000 0514     TCCR1A = 0x00;
_0x193:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0515     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0516     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0517 
; 0000 0518     // Wait for falling edge on Echo pin
; 0000 0519     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x195:
	CALL SUBOPT_0x3B
	BRSH _0x196
; 0000 051A     {
; 0000 051B         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 051C             break; // Falling edge detected
	RJMP _0x196
; 0000 051D         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x198
; 0000 051E             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0004
; 0000 051F     }
_0x198:
	CALL SUBOPT_0x3C
	RJMP _0x195
_0x196:
; 0000 0520 
; 0000 0521     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 0522     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0523 
; 0000 0524     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x199
; 0000 0525         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0004
; 0000 0526     else
_0x199:
; 0000 0527         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
	RJMP _0x20C0004
; 0000 0528 }
; .FEND
;
;void startSonar()
; 0000 052B {
_startSonar:
; .FSTART _startSonar
; 0000 052C     char numberString[16];
; 0000 052D     uint16_t pulseWidth; // Pulse width from echo
; 0000 052E     int distance, previous_distance = -1;
; 0000 052F     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 0530 
; 0000 0531     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x0
; 0000 0532     lcd_gotoxy(1, 1);
; 0000 0533     lcd_print("Distance: ");
	__POINTW2MN _0x19C,0
	RCALL _lcd_print
; 0000 0534 
; 0000 0535     while (stage == STAGE_TRAFFIC_MONITORING)
_0x19D:
	LDI  R30,LOW(10)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x19F
; 0000 0536     {
; 0000 0537         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 0538         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 0539 
; 0000 053A         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1A0
; 0000 053B         {
; 0000 053C             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 053D             lcd_gotoxy(1, 1);
; 0000 053E             lcd_print("Error"); // Display error message
	__POINTW2MN _0x19C,11
	RJMP _0x1BF
; 0000 053F         }
; 0000 0540         else if (pulseWidth == US_NO_OBSTACLE)
_0x1A0:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1A2
; 0000 0541         {
; 0000 0542             lcdCommand(0x01);
	CALL SUBOPT_0x0
; 0000 0543             lcd_gotoxy(1, 1);
; 0000 0544             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x19C,17
	RJMP _0x1BF
; 0000 0545         }
; 0000 0546         else
_0x1A2:
; 0000 0547         {
; 0000 0548             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 0549 
; 0000 054A             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x1A4
; 0000 054B             {
; 0000 054C                 previous_distance = distance;
	MOVW R20,R18
; 0000 054D                 // Display distance on LCD
; 0000 054E                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 054F                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x22
; 0000 0550                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 0551                 lcd_print(" cm ");
	__POINTW2MN _0x19C,29
	RCALL _lcd_print
; 0000 0552             }
; 0000 0553             // Counting logic based on distance
; 0000 0554             if (distance < 6)
_0x1A4:
	__CPWRN 18,19,6
	BRGE _0x1A5
; 0000 0555             {
; 0000 0556                 US_count++; // Increment count if distance is below threshold
	INC  R7
; 0000 0557             }
; 0000 0558 
; 0000 0559             // Update count on LCD only if it changes
; 0000 055A             if (US_count != previous_count)
_0x1A5:
	LDS  R30,_previous_count_S0000015000
	LDS  R31,_previous_count_S0000015000+1
	MOV  R26,R7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x1A6
; 0000 055B             {
; 0000 055C                 previous_count = US_count;
	MOV  R30,R7
	LDI  R31,0
	STS  _previous_count_S0000015000,R30
	STS  _previous_count_S0000015000+1,R31
; 0000 055D                 lcd_gotoxy(1, 2); // Move to second line
	CALL SUBOPT_0x1C
; 0000 055E                 itoa(US_count, numberString);
	MOV  R30,R7
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 055F                 lcd_print("Count: ");
	__POINTW2MN _0x19C,34
	RCALL _lcd_print
; 0000 0560                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x1BF:
	RCALL _lcd_print
; 0000 0561             }
; 0000 0562         }
_0x1A6:
; 0000 0563         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0564     }
	RJMP _0x19D
_0x19F:
; 0000 0565 }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x19C:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 0568 {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 0569     unsigned int hash = 0;
; 0000 056A     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x1A7:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x1A9
; 0000 056B     {
; 0000 056C         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 056D         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 056E     }
	RJMP _0x1A7
_0x1A9:
; 0000 056F     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0007:
	ADIW R28,4
	RET
; 0000 0570 }
; .FEND
;
;void I2C_init()
; 0000 0573 {
_I2C_init:
; .FSTART _I2C_init
; 0000 0574     TWSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0575     TWBR = 0x47;
	LDI  R30,LOW(71)
	OUT  0x0,R30
; 0000 0576     TWCR = 0x04;
	LDI  R30,LOW(4)
	OUT  0x36,R30
; 0000 0577 }
	RET
; .FEND
;
;void I2C_start()
; 0000 057A {
_I2C_start:
; .FSTART _I2C_start
; 0000 057B     TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0000 057C     while(!(TWCR & (1 << TWINT)));
_0x1AA:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1AA
; 0000 057D }
	RET
; .FEND
;
;void I2C_write(unsigned char data)
; 0000 0580 {
_I2C_write:
; .FSTART _I2C_write
; 0000 0581     TWDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0000 0582     TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0000 0583     while(!(TWCR & (1 << TWINT)));
_0x1AD:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1AD
; 0000 0584 }
	RJMP _0x20C0006
; .FEND
;
;unsigned char I2C_read(unsigned char ackVal)
; 0000 0587 {
_I2C_read:
; .FSTART _I2C_read
; 0000 0588     TWCR = (1 << TWINT) | (1 << TWEN) | (ackVal << TWEA);
	ST   -Y,R26
;	ackVal -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
; 0000 0589     while(!(TWCR & (1 << TWINT)));
_0x1B0:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1B0
; 0000 058A     return TWDR;
	IN   R30,0x3
_0x20C0006:
	ADIW R28,1
	RET
; 0000 058B }
; .FEND
;
;void I2C_stop()
; 0000 058E {
_I2C_stop:
; .FSTART _I2C_stop
; 0000 058F     TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0000 0590     while(TWCR & (1 << TWSTO));
_0x1B3:
	IN   R30,0x36
	SBRC R30,4
	RJMP _0x1B3
; 0000 0591 }
	RET
; .FEND
;
;void rtc_init()
; 0000 0594 {
_rtc_init:
; .FSTART _rtc_init
; 0000 0595     I2C_init();
	RCALL _I2C_init
; 0000 0596     I2C_start();
	CALL SUBOPT_0x3D
; 0000 0597     I2C_write(0xD0);
; 0000 0598     I2C_write(0x07);
	LDI  R26,LOW(7)
	RCALL _I2C_write
; 0000 0599     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x3E
; 0000 059A     I2C_stop();
; 0000 059B }
	RET
; .FEND
;
;void rtc_getTime(unsigned char* hour, unsigned char* minute, unsigned char* second)
; 0000 059E {
_rtc_getTime:
; .FSTART _rtc_getTime
; 0000 059F     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*hour -> Y+4
;	*minute -> Y+2
;	*second -> Y+0
	CALL SUBOPT_0x3D
; 0000 05A0     I2C_write(0xD0);
; 0000 05A1     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x3E
; 0000 05A2     I2C_stop();
; 0000 05A3 
; 0000 05A4     I2C_start();
	CALL SUBOPT_0x3F
; 0000 05A5     I2C_write(0xD1);
; 0000 05A6     *second = I2C_read(1);
; 0000 05A7     *minute = I2C_read(1);
; 0000 05A8     *hour = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 05A9     I2C_stop();
	RCALL _I2C_stop
; 0000 05AA }
_0x20C0005:
	ADIW R28,6
	RET
; .FEND
;
;void rtc_getDate(unsigned char* year, unsigned char* month, unsigned char* date, unsigned char* day)
; 0000 05AD {
_rtc_getDate:
; .FSTART _rtc_getDate
; 0000 05AE     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*year -> Y+6
;	*month -> Y+4
;	*date -> Y+2
;	*day -> Y+0
	CALL SUBOPT_0x3D
; 0000 05AF     I2C_write(0xD0);
; 0000 05B0     I2C_write(0x03);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x3E
; 0000 05B1     I2C_stop();
; 0000 05B2 
; 0000 05B3     I2C_start();
	CALL SUBOPT_0x3F
; 0000 05B4     I2C_write(0xD1);
; 0000 05B5     *day = I2C_read(1);
; 0000 05B6     *date = I2C_read(1);
; 0000 05B7     *month = I2C_read(1);
	LDI  R26,LOW(1)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 05B8     *year = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
; 0000 05B9     I2C_stop();
	RCALL _I2C_stop
; 0000 05BA }
_0x20C0004:
	ADIW R28,8
	RET
; .FEND
;
;void Timer2_Init()
; 0000 05BD {
_Timer2_Init:
; .FSTART _Timer2_Init
; 0000 05BE     //Disable timer2 interrupts
; 0000 05BF     TIMSK = 0;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 05C0     //Enable asynchronous mode
; 0000 05C1     ASSR = (1 << AS2);
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 05C2     //set initial counter value
; 0000 05C3     TCNT2 = 0;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 05C4     //set prescaller 128
; 0000 05C5     TCCR2 = 0;
	OUT  0x25,R30
; 0000 05C6     TCCR2 |= (1 << CS22) | ( 1 << CS00);
	IN   R30,0x25
	ORI  R30,LOW(0x5)
	OUT  0x25,R30
; 0000 05C7     //wait for registers update
; 0000 05C8     while (ASSR & ((1 << TCN2UB) | (1 << TCR2UB)));
_0x1B6:
	IN   R30,0x22
	ANDI R30,LOW(0x5)
	BRNE _0x1B6
; 0000 05C9     //clear interrupt flags
; 0000 05CA     TIFR = (1 << TOV2);
	LDI  R30,LOW(64)
	OUT  0x38,R30
; 0000 05CB     //enable TOV2 interrupt
; 0000 05CC     TIMSK  = (1 << TOIE2);
	OUT  0x39,R30
; 0000 05CD }
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
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
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
	LDD  R30,Y+8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+13
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:429 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
	CALL _lcd_print
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
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
SUBOPT_0x2A:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(192)
	CALL _lcdCommand
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2D:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(192)
	CALL _lcdCommand
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	MOV  R30,R18
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
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
SUBOPT_0x32:
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x10

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

;END OF CODE MARKER
__END_OF_CODE:
