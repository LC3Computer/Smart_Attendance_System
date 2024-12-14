
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
	.DEF _page_num=R7
	.DEF _US_count=R6
	.DEF _logged_in=R9

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
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x37,0x38,0x39,0x4F,0x34,0x35,0x36,0x44
	.DB  0x31,0x32,0x33,0x43,0x4C,0x30,0x52,0x45
_0x4:
	.DB  0x64,0xF
_0x125:
	.DB  0xFF,0xFF
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
	.DB  0x73,0x6D,0x69,0x74,0x20,0x46,0x69,0x6E
	.DB  0x69,0x73,0x68,0x65,0x64,0x0,0x31,0x3A
	.DB  0x20,0x53,0x65,0x61,0x72,0x63,0x68,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x0
	.DB  0x32,0x3A,0x20,0x44,0x65,0x6C,0x65,0x74
	.DB  0x65,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x46,0x6F,0x72
	.DB  0x20,0x53,0x65,0x61,0x72,0x63,0x68,0x3A
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x46,0x6F,0x72,0x20
	.DB  0x44,0x65,0x6C,0x65,0x74,0x65,0x3A,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x53,0x65
	.DB  0x63,0x72,0x65,0x74,0x20,0x43,0x6F,0x64
	.DB  0x65,0x20,0x28,0x6F,0x72,0x20,0x63,0x61
	.DB  0x6E,0x63,0x65,0x6C,0x29,0x0,0x31,0x20
	.DB  0x3A,0x20,0x43,0x6C,0x65,0x61,0x72,0x20
	.DB  0x45,0x45,0x50,0x52,0x4F,0x4D,0x0,0x4C
	.DB  0x6F,0x67,0x6F,0x75,0x74,0x20,0x2E,0x2E
	.DB  0x2E,0x0,0x47,0x6F,0x69,0x6E,0x67,0x20
	.DB  0x54,0x6F,0x20,0x41,0x64,0x6D,0x69,0x6E
	.DB  0x20,0x50,0x61,0x67,0x65,0x20,0x49,0x6E
	.DB  0x20,0x32,0x20,0x53,0x65,0x63,0x0,0x34
	.DB  0x30,0x0,0x49,0x6E,0x63,0x6F,0x72,0x72
	.DB  0x65,0x63,0x74,0x20,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x46,0x6F,0x72,0x6D,0x61,0x74,0x0
	.DB  0x59,0x6F,0x75,0x20,0x57,0x69,0x6C,0x6C
	.DB  0x20,0x42,0x61,0x63,0x6B,0x20,0x4D,0x65
	.DB  0x6E,0x75,0x20,0x49,0x6E,0x20,0x32,0x20
	.DB  0x53,0x65,0x63,0x6F,0x6E,0x64,0x0,0x44
	.DB  0x75,0x70,0x6C,0x69,0x63,0x61,0x74,0x65
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x45,0x6E
	.DB  0x74,0x65,0x72,0x65,0x64,0x0,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x20,0x53,0x75,0x63,0x63,0x65
	.DB  0x73,0x73,0x66,0x75,0x6C,0x6C,0x79,0x20
	.DB  0x41,0x64,0x64,0x65,0x64,0x0,0x59,0x6F
	.DB  0x75,0x20,0x4D,0x75,0x73,0x74,0x20,0x46
	.DB  0x69,0x72,0x73,0x74,0x20,0x4C,0x6F,0x67
	.DB  0x69,0x6E,0x0,0x59,0x6F,0x75,0x20,0x57
	.DB  0x69,0x6C,0x6C,0x20,0x47,0x6F,0x20,0x41
	.DB  0x64,0x6D,0x69,0x6E,0x20,0x50,0x61,0x67
	.DB  0x65,0x20,0x32,0x20,0x53,0x65,0x63,0x0
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x46,0x6F,0x75
	.DB  0x6E,0x64,0x0,0x4F,0x70,0x73,0x20,0x2C
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x4E,0x6F
	.DB  0x74,0x20,0x46,0x6F,0x75,0x6E,0x64,0x0
	.DB  0x57,0x61,0x69,0x74,0x20,0x46,0x6F,0x72
	.DB  0x20,0x44,0x65,0x6C,0x65,0x74,0x65,0x2E
	.DB  0x2E,0x2E,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x57,0x61,0x73,0x20,0x44,0x65,0x6C,0x65
	.DB  0x74,0x65,0x64,0x0,0x4C,0x6F,0x67,0x69
	.DB  0x6E,0x20,0x53,0x75,0x63,0x63,0x65,0x73
	.DB  0x73,0x66,0x75,0x6C,0x6C,0x79,0x0,0x57
	.DB  0x61,0x69,0x74,0x2E,0x2E,0x2E,0x0,0x4F
	.DB  0x70,0x73,0x20,0x2C,0x20,0x73,0x65,0x63
	.DB  0x72,0x65,0x74,0x20,0x69,0x73,0x20,0x69
	.DB  0x6E,0x63,0x6F,0x72,0x72,0x65,0x63,0x74
	.DB  0x0,0x43,0x6C,0x65,0x61,0x72,0x69,0x6E
	.DB  0x67,0x20,0x45,0x45,0x50,0x52,0x4F,0x4D
	.DB  0x20,0x2E,0x2E,0x2E,0x0,0x74,0x65,0x6D
	.DB  0x70,0x65,0x72,0x61,0x74,0x75,0x72,0x65
	.DB  0x28,0x43,0x29,0x3A,0x0,0x31,0x3A,0x20
	.DB  0x41,0x74,0x74,0x65,0x6E,0x64,0x61,0x6E
	.DB  0x63,0x65,0x20,0x49,0x6E,0x69,0x74,0x69
	.DB  0x61,0x6C,0x69,0x7A,0x61,0x74,0x69,0x6F
	.DB  0x6E,0x0,0x32,0x3A,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x4D,0x61,0x6E
	.DB  0x61,0x67,0x65,0x6D,0x65,0x6E,0x74,0x0
	.DB  0x33,0x3A,0x20,0x56,0x69,0x65,0x77,0x20
	.DB  0x50,0x72,0x65,0x73,0x65,0x6E,0x74,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x73
	.DB  0x20,0x0,0x34,0x3A,0x20,0x54,0x65,0x6D
	.DB  0x70,0x65,0x72,0x61,0x74,0x75,0x72,0x65
	.DB  0x20,0x4D,0x6F,0x6E,0x69,0x74,0x6F,0x72
	.DB  0x69,0x6E,0x67,0x0,0x35,0x3A,0x20,0x52
	.DB  0x65,0x74,0x72,0x69,0x65,0x76,0x65,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x44,0x61,0x74,0x61,0x0,0x36,0x3A,0x20
	.DB  0x54,0x72,0x61,0x66,0x66,0x69,0x63,0x20
	.DB  0x4D,0x6F,0x6E,0x69,0x74,0x6F,0x72,0x69
	.DB  0x6E,0x67,0x0,0x37,0x3A,0x20,0x4C,0x6F
	.DB  0x67,0x69,0x6E,0x20,0x57,0x69,0x74,0x68
	.DB  0x20,0x41,0x64,0x6D,0x69,0x6E,0x0,0x38
	.DB  0x3A,0x20,0x4C,0x6F,0x67,0x6F,0x75,0x74
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

	.DW  0x18
	.DW  _0xB
	.DW  _0x0*2

	.DW  0x19
	.DW  _0xB+24
	.DW  _0x0*2+24

	.DW  0x19
	.DW  _0xB+49
	.DW  _0x0*2+49

	.DW  0x16
	.DW  _0xB+74
	.DW  _0x0*2+74

	.DW  0x18
	.DW  _0xB+96
	.DW  _0x0*2+96

	.DW  0x16
	.DW  _0xB+120
	.DW  _0x0*2+120

	.DW  0x18
	.DW  _0xB+142
	.DW  _0x0*2+142

	.DW  0x12
	.DW  _0xB+166
	.DW  _0x0*2+166

	.DW  0x12
	.DW  _0xB+184
	.DW  _0x0*2+184

	.DW  0x1F
	.DW  _0xB+202
	.DW  _0x0*2+202

	.DW  0x1F
	.DW  _0xB+233
	.DW  _0x0*2+233

	.DW  0x1E
	.DW  _0xB+264
	.DW  _0x0*2+264

	.DW  0x11
	.DW  _0xB+294
	.DW  _0x0*2+294

	.DW  0x19
	.DW  _0xB+311
	.DW  _0x0*2+24

	.DW  0x0B
	.DW  _0x63
	.DW  _0x0*2+311

	.DW  0x1D
	.DW  _0x63+11
	.DW  _0x0*2+322

	.DW  0x02
	.DW  _0x63+40
	.DW  _0x0*2+94

	.DW  0x03
	.DW  _0x63+42
	.DW  _0x0*2+351

	.DW  0x1E
	.DW  _0x63+45
	.DW  _0x0*2+354

	.DW  0x1F
	.DW  _0x63+75
	.DW  _0x0*2+384

	.DW  0x1F
	.DW  _0x63+106
	.DW  _0x0*2+415

	.DW  0x1F
	.DW  _0x63+137
	.DW  _0x0*2+384

	.DW  0x20
	.DW  _0x63+168
	.DW  _0x0*2+446

	.DW  0x1F
	.DW  _0x63+200
	.DW  _0x0*2+384

	.DW  0x15
	.DW  _0x63+231
	.DW  _0x0*2+478

	.DW  0x1D
	.DW  _0x63+252
	.DW  _0x0*2+499

	.DW  0x02
	.DW  _0x63+281
	.DW  _0x0*2+94

	.DW  0x13
	.DW  _0x63+283
	.DW  _0x0*2+528

	.DW  0x1F
	.DW  _0x63+302
	.DW  _0x0*2+384

	.DW  0x1D
	.DW  _0x63+333
	.DW  _0x0*2+547

	.DW  0x1F
	.DW  _0x63+362
	.DW  _0x0*2+384

	.DW  0x02
	.DW  _0x63+393
	.DW  _0x0*2+94

	.DW  0x13
	.DW  _0x63+395
	.DW  _0x0*2+528

	.DW  0x13
	.DW  _0x63+414
	.DW  _0x0*2+576

	.DW  0x19
	.DW  _0x63+433
	.DW  _0x0*2+595

	.DW  0x1F
	.DW  _0x63+458
	.DW  _0x0*2+384

	.DW  0x1D
	.DW  _0x63+489
	.DW  _0x0*2+547

	.DW  0x1F
	.DW  _0x63+518
	.DW  _0x0*2+384

	.DW  0x02
	.DW  _0x63+549
	.DW  _0x0*2+94

	.DW  0x13
	.DW  _0x63+551
	.DW  _0x0*2+620

	.DW  0x08
	.DW  _0x63+570
	.DW  _0x0*2+639

	.DW  0x1A
	.DW  _0x63+578
	.DW  _0x0*2+647

	.DW  0x1F
	.DW  _0x63+604
	.DW  _0x0*2+384

	.DW  0x14
	.DW  _0x63+635
	.DW  _0x0*2+673

	.DW  0x10
	.DW  _0xD5
	.DW  _0x0*2+693

	.DW  0x02
	.DW  _0xD5+16
	.DW  _0x0*2+94

	.DW  0x1D
	.DW  _0xE1
	.DW  _0x0*2+709

	.DW  0x16
	.DW  _0xE1+29
	.DW  _0x0*2+738

	.DW  0x1A
	.DW  _0xE1+51
	.DW  _0x0*2+760

	.DW  0x1A
	.DW  _0xE1+77
	.DW  _0x0*2+786

	.DW  0x19
	.DW  _0xE1+103
	.DW  _0x0*2+812

	.DW  0x16
	.DW  _0xE1+128
	.DW  _0x0*2+837

	.DW  0x14
	.DW  _0xE1+150
	.DW  _0x0*2+859

	.DW  0x0A
	.DW  _0xE1+170
	.DW  _0x0*2+879

	.DW  0x02
	.DW  _previous_count_S0000013000
	.DW  _0x125*2

	.DW  0x0B
	.DW  _0x126
	.DW  _0x0*2+889

	.DW  0x06
	.DW  _0x126+11
	.DW  _0x0*2+900

	.DW  0x0C
	.DW  _0x126+17
	.DW  _0x0*2+906

	.DW  0x05
	.DW  _0x126+29
	.DW  _0x0*2+918

	.DW  0x08
	.DW  _0x126+34
	.DW  _0x0*2+923

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
;#include <stdint.h>
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
;#define BUZZER_DDR DDRD
;#define BUZZER_PRT PORTD
;#define BUZZER_NUM 7
;#define MENU_PAGE_COUNT 4
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
;unsigned char search_student_code();
;void delete_student_code(unsigned char index);
;void HCSR04Init();
;void HCSR04Trigger();
;uint16_t GetPulseWidth();
;void startSonar();
;unsigned int simple_hash(const char *str);
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
;unsigned char page_num = 0;
;unsigned char US_count = 0;
;const unsigned int secret = 3940;
;char logged_in = 0;
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
;    STAGE_DELETE_STUDENT,
;    STAGE_TRAFFIC_MONITORING,
;    STAGE_LOGIN_WITH_ADMIN,
;    STAGE_CLEAR_EEPROM,
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
;};
;
;void main(void)
; 0000 0062 {

	.CSEG
_main:
; .FSTART _main
; 0000 0063     int i, j;
; 0000 0064     unsigned char st_counts;
; 0000 0065     KEY_DDR = 0xF0;
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0066     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0067     KEY_PRT &= 0x0F;                  // ground all rows at once
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0068     MCUCR = 0x02;                     // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0069     GICR = (1 << INT0);               // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 006A     BUZZER_DDR |= (1 << BUZZER_NUM);  // make buzzer pin output
	SBI  0x11,7
; 0000 006B     BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
	CBI  0x12,7
; 0000 006C     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	CALL _USART_init
; 0000 006D     HCSR04Init(); // Initialize ultrasonic sensor
	CALL _HCSR04Init
; 0000 006E     lcd_init();
	RCALL _lcd_init
; 0000 006F 
; 0000 0070 #asm("sei")           // enable interrupts
	sei
; 0000 0071     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0072     while (1)
_0x5:
; 0000 0073     {
; 0000 0074         if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x8
; 0000 0075         {
; 0000 0076             show_menu();
	RCALL _show_menu
; 0000 0077         }
; 0000 0078         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x9
_0x8:
	CALL SUBOPT_0x0
	BRNE _0xA
; 0000 0079         {
; 0000 007A             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 007B             lcd_gotoxy(1, 1);
; 0000 007C             lcd_print("1 : Submit Student Code");
	__POINTW2MN _0xB,0
	CALL SUBOPT_0x2
; 0000 007D             lcd_gotoxy(1, 2);
; 0000 007E             lcd_print("    press cancel to back");
	__POINTW2MN _0xB,24
	RCALL _lcd_print
; 0000 007F             while (stage == STAGE_ATTENDENC_MENU)
_0xC:
	CALL SUBOPT_0x0
	BREQ _0xC
; 0000 0080                 ;
; 0000 0081         }
; 0000 0082         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0xF
_0xA:
	CALL SUBOPT_0x3
	BRNE _0x10
; 0000 0083         {
; 0000 0084             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0085             lcd_gotoxy(1, 1);
; 0000 0086             lcd_print("Enter your student code:");
	__POINTW2MN _0xB,49
	CALL SUBOPT_0x2
; 0000 0087             lcd_gotoxy(1, 2);
; 0000 0088             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0089             delay_us(100 * 16); // wait
; 0000 008A             while (stage == STAGE_SUBMIT_CODE)
_0x11:
	CALL SUBOPT_0x3
	BREQ _0x11
; 0000 008B                 ;
; 0000 008C             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x134
; 0000 008D             delay_us(100 * 16); // wait
; 0000 008E         }
; 0000 008F         else if (stage == STAGE_TEMPERATURE_MONITORING)
_0x10:
	CALL SUBOPT_0x5
	BRNE _0x15
; 0000 0090         {
; 0000 0091             show_temperature();
	RCALL _show_temperature
; 0000 0092         }
; 0000 0093         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x16
_0x15:
	CALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x17
; 0000 0094         {
; 0000 0095             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0096             lcd_gotoxy(1, 1);
; 0000 0097             lcd_print("Number of students : ");
	__POINTW2MN _0xB,74
	CALL SUBOPT_0x2
; 0000 0098             lcd_gotoxy(1, 2);
; 0000 0099             st_counts = read_byte_from_eeprom(0x0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _read_byte_from_eeprom
	MOV  R21,R30
; 0000 009A             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 009B             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _itoa
; 0000 009C             lcd_print(buffer);
	CALL SUBOPT_0x8
; 0000 009D             delay_ms(1000);
; 0000 009E 
; 0000 009F             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x19:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1A
; 0000 00A0             {
; 0000 00A1                 memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 00A2                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x1C:
	__CPWRN 18,19,8
	BRGE _0x1D
; 0000 00A3                 {
; 0000 00A4                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00A5                 }
	__ADDWRN 18,19,1
	RJMP _0x1C
_0x1D:
; 0000 00A6                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00A7                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00A8                 lcd_gotoxy(1, 1);
; 0000 00A9                 lcd_print(buffer);
	CALL SUBOPT_0x8
; 0000 00AA                 delay_ms(1000);
; 0000 00AB             }
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
; 0000 00AC 
; 0000 00AD             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00AE             lcd_gotoxy(1, 1);
; 0000 00AF             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xB,96
	RCALL _lcd_print
; 0000 00B0             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x1E:
	CALL SUBOPT_0x6
	BREQ _0x1E
; 0000 00B1                 ;
; 0000 00B2         }
; 0000 00B3         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x21
_0x17:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x22
; 0000 00B4         {
; 0000 00B5             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00B6             lcd_gotoxy(1, 1);
; 0000 00B7             lcd_print("Start Transferring...");
	__POINTW2MN _0xB,120
	RCALL _lcd_print
; 0000 00B8             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xA
	MOV  R21,R30
; 0000 00B9             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x24:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x25
; 0000 00BA             {
; 0000 00BB                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x27:
	__CPWRN 18,19,8
	BRGE _0x28
; 0000 00BC                 {
; 0000 00BD                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0x9
	MOV  R26,R30
	RCALL _USART_Transmit
; 0000 00BE                 }
	__ADDWRN 18,19,1
	RJMP _0x27
_0x28:
; 0000 00BF 
; 0000 00C0                 USART_Transmit('\r');
	CALL SUBOPT_0xB
; 0000 00C1                 USART_Transmit('\r');
; 0000 00C2 
; 0000 00C3                 delay_ms(500);
; 0000 00C4             }
	__ADDWRN 16,17,1
	RJMP _0x24
_0x25:
; 0000 00C5             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x2A:
	__CPWRN 18,19,8
	BRGE _0x2B
; 0000 00C6             {
; 0000 00C7                 USART_Transmit('=');
	LDI  R26,LOW(61)
	RCALL _USART_Transmit
; 0000 00C8             }
	__ADDWRN 18,19,1
	RJMP _0x2A
_0x2B:
; 0000 00C9 
; 0000 00CA             USART_Transmit('\r');
	CALL SUBOPT_0xB
; 0000 00CB             USART_Transmit('\r');
; 0000 00CC             delay_ms(500);
; 0000 00CD 
; 0000 00CE             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00CF             lcd_gotoxy(1, 1);
; 0000 00D0             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xB,142
	CALL SUBOPT_0xC
; 0000 00D1             delay_ms(2000);
; 0000 00D2             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 00D3         }
; 0000 00D4         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x2C
_0x22:
	CALL SUBOPT_0xD
	BRNE _0x2D
; 0000 00D5         {
; 0000 00D6             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00D7             lcd_gotoxy(1, 1);
; 0000 00D8             lcd_print("1: Search Student");
	__POINTW2MN _0xB,166
	CALL SUBOPT_0x2
; 0000 00D9             lcd_gotoxy(1, 2);
; 0000 00DA             lcd_print("2: Delete Student");
	__POINTW2MN _0xB,184
	RCALL _lcd_print
; 0000 00DB             while (stage == STAGE_STUDENT_MANAGMENT)
_0x2E:
	CALL SUBOPT_0xD
	BREQ _0x2E
; 0000 00DC                 ;
; 0000 00DD         }
; 0000 00DE         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x31
_0x2D:
	CALL SUBOPT_0xE
	BRNE _0x32
; 0000 00DF         {
; 0000 00E0             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00E1             lcd_gotoxy(1, 1);
; 0000 00E2             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xB,202
	CALL SUBOPT_0x2
; 0000 00E3             lcd_gotoxy(1, 2);
; 0000 00E4             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 00E5             delay_us(100 * 16); // wait
; 0000 00E6             while (stage == STAGE_SEARCH_STUDENT)
_0x33:
	CALL SUBOPT_0xE
	BREQ _0x33
; 0000 00E7                 ;
; 0000 00E8             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x134
; 0000 00E9             delay_us(100 * 16); // wait
; 0000 00EA         }
; 0000 00EB         else if (stage == STAGE_DELETE_STUDENT)
_0x32:
	CALL SUBOPT_0xF
	BRNE _0x37
; 0000 00EC         {
; 0000 00ED             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00EE             lcd_gotoxy(1, 1);
; 0000 00EF             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xB,233
	CALL SUBOPT_0x2
; 0000 00F0             lcd_gotoxy(1, 2);
; 0000 00F1             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 00F2             delay_us(100 * 16); // wait
; 0000 00F3             while (stage == STAGE_DELETE_STUDENT)
_0x38:
	CALL SUBOPT_0xF
	BREQ _0x38
; 0000 00F4                 ;
; 0000 00F5             lcdCommand(0x0c); // display on, cursor off
	RJMP _0x134
; 0000 00F6             delay_us(100 * 16);
; 0000 00F7         }
; 0000 00F8         else if (stage == STAGE_TRAFFIC_MONITORING)
_0x37:
	CALL SUBOPT_0x10
	BRNE _0x3C
; 0000 00F9         {
; 0000 00FA             startSonar();
	RCALL _startSonar
; 0000 00FB             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 00FC         }
; 0000 00FD         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x3D
_0x3C:
	CALL SUBOPT_0x11
	BRNE _0x3E
; 0000 00FE         {
; 0000 00FF             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0100             lcd_gotoxy(1, 1);
; 0000 0101             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xB,264
	CALL SUBOPT_0x2
; 0000 0102             lcd_gotoxy(1, 2);
; 0000 0103             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0104             delay_us(100 * 16); // wait
; 0000 0105             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x3F:
	CALL SUBOPT_0x11
	BRNE _0x42
	TST  R9
	BREQ _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 0106                 ;
	RJMP _0x3F
_0x41:
; 0000 0107             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x44
; 0000 0108             {
; 0000 0109                 lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x12
; 0000 010A                 delay_us(100 * 16);
; 0000 010B                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 010C                 lcd_gotoxy(1, 1);
; 0000 010D                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xB,294
	CALL SUBOPT_0x2
; 0000 010E                 lcd_gotoxy(1, 2);
; 0000 010F                 lcd_print("    press cancel to back");
	__POINTW2MN _0xB,311
	RCALL _lcd_print
; 0000 0110                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x45:
	CALL SUBOPT_0x11
	BREQ _0x45
; 0000 0111                     ;
; 0000 0112             }
; 0000 0113             else
	RJMP _0x48
_0x44:
; 0000 0114             {
; 0000 0115                 lcdCommand(0x0c); // display on, cursor off
_0x134:
	LDI  R26,LOW(12)
	CALL SUBOPT_0x13
; 0000 0116                 delay_us(100 * 16);
; 0000 0117             }
_0x48:
; 0000 0118         }
; 0000 0119     }
_0x3E:
_0x3D:
_0x31:
_0x2C:
_0x21:
_0x16:
_0xF:
_0x9:
	RJMP _0x5
; 0000 011A }
_0x49:
	RJMP _0x49
; .FEND

	.DSEG
_0xB:
	.BYTE 0x150
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 011E {

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
; 0000 011F     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 0120     int i;
; 0000 0121 
; 0000 0122     // detect the key
; 0000 0123     while (1)
	SBIW R28,2
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	i -> Y+6
; 0000 0124     {
; 0000 0125         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x14
; 0000 0126         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0127         if (colloc != 0x0F)        // column detected
	BREQ _0x4D
; 0000 0128         {
; 0000 0129             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 012A             break;      // exit while loop
	RJMP _0x4C
; 0000 012B         }
; 0000 012C         KEY_PRT = 0xDF;            // ground row 1
_0x4D:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x14
; 0000 012D         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 012E         if (colloc != 0x0F)        // column detected
	BREQ _0x4E
; 0000 012F         {
; 0000 0130             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 0131             break;      // exit while loop
	RJMP _0x4C
; 0000 0132         }
; 0000 0133         KEY_PRT = 0xBF;            // ground row 2
_0x4E:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x14
; 0000 0134         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0135         if (colloc != 0x0F)        // column detected
	BREQ _0x4F
; 0000 0136         {
; 0000 0137             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 0138             break;      // exit while loop
	RJMP _0x4C
; 0000 0139         }
; 0000 013A         KEY_PRT = 0x7F;            // ground row 3
_0x4F:
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 013B         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 013C         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 013D         break;                     // exit while loop
; 0000 013E     }
_0x4C:
; 0000 013F     // check column and send result to Port D
; 0000 0140     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x50
; 0000 0141         cl = 0;
	LDI  R19,LOW(0)
; 0000 0142     else if (colloc == 0x0D)
	RJMP _0x51
_0x50:
	CPI  R17,13
	BRNE _0x52
; 0000 0143         cl = 1;
	LDI  R19,LOW(1)
; 0000 0144     else if (colloc == 0x0B)
	RJMP _0x53
_0x52:
	CPI  R17,11
	BRNE _0x54
; 0000 0145         cl = 2;
	LDI  R19,LOW(2)
; 0000 0146     else
	RJMP _0x55
_0x54:
; 0000 0147         cl = 3;
	LDI  R19,LOW(3)
; 0000 0148 
; 0000 0149     KEY_PRT &= 0x0F; // ground all rows at once
_0x55:
_0x53:
_0x51:
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 014A 
; 0000 014B     // inside menu level 1
; 0000 014C     if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0x56
; 0000 014D     {
; 0000 014E         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 014F         {
; 0000 0150         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5A
; 0000 0151             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0152             break;
	RJMP _0x59
; 0000 0153 
; 0000 0154         case OPTION_TEMPERATURE_MONITORING:
_0x5A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5B
; 0000 0155             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0156             break;
	RJMP _0x59
; 0000 0157         case OPTION_VIEW_PRESENT_STUDENTS:
_0x5B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5C
; 0000 0158             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 0159             break;
	RJMP _0x59
; 0000 015A         case OPTION_RETRIEVE_STUDENT_DATA:
_0x5C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5D
; 0000 015B             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 015C             break;
	RJMP _0x59
; 0000 015D         case OPTION_STUDENT_MANAGEMENT:
_0x5D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5E
; 0000 015E             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 015F             break;
	RJMP _0x59
; 0000 0160         case OPTION_TRAFFIC_MONITORING:
_0x5E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0161             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
; 0000 0162             break;
	RJMP _0x59
; 0000 0163         case OPTION_LOGIN_WITH_ADMIN:
_0x5F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60
; 0000 0164             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R4,R30
; 0000 0165             break;
	RJMP _0x59
; 0000 0166         case OPTION_LOGOUT:
_0x60:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x64
; 0000 0167 #asm("cli") // disable interrupts
	cli
; 0000 0168             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x62
; 0000 0169             {
; 0000 016A                 lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 016B                 lcd_gotoxy(1, 1);
; 0000 016C                 lcd_print("Logout ...");
	__POINTW2MN _0x63,0
	CALL SUBOPT_0x2
; 0000 016D                 lcd_gotoxy(1, 2);
; 0000 016E                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x63,11
	CALL SUBOPT_0xC
; 0000 016F                 delay_ms(2000);
; 0000 0170                 logged_in = 0;
	CLR  R9
; 0000 0171 #asm("sei")
	sei
; 0000 0172                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R4,R30
; 0000 0173             }
; 0000 0174             break;
_0x62:
; 0000 0175         default:
_0x64:
; 0000 0176             break;
; 0000 0177         }
_0x59:
; 0000 0178 
; 0000 0179         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x65
; 0000 017A         {
; 0000 017B             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x66
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,1
	RJMP _0x67
_0x66:
	LDI  R30,LOW(3)
_0x67:
	MOV  R7,R30
; 0000 017C         }
; 0000 017D         if (keypad[rowloc][cl] == 'R')
_0x65:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x69
; 0000 017E         {
; 0000 017F             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	MOV  R7,R30
; 0000 0180         }
; 0000 0181     }
_0x69:
; 0000 0182     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x6A
_0x56:
	CALL SUBOPT_0x0
	BRNE _0x6B
; 0000 0183     {
; 0000 0184         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
; 0000 0185         {
; 0000 0186         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x6F
; 0000 0187             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0188             break;
	RJMP _0x6E
; 0000 0189         case '1':
_0x6F:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x71
; 0000 018A             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 018B             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 018C             break;
; 0000 018D         default:
_0x71:
; 0000 018E             break;
; 0000 018F         }
_0x6E:
; 0000 0190     }
; 0000 0191     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x72
_0x6B:
	CALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x73
; 0000 0192     {
; 0000 0193 
; 0000 0194         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x74
; 0000 0195         {
; 0000 0196             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0197             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0198         }
; 0000 0199         if ((keypad[rowloc][cl] - '0') < 10)
_0x74:
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x75
; 0000 019A         {
; 0000 019B             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x16
	SBIW R30,31
	BRSH _0x76
; 0000 019C             {
; 0000 019D                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
; 0000 019E                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x19
; 0000 019F                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 01A0             }
; 0000 01A1         }
_0x76:
; 0000 01A2         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x77
_0x75:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x78
; 0000 01A3         {
; 0000 01A4             buffer_len = strlen(buffer);
	CALL SUBOPT_0x16
	MOV  R21,R30
; 0000 01A5             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x79
; 0000 01A6             {
; 0000 01A7                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 01A8                 lcdCommand(0x10);
; 0000 01A9                 lcd_print(" ");
	__POINTW2MN _0x63,40
	CALL SUBOPT_0x1B
; 0000 01AA                 lcdCommand(0x10);
; 0000 01AB             }
; 0000 01AC         }
_0x79:
; 0000 01AD         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x7A
_0x78:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0x7B
; 0000 01AE         {
; 0000 01AF 
; 0000 01B0 #asm("cli")
	cli
; 0000 01B1 
; 0000 01B2             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 01B3                 strlen(buffer) != 8)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x63,42
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x7D
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x7C
_0x7D:
; 0000 01B4             {
; 0000 01B5 
; 0000 01B6                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 01B7                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01B8                 lcd_gotoxy(1, 1);
; 0000 01B9                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x63,45
	CALL SUBOPT_0x2
; 0000 01BA                 lcd_gotoxy(1, 2);
; 0000 01BB                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,75
	CALL SUBOPT_0xC
; 0000 01BC                 delay_ms(2000);
; 0000 01BD                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
	CBI  0x12,7
; 0000 01BE             }
; 0000 01BF             else if (search_student_code() > 0)
	RJMP _0x7F
_0x7C:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x80
; 0000 01C0             {
; 0000 01C1                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 01C2                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01C3                 lcd_gotoxy(1, 1);
; 0000 01C4                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x63,106
	CALL SUBOPT_0x2
; 0000 01C5                 lcd_gotoxy(1, 2);
; 0000 01C6                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,137
	CALL SUBOPT_0xC
; 0000 01C7                 delay_ms(2000);
; 0000 01C8                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
	CBI  0x12,7
; 0000 01C9             }
; 0000 01CA             else
	RJMP _0x81
_0x80:
; 0000 01CB             {
; 0000 01CC                 // save the buffer to EEPROM
; 0000 01CD                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xA
	MOV  R18,R30
; 0000 01CE                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x83:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,8
	BRGE _0x84
; 0000 01CF                 {
; 0000 01D0                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R18
	CALL SUBOPT_0x1C
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
; 0000 01D1                 }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x83
_0x84:
; 0000 01D2                 write_byte_to_eeprom(0x0, st_counts + 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 01D3 
; 0000 01D4                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01D5                 lcd_gotoxy(1, 1);
; 0000 01D6                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x63,168
	CALL SUBOPT_0x2
; 0000 01D7                 lcd_gotoxy(1, 2);
; 0000 01D8                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,200
	CALL SUBOPT_0xC
; 0000 01D9                 delay_ms(2000);
; 0000 01DA             }
_0x81:
_0x7F:
; 0000 01DB             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 01DC #asm("sei")
	sei
; 0000 01DD             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x135
; 0000 01DE         }
; 0000 01DF         else if (keypad[rowloc][cl] == 'C')
_0x7B:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x86
; 0000 01E0             stage = STAGE_ATTENDENC_MENU;
_0x135:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01E1     }
_0x86:
_0x7A:
_0x77:
; 0000 01E2     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x87
_0x73:
	CALL SUBOPT_0x5
	BRNE _0x88
; 0000 01E3     {
; 0000 01E4 
; 0000 01E5         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x89
; 0000 01E6             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01E7     }
_0x89:
; 0000 01E8     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x8A
_0x88:
	CALL SUBOPT_0x6
	BRNE _0x8B
; 0000 01E9     {
; 0000 01EA         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x8C
; 0000 01EB             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01EC     }
_0x8C:
; 0000 01ED     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x8D
_0x8B:
	CALL SUBOPT_0xD
	BRNE _0x8E
; 0000 01EE     {
; 0000 01EF         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x8F
; 0000 01F0             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01F1         else if (keypad[rowloc][cl] == '1')
	RJMP _0x90
_0x8F:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0x91
; 0000 01F2             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x136
; 0000 01F3         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0x91:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0x94
	LDI  R30,LOW(1)
	CP   R30,R9
	BREQ _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 01F4             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x136
; 0000 01F5         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0x93:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0x98
	TST  R9
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
; 0000 01F6         {
; 0000 01F7             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01F8             lcd_gotoxy(1, 1);
; 0000 01F9             lcd_print("You Must First Login");
	__POINTW2MN _0x63,231
	CALL SUBOPT_0x2
; 0000 01FA             lcd_gotoxy(1, 2);
; 0000 01FB             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x63,252
	CALL SUBOPT_0xC
; 0000 01FC             delay_ms(2000);
; 0000 01FD             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x136:
	MOVW R4,R30
; 0000 01FE         }
; 0000 01FF     }
_0x97:
_0x90:
; 0000 0200     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x9A
_0x8E:
	CALL SUBOPT_0xE
	BREQ PC+2
	RJMP _0x9B
; 0000 0201     {
; 0000 0202         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9C
; 0000 0203         {
; 0000 0204             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0205             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x137
; 0000 0206         }
; 0000 0207         else if ((keypad[rowloc][cl] - '0') < 10)
_0x9C:
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x9E
; 0000 0208         {
; 0000 0209             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x16
	SBIW R30,31
	BRSH _0x9F
; 0000 020A             {
; 0000 020B                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
; 0000 020C                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x19
; 0000 020D                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 020E             }
; 0000 020F         }
_0x9F:
; 0000 0210         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xA0
_0x9E:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xA1
; 0000 0211         {
; 0000 0212             buffer_len = strlen(buffer);
	CALL SUBOPT_0x16
	MOV  R21,R30
; 0000 0213             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xA2
; 0000 0214             {
; 0000 0215                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 0216                 lcdCommand(0x10);
; 0000 0217                 lcd_print(" ");
	__POINTW2MN _0x63,281
	CALL SUBOPT_0x1B
; 0000 0218                 lcdCommand(0x10);
; 0000 0219             }
; 0000 021A         }
_0xA2:
; 0000 021B         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xA3
_0xA1:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xA4
; 0000 021C         {
; 0000 021D             // search from eeprom data
; 0000 021E             unsigned char result = search_student_code();
; 0000 021F 
; 0000 0220             if (result > 0)
	CALL SUBOPT_0x1D
;	i -> Y+7
;	result -> Y+0
	BRLO _0xA5
; 0000 0221             {
; 0000 0222                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0223                 lcd_gotoxy(1, 1);
; 0000 0224                 lcd_print("Student Code Found");
	__POINTW2MN _0x63,283
	CALL SUBOPT_0x2
; 0000 0225                 lcd_gotoxy(1, 2);
; 0000 0226                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,302
	RJMP _0x138
; 0000 0227                 delay_ms(2000);
; 0000 0228             }
; 0000 0229             else
_0xA5:
; 0000 022A             {
; 0000 022B                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 022C                 lcd_gotoxy(1, 1);
; 0000 022D                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x63,333
	CALL SUBOPT_0x2
; 0000 022E                 lcd_gotoxy(1, 2);
; 0000 022F                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,362
_0x138:
	RCALL _lcd_print
; 0000 0230                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0231             }
; 0000 0232             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0233             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0234         }
	ADIW R28,1
; 0000 0235         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xA7
_0xA4:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA8
; 0000 0236             stage = STAGE_STUDENT_MANAGMENT;
_0x137:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0237     }
_0xA8:
_0xA7:
_0xA3:
_0xA0:
; 0000 0238     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xA9
_0x9B:
	CALL SUBOPT_0xF
	BREQ PC+2
	RJMP _0xAA
; 0000 0239     {
; 0000 023A         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xAB
; 0000 023B         {
; 0000 023C             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 023D             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 023E         }
; 0000 023F         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xAC
_0xAB:
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xAD
; 0000 0240         {
; 0000 0241             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x16
	SBIW R30,31
	BRSH _0xAE
; 0000 0242             {
; 0000 0243                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
; 0000 0244                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x19
; 0000 0245                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0246             }
; 0000 0247         }
_0xAE:
; 0000 0248         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xAF
_0xAD:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xB0
; 0000 0249         {
; 0000 024A             buffer_len = strlen(buffer);
	CALL SUBOPT_0x16
	MOV  R21,R30
; 0000 024B             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xB1
; 0000 024C             {
; 0000 024D                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 024E                 lcdCommand(0x10);
; 0000 024F                 lcd_print(" ");
	__POINTW2MN _0x63,393
	CALL SUBOPT_0x1B
; 0000 0250                 lcdCommand(0x10);
; 0000 0251             }
; 0000 0252         }
_0xB1:
; 0000 0253         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xB2
_0xB0:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xB3
; 0000 0254         {
; 0000 0255             // search from eeprom data
; 0000 0256             unsigned char result = search_student_code();
; 0000 0257 
; 0000 0258             if (result > 0)
	CALL SUBOPT_0x1D
;	i -> Y+7
;	result -> Y+0
	BRLO _0xB4
; 0000 0259             {
; 0000 025A                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 025B                 lcd_gotoxy(1, 1);
; 0000 025C                 lcd_print("Student Code Found");
	__POINTW2MN _0x63,395
	CALL SUBOPT_0x2
; 0000 025D                 lcd_gotoxy(1, 2);
; 0000 025E                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x63,414
	RCALL _lcd_print
; 0000 025F                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 0260                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0261                 lcd_gotoxy(1, 1);
; 0000 0262                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x63,433
	CALL SUBOPT_0x2
; 0000 0263                 lcd_gotoxy(1, 2);
; 0000 0264                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,458
	RJMP _0x139
; 0000 0265                 delay_ms(2000);
; 0000 0266             }
; 0000 0267             else
_0xB4:
; 0000 0268             {
; 0000 0269                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 026A                 lcd_gotoxy(1, 1);
; 0000 026B                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x63,489
	CALL SUBOPT_0x2
; 0000 026C                 lcd_gotoxy(1, 2);
; 0000 026D                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,518
_0x139:
	RCALL _lcd_print
; 0000 026E                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 026F             }
; 0000 0270             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 0271             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0272         }
	ADIW R28,1
; 0000 0273     }
_0xB3:
_0xB2:
_0xAF:
_0xAC:
; 0000 0274     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0xB6
_0xAA:
	CALL SUBOPT_0x10
	BRNE _0xB7
; 0000 0275     {
; 0000 0276         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB8
; 0000 0277             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0278     }
_0xB8:
; 0000 0279     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0xB9
_0xB7:
	CALL SUBOPT_0x11
	BRNE _0xBB
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0xBC
_0xBB:
	RJMP _0xBA
_0xBC:
; 0000 027A     {
; 0000 027B         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBD
; 0000 027C         {
; 0000 027D             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 027E             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 027F         }
; 0000 0280 
; 0000 0281         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xBE
_0xBD:
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xBF
; 0000 0282         {
; 0000 0283             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x16
	SBIW R30,31
	BRSH _0xC0
; 0000 0284             {
; 0000 0285                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
; 0000 0286                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x19
; 0000 0287                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0288             }
; 0000 0289         }
_0xC0:
; 0000 028A         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xC1
_0xBF:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xC2
; 0000 028B         {
; 0000 028C             buffer_len = strlen(buffer);
	CALL SUBOPT_0x16
	MOV  R21,R30
; 0000 028D             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xC3
; 0000 028E             {
; 0000 028F                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 0290                 lcdCommand(0x10);
; 0000 0291                 lcd_print(" ");
	__POINTW2MN _0x63,549
	CALL SUBOPT_0x1B
; 0000 0292                 lcdCommand(0x10);
; 0000 0293             }
; 0000 0294         }
_0xC3:
; 0000 0295         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xC4
_0xC2:
	CALL SUBOPT_0x15
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xC5
; 0000 0296         {
; 0000 0297             // search from eeprom data
; 0000 0298             unsigned int input_hash = simple_hash(buffer);
; 0000 0299 
; 0000 029A             if (input_hash == secret)
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
	BRNE _0xC6
; 0000 029B             {
; 0000 029C                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 029D                 lcd_gotoxy(1, 1);
; 0000 029E                 lcd_print("Login Successfully");
	__POINTW2MN _0x63,551
	CALL SUBOPT_0x2
; 0000 029F                 lcd_gotoxy(1, 2);
; 0000 02A0                 lcd_print("Wait...");
	__POINTW2MN _0x63,570
	CALL SUBOPT_0xC
; 0000 02A1                 delay_ms(2000);
; 0000 02A2                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 02A3             }
; 0000 02A4             else
	RJMP _0xC7
_0xC6:
; 0000 02A5             {
; 0000 02A6                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02A7                 lcd_gotoxy(1, 1);
; 0000 02A8                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x63,578
	CALL SUBOPT_0x2
; 0000 02A9                 lcd_gotoxy(1, 2);
; 0000 02AA                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x63,604
	CALL SUBOPT_0xC
; 0000 02AB                 delay_ms(2000);
; 0000 02AC             }
_0xC7:
; 0000 02AD             memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 02AE             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02AF         }
	ADIW R28,2
; 0000 02B0     }
_0xC5:
_0xC4:
_0xC1:
_0xBE:
; 0000 02B1     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0xC8
_0xBA:
	CALL SUBOPT_0x11
	BRNE _0xCA
	TST  R9
	BRNE _0xCB
_0xCA:
	RJMP _0xC9
_0xCB:
; 0000 02B2     {
; 0000 02B3         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x15
	LD   R30,X
	LDI  R31,0
; 0000 02B4         {
; 0000 02B5         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xCF
; 0000 02B6             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02B7             break;
	RJMP _0xCE
; 0000 02B8         case '1':
_0xCF:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xD1
; 0000 02B9 #asm("cli") // disable interrupts
	cli
; 0000 02BA             lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 02BB             lcd_gotoxy(1, 1);
; 0000 02BC             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x63,635
	RCALL _lcd_print
; 0000 02BD             clear_eeprom();
	RCALL _clear_eeprom
; 0000 02BE #asm("sei") // enable interrupts
	sei
; 0000 02BF             break;
; 0000 02C0         default:
_0xD1:
; 0000 02C1             break;
; 0000 02C2         }
_0xCE:
; 0000 02C3         memset(buffer, 0, 32);
	CALL SUBOPT_0x7
; 0000 02C4         stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02C5     }
; 0000 02C6 }
_0xC9:
_0xC8:
_0xB9:
_0xB6:
_0xA9:
_0x9A:
_0x8D:
_0x8A:
_0x87:
_0x72:
_0x6A:
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
_0x63:
	.BYTE 0x28F
;
;void lcdCommand(unsigned char cmnd)
; 0000 02C9 {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 02CA     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x1E
;	cmnd -> Y+0
; 0000 02CB     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x18,0
; 0000 02CC     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x1F
; 0000 02CD     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 02CE     delay_us(1 * 16);          // wait to make EN wider
; 0000 02CF     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 02D0     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 02D1     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x20
; 0000 02D2     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 02D3     delay_us(1 * 16);          // wait to make EN wider
; 0000 02D4     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 02D5 }
	RJMP _0x20A0005
; .FEND
;void lcdData(unsigned char data)
; 0000 02D7 {
_lcdData:
; .FSTART _lcdData
; 0000 02D8     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x1E
;	data -> Y+0
; 0000 02D9     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x18,0
; 0000 02DA     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x1F
; 0000 02DB     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 02DC     delay_us(1 * 16);          // wait to make EN wider
; 0000 02DD     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 02DE     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x20
; 0000 02DF     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 02E0     delay_us(1 * 16);          // wait to make EN wider
; 0000 02E1     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 02E2 }
	RJMP _0x20A0005
; .FEND
;void lcd_init()
; 0000 02E4 {
_lcd_init:
; .FSTART _lcd_init
; 0000 02E5     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 02E6     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x18,2
; 0000 02E7     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 02E8     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x13
; 0000 02E9     delay_us(100 * 16);        // wait
; 0000 02EA     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x13
; 0000 02EB     delay_us(100 * 16);        // wait
; 0000 02EC     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x13
; 0000 02ED     delay_us(100 * 16);        // wait
; 0000 02EE     lcdCommand(0x0c);          // display on, cursor off
	CALL SUBOPT_0x12
; 0000 02EF     delay_us(100 * 16);        // wait
; 0000 02F0     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 02F1     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 02F2     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x13
; 0000 02F3     delay_us(100 * 16);
; 0000 02F4 }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 02F6 {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 02F7     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 02F8     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0x13
; 0000 02F9     delay_us(100 * 16);
; 0000 02FA }
	ADIW R28,6
	RET
; .FEND
;void lcd_print(char *str)
; 0000 02FC {
_lcd_print:
; .FSTART _lcd_print
; 0000 02FD     unsigned char i = 0;
; 0000 02FE     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0xD2:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0xD4
; 0000 02FF     {
; 0000 0300         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 0301         i++;
	SUBI R17,-1
; 0000 0302     }
	RJMP _0xD2
_0xD4:
; 0000 0303 }
	LDD  R17,Y+0
	RJMP _0x20A0006
; .FEND
;
;void show_temperature()
; 0000 0306 {
_show_temperature:
; .FSTART _show_temperature
; 0000 0307     unsigned char temperatureVal = 0;
; 0000 0308     unsigned char temperatureRep[3];
; 0000 0309 
; 0000 030A     ADMUX = 0xE0;
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 030B     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 030C 
; 0000 030D     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 030E     lcd_gotoxy(1, 1);
; 0000 030F     lcd_print("temperature(C):");
	__POINTW2MN _0xD5,0
	RCALL _lcd_print
; 0000 0310 
; 0000 0311     while (stage == STAGE_TEMPERATURE_MONITORING)
_0xD6:
	CALL SUBOPT_0x5
	BRNE _0xD8
; 0000 0312     {
; 0000 0313         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 0314         while ((ADCSRA & (1 << ADIF)) == 0)
_0xD9:
	SBIS 0x6,4
; 0000 0315             ;
	RJMP _0xD9
; 0000 0316         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0xDC
; 0000 0317         {
; 0000 0318             temperatureVal = ADCH;
	IN   R17,5
; 0000 0319             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 031A             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 031B             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 031C             lcd_print(" ");
	__POINTW2MN _0xD5,16
	RCALL _lcd_print
; 0000 031D         }
; 0000 031E         delay_ms(500);
_0xDC:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 031F     }
	RJMP _0xD6
_0xD8:
; 0000 0320 
; 0000 0321     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0322 }
	LDD  R17,Y+0
	RJMP _0x20A0002
; .FEND

	.DSEG
_0xD5:
	.BYTE 0x12
;
;void show_menu()
; 0000 0325 {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 0326 
; 0000 0327     while (stage == STAGE_INIT_MENU)
_0xDD:
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0xDF
; 0000 0328     {
; 0000 0329         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 032A         lcd_gotoxy(1, 1);
; 0000 032B         if (page_num == 0)
	TST  R7
	BRNE _0xE0
; 0000 032C         {
; 0000 032D             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0xE1,0
	CALL SUBOPT_0x2
; 0000 032E             lcd_gotoxy(1, 2);
; 0000 032F             lcd_print("2: Student Management");
	__POINTW2MN _0xE1,29
	RCALL _lcd_print
; 0000 0330             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0xE2:
	TST  R7
	BRNE _0xE5
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xE6
_0xE5:
	RJMP _0xE4
_0xE6:
; 0000 0331                 ;
	RJMP _0xE2
_0xE4:
; 0000 0332         }
; 0000 0333         else if (page_num == 1)
	RJMP _0xE7
_0xE0:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xE8
; 0000 0334         {
; 0000 0335             lcd_print("3: View Present Students ");
	__POINTW2MN _0xE1,51
	CALL SUBOPT_0x2
; 0000 0336             lcd_gotoxy(1, 2);
; 0000 0337             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0xE1,77
	RCALL _lcd_print
; 0000 0338             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0xE9:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xEC
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xED
_0xEC:
	RJMP _0xEB
_0xED:
; 0000 0339                 ;
	RJMP _0xE9
_0xEB:
; 0000 033A         }
; 0000 033B         else if (page_num == 2)
	RJMP _0xEE
_0xE8:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xEF
; 0000 033C         {
; 0000 033D             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0xE1,103
	CALL SUBOPT_0x2
; 0000 033E             lcd_gotoxy(1, 2);
; 0000 033F             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0xE1,128
	RCALL _lcd_print
; 0000 0340             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0xF0:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xF3
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xF4
_0xF3:
	RJMP _0xF2
_0xF4:
; 0000 0341                 ;
	RJMP _0xF0
_0xF2:
; 0000 0342         }
; 0000 0343         else if (page_num == 3)
	RJMP _0xF5
_0xEF:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0xF6
; 0000 0344         {
; 0000 0345             lcd_print("7: Login With Admin");
	__POINTW2MN _0xE1,150
	CALL SUBOPT_0x2
; 0000 0346             lcd_gotoxy(1, 2);
; 0000 0347             lcd_print("8: Logout");
	__POINTW2MN _0xE1,170
	RCALL _lcd_print
; 0000 0348             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0xF7:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0xFA
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xFB
_0xFA:
	RJMP _0xF9
_0xFB:
; 0000 0349                 ;
	RJMP _0xF7
_0xF9:
; 0000 034A         }
; 0000 034B     }
_0xF6:
_0xF5:
_0xEE:
_0xE7:
	RJMP _0xDD
_0xDF:
; 0000 034C }
	RET
; .FEND

	.DSEG
_0xE1:
	.BYTE 0xB4
;
;void clear_eeprom()
; 0000 034F {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 0350     unsigned int i;
; 0000 0351 
; 0000 0352     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0xFD:
	__CPWRN 16,17,1024
	BRSH _0xFE
; 0000 0353     {
; 0000 0354         // Wait for the previous write to complete
; 0000 0355         while (EECR & (1 << EEWE))
_0xFF:
	SBIC 0x1C,1
; 0000 0356             ;
	RJMP _0xFF
; 0000 0357 
; 0000 0358         // Set up address registers
; 0000 0359         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 035A         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 035B 
; 0000 035C         // Set up data register
; 0000 035D         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 035E 
; 0000 035F         // Enable write
; 0000 0360         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 0361         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0362     }
	__ADDWRN 16,17,1
	RJMP _0xFD
_0xFE:
; 0000 0363 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 0366 {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 0367     unsigned char x;
; 0000 0368     // Wait for the previous write to complete
; 0000 0369     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x102:
	SBIC 0x1C,1
; 0000 036A         ;
	RJMP _0x102
; 0000 036B 
; 0000 036C     // Set up address registers
; 0000 036D     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x21
; 0000 036E     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 036F     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 0370     x = EEDR;
	IN   R17,29
; 0000 0371     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0006
; 0000 0372 }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 0375 {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 0376     // Wait for the previous write to complete
; 0000 0377     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x105:
	SBIC 0x1C,1
; 0000 0378         ;
	RJMP _0x105
; 0000 0379 
; 0000 037A     // Set up address registers
; 0000 037B     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x21
; 0000 037C     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 037D 
; 0000 037E     // Set up data register
; 0000 037F     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 0380 
; 0000 0381     // Enable write
; 0000 0382     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 0383     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0384 }
_0x20A0006:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 0387 {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 0388     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x108:
	SBIS 0xB,5
; 0000 0389         ;
	RJMP _0x108
; 0000 038A     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 038B }
_0x20A0005:
	ADIW R28,1
	RET
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 038E {
_USART_init:
; .FSTART _USART_init
; 0000 038F     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 0390     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 0391     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0392     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 0393 }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 0396 {
_search_student_code:
; .FSTART _search_student_code
; 0000 0397     unsigned char st_counts, i, j;
; 0000 0398     char temp[10];
; 0000 0399 
; 0000 039A     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0xA
	MOV  R17,R30
; 0000 039B 
; 0000 039C     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x10C:
	CP   R16,R17
	BRSH _0x10D
; 0000 039D     {
; 0000 039E         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 039F         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x10F:
	CPI  R19,8
	BRSH _0x110
; 0000 03A0         {
; 0000 03A1             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
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
	CALL SUBOPT_0x1C
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 03A2         }
	SUBI R19,-1
	RJMP _0x10F
_0x110:
; 0000 03A3         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 03A4         if (strncmp(temp, buffer, 8) == 0)
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x111
; 0000 03A5             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20A0004
; 0000 03A6     }
_0x111:
	SUBI R16,-1
	RJMP _0x10C
_0x10D:
; 0000 03A7 
; 0000 03A8     return 0;
	LDI  R30,LOW(0)
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 03A9 }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 03AC {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 03AD     unsigned char st_counts, i, j;
; 0000 03AE     unsigned char temp;
; 0000 03AF 
; 0000 03B0     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0xA
	MOV  R17,R30
; 0000 03B1 
; 0000 03B2     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x113:
	CP   R17,R16
	BRLO _0x114
; 0000 03B3     {
; 0000 03B4         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x116:
	CPI  R19,8
	BRSH _0x117
; 0000 03B5         {
; 0000 03B6             temp = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0x1C
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	MOV  R18,R30
; 0000 03B7             write_byte_to_eeprom(j + ((i) * 8), temp);
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
; 0000 03B8         }
	SUBI R19,-1
	RJMP _0x116
_0x117:
; 0000 03B9     }
	SUBI R16,-1
	RJMP _0x113
_0x114:
; 0000 03BA     write_byte_to_eeprom(0x0, st_counts - 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 03BB }
	CALL __LOADLOCR4
	JMP  _0x20A0001
; .FEND
;
;void HCSR04Init()
; 0000 03BE {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 03BF     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 03C0     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 03C1 }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 03C4 {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 03C5     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 03C6     delay_us(15);                   // Wait for 15 microseconds
	__DELAY_USB 40
; 0000 03C7     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 03C8 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 03CB {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 03CC     uint32_t i, result;
; 0000 03CD 
; 0000 03CE     // Wait for rising edge on Echo pin
; 0000 03CF     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x119:
	CALL SUBOPT_0x22
	BRSH _0x11A
; 0000 03D0     {
; 0000 03D1         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 03D2             continue;
	RJMP _0x118
; 0000 03D3         else
; 0000 03D4             break;
	RJMP _0x11A
; 0000 03D5     }
_0x118:
	CALL SUBOPT_0x23
	RJMP _0x119
_0x11A:
; 0000 03D6 
; 0000 03D7     if (i == 600000)
	CALL SUBOPT_0x22
	BRNE _0x11D
; 0000 03D8         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0003
; 0000 03D9 
; 0000 03DA     // Start timer with prescaler 8
; 0000 03DB     TCCR1A = 0x00;
_0x11D:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 03DC     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 03DD     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 03DE 
; 0000 03DF     // Wait for falling edge on Echo pin
; 0000 03E0     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x11F:
	CALL SUBOPT_0x22
	BRSH _0x120
; 0000 03E1     {
; 0000 03E2         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 03E3             break; // Falling edge detected
	RJMP _0x120
; 0000 03E4         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x122
; 0000 03E5             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0003
; 0000 03E6     }
_0x122:
	CALL SUBOPT_0x23
	RJMP _0x11F
_0x120:
; 0000 03E7 
; 0000 03E8     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 03E9     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 03EA 
; 0000 03EB     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x123
; 0000 03EC         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0003
; 0000 03ED     else
_0x123:
; 0000 03EE         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
; 0000 03EF }
_0x20A0003:
	ADIW R28,8
	RET
; .FEND
;
;void startSonar()
; 0000 03F2 {
_startSonar:
; .FSTART _startSonar
; 0000 03F3     char numberString[16];
; 0000 03F4     uint16_t pulseWidth; // Pulse width from echo
; 0000 03F5     int distance, previous_distance = -1;
; 0000 03F6     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 03F7 
; 0000 03F8     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x1
; 0000 03F9     lcd_gotoxy(1, 1);
; 0000 03FA     lcd_print("Distance: ");
	__POINTW2MN _0x126,0
	RCALL _lcd_print
; 0000 03FB 
; 0000 03FC     while (stage == STAGE_TRAFFIC_MONITORING)
_0x127:
	CALL SUBOPT_0x10
	BREQ PC+2
	RJMP _0x129
; 0000 03FD     {
; 0000 03FE         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 03FF         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 0400 
; 0000 0401         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x12A
; 0000 0402         {
; 0000 0403             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0404             lcd_gotoxy(1, 1);
; 0000 0405             lcd_print("Error"); // Display error message
	__POINTW2MN _0x126,11
	RJMP _0x13A
; 0000 0406         }
; 0000 0407         else if (pulseWidth == US_NO_OBSTACLE)
_0x12A:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x12C
; 0000 0408         {
; 0000 0409             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 040A             lcd_gotoxy(1, 1);
; 0000 040B             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x126,17
	RJMP _0x13A
; 0000 040C         }
; 0000 040D         else
_0x12C:
; 0000 040E         {
; 0000 040F             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 0410 
; 0000 0411             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x12E
; 0000 0412             {
; 0000 0413                 previous_distance = distance;
	MOVW R20,R18
; 0000 0414                 // Display distance on LCD
; 0000 0415                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0416                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0417                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 0418                 lcd_print(" cm ");
	__POINTW2MN _0x126,29
	RCALL _lcd_print
; 0000 0419             }
; 0000 041A             // Counting logic based on distance
; 0000 041B             if (distance < 6)
_0x12E:
	__CPWRN 18,19,6
	BRGE _0x12F
; 0000 041C             {
; 0000 041D                 US_count++; // Increment count if distance is below threshold
	INC  R6
; 0000 041E             }
; 0000 041F 
; 0000 0420             // Update count on LCD only if it changes
; 0000 0421             if (US_count != previous_count)
_0x12F:
	LDS  R30,_previous_count_S0000013000
	LDS  R31,_previous_count_S0000013000+1
	MOV  R26,R6
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x130
; 0000 0422             {
; 0000 0423                 previous_count = US_count;
	MOV  R30,R6
	LDI  R31,0
	STS  _previous_count_S0000013000,R30
	STS  _previous_count_S0000013000+1,R31
; 0000 0424                 lcd_gotoxy(1, 2); // Move to second line
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0425                 itoa(US_count, numberString);
	MOV  R30,R6
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0426                 lcd_print("Count: ");
	__POINTW2MN _0x126,34
	RCALL _lcd_print
; 0000 0427                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x13A:
	RCALL _lcd_print
; 0000 0428             }
; 0000 0429         }
_0x130:
; 0000 042A         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 042B     }
	RJMP _0x127
_0x129:
; 0000 042C }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x126:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 042F {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 0430     unsigned int hash = 0;
; 0000 0431     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x131:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x133
; 0000 0432     {
; 0000 0433         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 0434         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0435     }
	RJMP _0x131
_0x133:
; 0000 0436     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0002:
	ADIW R28,4
	RET
; 0000 0437 }
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
_0x20A0001:
	ADIW R28,5
	RET
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
_previous_count_S0000013000:
	.BYTE 0x2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:171 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	CALL _lcdCommand
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:112 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:85 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_print
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xC:
	CALL _lcd_print
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(12)
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13:
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:330 WORDS
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A:
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
SUBOPT_0x1B:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
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
SUBOPT_0x1F:
	CBI  0x18,1
	SBI  0x18,2
	__DELAY_USB 43
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x20:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x22:
	__GETD2S 4
	__CPD2N 0x927C0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	__GETD1S 4
	__SUBD1N -1
	__PUTD1S 4
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

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
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
