
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

_0x3:
	.DB  0x37,0x38,0x39,0x4F,0x34,0x35,0x36,0x44
	.DB  0x31,0x32,0x33,0x43,0x4C,0x30,0x52,0x45
_0xE8:
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
	.DB  0x43,0x6C,0x65,0x61,0x72,0x69,0x6E,0x67
	.DB  0x20,0x45,0x45,0x50,0x52,0x4F,0x4D,0x20
	.DB  0x2E,0x2E,0x2E,0x0,0x34,0x30,0x0,0x49
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
	.DB  0x65,0x64,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x46,0x6F,0x75,0x6E,0x64,0x0,0x59,0x6F
	.DB  0x75,0x20,0x57,0x69,0x6C,0x6C,0x20,0x42
	.DB  0x61,0x63,0x6B,0x20,0x4D,0x65,0x6E,0x75
	.DB  0x20,0x49,0x6E,0x20,0x35,0x20,0x53,0x65
	.DB  0x63,0x6F,0x6E,0x64,0x0,0x4F,0x70,0x73
	.DB  0x20,0x2C,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x4E,0x6F,0x74,0x20,0x46,0x6F,0x75,0x6E
	.DB  0x64,0x0,0x57,0x61,0x69,0x74,0x20,0x46
	.DB  0x6F,0x72,0x20,0x44,0x65,0x6C,0x65,0x74
	.DB  0x65,0x2E,0x2E,0x2E,0x0,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x43,0x6F,0x64
	.DB  0x65,0x20,0x57,0x61,0x73,0x20,0x44,0x65
	.DB  0x6C,0x65,0x74,0x65,0x64,0x0,0x74,0x65
	.DB  0x6D,0x70,0x65,0x72,0x61,0x74,0x75,0x72
	.DB  0x65,0x28,0x43,0x29,0x3A,0x0,0x31,0x3A
	.DB  0x20,0x41,0x74,0x74,0x65,0x6E,0x64,0x61
	.DB  0x6E,0x63,0x65,0x20,0x49,0x6E,0x69,0x74
	.DB  0x69,0x61,0x6C,0x69,0x7A,0x61,0x74,0x69
	.DB  0x6F,0x6E,0x0,0x32,0x3A,0x20,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x4D,0x61
	.DB  0x6E,0x61,0x67,0x65,0x6D,0x65,0x6E,0x74
	.DB  0x0,0x33,0x3A,0x20,0x56,0x69,0x65,0x77
	.DB  0x20,0x50,0x72,0x65,0x73,0x65,0x6E,0x74
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x73,0x20,0x0,0x34,0x3A,0x20,0x54,0x65
	.DB  0x6D,0x70,0x65,0x72,0x61,0x74,0x75,0x72
	.DB  0x65,0x20,0x4D,0x6F,0x6E,0x69,0x74,0x6F
	.DB  0x72,0x69,0x6E,0x67,0x0,0x35,0x3A,0x20
	.DB  0x52,0x65,0x74,0x72,0x69,0x65,0x76,0x65
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x44,0x61,0x74,0x61,0x0,0x36,0x3A
	.DB  0x20,0x54,0x72,0x61,0x66,0x66,0x69,0x63
	.DB  0x20,0x4D,0x6F,0x6E,0x69,0x74,0x6F,0x72
	.DB  0x69,0x6E,0x67,0x0,0x44,0x69,0x73,0x74
	.DB  0x61,0x6E,0x63,0x65,0x3A,0x20,0x0,0x45
	.DB  0x72,0x72,0x6F,0x72,0x0,0x4E,0x6F,0x20
	.DB  0x4F,0x62,0x73,0x74,0x61,0x63,0x6C,0x65
	.DB  0x0,0x20,0x63,0x6D,0x20,0x0,0x43,0x6F
	.DB  0x75,0x6E,0x74,0x3A,0x20,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
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

	.DW  0x12
	.DW  _0xA+166
	.DW  _0x0*2+166

	.DW  0x12
	.DW  _0xA+184
	.DW  _0x0*2+184

	.DW  0x1F
	.DW  _0xA+202
	.DW  _0x0*2+202

	.DW  0x1F
	.DW  _0xA+233
	.DW  _0x0*2+233

	.DW  0x14
	.DW  _0x51
	.DW  _0x0*2+264

	.DW  0x02
	.DW  _0x51+20
	.DW  _0x0*2+94

	.DW  0x03
	.DW  _0x51+22
	.DW  _0x0*2+284

	.DW  0x1E
	.DW  _0x51+25
	.DW  _0x0*2+287

	.DW  0x1F
	.DW  _0x51+55
	.DW  _0x0*2+317

	.DW  0x1F
	.DW  _0x51+86
	.DW  _0x0*2+348

	.DW  0x1F
	.DW  _0x51+117
	.DW  _0x0*2+317

	.DW  0x20
	.DW  _0x51+148
	.DW  _0x0*2+379

	.DW  0x1F
	.DW  _0x51+180
	.DW  _0x0*2+317

	.DW  0x02
	.DW  _0x51+211
	.DW  _0x0*2+94

	.DW  0x13
	.DW  _0x51+213
	.DW  _0x0*2+411

	.DW  0x1F
	.DW  _0x51+232
	.DW  _0x0*2+430

	.DW  0x1D
	.DW  _0x51+263
	.DW  _0x0*2+461

	.DW  0x1F
	.DW  _0x51+292
	.DW  _0x0*2+430

	.DW  0x02
	.DW  _0x51+323
	.DW  _0x0*2+94

	.DW  0x13
	.DW  _0x51+325
	.DW  _0x0*2+411

	.DW  0x13
	.DW  _0x51+344
	.DW  _0x0*2+490

	.DW  0x19
	.DW  _0x51+363
	.DW  _0x0*2+509

	.DW  0x1F
	.DW  _0x51+388
	.DW  _0x0*2+317

	.DW  0x1D
	.DW  _0x51+419
	.DW  _0x0*2+461

	.DW  0x1F
	.DW  _0x51+448
	.DW  _0x0*2+317

	.DW  0x10
	.DW  _0x9F
	.DW  _0x0*2+534

	.DW  0x02
	.DW  _0x9F+16
	.DW  _0x0*2+94

	.DW  0x1D
	.DW  _0xAB
	.DW  _0x0*2+550

	.DW  0x16
	.DW  _0xAB+29
	.DW  _0x0*2+579

	.DW  0x1A
	.DW  _0xAB+51
	.DW  _0x0*2+601

	.DW  0x1A
	.DW  _0xAB+77
	.DW  _0x0*2+627

	.DW  0x19
	.DW  _0xAB+103
	.DW  _0x0*2+653

	.DW  0x16
	.DW  _0xAB+128
	.DW  _0x0*2+678

	.DW  0x02
	.DW  _previous_count_S0000013000
	.DW  _0xE8*2

	.DW  0x0B
	.DW  _0xE9
	.DW  _0x0*2+700

	.DW  0x06
	.DW  _0xE9+11
	.DW  _0x0*2+711

	.DW  0x0C
	.DW  _0xE9+17
	.DW  _0x0*2+717

	.DW  0x05
	.DW  _0xE9+29
	.DW  _0x0*2+729

	.DW  0x08
	.DW  _0xE9+34
	.DW  _0x0*2+734

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
;#define MENU_PAGE_COUNT 3
;#define US_ERROR -1       // Error indicator
;#define US_NO_OBSTACLE -2 // No obstacle indicator
;#define US_PORT PORTD     // Ultrasonic sensor connected to PORTB
;#define US_PIN PIND       // Ultrasonic PIN register
;#define US_DDR DDRD       // Ultrasonic data direction register
;#define US_TRIG_POS 5   // Trigger pin connected to PD5
;#define US_ECHO_POS 6   // Echo pin connected to PD6
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
; 0000 005B {

	.CSEG
_main:
; .FSTART _main
; 0000 005C     int i, j;
; 0000 005D     unsigned char st_counts;
; 0000 005E     KEY_DDR = 0xF0;
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 005F     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0060     KEY_PRT &= 0x0F;                  // ground all rows at once
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0061     MCUCR = 0x02;                     // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0062     GICR = (1 << INT0);               // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0063     BUZZER_DDR |= (1 << BUZZER_NUM);  // make buzzer pin output
	SBI  0x11,7
; 0000 0064     BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
	CBI  0x12,7
; 0000 0065     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	RCALL _USART_init
; 0000 0066     HCSR04Init(); // Initialize ultrasonic sensor
	RCALL _HCSR04Init
; 0000 0067     lcd_init();
	RCALL _lcd_init
; 0000 0068 
; 0000 0069 #asm("sei")           // enable interrupts
	sei
; 0000 006A     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 006B     while (1)
_0x4:
; 0000 006C     {
; 0000 006D         if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x7
; 0000 006E         {
; 0000 006F             show_menu();
	RCALL _show_menu
; 0000 0070         }
; 0000 0071         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x8
_0x7:
	CALL SUBOPT_0x0
	BRNE _0x9
; 0000 0072         {
; 0000 0073             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0074             lcd_gotoxy(1, 1);
; 0000 0075             lcd_print("1 : Submit Student Code");
	__POINTW2MN _0xA,0
	CALL SUBOPT_0x2
; 0000 0076             lcd_gotoxy(1, 2);
; 0000 0077             lcd_print("    press cancel to back");
	__POINTW2MN _0xA,24
	RCALL _lcd_print
; 0000 0078             while (stage == STAGE_ATTENDENC_MENU)
_0xB:
	CALL SUBOPT_0x0
	BREQ _0xB
; 0000 0079                 ;
; 0000 007A         }
; 0000 007B         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0xE
_0x9:
	CALL SUBOPT_0x3
	BRNE _0xF
; 0000 007C         {
; 0000 007D             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 007E             lcd_gotoxy(1, 1);
; 0000 007F             lcd_print("Enter your student code:");
	__POINTW2MN _0xA,49
	CALL SUBOPT_0x2
; 0000 0080             lcd_gotoxy(1, 2);
; 0000 0081             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0082             delay_us(100 * 16); // wait
; 0000 0083             while (stage == STAGE_SUBMIT_CODE)
_0x10:
	CALL SUBOPT_0x3
	BREQ _0x10
; 0000 0084                 ;
; 0000 0085             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x5
; 0000 0086             delay_us(100 * 16); // wait
; 0000 0087         }
; 0000 0088         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x13
_0xF:
	CALL SUBOPT_0x6
	BRNE _0x14
; 0000 0089         {
; 0000 008A             show_temperature();
	RCALL _show_temperature
; 0000 008B         }
; 0000 008C         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x15
_0x14:
	CALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x16
; 0000 008D         {
; 0000 008E             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 008F             lcd_gotoxy(1, 1);
; 0000 0090             lcd_print("Number of students : ");
	__POINTW2MN _0xA,74
	CALL SUBOPT_0x2
; 0000 0091             lcd_gotoxy(1, 2);
; 0000 0092             st_counts = read_byte_from_eeprom(0x0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _read_byte_from_eeprom
	MOV  R21,R30
; 0000 0093             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
; 0000 0094             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _itoa
; 0000 0095             lcd_print(buffer);
	CALL SUBOPT_0x9
; 0000 0096             delay_ms(1000);
; 0000 0097 
; 0000 0098             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x18:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x19
; 0000 0099             {
; 0000 009A                 memset(buffer, 0, 32);
	CALL SUBOPT_0x8
; 0000 009B                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x1B:
	__CPWRN 18,19,8
	BRGE _0x1C
; 0000 009C                 {
; 0000 009D                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	POP  R26
	POP  R27
	ST   X,R30
; 0000 009E                 }
	__ADDWRN 18,19,1
	RJMP _0x1B
_0x1C:
; 0000 009F                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00A0                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00A1                 lcd_gotoxy(1, 1);
; 0000 00A2                 lcd_print(buffer);
	CALL SUBOPT_0x9
; 0000 00A3                 delay_ms(1000);
; 0000 00A4             }
	__ADDWRN 16,17,1
	RJMP _0x18
_0x19:
; 0000 00A5 
; 0000 00A6             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00A7             lcd_gotoxy(1, 1);
; 0000 00A8             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xA,96
	RCALL _lcd_print
; 0000 00A9             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x1D:
	CALL SUBOPT_0x7
	BREQ _0x1D
; 0000 00AA                 ;
; 0000 00AB         }
; 0000 00AC         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x20
_0x16:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x21
; 0000 00AD         {
; 0000 00AE             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00AF             lcd_gotoxy(1, 1);
; 0000 00B0             lcd_print("Start Transferring...");
	__POINTW2MN _0xA,120
	RCALL _lcd_print
; 0000 00B1             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xB
	MOV  R21,R30
; 0000 00B2             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x23:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x24
; 0000 00B3             {
; 0000 00B4                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x26:
	__CPWRN 18,19,8
	BRGE _0x27
; 0000 00B5                 {
; 0000 00B6                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0xA
	MOV  R26,R30
	RCALL _USART_Transmit
; 0000 00B7                 }
	__ADDWRN 18,19,1
	RJMP _0x26
_0x27:
; 0000 00B8                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0000 00B9                 USART_Transmit('\r');
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0000 00BA                 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 00BB             }
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
; 0000 00BC             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00BD             lcd_gotoxy(1, 1);
; 0000 00BE             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xA,142
	CALL SUBOPT_0xC
; 0000 00BF             delay_ms(2000);
; 0000 00C0             stage = STAGE_INIT_MENU;
	RJMP _0xF4
; 0000 00C1         }
; 0000 00C2         else if (stage == STAGE_STUDENT_MANAGMENT)
_0x21:
	CALL SUBOPT_0xD
	BRNE _0x29
; 0000 00C3         {
; 0000 00C4             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00C5             lcd_gotoxy(1, 1);
; 0000 00C6             lcd_print("1: Search Student");
	__POINTW2MN _0xA,166
	CALL SUBOPT_0x2
; 0000 00C7             lcd_gotoxy(1, 2);
; 0000 00C8             lcd_print("2: Delete Student");
	__POINTW2MN _0xA,184
	RCALL _lcd_print
; 0000 00C9             while (stage == STAGE_STUDENT_MANAGMENT)
_0x2A:
	CALL SUBOPT_0xD
	BREQ _0x2A
; 0000 00CA                 ;
; 0000 00CB         }
; 0000 00CC         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x2D
_0x29:
	CALL SUBOPT_0xE
	BRNE _0x2E
; 0000 00CD         {
; 0000 00CE             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00CF             lcd_gotoxy(1, 1);
; 0000 00D0             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xA,202
	CALL SUBOPT_0x2
; 0000 00D1             lcd_gotoxy(1, 2);
; 0000 00D2             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 00D3             delay_us(100 * 16); // wait
; 0000 00D4             while (stage == STAGE_SEARCH_STUDENT)
_0x2F:
	CALL SUBOPT_0xE
	BREQ _0x2F
; 0000 00D5                 ;
; 0000 00D6             lcdCommand(0x0c);   // display on, cursor off
	CALL SUBOPT_0x5
; 0000 00D7             delay_us(100 * 16); // wait
; 0000 00D8         }
; 0000 00D9         else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0x32
_0x2E:
	CALL SUBOPT_0xF
	BRNE _0x33
; 0000 00DA         {
; 0000 00DB             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00DC             lcd_gotoxy(1, 1);
; 0000 00DD             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xA,233
	CALL SUBOPT_0x2
; 0000 00DE             lcd_gotoxy(1, 2);
; 0000 00DF             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 00E0             delay_us(100 * 16); // wait
; 0000 00E1             while (stage == STAGE_DELETE_STUDENT)
_0x34:
	CALL SUBOPT_0xF
	BREQ _0x34
; 0000 00E2                 ;
; 0000 00E3             lcdCommand(0x0c); // display on, cursor off
	CALL SUBOPT_0x5
; 0000 00E4             delay_us(100 * 16);
; 0000 00E5         }
; 0000 00E6         else if(stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x37
_0x33:
	CALL SUBOPT_0x10
	BRNE _0x38
; 0000 00E7         {
; 0000 00E8             startSonar();
	RCALL _startSonar
; 0000 00E9             stage = STAGE_INIT_MENU;
_0xF4:
	CLR  R4
	CLR  R5
; 0000 00EA         }
; 0000 00EB     }
_0x38:
_0x37:
_0x32:
_0x2D:
_0x20:
_0x15:
_0x13:
_0xE:
_0x8:
	RJMP _0x4
; 0000 00EC }
_0x39:
	RJMP _0x39
; .FEND

	.DSEG
_0xA:
	.BYTE 0x108
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 00F0 {

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
; 0000 00F1     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 00F2     int i;
; 0000 00F3 
; 0000 00F4     // detect the key
; 0000 00F5     while (1)
	SBIW R28,2
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	i -> Y+6
; 0000 00F6     {
; 0000 00F7         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x11
; 0000 00F8         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 00F9         if (colloc != 0x0F)        // column detected
	BREQ _0x3D
; 0000 00FA         {
; 0000 00FB             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 00FC             break;      // exit while loop
	RJMP _0x3C
; 0000 00FD         }
; 0000 00FE         KEY_PRT = 0xDF;            // ground row 1
_0x3D:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x11
; 0000 00FF         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0100         if (colloc != 0x0F)        // column detected
	BREQ _0x3E
; 0000 0101         {
; 0000 0102             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 0103             break;      // exit while loop
	RJMP _0x3C
; 0000 0104         }
; 0000 0105         KEY_PRT = 0xBF;            // ground row 2
_0x3E:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x11
; 0000 0106         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0107         if (colloc != 0x0F)        // column detected
	BREQ _0x3F
; 0000 0108         {
; 0000 0109             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 010A             break;      // exit while loop
	RJMP _0x3C
; 0000 010B         }
; 0000 010C         KEY_PRT = 0x7F;            // ground row 3
_0x3F:
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 010D         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 010E         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 010F         break;                     // exit while loop
; 0000 0110     }
_0x3C:
; 0000 0111     // check column and send result to Port D
; 0000 0112     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x40
; 0000 0113         cl = 0;
	LDI  R19,LOW(0)
; 0000 0114     else if (colloc == 0x0D)
	RJMP _0x41
_0x40:
	CPI  R17,13
	BRNE _0x42
; 0000 0115         cl = 1;
	LDI  R19,LOW(1)
; 0000 0116     else if (colloc == 0x0B)
	RJMP _0x43
_0x42:
	CPI  R17,11
	BRNE _0x44
; 0000 0117         cl = 2;
	LDI  R19,LOW(2)
; 0000 0118     else
	RJMP _0x45
_0x44:
; 0000 0119         cl = 3;
	LDI  R19,LOW(3)
; 0000 011A 
; 0000 011B     KEY_PRT &= 0x0F; // ground all rows at once
_0x45:
_0x43:
_0x41:
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 011C 
; 0000 011D     // inside menu level 1
; 0000 011E     if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0x46
; 0000 011F     {
; 0000 0120         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x12
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 0121         {
; 0000 0122         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4A
; 0000 0123             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0124             break;
	RJMP _0x49
; 0000 0125 
; 0000 0126         case OPTION_TEMPERATURE_MONITORING:
_0x4A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4B
; 0000 0127             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0128             break;
	RJMP _0x49
; 0000 0129         case OPTION_VIEW_PRESENT_STUDENTS:
_0x4B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4C
; 0000 012A             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 012B             break;
	RJMP _0x49
; 0000 012C         case OPTION_RETRIEVE_STUDENT_DATA:
_0x4C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4D
; 0000 012D             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 012E             break;
	RJMP _0x49
; 0000 012F         case OPTION_STUDENT_MANAGEMENT:
_0x4D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4E
; 0000 0130             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0131             break;
	RJMP _0x49
; 0000 0132         case OPTION_TRAFFIC_MONITORING:
_0x4E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4F
; 0000 0133             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
; 0000 0134             break;
	RJMP _0x49
; 0000 0135         case 9:
_0x4F:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x52
; 0000 0136 #asm("cli") // disable interrupts
	cli
; 0000 0137 
; 0000 0138             lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 0139             lcd_gotoxy(1, 1);
; 0000 013A             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x51,0
	RCALL _lcd_print
; 0000 013B             clear_eeprom();
	RCALL _clear_eeprom
; 0000 013C #asm("sei") // enable interrupts
	sei
; 0000 013D             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 013E         default:
_0x52:
; 0000 013F             break;
; 0000 0140         }
_0x49:
; 0000 0141 
; 0000 0142         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x53
; 0000 0143         {
; 0000 0144             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x54
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,1
	RJMP _0x55
_0x54:
	LDI  R30,LOW(2)
_0x55:
	MOV  R7,R30
; 0000 0145         }
; 0000 0146         if (keypad[rowloc][cl] == 'R')
_0x53:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x57
; 0000 0147         {
; 0000 0148             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	MOV  R7,R30
; 0000 0149         }
; 0000 014A     }
_0x57:
; 0000 014B     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x58
_0x46:
	CALL SUBOPT_0x0
	BRNE _0x59
; 0000 014C     {
; 0000 014D         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x12
	LD   R30,X
	LDI  R31,0
; 0000 014E         {
; 0000 014F         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0150             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0151             break;
	RJMP _0x5C
; 0000 0152         case '1':
_0x5D:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0153             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
; 0000 0154             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0155             break;
; 0000 0156         default:
_0x5F:
; 0000 0157             break;
; 0000 0158         }
_0x5C:
; 0000 0159     }
; 0000 015A     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x60
_0x59:
	CALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x61
; 0000 015B     {
; 0000 015C 
; 0000 015D         if ((keypad[rowloc][cl] - '0') < 10)
	CALL SUBOPT_0x12
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x62
; 0000 015E         {
; 0000 015F             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x13
	SBIW R30,31
	BRSH _0x63
; 0000 0160             {
; 0000 0161                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 0162                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x16
; 0000 0163                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0164             }
; 0000 0165         }
_0x63:
; 0000 0166         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x64
_0x62:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x65
; 0000 0167         {
; 0000 0168             buffer_len = strlen(buffer);
	CALL SUBOPT_0x13
	MOV  R21,R30
; 0000 0169             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x66
; 0000 016A             {
; 0000 016B                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x17
; 0000 016C                 lcdCommand(0x10);
; 0000 016D                 lcd_print(" ");
	__POINTW2MN _0x51,20
	CALL SUBOPT_0x18
; 0000 016E                 lcdCommand(0x10);
; 0000 016F             }
; 0000 0170         }
_0x66:
; 0000 0171         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x67
_0x65:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0x68
; 0000 0172         {
; 0000 0173 
; 0000 0174 #asm("cli")
	cli
; 0000 0175 
; 0000 0176             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 0177                 strlen(buffer) != 8)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x51,22
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x6A
	CALL SUBOPT_0x13
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x69
_0x6A:
; 0000 0178             {
; 0000 0179 
; 0000 017A                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 017B                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 017C                 lcd_gotoxy(1, 1);
; 0000 017D                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x51,25
	CALL SUBOPT_0x2
; 0000 017E                 lcd_gotoxy(1, 2);
; 0000 017F                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x51,55
	CALL SUBOPT_0xC
; 0000 0180                 delay_ms(2000);
; 0000 0181                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
	CBI  0x12,7
; 0000 0182             }
; 0000 0183             else if (search_student_code() > 0)
	RJMP _0x6C
_0x69:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x6D
; 0000 0184             {
; 0000 0185                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0186                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0187                 lcd_gotoxy(1, 1);
; 0000 0188                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x51,86
	CALL SUBOPT_0x2
; 0000 0189                 lcd_gotoxy(1, 2);
; 0000 018A                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x51,117
	CALL SUBOPT_0xC
; 0000 018B                 delay_ms(2000);
; 0000 018C                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
	CBI  0x12,7
; 0000 018D             }
; 0000 018E             else
	RJMP _0x6E
_0x6D:
; 0000 018F             {
; 0000 0190                 // save the buffer to EEPROM
; 0000 0191                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xB
	MOV  R18,R30
; 0000 0192                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x70:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,8
	BRGE _0x71
; 0000 0193                 {
; 0000 0194                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R18
	CALL SUBOPT_0x19
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
; 0000 0195                 }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x70
_0x71:
; 0000 0196                 write_byte_to_eeprom(0x0, st_counts + 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0197 
; 0000 0198                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0199                 lcd_gotoxy(1, 1);
; 0000 019A                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x51,148
	CALL SUBOPT_0x2
; 0000 019B                 lcd_gotoxy(1, 2);
; 0000 019C                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x51,180
	CALL SUBOPT_0xC
; 0000 019D                 delay_ms(2000);
; 0000 019E             }
_0x6E:
_0x6C:
; 0000 019F             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
; 0000 01A0 #asm("sei")
	sei
; 0000 01A1             stage = STAGE_ATTENDENC_MENU;
	RJMP _0xF5
; 0000 01A2         }
; 0000 01A3         else if (keypad[rowloc][cl] == 'C')
_0x68:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x73
; 0000 01A4             stage = STAGE_ATTENDENC_MENU;
_0xF5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01A5     }
_0x73:
_0x67:
_0x64:
; 0000 01A6     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x74
_0x61:
	CALL SUBOPT_0x6
	BRNE _0x75
; 0000 01A7     {
; 0000 01A8 
; 0000 01A9         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x76
; 0000 01AA             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01AB     }
_0x76:
; 0000 01AC     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x77
_0x75:
	CALL SUBOPT_0x7
	BRNE _0x78
; 0000 01AD     {
; 0000 01AE         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x79
; 0000 01AF             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01B0     }
_0x79:
; 0000 01B1     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x7A
_0x78:
	CALL SUBOPT_0xD
	BRNE _0x7B
; 0000 01B2     {
; 0000 01B3         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x7C
; 0000 01B4             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01B5         else if (keypad[rowloc][cl] == '1')
	RJMP _0x7D
_0x7C:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0x7E
; 0000 01B6             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0xF6
; 0000 01B7         else if (keypad[rowloc][cl] == '2')
_0x7E:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0x80
; 0000 01B8             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
_0xF6:
	MOVW R4,R30
; 0000 01B9     }
_0x80:
_0x7D:
; 0000 01BA     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x81
_0x7B:
	CALL SUBOPT_0xE
	BREQ PC+2
	RJMP _0x82
; 0000 01BB     {
; 0000 01BC         if ((keypad[rowloc][cl] - '0') < 10)
	CALL SUBOPT_0x12
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x83
; 0000 01BD         {
; 0000 01BE             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x13
	SBIW R30,31
	BRSH _0x84
; 0000 01BF             {
; 0000 01C0                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 01C1                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x16
; 0000 01C2                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 01C3             }
; 0000 01C4         }
_0x84:
; 0000 01C5         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x85
_0x83:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x86
; 0000 01C6         {
; 0000 01C7             buffer_len = strlen(buffer);
	CALL SUBOPT_0x13
	MOV  R21,R30
; 0000 01C8             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x87
; 0000 01C9             {
; 0000 01CA                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x17
; 0000 01CB                 lcdCommand(0x10);
; 0000 01CC                 lcd_print(" ");
	__POINTW2MN _0x51,211
	CALL SUBOPT_0x18
; 0000 01CD                 lcdCommand(0x10);
; 0000 01CE             }
; 0000 01CF         }
_0x87:
; 0000 01D0         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x88
_0x86:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x89
; 0000 01D1         {
; 0000 01D2             // search from eeprom data
; 0000 01D3             unsigned char result = search_student_code();
; 0000 01D4 
; 0000 01D5             if (result > 0)
	CALL SUBOPT_0x1A
;	i -> Y+7
;	result -> Y+0
	BRLO _0x8A
; 0000 01D6             {
; 0000 01D7                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01D8                 lcd_gotoxy(1, 1);
; 0000 01D9                 lcd_print("Student Code Found");
	__POINTW2MN _0x51,213
	CALL SUBOPT_0x2
; 0000 01DA                 lcd_gotoxy(1, 2);
; 0000 01DB                 lcd_print("You Will Back Menu In 5 Second");
	__POINTW2MN _0x51,232
	RJMP _0xF7
; 0000 01DC                 delay_ms(5000);
; 0000 01DD             }
; 0000 01DE             else
_0x8A:
; 0000 01DF             {
; 0000 01E0                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01E1                 lcd_gotoxy(1, 1);
; 0000 01E2                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x51,263
	CALL SUBOPT_0x2
; 0000 01E3                 lcd_gotoxy(1, 2);
; 0000 01E4                 lcd_print("You Will Back Menu In 5 Second");
	__POINTW2MN _0x51,292
_0xF7:
	RCALL _lcd_print
; 0000 01E5                 delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 01E6             }
; 0000 01E7             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
; 0000 01E8             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 01E9         }
	ADIW R28,1
; 0000 01EA         else if (keypad[rowloc][cl] == 'C')
	RJMP _0x8C
_0x89:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x8D
; 0000 01EB             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 01EC     }
_0x8D:
_0x8C:
_0x88:
_0x85:
; 0000 01ED     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0x8E
_0x82:
	CALL SUBOPT_0xF
	BREQ PC+2
	RJMP _0x8F
; 0000 01EE     {
; 0000 01EF         if ((keypad[rowloc][cl] - '0') < 10)
	CALL SUBOPT_0x12
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x90
; 0000 01F0         {
; 0000 01F1             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x13
	SBIW R30,31
	BRSH _0x91
; 0000 01F2             {
; 0000 01F3                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 01F4                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x16
; 0000 01F5                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 01F6             }
; 0000 01F7         }
_0x91:
; 0000 01F8         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x92
_0x90:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x93
; 0000 01F9         {
; 0000 01FA             buffer_len = strlen(buffer);
	CALL SUBOPT_0x13
	MOV  R21,R30
; 0000 01FB             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x94
; 0000 01FC             {
; 0000 01FD                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x17
; 0000 01FE                 lcdCommand(0x10);
; 0000 01FF                 lcd_print(" ");
	__POINTW2MN _0x51,323
	CALL SUBOPT_0x18
; 0000 0200                 lcdCommand(0x10);
; 0000 0201             }
; 0000 0202         }
_0x94:
; 0000 0203         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x95
_0x93:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0x96
; 0000 0204         {
; 0000 0205             // search from eeprom data
; 0000 0206             unsigned char result = search_student_code();
; 0000 0207 
; 0000 0208             if (result > 0)
	CALL SUBOPT_0x1A
;	i -> Y+7
;	result -> Y+0
	BRLO _0x97
; 0000 0209             {
; 0000 020A                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 020B                 lcd_gotoxy(1, 1);
; 0000 020C                 lcd_print("Student Code Found");
	__POINTW2MN _0x51,325
	CALL SUBOPT_0x2
; 0000 020D                 lcd_gotoxy(1, 2);
; 0000 020E                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x51,344
	RCALL _lcd_print
; 0000 020F                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 0210                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0211                 lcd_gotoxy(1, 1);
; 0000 0212                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x51,363
	CALL SUBOPT_0x2
; 0000 0213                 lcd_gotoxy(1, 2);
; 0000 0214                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x51,388
	RJMP _0xF8
; 0000 0215                 delay_ms(2000);
; 0000 0216             }
; 0000 0217             else
_0x97:
; 0000 0218             {
; 0000 0219                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 021A                 lcd_gotoxy(1, 1);
; 0000 021B                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x51,419
	CALL SUBOPT_0x2
; 0000 021C                 lcd_gotoxy(1, 2);
; 0000 021D                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x51,448
_0xF8:
	RCALL _lcd_print
; 0000 021E                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 021F             }
; 0000 0220             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
; 0000 0221             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0222         }
	ADIW R28,1
; 0000 0223     }
_0x96:
_0x95:
_0x92:
; 0000 0224     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0x99
_0x8F:
	CALL SUBOPT_0x10
	BRNE _0x9A
; 0000 0225     {
; 0000 0226         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9B
; 0000 0227             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0228     }
_0x9B:
; 0000 0229 }
_0x9A:
_0x99:
_0x8E:
_0x81:
_0x7A:
_0x77:
_0x74:
_0x60:
_0x58:
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
_0x51:
	.BYTE 0x1DF
;
;void lcdCommand(unsigned char cmnd)
; 0000 022C {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 022D     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x1B
;	cmnd -> Y+0
; 0000 022E     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x18,0
; 0000 022F     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x1C
; 0000 0230     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0231     delay_us(1 * 16);          // wait to make EN wider
; 0000 0232     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0233     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 0234     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x1D
; 0000 0235     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0236     delay_us(1 * 16);          // wait to make EN wider
; 0000 0237     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0238 }
	RJMP _0x20A0004
; .FEND
;void lcdData(unsigned char data)
; 0000 023A {
_lcdData:
; .FSTART _lcdData
; 0000 023B     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x1B
;	data -> Y+0
; 0000 023C     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x18,0
; 0000 023D     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x1C
; 0000 023E     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 023F     delay_us(1 * 16);          // wait to make EN wider
; 0000 0240     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0241     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x1D
; 0000 0242     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0243     delay_us(1 * 16);          // wait to make EN wider
; 0000 0244     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0245 }
	RJMP _0x20A0004
; .FEND
;void lcd_init()
; 0000 0247 {
_lcd_init:
; .FSTART _lcd_init
; 0000 0248     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0249     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x18,2
; 0000 024A     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 024B     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x1E
; 0000 024C     delay_us(100 * 16);        // wait
; 0000 024D     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x1E
; 0000 024E     delay_us(100 * 16);        // wait
; 0000 024F     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x1E
; 0000 0250     delay_us(100 * 16);        // wait
; 0000 0251     lcdCommand(0x0c);          // display on, cursor off
	CALL SUBOPT_0x5
; 0000 0252     delay_us(100 * 16);        // wait
; 0000 0253     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0254     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 0255     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x1E
; 0000 0256     delay_us(100 * 16);
; 0000 0257 }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 0259 {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 025A     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 025B     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0x1E
; 0000 025C     delay_us(100 * 16);
; 0000 025D }
	ADIW R28,6
	RET
; .FEND
;void lcd_print(char *str)
; 0000 025F {
_lcd_print:
; .FSTART _lcd_print
; 0000 0260     unsigned char i = 0;
; 0000 0261     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x9C:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x9E
; 0000 0262     {
; 0000 0263         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 0264         i++;
	SUBI R17,-1
; 0000 0265     }
	RJMP _0x9C
_0x9E:
; 0000 0266 }
	LDD  R17,Y+0
	RJMP _0x20A0005
; .FEND
;
;void show_temperature()
; 0000 0269 {
_show_temperature:
; .FSTART _show_temperature
; 0000 026A     unsigned char temperatureVal = 0;
; 0000 026B     unsigned char temperatureRep[3];
; 0000 026C 
; 0000 026D     ADMUX = 0xE0;
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 026E     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 026F 
; 0000 0270     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0271     lcd_gotoxy(1, 1);
; 0000 0272     lcd_print("temperature(C):");
	__POINTW2MN _0x9F,0
	RCALL _lcd_print
; 0000 0273 
; 0000 0274     while (stage == STAGE_TEMPERATURE_MONITORING)
_0xA0:
	CALL SUBOPT_0x6
	BRNE _0xA2
; 0000 0275     {
; 0000 0276         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 0277         while ((ADCSRA & (1 << ADIF)) == 0)
_0xA3:
	SBIS 0x6,4
; 0000 0278             ;
	RJMP _0xA3
; 0000 0279         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0xA6
; 0000 027A         {
; 0000 027B             temperatureVal = ADCH;
	IN   R17,5
; 0000 027C             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 027D             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 027E             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 027F             lcd_print(" ");
	__POINTW2MN _0x9F,16
	RCALL _lcd_print
; 0000 0280         }
; 0000 0281         delay_ms(500);
_0xA6:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0282     }
	RJMP _0xA0
_0xA2:
; 0000 0283 
; 0000 0284     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0285 }
	LDD  R17,Y+0
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x9F:
	.BYTE 0x12
;
;void show_menu()
; 0000 0288 {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 0289 
; 0000 028A     while (stage == STAGE_INIT_MENU)
_0xA7:
	MOV  R0,R4
	OR   R0,R5
	BRNE _0xA9
; 0000 028B     {
; 0000 028C         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 028D         lcd_gotoxy(1, 1);
; 0000 028E         if (page_num == 0)
	TST  R7
	BRNE _0xAA
; 0000 028F         {
; 0000 0290             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0xAB,0
	CALL SUBOPT_0x2
; 0000 0291             lcd_gotoxy(1, 2);
; 0000 0292             lcd_print("2: Student Management");
	__POINTW2MN _0xAB,29
	RCALL _lcd_print
; 0000 0293             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0xAC:
	TST  R7
	BRNE _0xAF
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
; 0000 0294                 ;
	RJMP _0xAC
_0xAE:
; 0000 0295         }
; 0000 0296         else if (page_num == 1)
	RJMP _0xB1
_0xAA:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xB2
; 0000 0297         {
; 0000 0298             lcd_print("3: View Present Students ");
	__POINTW2MN _0xAB,51
	CALL SUBOPT_0x2
; 0000 0299             lcd_gotoxy(1, 2);
; 0000 029A             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0xAB,77
	RCALL _lcd_print
; 0000 029B             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0xB3:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xB6
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xB7
_0xB6:
	RJMP _0xB5
_0xB7:
; 0000 029C                 ;
	RJMP _0xB3
_0xB5:
; 0000 029D         }
; 0000 029E         else if (page_num == 2)
	RJMP _0xB8
_0xB2:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xB9
; 0000 029F         {
; 0000 02A0             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0xAB,103
	CALL SUBOPT_0x2
; 0000 02A1             lcd_gotoxy(1, 2);
; 0000 02A2             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0xAB,128
	RCALL _lcd_print
; 0000 02A3             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0xBA:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xBD
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
; 0000 02A4                 ;
	RJMP _0xBA
_0xBC:
; 0000 02A5         }
; 0000 02A6     }
_0xB9:
_0xB8:
_0xB1:
	RJMP _0xA7
_0xA9:
; 0000 02A7 }
	RET
; .FEND

	.DSEG
_0xAB:
	.BYTE 0x96
;
;void clear_eeprom()
; 0000 02AA {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 02AB     unsigned int i;
; 0000 02AC 
; 0000 02AD     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0xC0:
	__CPWRN 16,17,1024
	BRSH _0xC1
; 0000 02AE     {
; 0000 02AF         // Wait for the previous write to complete
; 0000 02B0         while (EECR & (1 << EEWE))
_0xC2:
	SBIC 0x1C,1
; 0000 02B1             ;
	RJMP _0xC2
; 0000 02B2 
; 0000 02B3         // Set up address registers
; 0000 02B4         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 02B5         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 02B6 
; 0000 02B7         // Set up data register
; 0000 02B8         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 02B9 
; 0000 02BA         // Enable write
; 0000 02BB         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 02BC         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 02BD     }
	__ADDWRN 16,17,1
	RJMP _0xC0
_0xC1:
; 0000 02BE }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 02C1 {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 02C2     unsigned char x;
; 0000 02C3     // Wait for the previous write to complete
; 0000 02C4     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0xC5:
	SBIC 0x1C,1
; 0000 02C5         ;
	RJMP _0xC5
; 0000 02C6 
; 0000 02C7     // Set up address registers
; 0000 02C8     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x1F
; 0000 02C9     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 02CA     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 02CB     x = EEDR;
	IN   R17,29
; 0000 02CC     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0005
; 0000 02CD }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 02D0 {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 02D1     // Wait for the previous write to complete
; 0000 02D2     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0xC8:
	SBIC 0x1C,1
; 0000 02D3         ;
	RJMP _0xC8
; 0000 02D4 
; 0000 02D5     // Set up address registers
; 0000 02D6     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x1F
; 0000 02D7     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 02D8 
; 0000 02D9     // Set up data register
; 0000 02DA     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 02DB 
; 0000 02DC     // Enable write
; 0000 02DD     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 02DE     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 02DF }
_0x20A0005:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 02E2 {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 02E3     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0xCB:
	SBIS 0xB,5
; 0000 02E4         ;
	RJMP _0xCB
; 0000 02E5     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 02E6 }
_0x20A0004:
	ADIW R28,1
	RET
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 02E9 {
_USART_init:
; .FSTART _USART_init
; 0000 02EA     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 02EB     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 02EC     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 02ED     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 02EE }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 02F1 {
_search_student_code:
; .FSTART _search_student_code
; 0000 02F2     unsigned char st_counts, i, j;
; 0000 02F3     char temp[10];
; 0000 02F4 
; 0000 02F5     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0xB
	MOV  R17,R30
; 0000 02F6 
; 0000 02F7     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0xCF:
	CP   R16,R17
	BRSH _0xD0
; 0000 02F8     {
; 0000 02F9         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 02FA         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0xD2:
	CPI  R19,8
	BRSH _0xD3
; 0000 02FB         {
; 0000 02FC             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
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
	CALL SUBOPT_0x19
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 02FD         }
	SUBI R19,-1
	RJMP _0xD2
_0xD3:
; 0000 02FE         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 02FF         if (strncmp(temp, buffer , 8) == 0)
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
	BRNE _0xD4
; 0000 0300             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20A0003
; 0000 0301     }
_0xD4:
	SUBI R16,-1
	RJMP _0xCF
_0xD0:
; 0000 0302 
; 0000 0303     return 0;
	LDI  R30,LOW(0)
_0x20A0003:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 0304 }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 0307 {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 0308     unsigned char st_counts, i, j;
; 0000 0309     unsigned char temp;
; 0000 030A 
; 0000 030B     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0xB
	MOV  R17,R30
; 0000 030C 
; 0000 030D     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0xD6:
	CP   R17,R16
	BRLO _0xD7
; 0000 030E     {
; 0000 030F         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0xD9:
	CPI  R19,8
	BRSH _0xDA
; 0000 0310         {
; 0000 0311             temp = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0x19
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	MOV  R18,R30
; 0000 0312             write_byte_to_eeprom(j + ((i) * 8), temp);
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
; 0000 0313         }
	SUBI R19,-1
	RJMP _0xD9
_0xDA:
; 0000 0314     }
	SUBI R16,-1
	RJMP _0xD6
_0xD7:
; 0000 0315     write_byte_to_eeprom(0x0, st_counts - 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0316 }
	CALL __LOADLOCR4
	JMP  _0x20A0001
; .FEND
;
;void HCSR04Init()
; 0000 0319 {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 031A     US_DDR |= (1 << US_TRIG_POS); // Trigger pin as output
	SBI  0x11,5
; 0000 031B     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 031C }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 031F {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 0320     US_PORT |= (1 << US_TRIG_POS); // Set trigger pin high
	SBI  0x12,5
; 0000 0321     delay_us(15);                  // Wait for 15 microseconds
	__DELAY_USB 40
; 0000 0322     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 0323 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 0326 {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 0327     uint32_t i, result;
; 0000 0328 
; 0000 0329     // Wait for rising edge on Echo pin
; 0000 032A     for (i = 0; i < 600000; i++) {
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0xDC:
	CALL SUBOPT_0x20
	BRSH _0xDD
; 0000 032B         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 032C             continue;
	RJMP _0xDB
; 0000 032D         else
; 0000 032E             break;
	RJMP _0xDD
; 0000 032F     }
_0xDB:
	CALL SUBOPT_0x21
	RJMP _0xDC
_0xDD:
; 0000 0330 
; 0000 0331     if (i == 600000)
	CALL SUBOPT_0x20
	BRNE _0xE0
; 0000 0332         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
; 0000 0333 
; 0000 0334     // Start timer with prescaler 8
; 0000 0335     TCCR1A = 0x00;
_0xE0:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0336     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0337     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0338 
; 0000 0339     // Wait for falling edge on Echo pin
; 0000 033A     for (i = 0; i < 600000; i++) {
	__CLRD1S 4
_0xE2:
	CALL SUBOPT_0x20
	BRSH _0xE3
; 0000 033B         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 033C             break;  // Falling edge detected
	RJMP _0xE3
; 0000 033D         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0xE5
; 0000 033E             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0002
; 0000 033F     }
_0xE5:
	CALL SUBOPT_0x21
	RJMP _0xE2
_0xE3:
; 0000 0340 
; 0000 0341     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 0342     TCCR1B = 0x00; // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0343 
; 0000 0344     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0xE6
; 0000 0345         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0002
; 0000 0346     else
_0xE6:
; 0000 0347         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
; 0000 0348 }
_0x20A0002:
	ADIW R28,8
	RET
; .FEND
;
;void startSonar()
; 0000 034B {
_startSonar:
; .FSTART _startSonar
; 0000 034C     char numberString[16];
; 0000 034D     uint16_t pulseWidth;    // Pulse width from echo
; 0000 034E     int distance, previous_distance = -1;
; 0000 034F     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 0350 
; 0000 0351     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x1
; 0000 0352     lcd_gotoxy(1, 1);
; 0000 0353     lcd_print("Distance: ");
	__POINTW2MN _0xE9,0
	RCALL _lcd_print
; 0000 0354 
; 0000 0355     while(stage == STAGE_TRAFFIC_MONITORING){
_0xEA:
	CALL SUBOPT_0x10
	BREQ PC+2
	RJMP _0xEC
; 0000 0356         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 0357         pulseWidth = GetPulseWidth();  // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 0358 
; 0000 0359         if (pulseWidth == US_ERROR) {
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xED
; 0000 035A             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 035B             lcd_gotoxy(1, 1);
; 0000 035C             lcd_print("Error");        // Display error message
	__POINTW2MN _0xE9,11
	RJMP _0xF9
; 0000 035D         } else if (pulseWidth == US_NO_OBSTACLE) {
_0xED:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xEF
; 0000 035E             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 035F             lcd_gotoxy(1, 1);
; 0000 0360             lcd_print("No Obstacle");  // Display no obstacle message
	__POINTW2MN _0xE9,17
	RJMP _0xF9
; 0000 0361         } else {
_0xEF:
; 0000 0362             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 0363 
; 0000 0364             if(distance != previous_distance){
	__CPWRR 20,21,18,19
	BREQ _0xF1
; 0000 0365                 previous_distance = distance;
	MOVW R20,R18
; 0000 0366                 // Display distance on LCD
; 0000 0367                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0368                 lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0369                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 036A                 lcd_print(" cm ");
	__POINTW2MN _0xE9,29
	RCALL _lcd_print
; 0000 036B             }
; 0000 036C             // Counting logic based on distance
; 0000 036D             if (distance < 6) {
_0xF1:
	__CPWRN 18,19,6
	BRGE _0xF2
; 0000 036E                 US_count++;  // Increment count if distance is below threshold
	INC  R6
; 0000 036F             }
; 0000 0370 
; 0000 0371 
; 0000 0372             // Update count on LCD only if it changes
; 0000 0373             if (US_count != previous_count) {
_0xF2:
	LDS  R30,_previous_count_S0000013000
	LDS  R31,_previous_count_S0000013000+1
	MOV  R26,R6
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xF3
; 0000 0374                 previous_count = US_count;
	MOV  R30,R6
	LDI  R31,0
	STS  _previous_count_S0000013000,R30
	STS  _previous_count_S0000013000+1,R31
; 0000 0375                 lcd_gotoxy(1, 2); // Move to second line
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0376                 itoa(US_count, numberString);
	MOV  R30,R6
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0377                 lcd_print("Count: ");
	__POINTW2MN _0xE9,34
	RCALL _lcd_print
; 0000 0378                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0xF9:
	RCALL _lcd_print
; 0000 0379             }
; 0000 037A         }
_0xF3:
; 0000 037B         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 037C     }
	RJMP _0xEA
_0xEC:
; 0000 037D }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0xE9:
	.BYTE 0x2A

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:135 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	CALL _lcdCommand
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:77 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(15)
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(12)
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x8:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:231 WORDS
SUBOPT_0x12:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
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
SUBOPT_0x1C:
	CBI  0x18,1
	SBI  0x18,2
	__DELAY_USB 43
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1D:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	CALL _lcdCommand
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x20:
	__GETD2S 4
	__CPD2N 0x927C0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
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
