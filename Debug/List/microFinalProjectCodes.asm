
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
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
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
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _stage=R4
	.DEF _stage_msb=R5

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
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0x37,0x38,0x39,0x4F,0x34,0x35,0x36,0x44
	.DB  0x31,0x32,0x33,0x43,0x4C,0x30,0x52,0x45
_0x0:
	.DB  0x31,0x20,0x3A,0x20,0x53,0x75,0x62,0x6D
	.DB  0x69,0x74,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x0
	.DB  0x20,0x20,0x20,0x20,0x70,0x72,0x65,0x73
	.DB  0x73,0x20,0x63,0x61,0x6E,0x63,0x65,0x6C
	.DB  0x20,0x74,0x6F,0x20,0x62,0x61,0x63,0x6B
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x79
	.DB  0x6F,0x75,0x72,0x20,0x73,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x63,0x6F,0x64,0x65
	.DB  0x3A,0x0,0x4E,0x75,0x6D,0x62,0x65,0x72
	.DB  0x20,0x6F,0x66,0x20,0x73,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x73,0x20,0x3A,0x20,0x0
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x43,0x61
	.DB  0x6E,0x63,0x65,0x6C,0x20,0x54,0x6F,0x20
	.DB  0x47,0x6F,0x20,0x42,0x61,0x63,0x6B,0x0
	.DB  0x53,0x74,0x61,0x72,0x74,0x20,0x54,0x72
	.DB  0x61,0x6E,0x73,0x66,0x65,0x72,0x72,0x69
	.DB  0x6E,0x67,0x2E,0x2E,0x2E,0x0,0x55,0x73
	.DB  0x61,0x72,0x74,0x20,0x54,0x72,0x61,0x6E
	.DB  0x73,0x6D,0x69,0x74,0x20,0x66,0x69,0x6E
	.DB  0x69,0x73,0x68,0x65,0x64,0x0,0x31,0x20
	.DB  0x3A,0x20,0x53,0x65,0x61,0x72,0x63,0x68
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x0,0x20,0x20,0x20,0x20,0x50,0x72,0x65
	.DB  0x73,0x73,0x20,0x43,0x61,0x6E,0x63,0x65
	.DB  0x6C,0x20,0x54,0x6F,0x20,0x42,0x61,0x63
	.DB  0x6B,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x46,0x6F,0x72
	.DB  0x20,0x53,0x65,0x61,0x72,0x63,0x68,0x3A
	.DB  0x0,0x43,0x6C,0x65,0x61,0x72,0x69,0x6E
	.DB  0x67,0x20,0x45,0x45,0x50,0x52,0x4F,0x4D
	.DB  0x20,0x2E,0x2E,0x2E,0x0,0x34,0x30,0x0
	.DB  0x49,0x6E,0x63,0x6F,0x72,0x72,0x65,0x63
	.DB  0x74,0x20,0x53,0x75,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x46
	.DB  0x6F,0x72,0x6D,0x61,0x74,0x0,0x59,0x6F
	.DB  0x75,0x20,0x57,0x69,0x6C,0x6C,0x20,0x42
	.DB  0x61,0x63,0x6B,0x20,0x4D,0x65,0x6E,0x75
	.DB  0x20,0x49,0x6E,0x20,0x35,0x20,0x53,0x65
	.DB  0x63,0x6F,0x6E,0x64,0x0,0x44,0x75,0x70
	.DB  0x6C,0x69,0x63,0x61,0x74,0x65,0x20,0x53
	.DB  0x75,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x45,0x6E,0x74,0x65
	.DB  0x72,0x65,0x64,0x0,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x53,0x75,0x63,0x63,0x65,0x73,0x73
	.DB  0x66,0x75,0x6C,0x6C,0x79,0x20,0x41,0x64
	.DB  0x64,0x65,0x64,0x0,0x59,0x6F,0x75,0x20
	.DB  0x57,0x69,0x6C,0x6C,0x20,0x42,0x61,0x63
	.DB  0x6B,0x20,0x4D,0x65,0x6E,0x75,0x20,0x49
	.DB  0x6E,0x20,0x32,0x20,0x53,0x65,0x63,0x6F
	.DB  0x6E,0x64,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x46,0x6F,0x75,0x6E,0x64,0x0,0x4F,0x70
	.DB  0x73,0x20,0x2C,0x20,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x4E,0x6F,0x74,0x20,0x46,0x6F,0x75
	.DB  0x6E,0x64,0x0,0x54,0x65,0x6D,0x70,0x28
	.DB  0x43,0x29,0x3A,0x0,0x31,0x3A,0x20,0x41
	.DB  0x74,0x74,0x65,0x6E,0x64,0x61,0x6E,0x63
	.DB  0x65,0x20,0x49,0x6E,0x69,0x74,0x69,0x61
	.DB  0x6C,0x69,0x7A,0x61,0x74,0x69,0x6F,0x6E
	.DB  0x0,0x32,0x3A,0x20,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x4D,0x61,0x6E,0x61
	.DB  0x67,0x65,0x6D,0x65,0x6E,0x74,0x0,0x33
	.DB  0x3A,0x20,0x56,0x69,0x65,0x77,0x20,0x50
	.DB  0x72,0x65,0x73,0x65,0x6E,0x74,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x73,0x20
	.DB  0x0,0x34,0x3A,0x20,0x54,0x65,0x6D,0x70
	.DB  0x65,0x72,0x61,0x74,0x75,0x72,0x65,0x20
	.DB  0x4D,0x6F,0x6E,0x69,0x74,0x6F,0x72,0x69
	.DB  0x6E,0x67,0x0,0x35,0x3A,0x20,0x52,0x65
	.DB  0x74,0x72,0x69,0x65,0x76,0x65,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x44
	.DB  0x61,0x74,0x61,0x0,0x36,0x3A,0x20,0x54
	.DB  0x72,0x61,0x66,0x66,0x69,0x63,0x20,0x4D
	.DB  0x6F,0x6E,0x69,0x74,0x6F,0x72,0x69,0x6E
	.DB  0x67,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x18
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x19
	.DW  _0xA+24
	.DW  _0x0*2+24

	.DW  0x19
	.DW  _0xA+49
	.DW  _0x0*2+49

	.DW  0x16
	.DW  _0xA+74
	.DW  _0x0*2+74

	.DW  0x18
	.DW  _0xA+96
	.DW  _0x0*2+96

	.DW  0x16
	.DW  _0xA+120
	.DW  _0x0*2+120

	.DW  0x18
	.DW  _0xA+142
	.DW  _0x0*2+142

	.DW  0x13
	.DW  _0xA+166
	.DW  _0x0*2+166

	.DW  0x19
	.DW  _0xA+185
	.DW  _0x0*2+185

	.DW  0x1F
	.DW  _0xA+210
	.DW  _0x0*2+210

	.DW  0x14
	.DW  _0x49
	.DW  _0x0*2+241

	.DW  0x03
	.DW  _0x49+20
	.DW  _0x0*2+261

	.DW  0x1E
	.DW  _0x49+23
	.DW  _0x0*2+264

	.DW  0x1F
	.DW  _0x49+53
	.DW  _0x0*2+294

	.DW  0x1F
	.DW  _0x49+84
	.DW  _0x0*2+325

	.DW  0x1F
	.DW  _0x49+115
	.DW  _0x0*2+294

	.DW  0x20
	.DW  _0x49+146
	.DW  _0x0*2+356

	.DW  0x1F
	.DW  _0x49+178
	.DW  _0x0*2+388

	.DW  0x13
	.DW  _0x49+209
	.DW  _0x0*2+419

	.DW  0x1F
	.DW  _0x49+228
	.DW  _0x0*2+294

	.DW  0x1D
	.DW  _0x49+259
	.DW  _0x0*2+438

	.DW  0x1F
	.DW  _0x49+288
	.DW  _0x0*2+294

	.DW  0x09
	.DW  _0x7F
	.DW  _0x0*2+467

	.DW  0x1D
	.DW  _0x87
	.DW  _0x0*2+476

	.DW  0x16
	.DW  _0x87+29
	.DW  _0x0*2+505

	.DW  0x1A
	.DW  _0x87+51
	.DW  _0x0*2+527

	.DW  0x1A
	.DW  _0x87+77
	.DW  _0x0*2+553

	.DW  0x19
	.DW  _0x87+103
	.DW  _0x0*2+579

	.DW  0x16
	.DW  _0x87+128
	.DW  _0x0*2+604

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
	.ORG 0x260

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
;
;#define LCD_PRT PORTB // LCD DATA PORT
;#define LCD_DDR DDRB  // LCD DATA DDR
;#define LCD_PIN PINB  // LCD DATA PIN
;#define LCD_RS 0      // LCD RS
;#define LCD_RW 1      // LCD RW
;#define LCD_EN 2      // LCD EN
;#define KEY_PRT PORTC // keyboard PORT
;#define KEY_DDR DDRC  // keyboard DDR
;#define KEY_PIN PINC  // keyboard PIN
;
;void lcdCommand(unsigned char cmnd);
;void lcdData(unsigned char data);
;void lcd_init();
;void lcd_gotoxy(unsigned char x, unsigned char y);
;void lcd_print(char *str);
;void LCM35_init();
;void show_temp();
;void show_menu();
;void clear_eeprom();
;unsigned char read_byte_from_eeprom(unsigned int addr);
;void write_byte_to_eeprom(unsigned int addr, unsigned char value);
;void USART_init(unsigned int ubrr);
;void USART_Transmit(unsigned char data);
;int search_student_code();
;
;/* keypad mapping :
;C : Cancel
;O : On/Clear
;D : Delete
;L : Left
;R : Right
;E : Enter  */
;unsigned char keypad[4][4] = {'7', '8', '9', 'O',
;                              '4', '5', '6', 'D',
;                              '1', '2', '3', 'C',
;                              'L', '0', 'R', 'E'};

	.DSEG
;
;unsigned int stage = 0;
;char buffer[32] = "";
;
;enum stages
;{
;    STAGE_INIT_MENU,
;    STAGE_ATTENDENC_MENU,
;    STAGE_SUBMIT_CODE,
;    STAGE_TEMPERATURE_MONITORING,
;    STAGE_VIEW_PRESENT_STUDENTS,
;    STAGE_RETRIEVE_STUDENT_DATA,
;    STAGE_STUDENT_MANAGMENT,
;    STAGE_SEARCH_STUDENT,
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
;};
;
;void main(void)
; 0000 0047 {

	.CSEG
_main:
; .FSTART _main
; 0000 0048     int i, j;
; 0000 0049     unsigned char st_counts;
; 0000 004A     KEY_DDR = 0xF0;
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 004B     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 004C     KEY_PRT &= 0x0F;    // ground all rows at once
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 004D     MCUCR = 0x02;       // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 004E     GICR = (1 << INT0); // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 004F     lcd_init();
	RCALL _lcd_init
; 0000 0050     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	RCALL _USART_init
; 0000 0051 
; 0000 0052 #asm("sei")           // enable interrupts
	sei
; 0000 0053     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0054     LCM35_init();
	RCALL _LCM35_init
; 0000 0055     while (1)
_0x4:
; 0000 0056     {
; 0000 0057         if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x7
; 0000 0058         {
; 0000 0059             show_menu();
	RCALL _show_menu
; 0000 005A         }
; 0000 005B         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x8
_0x7:
	CALL SUBOPT_0x0
	BRNE _0x9
; 0000 005C         {
; 0000 005D             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 005E             lcd_gotoxy(1, 1);
; 0000 005F             lcd_print("1 : Submit Student Code");
	__POINTW2MN _0xA,0
	CALL SUBOPT_0x2
; 0000 0060             lcd_gotoxy(1, 2);
; 0000 0061             lcd_print("    press cancel to back");
	__POINTW2MN _0xA,24
	RCALL _lcd_print
; 0000 0062             while (stage == STAGE_ATTENDENC_MENU)
_0xB:
	CALL SUBOPT_0x0
	BREQ _0xB
; 0000 0063                 ;
; 0000 0064         }
; 0000 0065         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0xE
_0x9:
	CALL SUBOPT_0x3
	BRNE _0xF
; 0000 0066         {
; 0000 0067             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0068             lcd_gotoxy(1, 1);
; 0000 0069             lcd_print("Enter your student code:");
	__POINTW2MN _0xA,49
	CALL SUBOPT_0x2
; 0000 006A             lcd_gotoxy(1, 2);
; 0000 006B             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 006C             delay_us(100 * 16); // wait
; 0000 006D             while (stage == STAGE_SUBMIT_CODE)
_0x10:
	CALL SUBOPT_0x3
	BREQ _0x10
; 0000 006E                 ;
; 0000 006F             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0xA5
; 0000 0070             delay_us(100 * 16); // wait
; 0000 0071         }
; 0000 0072         else if (stage == STAGE_TEMPERATURE_MONITORING)
_0xF:
	CALL SUBOPT_0x5
	BRNE _0x14
; 0000 0073         {
; 0000 0074             show_temp();
	RCALL _show_temp
; 0000 0075         }
; 0000 0076         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x15
_0x14:
	CALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x16
; 0000 0077         {
; 0000 0078             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0079             lcd_gotoxy(1, 1);
; 0000 007A             lcd_print("Number of students : ");
	__POINTW2MN _0xA,74
	CALL SUBOPT_0x2
; 0000 007B             lcd_gotoxy(1, 2);
; 0000 007C             st_counts = read_byte_from_eeprom(0x0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _read_byte_from_eeprom
	MOV  R21,R30
; 0000 007D             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 007E             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	CALL SUBOPT_0x8
	CALL _itoa
; 0000 007F             lcd_print(buffer);
	CALL SUBOPT_0x9
; 0000 0080             delay_ms(1000);
; 0000 0081 
; 0000 0082             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x18:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x19
; 0000 0083             {
; 0000 0084                 memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0085                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x1B:
	__CPWRN 18,19,8
	BRGE _0x1C
; 0000 0086                 {
; 0000 0087                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0088                 }
	__ADDWRN 18,19,1
	RJMP _0x1B
_0x1C:
; 0000 0089                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 008A                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 008B                 lcd_gotoxy(1, 1);
; 0000 008C                 lcd_print(buffer);
	CALL SUBOPT_0x9
; 0000 008D                 delay_ms(1000);
; 0000 008E             }
	__ADDWRN 16,17,1
	RJMP _0x18
_0x19:
; 0000 008F 
; 0000 0090             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0091             lcd_gotoxy(1, 1);
; 0000 0092             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xA,96
	RCALL _lcd_print
; 0000 0093             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x1D:
	CALL SUBOPT_0x6
	BREQ _0x1D
; 0000 0094                 ;
; 0000 0095         }
; 0000 0096         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x20
_0x16:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x21
; 0000 0097         {
; 0000 0098             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0099             lcd_gotoxy(1, 1);
; 0000 009A             lcd_print("Start Transferring...");
	__POINTW2MN _0xA,120
	RCALL _lcd_print
; 0000 009B             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xB
	MOV  R21,R30
; 0000 009C             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x23:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x24
; 0000 009D             {
; 0000 009E                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x26:
	__CPWRN 18,19,8
	BRGE _0x27
; 0000 009F                 {
; 0000 00A0                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0xA
	MOV  R26,R30
	RCALL _USART_Transmit
; 0000 00A1                 }
	__ADDWRN 18,19,1
	RJMP _0x26
_0x27:
; 0000 00A2                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0000 00A3                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0000 00A4                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0000 00A5 
; 0000 00A6 
; 0000 00A7 
; 0000 00A8                 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 00A9             }
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
; 0000 00AA             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00AB             lcd_gotoxy(1, 1);
; 0000 00AC             lcd_print("Usart Transmit finished");
	__POINTW2MN _0xA,142
	RCALL _lcd_print
; 0000 00AD             delay_ms(2000);
	CALL SUBOPT_0xC
; 0000 00AE             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 00AF         }
; 0000 00B0         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x28
_0x21:
	CALL SUBOPT_0xD
	BRNE _0x29
; 0000 00B1         {
; 0000 00B2             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00B3             lcd_gotoxy(1, 1);
; 0000 00B4             lcd_print("1 : Search Student");
	__POINTW2MN _0xA,166
	CALL SUBOPT_0x2
; 0000 00B5             lcd_gotoxy(1, 2);
; 0000 00B6             lcd_print("    Press Cancel To Back");
	__POINTW2MN _0xA,185
	RCALL _lcd_print
; 0000 00B7             while (stage == STAGE_STUDENT_MANAGMENT)
_0x2A:
	CALL SUBOPT_0xD
	BREQ _0x2A
; 0000 00B8                 ;
; 0000 00B9         }
; 0000 00BA         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x2D
_0x29:
	CALL SUBOPT_0xE
	BRNE _0x2E
; 0000 00BB         {
; 0000 00BC             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00BD             lcd_gotoxy(1, 1);
; 0000 00BE             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xA,210
	CALL SUBOPT_0x2
; 0000 00BF             lcd_gotoxy(1, 2);
; 0000 00C0             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 00C1             delay_us(100 * 16); // wait
; 0000 00C2             while (stage == STAGE_SEARCH_STUDENT)
_0x2F:
	CALL SUBOPT_0xE
	BREQ _0x2F
; 0000 00C3                 ;
; 0000 00C4             lcdCommand(0x0c);   // display on, cursor off
_0xA5:
	LDI  R26,LOW(12)
	CALL SUBOPT_0xF
; 0000 00C5             delay_us(100 * 16); // wait
; 0000 00C6         }
; 0000 00C7     }
_0x2E:
_0x2D:
_0x28:
_0x20:
_0x15:
_0xE:
_0x8:
	RJMP _0x4
; 0000 00C8 }
_0x32:
	RJMP _0x32
; .FEND

	.DSEG
_0xA:
	.BYTE 0xF1
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 00CC {

	.CSEG
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
; 0000 00CD     unsigned char colloc, rowloc, cl, st_counts;
; 0000 00CE     int i;
; 0000 00CF 
; 0000 00D0     // detect the key
; 0000 00D1     while (1)
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	i -> R20,R21
; 0000 00D2     {
; 0000 00D3         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x10
; 0000 00D4         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 00D5         if (colloc != 0x0F)        // column detected
	BREQ _0x36
; 0000 00D6         {
; 0000 00D7             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 00D8             break;      // exit while loop
	RJMP _0x35
; 0000 00D9         }
; 0000 00DA         KEY_PRT = 0xDF;            // ground row 1
_0x36:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x10
; 0000 00DB         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 00DC         if (colloc != 0x0F)        // column detected
	BREQ _0x37
; 0000 00DD         {
; 0000 00DE             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 00DF             break;      // exit while loop
	RJMP _0x35
; 0000 00E0         }
; 0000 00E1         KEY_PRT = 0xBF;            // ground row 2
_0x37:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x10
; 0000 00E2         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 00E3         if (colloc != 0x0F)        // column detected
	BREQ _0x38
; 0000 00E4         {
; 0000 00E5             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 00E6             break;      // exit while loop
	RJMP _0x35
; 0000 00E7         }
; 0000 00E8         KEY_PRT = 0x7F;            // ground row 3
_0x38:
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 00E9         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 00EA         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 00EB         break;                     // exit while loop
; 0000 00EC     }
_0x35:
; 0000 00ED     // check column and send result to Port D
; 0000 00EE     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x39
; 0000 00EF         cl = 0;
	LDI  R19,LOW(0)
; 0000 00F0     else if (colloc == 0x0D)
	RJMP _0x3A
_0x39:
	CPI  R17,13
	BRNE _0x3B
; 0000 00F1         cl = 1;
	LDI  R19,LOW(1)
; 0000 00F2     else if (colloc == 0x0B)
	RJMP _0x3C
_0x3B:
	CPI  R17,11
	BRNE _0x3D
; 0000 00F3         cl = 2;
	LDI  R19,LOW(2)
; 0000 00F4     else
	RJMP _0x3E
_0x3D:
; 0000 00F5         cl = 3;
	LDI  R19,LOW(3)
; 0000 00F6 
; 0000 00F7     KEY_PRT &= 0x0F; // ground all rows at once
_0x3E:
_0x3C:
_0x3A:
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 00F8 
; 0000 00F9     // inside menu level 1
; 0000 00FA     if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x3F
; 0000 00FB     {
; 0000 00FC         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x11
	SBIW R30,48
; 0000 00FD         {
; 0000 00FE         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x43
; 0000 00FF             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0100             break;
	RJMP _0x42
; 0000 0101 
; 0000 0102         case OPTION_TEMPERATURE_MONITORING:
_0x43:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x44
; 0000 0103             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0104             break;
	RJMP _0x42
; 0000 0105         case OPTION_VIEW_PRESENT_STUDENTS:
_0x44:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x45
; 0000 0106             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 0107             break;
	RJMP _0x42
; 0000 0108         case OPTION_RETRIEVE_STUDENT_DATA:
_0x45:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x46
; 0000 0109             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 010A             break;
	RJMP _0x42
; 0000 010B         case OPTION_STUDENT_MANAGEMENT:
_0x46:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x47
; 0000 010C             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 010D             break;
	RJMP _0x42
; 0000 010E         case 9:
_0x47:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x4A
; 0000 010F #asm("cli") // disable interrupts
	cli
; 0000 0110 
; 0000 0111             lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 0112             lcd_gotoxy(1, 1);
; 0000 0113             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x49,0
	RCALL _lcd_print
; 0000 0114             clear_eeprom();
	RCALL _clear_eeprom
; 0000 0115 #asm("sei") // enable interrupts
	sei
; 0000 0116 
; 0000 0117         default:
_0x4A:
; 0000 0118             break;
; 0000 0119         }
_0x42:
; 0000 011A     }
; 0000 011B     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x4B
_0x3F:
	CALL SUBOPT_0x0
	BRNE _0x4C
; 0000 011C     {
; 0000 011D         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x11
; 0000 011E         {
; 0000 011F         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x50
; 0000 0120             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0121             break;
	RJMP _0x4F
; 0000 0122         case '1':
_0x50:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x52
; 0000 0123             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0124             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0125             break;
; 0000 0126         default:
_0x52:
; 0000 0127             break;
; 0000 0128         }
_0x4F:
; 0000 0129     }
; 0000 012A     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x53
_0x4C:
	CALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x54
; 0000 012B     {
; 0000 012C 
; 0000 012D         if ((keypad[rowloc][cl] - '0') < 10)
	CALL SUBOPT_0x11
	SBIW R30,58
	BRGE _0x55
; 0000 012E         {
; 0000 012F             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x12
	SBIW R30,31
	BRSH _0x56
; 0000 0130             {
; 0000 0131                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 0132                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x14
; 0000 0133                 lcdData(keypad[rowloc][cl]);
; 0000 0134             }
; 0000 0135         }
_0x56:
; 0000 0136         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x57
_0x55:
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0x58
; 0000 0137         {
; 0000 0138 
; 0000 0139             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 013A                 strlen(buffer) != 8)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x49,20
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x5A
	CALL SUBOPT_0x12
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x59
_0x5A:
; 0000 013B             {
; 0000 013C                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 013D                 lcd_gotoxy(1, 1);
; 0000 013E                 lcd_print("Incorrect Suudent Code Format");
	__POINTW2MN _0x49,23
	CALL SUBOPT_0x2
; 0000 013F                 lcd_gotoxy(1, 2);
; 0000 0140                 lcd_print("You Will Back Menu In 5 Second");
	__POINTW2MN _0x49,53
	RCALL _lcd_print
; 0000 0141                 delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RJMP _0xA6
; 0000 0142             }
; 0000 0143             else if (search_student_code())
_0x59:
	RCALL _search_student_code
	SBIW R30,0
	BREQ _0x5D
; 0000 0144             {
; 0000 0145                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0146                 lcd_gotoxy(1, 1);
; 0000 0147                 lcd_print("Duplicate Suudent Code Entered");
	__POINTW2MN _0x49,84
	CALL SUBOPT_0x2
; 0000 0148                 lcd_gotoxy(1, 2);
; 0000 0149                 lcd_print("You Will Back Menu In 5 Second");
	__POINTW2MN _0x49,115
	RCALL _lcd_print
; 0000 014A                 delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RJMP _0xA6
; 0000 014B             }
; 0000 014C             else
_0x5D:
; 0000 014D             {
; 0000 014E                 // save the buffer to EEPROM
; 0000 014F                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xB
	MOV  R18,R30
; 0000 0150                 for (i = 0; i < 8; i++)
	__GETWRN 20,21,0
_0x60:
	__CPWRN 20,21,8
	BRGE _0x61
; 0000 0151                 {
; 0000 0152                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R18
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R20
	ADC  R31,R21
	CALL SUBOPT_0x8
	ADD  R26,R20
	ADC  R27,R21
	LD   R26,X
	RCALL _write_byte_to_eeprom
; 0000 0153                 }
	__ADDWRN 20,21,1
	RJMP _0x60
_0x61:
; 0000 0154                 write_byte_to_eeprom(0x0, st_counts + 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0155 
; 0000 0156                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0157                 lcd_gotoxy(1, 1);
; 0000 0158                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x49,146
	CALL SUBOPT_0x2
; 0000 0159                 lcd_gotoxy(1, 2);
; 0000 015A                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x49,178
	RCALL _lcd_print
; 0000 015B                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
_0xA6:
	CALL _delay_ms
; 0000 015C             }
; 0000 015D             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 015E 
; 0000 015F             stage = STAGE_ATTENDENC_MENU;
	RJMP _0xA7
; 0000 0160         }
; 0000 0161         else if (keypad[rowloc][cl] == 'C')
_0x58:
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x43)
	BRNE _0x63
; 0000 0162             stage = STAGE_ATTENDENC_MENU;
_0xA7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0163     }
_0x63:
_0x57:
; 0000 0164     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x64
_0x54:
	CALL SUBOPT_0x5
	BRNE _0x65
; 0000 0165     {
; 0000 0166 
; 0000 0167         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x43)
	BRNE _0x66
; 0000 0168             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0169     }
_0x66:
; 0000 016A     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x67
_0x65:
	CALL SUBOPT_0x6
	BRNE _0x68
; 0000 016B     {
; 0000 016C         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x43)
	BRNE _0x69
; 0000 016D             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 016E     }
_0x69:
; 0000 016F     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x6A
_0x68:
	CALL SUBOPT_0xD
	BRNE _0x6B
; 0000 0170     {
; 0000 0171         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x43)
	BRNE _0x6C
; 0000 0172             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0173         else if (keypad[rowloc][cl] == '1')
	RJMP _0x6D
_0x6C:
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x31)
	BRNE _0x6E
; 0000 0174             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 0175     }
_0x6E:
_0x6D:
; 0000 0176     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x6F
_0x6B:
	CALL SUBOPT_0xE
	BREQ PC+2
	RJMP _0x70
; 0000 0177     {
; 0000 0178         if ((keypad[rowloc][cl] - '0') < 10)
	CALL SUBOPT_0x11
	SBIW R30,58
	BRGE _0x71
; 0000 0179         {
; 0000 017A             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x12
	SBIW R30,31
	BRSH _0x72
; 0000 017B             {
; 0000 017C                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 017D                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x14
; 0000 017E                 lcdData(keypad[rowloc][cl]);
; 0000 017F             }
; 0000 0180         }
_0x72:
; 0000 0181         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x73
_0x71:
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x45)
	BRNE _0x74
; 0000 0182         {
; 0000 0183             // search from eeprom data
; 0000 0184             int result = search_student_code();
; 0000 0185 
; 0000 0186             if (result == 1)
	SBIW R28,2
;	result -> Y+0
	RCALL _search_student_code
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x75
; 0000 0187             {
; 0000 0188                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0189                 lcd_gotoxy(1, 1);
; 0000 018A                 lcd_print("Student Code Found");
	__POINTW2MN _0x49,209
	CALL SUBOPT_0x2
; 0000 018B                 lcd_gotoxy(1, 2);
; 0000 018C                 lcd_print("You Will Back Menu In 5 Second");
	__POINTW2MN _0x49,228
	RJMP _0xA8
; 0000 018D                 delay_ms(5000);
; 0000 018E             }
; 0000 018F             else
_0x75:
; 0000 0190             {
; 0000 0191                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0192                 lcd_gotoxy(1, 1);
; 0000 0193                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x49,259
	CALL SUBOPT_0x2
; 0000 0194                 lcd_gotoxy(1, 2);
; 0000 0195                 lcd_print("You Will Back Menu In 5 Second");
	__POINTW2MN _0x49,288
_0xA8:
	RCALL _lcd_print
; 0000 0196                 delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0197             }
; 0000 0198             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0199             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 019A         }
	ADIW R28,2
; 0000 019B         else if (keypad[rowloc][cl] == 'C')
	RJMP _0x77
_0x74:
	CALL SUBOPT_0x15
	CPI  R26,LOW(0x43)
	BRNE _0x78
; 0000 019C             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 019D     }
_0x78:
_0x77:
_0x73:
; 0000 019E }
_0x70:
_0x6F:
_0x6A:
_0x67:
_0x64:
_0x53:
_0x4B:
	CALL __LOADLOCR6
	ADIW R28,6
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
_0x49:
	.BYTE 0x13F
;
;void lcdCommand(unsigned char cmnd)
; 0000 01A1 {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 01A2     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x16
;	cmnd -> Y+0
; 0000 01A3     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x18,0
; 0000 01A4     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x17
; 0000 01A5     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 01A6     delay_us(1 * 16);          // wait to make EN wider
; 0000 01A7     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 01A8     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 01A9     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x18
; 0000 01AA     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 01AB     delay_us(1 * 16);          // wait to make EN wider
; 0000 01AC     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 01AD }
	RJMP _0x20A0002
; .FEND
;void lcdData(unsigned char data)
; 0000 01AF {
_lcdData:
; .FSTART _lcdData
; 0000 01B0     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x16
;	data -> Y+0
; 0000 01B1     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x18,0
; 0000 01B2     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x17
; 0000 01B3     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 01B4     delay_us(1 * 16);          // wait to make EN wider
; 0000 01B5     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 01B6     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x18
; 0000 01B7     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 01B8     delay_us(1 * 16);          // wait to make EN wider
; 0000 01B9     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 01BA }
	RJMP _0x20A0002
; .FEND
;void lcd_init()
; 0000 01BC {
_lcd_init:
; .FSTART _lcd_init
; 0000 01BD     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 01BE     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x18,2
; 0000 01BF     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 01C0     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0xF
; 0000 01C1     delay_us(100 * 16);        // wait
; 0000 01C2     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0xF
; 0000 01C3     delay_us(100 * 16);        // wait
; 0000 01C4     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0xF
; 0000 01C5     delay_us(100 * 16);        // wait
; 0000 01C6     lcdCommand(0x0c);          // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0xF
; 0000 01C7     delay_us(100 * 16);        // wait
; 0000 01C8     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 01C9     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 01CA     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0xF
; 0000 01CB     delay_us(100 * 16);
; 0000 01CC }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 01CE {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 01CF     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 01D0     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0xF
; 0000 01D1     delay_us(100 * 16);
; 0000 01D2 }
	ADIW R28,6
	RET
; .FEND
;void lcd_print(char *str)
; 0000 01D4 {
_lcd_print:
; .FSTART _lcd_print
; 0000 01D5     unsigned char i = 0;
; 0000 01D6     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x79:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x7B
; 0000 01D7     {
; 0000 01D8         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 01D9         i++;
	SUBI R17,-1
; 0000 01DA     }
	RJMP _0x79
_0x7B:
; 0000 01DB }
	LDD  R17,Y+0
	RJMP _0x20A0003
; .FEND
;
;void LCM35_init()
; 0000 01DE {
_LCM35_init:
; .FSTART _LCM35_init
; 0000 01DF     ADMUX = 0xE0;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 01E0     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 01E1 }
	RET
; .FEND
;
;void show_temp()
; 0000 01E4 {
_show_temp:
; .FSTART _show_temp
; 0000 01E5     unsigned char temperatureVal = 0;
; 0000 01E6     unsigned char temperatureRep[3];
; 0000 01E7 
; 0000 01E8     while (stage == STAGE_TEMPERATURE_MONITORING)
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
_0x7C:
	CALL SUBOPT_0x5
	BRNE _0x7E
; 0000 01E9     {
; 0000 01EA         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01EB         lcd_gotoxy(1, 1);
; 0000 01EC         lcd_print("Temp(C):");
	__POINTW2MN _0x7F,0
	RCALL _lcd_print
; 0000 01ED         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 01EE         while ((ADCSRA & (1 << ADIF)) == 0)
_0x80:
	SBIS 0x6,4
; 0000 01EF             ;
	RJMP _0x80
; 0000 01F0         temperatureVal = ADCH;
	IN   R17,5
; 0000 01F1         itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 01F2         lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 01F3         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 01F4     }
	RJMP _0x7C
_0x7E:
; 0000 01F5 }
	LDD  R17,Y+0
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x7F:
	.BYTE 0x9
;
;void show_menu()
; 0000 01F8 {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 01F9     unsigned char page_num = 0;
; 0000 01FA     while (stage == STAGE_INIT_MENU)
	ST   -Y,R17
;	page_num -> R17
	LDI  R17,0
_0x83:
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x85
; 0000 01FB     {
; 0000 01FC         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01FD         lcd_gotoxy(1, 1);
; 0000 01FE         if (page_num == 0)
	CPI  R17,0
	BRNE _0x86
; 0000 01FF         {
; 0000 0200             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0x87,0
	CALL SUBOPT_0x2
; 0000 0201             lcd_gotoxy(1, 2);
; 0000 0202             lcd_print("2: Student Management");
	__POINTW2MN _0x87,29
	CALL SUBOPT_0x19
; 0000 0203             if (stage == STAGE_INIT_MENU)
	BRNE _0x88
; 0000 0204                 delay_ms(2000);
	CALL SUBOPT_0xC
; 0000 0205             page_num = (page_num + 1) % 3;
_0x88:
	RJMP _0xA9
; 0000 0206         }
; 0000 0207         else if (page_num == 1)
_0x86:
	CPI  R17,1
	BRNE _0x8A
; 0000 0208         {
; 0000 0209             lcd_print("3: View Present Students ");
	__POINTW2MN _0x87,51
	CALL SUBOPT_0x2
; 0000 020A             lcd_gotoxy(1, 2);
; 0000 020B             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0x87,77
	CALL SUBOPT_0x19
; 0000 020C             if (stage == STAGE_INIT_MENU)
	BRNE _0x8B
; 0000 020D                 delay_ms(2000);
	CALL SUBOPT_0xC
; 0000 020E             page_num = (page_num + 1) % 3;
_0x8B:
	RJMP _0xA9
; 0000 020F         }
; 0000 0210         else if (page_num == 2)
_0x8A:
	CPI  R17,2
	BRNE _0x8D
; 0000 0211         {
; 0000 0212             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0x87,103
	CALL SUBOPT_0x2
; 0000 0213             lcd_gotoxy(1, 2);
; 0000 0214             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0x87,128
	CALL SUBOPT_0x19
; 0000 0215             if (stage == STAGE_INIT_MENU)
	BRNE _0x8E
; 0000 0216                 delay_ms(2000);
	CALL SUBOPT_0xC
; 0000 0217             page_num = (page_num + 1) % 3;
_0x8E:
_0xA9:
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	MOV  R17,R30
; 0000 0218         }
; 0000 0219     }
_0x8D:
	RJMP _0x83
_0x85:
; 0000 021A }
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x87:
	.BYTE 0x96
;
;void clear_eeprom()
; 0000 021D {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 021E     unsigned int i;
; 0000 021F     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x90:
	__CPWRN 16,17,1024
	BRSH _0x91
; 0000 0220     {
; 0000 0221         // Wait for the previous write to complete
; 0000 0222         while (EECR & (1 << EEWE))
_0x92:
	SBIC 0x1C,1
; 0000 0223             ;
	RJMP _0x92
; 0000 0224 
; 0000 0225         // Set up address registers
; 0000 0226         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 0227         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 0228 
; 0000 0229         // Set up data register
; 0000 022A         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 022B 
; 0000 022C         // Enable write
; 0000 022D         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 022E         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 022F     }
	__ADDWRN 16,17,1
	RJMP _0x90
_0x91:
; 0000 0230 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 0233 {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 0234     unsigned char x;
; 0000 0235     // Wait for the previous write to complete
; 0000 0236     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x95:
	SBIC 0x1C,1
; 0000 0237         ;
	RJMP _0x95
; 0000 0238 
; 0000 0239     // Set up address registers
; 0000 023A     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x1A
; 0000 023B     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 023C     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 023D     x = EEDR;
	IN   R17,29
; 0000 023E     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0003
; 0000 023F }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 0242 {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 0243     // Wait for the previous write to complete
; 0000 0244     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x98:
	SBIC 0x1C,1
; 0000 0245         ;
	RJMP _0x98
; 0000 0246 
; 0000 0247     // Set up address registers
; 0000 0248     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x1A
; 0000 0249     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 024A 
; 0000 024B     // Set up data register
; 0000 024C     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 024D 
; 0000 024E     // Enable write
; 0000 024F     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 0250     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0251 }
_0x20A0003:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 0254 {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 0255     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x9B:
	SBIS 0xB,5
; 0000 0256         ;
	RJMP _0x9B
; 0000 0257     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0258 }
_0x20A0002:
	ADIW R28,1
	RET
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 025B {
_USART_init:
; .FSTART _USART_init
; 0000 025C     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 025D     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 025E     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 025F     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 0260 }
	ADIW R28,2
	RET
; .FEND
;
;int search_student_code()
; 0000 0263 {
_search_student_code:
; .FSTART _search_student_code
; 0000 0264     unsigned char st_counts, i, j;
; 0000 0265     char temp[32];
; 0000 0266 
; 0000 0267     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,32
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0xB
	MOV  R17,R30
; 0000 0268 
; 0000 0269     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x9F:
	CP   R16,R17
	BRSH _0xA0
; 0000 026A     {
; 0000 026B         memset(temp, 0, 32);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(32)
	LDI  R27,0
	CALL _memset
; 0000 026C         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0xA2:
	CPI  R19,8
	BRSH _0xA3
; 0000 026D         {
; 0000 026E             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
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
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 026F         }
	SUBI R19,-1
	RJMP _0xA2
_0xA3:
; 0000 0270         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0271         if (strcmp(temp, buffer) == 0)
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x8
	CALL _strcmp
	CPI  R30,0
	BRNE _0xA4
; 0000 0272             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20A0001
; 0000 0273     }
_0xA4:
	SUBI R16,-1
	RJMP _0x9F
_0xA0:
; 0000 0274 
; 0000 0275     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,36
	RET
; 0000 0276 }
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
	ADIW R28,5
	RET
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

	.CSEG

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x10
_buffer:
	.BYTE 0x20
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	CALL _lcdCommand
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x2:
	CALL _lcd_print
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(15)
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(32)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_print
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xF:
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x11:
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
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x13:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
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
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x14:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
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
	LD   R26,X
	JMP  _lcdData

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x15:
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
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CBI  0x18,1
	SBI  0x18,2
	__DELAY_USB 43
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x18,R30
	SBI  0x18,2
	__DELAY_USB 43
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL _lcd_print
	MOV  R0,R4
	OR   R0,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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
