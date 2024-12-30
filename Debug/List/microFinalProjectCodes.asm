
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

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x37,0x38,0x39,0x4F,0x34,0x35,0x36,0x44
	.DB  0x31,0x32,0x33,0x43,0x4C,0x30,0x52,0x45
_0x4:
	.DB  0x64,0xF
_0x6:
	.DB  LOW(_0x5),HIGH(_0x5),LOW(_0x5+4),HIGH(_0x5+4),LOW(_0x5+8),HIGH(_0x5+8),LOW(_0x5+12),HIGH(_0x5+12)
	.DB  LOW(_0x5+16),HIGH(_0x5+16),LOW(_0x5+20),HIGH(_0x5+20),LOW(_0x5+24),HIGH(_0x5+24)
_0x149:
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
	.DB  0x68,0x20,0x43,0x61,0x72,0x64,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x79,0x6F,0x75
	.DB  0x72,0x20,0x73,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x63,0x6F,0x64,0x65,0x3A,0x0
	.DB  0x42,0x72,0x69,0x6E,0x67,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x63,0x61,0x72,0x64,0x20
	.DB  0x6E,0x65,0x61,0x72,0x20,0x64,0x65,0x76
	.DB  0x69,0x63,0x65,0x3A,0x0,0x34,0x30,0x0
	.DB  0x49,0x6E,0x76,0x61,0x6C,0x69,0x64,0x20
	.DB  0x43,0x61,0x72,0x64,0x0,0x44,0x75,0x70
	.DB  0x6C,0x69,0x63,0x61,0x74,0x65,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x0,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x61,0x64,0x64,0x65
	.DB  0x64,0x20,0x77,0x69,0x74,0x68,0x20,0x49
	.DB  0x44,0x3A,0x0,0x4E,0x75,0x6D,0x62,0x65
	.DB  0x72,0x20,0x6F,0x66,0x20,0x73,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x73,0x20,0x3A,0x20
	.DB  0x0,0x50,0x72,0x65,0x73,0x73,0x20,0x43
	.DB  0x61,0x6E,0x63,0x65,0x6C,0x20,0x54,0x6F
	.DB  0x20,0x47,0x6F,0x20,0x42,0x61,0x63,0x6B
	.DB  0x0,0x53,0x74,0x61,0x72,0x74,0x20,0x54
	.DB  0x72,0x61,0x6E,0x73,0x66,0x65,0x72,0x72
	.DB  0x69,0x6E,0x67,0x2E,0x2E,0x2E,0x0,0x55
	.DB  0x73,0x61,0x72,0x74,0x20,0x54,0x72,0x61
	.DB  0x6E,0x73,0x6D,0x69,0x74,0x20,0x46,0x69
	.DB  0x6E,0x69,0x73,0x68,0x65,0x64,0x0,0x31
	.DB  0x3A,0x20,0x53,0x65,0x61,0x72,0x63,0x68
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x0,0x32,0x3A,0x20,0x44,0x65,0x6C,0x65
	.DB  0x74,0x65,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x46,0x6F
	.DB  0x72,0x20,0x53,0x65,0x61,0x72,0x63,0x68
	.DB  0x3A,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x43,0x6F,0x64,0x65,0x20,0x46,0x6F,0x72
	.DB  0x20,0x44,0x65,0x6C,0x65,0x74,0x65,0x3A
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x53
	.DB  0x65,0x63,0x72,0x65,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x20,0x28,0x6F,0x72,0x20,0x63
	.DB  0x61,0x6E,0x63,0x65,0x6C,0x29,0x0,0x31
	.DB  0x20,0x3A,0x20,0x43,0x6C,0x65,0x61,0x72
	.DB  0x20,0x45,0x45,0x50,0x52,0x4F,0x4D,0x0
	.DB  0x20,0x20,0x20,0x20,0x70,0x72,0x65,0x73
	.DB  0x73,0x20,0x63,0x61,0x6E,0x63,0x65,0x6C
	.DB  0x20,0x74,0x6F,0x20,0x62,0x61,0x63,0x6B
	.DB  0x0,0x4C,0x6F,0x67,0x6F,0x75,0x74,0x20
	.DB  0x2E,0x2E,0x2E,0x0,0x47,0x6F,0x69,0x6E
	.DB  0x67,0x20,0x54,0x6F,0x20,0x41,0x64,0x6D
	.DB  0x69,0x6E,0x20,0x50,0x61,0x67,0x65,0x20
	.DB  0x49,0x6E,0x20,0x32,0x20,0x53,0x65,0x63
	.DB  0x0,0x25,0x30,0x32,0x78,0x3A,0x25,0x30
	.DB  0x32,0x78,0x3A,0x25,0x30,0x32,0x78,0x20
	.DB  0x20,0x0,0x32,0x30,0x25,0x30,0x32,0x78
	.DB  0x2F,0x25,0x30,0x32,0x78,0x2F,0x25,0x30
	.DB  0x32,0x78,0x20,0x20,0x25,0x33,0x73,0x0
	.DB  0x49,0x6E,0x63,0x6F,0x72,0x72,0x65,0x63
	.DB  0x74,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x46
	.DB  0x6F,0x72,0x6D,0x61,0x74,0x0,0x59,0x6F
	.DB  0x75,0x20,0x57,0x69,0x6C,0x6C,0x20,0x42
	.DB  0x61,0x63,0x6B,0x20,0x4D,0x65,0x6E,0x75
	.DB  0x20,0x49,0x6E,0x20,0x32,0x20,0x53,0x65
	.DB  0x63,0x6F,0x6E,0x64,0x0,0x44,0x75,0x70
	.DB  0x6C,0x69,0x63,0x61,0x74,0x65,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x45,0x6E,0x74,0x65
	.DB  0x72,0x65,0x64,0x0,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x53,0x75,0x63,0x63,0x65,0x73,0x73
	.DB  0x66,0x75,0x6C,0x6C,0x79,0x20,0x41,0x64
	.DB  0x64,0x65,0x64,0x0,0x59,0x6F,0x75,0x20
	.DB  0x4D,0x75,0x73,0x74,0x20,0x46,0x69,0x72
	.DB  0x73,0x74,0x20,0x4C,0x6F,0x67,0x69,0x6E
	.DB  0x0,0x59,0x6F,0x75,0x20,0x57,0x69,0x6C
	.DB  0x6C,0x20,0x47,0x6F,0x20,0x41,0x64,0x6D
	.DB  0x69,0x6E,0x20,0x50,0x61,0x67,0x65,0x20
	.DB  0x32,0x20,0x53,0x65,0x63,0x0,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x20,0x46,0x6F,0x75,0x6E,0x64
	.DB  0x0,0x4F,0x70,0x73,0x20,0x2C,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x4E,0x6F,0x74,0x20
	.DB  0x46,0x6F,0x75,0x6E,0x64,0x0,0x57,0x61
	.DB  0x69,0x74,0x20,0x46,0x6F,0x72,0x20,0x44
	.DB  0x65,0x6C,0x65,0x74,0x65,0x2E,0x2E,0x2E
	.DB  0x0,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x57,0x61
	.DB  0x73,0x20,0x44,0x65,0x6C,0x65,0x74,0x65
	.DB  0x64,0x0,0x4C,0x6F,0x67,0x69,0x6E,0x20
	.DB  0x53,0x75,0x63,0x63,0x65,0x73,0x73,0x66
	.DB  0x75,0x6C,0x6C,0x79,0x0,0x57,0x61,0x69
	.DB  0x74,0x2E,0x2E,0x2E,0x0,0x4F,0x70,0x73
	.DB  0x20,0x2C,0x20,0x73,0x65,0x63,0x72,0x65
	.DB  0x74,0x20,0x69,0x73,0x20,0x69,0x6E,0x63
	.DB  0x6F,0x72,0x72,0x65,0x63,0x74,0x0,0x43
	.DB  0x6C,0x65,0x61,0x72,0x69,0x6E,0x67,0x20
	.DB  0x45,0x45,0x50,0x52,0x4F,0x4D,0x20,0x2E
	.DB  0x2E,0x2E,0x0,0x54,0x65,0x6D,0x70,0x65
	.DB  0x72,0x61,0x74,0x75,0x72,0x65,0x28,0x43
	.DB  0x29,0x3A,0x0,0x31,0x3A,0x20,0x41,0x74
	.DB  0x74,0x65,0x6E,0x64,0x61,0x6E,0x63,0x65
	.DB  0x20,0x49,0x6E,0x69,0x74,0x69,0x61,0x6C
	.DB  0x69,0x7A,0x61,0x74,0x69,0x6F,0x6E,0x0
	.DB  0x32,0x3A,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x4D,0x61,0x6E,0x61,0x67
	.DB  0x65,0x6D,0x65,0x6E,0x74,0x0,0x33,0x3A
	.DB  0x20,0x56,0x69,0x65,0x77,0x20,0x50,0x72
	.DB  0x65,0x73,0x65,0x6E,0x74,0x20,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x73,0x20,0x0
	.DB  0x34,0x3A,0x20,0x54,0x65,0x6D,0x70,0x65
	.DB  0x72,0x61,0x74,0x75,0x72,0x65,0x20,0x4D
	.DB  0x6F,0x6E,0x69,0x74,0x6F,0x72,0x69,0x6E
	.DB  0x67,0x0,0x35,0x3A,0x20,0x52,0x65,0x74
	.DB  0x72,0x69,0x65,0x76,0x65,0x20,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x44,0x61
	.DB  0x74,0x61,0x0,0x36,0x3A,0x20,0x54,0x72
	.DB  0x61,0x66,0x66,0x69,0x63,0x20,0x4D,0x6F
	.DB  0x6E,0x69,0x74,0x6F,0x72,0x69,0x6E,0x67
	.DB  0x0,0x37,0x3A,0x20,0x4C,0x6F,0x67,0x69
	.DB  0x6E,0x20,0x57,0x69,0x74,0x68,0x20,0x41
	.DB  0x64,0x6D,0x69,0x6E,0x0,0x38,0x3A,0x20
	.DB  0x4C,0x6F,0x67,0x6F,0x75,0x74,0x0,0x44
	.DB  0x69,0x73,0x74,0x61,0x6E,0x63,0x65,0x3A
	.DB  0x20,0x0,0x45,0x72,0x72,0x6F,0x72,0x0
	.DB  0x4E,0x6F,0x20,0x4F,0x62,0x73,0x74,0x61
	.DB  0x63,0x6C,0x65,0x0,0x20,0x63,0x6D,0x20
	.DB  0x0,0x43,0x6F,0x75,0x6E,0x74,0x3A,0x20
	.DB  0x0
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
	.DW  _0x5
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x5+4
	.DW  _0x0*2+4

	.DW  0x04
	.DW  _0x5+8
	.DW  _0x0*2+8

	.DW  0x04
	.DW  _0x5+12
	.DW  _0x0*2+12

	.DW  0x04
	.DW  _0x5+16
	.DW  _0x0*2+16

	.DW  0x04
	.DW  _0x5+20
	.DW  _0x0*2+20

	.DW  0x04
	.DW  _0x5+24
	.DW  _0x0*2+24

	.DW  0x0E
	.DW  _days
	.DW  _0x6*2

	.DW  0x17
	.DW  _0xD
	.DW  _0x0*2+28

	.DW  0x14
	.DW  _0xD+23
	.DW  _0x0*2+51

	.DW  0x19
	.DW  _0xD+43
	.DW  _0x0*2+71

	.DW  0x1D
	.DW  _0xD+68
	.DW  _0x0*2+96

	.DW  0x03
	.DW  _0xD+97
	.DW  _0x0*2+125

	.DW  0x0D
	.DW  _0xD+100
	.DW  _0x0*2+128

	.DW  0x17
	.DW  _0xD+113
	.DW  _0x0*2+141

	.DW  0x17
	.DW  _0xD+136
	.DW  _0x0*2+164

	.DW  0x16
	.DW  _0xD+159
	.DW  _0x0*2+187

	.DW  0x18
	.DW  _0xD+181
	.DW  _0x0*2+209

	.DW  0x16
	.DW  _0xD+205
	.DW  _0x0*2+233

	.DW  0x18
	.DW  _0xD+227
	.DW  _0x0*2+255

	.DW  0x12
	.DW  _0xD+251
	.DW  _0x0*2+279

	.DW  0x12
	.DW  _0xD+269
	.DW  _0x0*2+297

	.DW  0x1F
	.DW  _0xD+287
	.DW  _0x0*2+315

	.DW  0x1F
	.DW  _0xD+318
	.DW  _0x0*2+346

	.DW  0x1E
	.DW  _0xD+349
	.DW  _0x0*2+377

	.DW  0x11
	.DW  _0xD+379
	.DW  _0x0*2+407

	.DW  0x19
	.DW  _0xD+396
	.DW  _0x0*2+424

	.DW  0x0B
	.DW  _0x78
	.DW  _0x0*2+449

	.DW  0x1D
	.DW  _0x78+11
	.DW  _0x0*2+460

	.DW  0x02
	.DW  _0x78+40
	.DW  _0x0*2+207

	.DW  0x03
	.DW  _0x78+42
	.DW  _0x0*2+125

	.DW  0x1E
	.DW  _0x78+45
	.DW  _0x0*2+528

	.DW  0x1F
	.DW  _0x78+75
	.DW  _0x0*2+558

	.DW  0x1F
	.DW  _0x78+106
	.DW  _0x0*2+589

	.DW  0x1F
	.DW  _0x78+137
	.DW  _0x0*2+558

	.DW  0x20
	.DW  _0x78+168
	.DW  _0x0*2+620

	.DW  0x1F
	.DW  _0x78+200
	.DW  _0x0*2+558

	.DW  0x15
	.DW  _0x78+231
	.DW  _0x0*2+652

	.DW  0x1D
	.DW  _0x78+252
	.DW  _0x0*2+673

	.DW  0x02
	.DW  _0x78+281
	.DW  _0x0*2+207

	.DW  0x13
	.DW  _0x78+283
	.DW  _0x0*2+702

	.DW  0x1F
	.DW  _0x78+302
	.DW  _0x0*2+558

	.DW  0x1D
	.DW  _0x78+333
	.DW  _0x0*2+721

	.DW  0x1F
	.DW  _0x78+362
	.DW  _0x0*2+558

	.DW  0x02
	.DW  _0x78+393
	.DW  _0x0*2+207

	.DW  0x13
	.DW  _0x78+395
	.DW  _0x0*2+702

	.DW  0x13
	.DW  _0x78+414
	.DW  _0x0*2+750

	.DW  0x19
	.DW  _0x78+433
	.DW  _0x0*2+769

	.DW  0x1F
	.DW  _0x78+458
	.DW  _0x0*2+558

	.DW  0x1D
	.DW  _0x78+489
	.DW  _0x0*2+721

	.DW  0x1F
	.DW  _0x78+518
	.DW  _0x0*2+558

	.DW  0x02
	.DW  _0x78+549
	.DW  _0x0*2+207

	.DW  0x13
	.DW  _0x78+551
	.DW  _0x0*2+794

	.DW  0x08
	.DW  _0x78+570
	.DW  _0x0*2+813

	.DW  0x1A
	.DW  _0x78+578
	.DW  _0x0*2+821

	.DW  0x1F
	.DW  _0x78+604
	.DW  _0x0*2+558

	.DW  0x14
	.DW  _0x78+635
	.DW  _0x0*2+847

	.DW  0x10
	.DW  _0xF4
	.DW  _0x0*2+867

	.DW  0x02
	.DW  _0xF4+16
	.DW  _0x0*2+207

	.DW  0x1D
	.DW  _0x100
	.DW  _0x0*2+883

	.DW  0x16
	.DW  _0x100+29
	.DW  _0x0*2+912

	.DW  0x1A
	.DW  _0x100+51
	.DW  _0x0*2+934

	.DW  0x1A
	.DW  _0x100+77
	.DW  _0x0*2+960

	.DW  0x19
	.DW  _0x100+103
	.DW  _0x0*2+986

	.DW  0x16
	.DW  _0x100+128
	.DW  _0x0*2+1011

	.DW  0x14
	.DW  _0x100+150
	.DW  _0x0*2+1033

	.DW  0x0A
	.DW  _0x100+170
	.DW  _0x0*2+1053

	.DW  0x02
	.DW  _previous_count_S0000014000
	.DW  _0x149*2

	.DW  0x0B
	.DW  _0x14A
	.DW  _0x0*2+1063

	.DW  0x06
	.DW  _0x14A+11
	.DW  _0x0*2+1074

	.DW  0x0C
	.DW  _0x14A+17
	.DW  _0x0*2+1080

	.DW  0x05
	.DW  _0x14A+29
	.DW  _0x0*2+1092

	.DW  0x08
	.DW  _0x14A+34
	.DW  _0x0*2+1097

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
;char* days[7]= {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
_0x5:
	.BYTE 0x1C
;char time[20];
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
; 0000 006F {

	.CSEG
_main:
; .FSTART _main
; 0000 0070     int i, j;
; 0000 0071     unsigned char st_counts;
; 0000 0072     unsigned char data;
; 0000 0073 
; 0000 0074     KEY_DDR = 0xF0;
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
;	data -> R20
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0075     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0076     KEY_PRT &= 0x0F;                  // ground all rows at once
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 0077     MCUCR = 0x02;                     // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0078     GICR = (1 << INT0);               // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0079     BUZZER_DDR |= (1 << BUZZER_NUM);  // make buzzer pin output
	SBI  0x11,7
; 0000 007A     BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
	CBI  0x12,7
; 0000 007B     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	CALL _USART_init
; 0000 007C     HCSR04Init(); // Initialize ultrasonic sensor
	CALL _HCSR04Init
; 0000 007D     lcd_init();
	RCALL _lcd_init
; 0000 007E     rtc_init();
	CALL _rtc_init
; 0000 007F 
; 0000 0080 #asm("sei")           // enable interrupts
	sei
; 0000 0081     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0082     while (1)
_0x7:
; 0000 0083     {
; 0000 0084         if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BRNE _0xA
; 0000 0085         {
; 0000 0086             show_menu();
	CALL _show_menu
; 0000 0087         }
; 0000 0088         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0xB
_0xA:
	CALL SUBOPT_0x0
	BRNE _0xC
; 0000 0089         {
; 0000 008A             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 008B             lcd_gotoxy(1, 1);
; 0000 008C             lcd_print("1: Submit Student Code");
	__POINTW2MN _0xD,0
	CALL SUBOPT_0x2
; 0000 008D             lcd_gotoxy(1, 2);
; 0000 008E             lcd_print("2: Submit With Card");
	__POINTW2MN _0xD,23
	RCALL _lcd_print
; 0000 008F             while (stage == STAGE_ATTENDENC_MENU)
_0xE:
	CALL SUBOPT_0x0
	BREQ _0xE
; 0000 0090                 ;
; 0000 0091         }
; 0000 0092         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x11
_0xC:
	CALL SUBOPT_0x3
	BRNE _0x12
; 0000 0093         {
; 0000 0094             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0095             lcd_gotoxy(1, 1);
; 0000 0096             lcd_print("Enter your student code:");
	__POINTW2MN _0xD,43
	CALL SUBOPT_0x2
; 0000 0097             lcd_gotoxy(1, 2);
; 0000 0098             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0099             delay_us(100 * 16); // wait
; 0000 009A             while (stage == STAGE_SUBMIT_CODE)
_0x13:
	CALL SUBOPT_0x3
	BREQ _0x13
; 0000 009B                 ;
; 0000 009C             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x164
; 0000 009D             delay_us(100 * 16); // wait
; 0000 009E         }
; 0000 009F         else if(stage == STAGE_SUBMIT_WITH_CARD)
_0x12:
	CALL SUBOPT_0x5
	BREQ PC+2
	RJMP _0x17
; 0000 00A0         {
; 0000 00A1             memset(buffer,0,32);
	CALL SUBOPT_0x6
; 0000 00A2             while (stage == STAGE_SUBMIT_WITH_CARD)
_0x18:
	CALL SUBOPT_0x5
	BREQ PC+2
	RJMP _0x1A
; 0000 00A3             {
; 0000 00A4                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00A5                 lcd_gotoxy(1, 1);
; 0000 00A6                 lcd_print("Bring your card near device:");
	__POINTW2MN _0xD,68
	CALL SUBOPT_0x2
; 0000 00A7                 lcd_gotoxy(1, 2);
; 0000 00A8                 delay_us(100 * 16); // wait
	CALL SUBOPT_0x7
; 0000 00A9                 while((data = USART_Receive()) != '\r'){
_0x1B:
	CALL _USART_Receive
	MOV  R20,R30
	CPI  R30,LOW(0xD)
	BREQ _0x1D
; 0000 00AA                     if(stage != STAGE_SUBMIT_WITH_CARD)
	CALL SUBOPT_0x5
	BRNE _0x1D
; 0000 00AB                         break;
; 0000 00AC                     buffer[strlen(buffer)] = data;
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	ST   Z,R20
; 0000 00AD                 }
	RJMP _0x1B
_0x1D:
; 0000 00AE                 if(stage != STAGE_SUBMIT_WITH_CARD){
	CALL SUBOPT_0x5
	BREQ _0x1F
; 0000 00AF                     memset(buffer,0,32);
	CALL SUBOPT_0x6
; 0000 00B0                     break;
	RJMP _0x1A
; 0000 00B1                 }
; 0000 00B2                 if (strncmp(buffer, "40", 2) != 0 ||
_0x1F:
; 0000 00B3                         strlen(buffer) != 8)
	CALL SUBOPT_0x9
	__POINTW1MN _0xD,97
	CALL SUBOPT_0xA
	BRNE _0x21
	CALL SUBOPT_0x8
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x20
_0x21:
; 0000 00B4                 {
; 0000 00B5                     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00B6                     lcd_gotoxy(1, 1);
; 0000 00B7                     lcd_print("Invalid Card");
	__POINTW2MN _0xD,100
	RCALL _lcd_print
; 0000 00B8                     BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00B9                     delay_ms(2000);
	CALL SUBOPT_0xB
; 0000 00BA                     BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00BB                 }
; 0000 00BC                 else{
	RJMP _0x23
_0x20:
; 0000 00BD                     if (search_student_code() > 0){
	CALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x24
; 0000 00BE                         BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00BF                         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00C0                         lcd_gotoxy(1, 1);
; 0000 00C1                         lcd_print("Duplicate Student Code");
	__POINTW2MN _0xD,113
	CALL SUBOPT_0xC
; 0000 00C2                         delay_ms(2000);
; 0000 00C3                         BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00C4                     }
; 0000 00C5                     else{
	RJMP _0x25
_0x24:
; 0000 00C6                         // save the buffer to EEPROM
; 0000 00C7                         st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
; 0000 00C8                         for (i = 0; i < 8; i++)
	__GETWRN 16,17,0
_0x27:
	__CPWRN 16,17,8
	BRGE _0x28
; 0000 00C9                         {
; 0000 00CA                             write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R21
	CALL SUBOPT_0xE
	ADD  R30,R16
	ADC  R31,R17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _write_byte_to_eeprom
; 0000 00CB                         }
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 00CC                         write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0xF
	MOV  R26,R21
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 00CD                         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00CE                         lcd_gotoxy(1, 1);
; 0000 00CF                         lcd_print("Student added with ID:");
	__POINTW2MN _0xD,136
	CALL SUBOPT_0x2
; 0000 00D0                         lcd_gotoxy(1, 2);
; 0000 00D1                         lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00D2                         delay_ms(3000); // wait
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00D3                     }
_0x25:
; 0000 00D4                 }
_0x23:
; 0000 00D5                 memset(buffer,0,32);
	CALL SUBOPT_0x6
; 0000 00D6             }
	RJMP _0x18
_0x1A:
; 0000 00D7         }
; 0000 00D8         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x29
_0x17:
	CALL SUBOPT_0x11
	BRNE _0x2A
; 0000 00D9         {
; 0000 00DA             show_temperature();
	RCALL _show_temperature
; 0000 00DB         }
; 0000 00DC         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x2B
_0x2A:
	CALL SUBOPT_0x12
	BREQ PC+2
	RJMP _0x2C
; 0000 00DD         {
; 0000 00DE             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00DF             lcd_gotoxy(1, 1);
; 0000 00E0             lcd_print("Number of students : ");
	__POINTW2MN _0xD,159
	CALL SUBOPT_0x2
; 0000 00E1             lcd_gotoxy(1, 2);
; 0000 00E2             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
; 0000 00E3             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 00E4             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _itoa
; 0000 00E5             lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00E6             delay_ms(1000);
	CALL SUBOPT_0x13
; 0000 00E7 
; 0000 00E8             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x2E:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2F
; 0000 00E9             {
; 0000 00EA                 memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 00EB                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x31:
	__CPWRN 18,19,8
	BRGE _0x32
; 0000 00EC                 {
; 0000 00ED                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00EE                 }
	__ADDWRN 18,19,1
	RJMP _0x31
_0x32:
; 0000 00EF                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00F0                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00F1                 lcd_gotoxy(1, 1);
; 0000 00F2                 lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00F3                 delay_ms(1000);
	CALL SUBOPT_0x13
; 0000 00F4             }
	__ADDWRN 16,17,1
	RJMP _0x2E
_0x2F:
; 0000 00F5 
; 0000 00F6             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00F7             lcd_gotoxy(1, 1);
; 0000 00F8             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xD,181
	RCALL _lcd_print
; 0000 00F9             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x33:
	CALL SUBOPT_0x12
	BREQ _0x33
; 0000 00FA                 ;
; 0000 00FB         }
; 0000 00FC         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x36
_0x2C:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x37
; 0000 00FD         {
; 0000 00FE             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00FF             lcd_gotoxy(1, 1);
; 0000 0100             lcd_print("Start Transferring...");
	__POINTW2MN _0xD,205
	RCALL _lcd_print
; 0000 0101             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
; 0000 0102             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x39:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x3A
; 0000 0103             {
; 0000 0104                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3C:
	__CPWRN 18,19,8
	BRGE _0x3D
; 0000 0105                 {
; 0000 0106                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0x14
	MOV  R26,R30
	RCALL _USART_Transmit
; 0000 0107                 }
	__ADDWRN 18,19,1
	RJMP _0x3C
_0x3D:
; 0000 0108 
; 0000 0109                 USART_Transmit('\r');
	CALL SUBOPT_0x15
; 0000 010A                 USART_Transmit('\r');
; 0000 010B 
; 0000 010C                 delay_ms(500);
; 0000 010D             }
	__ADDWRN 16,17,1
	RJMP _0x39
_0x3A:
; 0000 010E             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3F:
	__CPWRN 18,19,8
	BRGE _0x40
; 0000 010F             {
; 0000 0110                 USART_Transmit('=');
	LDI  R26,LOW(61)
	RCALL _USART_Transmit
; 0000 0111             }
	__ADDWRN 18,19,1
	RJMP _0x3F
_0x40:
; 0000 0112 
; 0000 0113             USART_Transmit('\r');
	CALL SUBOPT_0x15
; 0000 0114             USART_Transmit('\r');
; 0000 0115             delay_ms(500);
; 0000 0116 
; 0000 0117             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0118             lcd_gotoxy(1, 1);
; 0000 0119             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xD,227
	CALL SUBOPT_0x16
; 0000 011A             delay_ms(2000);
; 0000 011B             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 011C         }
; 0000 011D         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x41
_0x37:
	CALL SUBOPT_0x17
	BRNE _0x42
; 0000 011E         {
; 0000 011F             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0120             lcd_gotoxy(1, 1);
; 0000 0121             lcd_print("1: Search Student");
	__POINTW2MN _0xD,251
	CALL SUBOPT_0x2
; 0000 0122             lcd_gotoxy(1, 2);
; 0000 0123             lcd_print("2: Delete Student");
	__POINTW2MN _0xD,269
	RCALL _lcd_print
; 0000 0124             while (stage == STAGE_STUDENT_MANAGMENT)
_0x43:
	CALL SUBOPT_0x17
	BREQ _0x43
; 0000 0125                 ;
; 0000 0126         }
; 0000 0127         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x46
_0x42:
	CALL SUBOPT_0x18
	BRNE _0x47
; 0000 0128         {
; 0000 0129             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 012A             lcd_gotoxy(1, 1);
; 0000 012B             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xD,287
	CALL SUBOPT_0x2
; 0000 012C             lcd_gotoxy(1, 2);
; 0000 012D             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 012E             delay_us(100 * 16); // wait
; 0000 012F             while (stage == STAGE_SEARCH_STUDENT)
_0x48:
	CALL SUBOPT_0x18
	BREQ _0x48
; 0000 0130                 ;
; 0000 0131             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x164
; 0000 0132             delay_us(100 * 16); // wait
; 0000 0133         }
; 0000 0134         else if (stage == STAGE_DELETE_STUDENT)
_0x47:
	CALL SUBOPT_0x19
	BRNE _0x4C
; 0000 0135         {
; 0000 0136             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0137             lcd_gotoxy(1, 1);
; 0000 0138             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xD,318
	CALL SUBOPT_0x2
; 0000 0139             lcd_gotoxy(1, 2);
; 0000 013A             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 013B             delay_us(100 * 16); // wait
; 0000 013C             while (stage == STAGE_DELETE_STUDENT)
_0x4D:
	CALL SUBOPT_0x19
	BREQ _0x4D
; 0000 013D                 ;
; 0000 013E             lcdCommand(0x0c); // display on, cursor off
	RJMP _0x164
; 0000 013F             delay_us(100 * 16);
; 0000 0140         }
; 0000 0141         else if (stage == STAGE_TRAFFIC_MONITORING)
_0x4C:
	CALL SUBOPT_0x1A
	BRNE _0x51
; 0000 0142         {
; 0000 0143             startSonar();
	CALL _startSonar
; 0000 0144             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0145         }
; 0000 0146         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x52
_0x51:
	CALL SUBOPT_0x1B
	BRNE _0x53
; 0000 0147         {
; 0000 0148             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0149             lcd_gotoxy(1, 1);
; 0000 014A             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xD,349
	CALL SUBOPT_0x2
; 0000 014B             lcd_gotoxy(1, 2);
; 0000 014C             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 014D             delay_us(100 * 16); // wait
; 0000 014E             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x54:
	CALL SUBOPT_0x1B
	BRNE _0x57
	TST  R9
	BREQ _0x58
_0x57:
	RJMP _0x56
_0x58:
; 0000 014F                 ;
	RJMP _0x54
_0x56:
; 0000 0150             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x59
; 0000 0151             {
; 0000 0152                 lcdCommand(0x0c); // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x1C
; 0000 0153                 delay_us(100 * 16);
; 0000 0154                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0155                 lcd_gotoxy(1, 1);
; 0000 0156                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xD,379
	CALL SUBOPT_0x2
; 0000 0157                 lcd_gotoxy(1, 2);
; 0000 0158                 lcd_print("    press cancel to back");
	__POINTW2MN _0xD,396
	RCALL _lcd_print
; 0000 0159                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x5A:
	CALL SUBOPT_0x1B
	BREQ _0x5A
; 0000 015A                     ;
; 0000 015B             }
; 0000 015C             else
	RJMP _0x5D
_0x59:
; 0000 015D             {
; 0000 015E                 lcdCommand(0x0c); // display on, cursor off
_0x164:
	LDI  R26,LOW(12)
	CALL SUBOPT_0x1C
; 0000 015F                 delay_us(100 * 16);
; 0000 0160             }
_0x5D:
; 0000 0161         }
; 0000 0162     }
_0x53:
_0x52:
_0x46:
_0x41:
_0x36:
_0x2B:
_0x29:
_0x11:
_0xB:
	RJMP _0x7
; 0000 0163 }
_0x5E:
	RJMP _0x5E
; .FEND

	.DSEG
_0xD:
	.BYTE 0x1A5
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 0167 {

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
; 0000 0168     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 0169     unsigned char second, minute, hour;
; 0000 016A     unsigned char day, date, month, year;
; 0000 016B     int i;
; 0000 016C 
; 0000 016D     // detect the key
; 0000 016E     while (1)
	SBIW R28,8
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	second -> R20
;	minute -> Y+13
;	hour -> Y+12
;	day -> Y+11
;	date -> Y+10
;	month -> Y+9
;	year -> Y+8
;	i -> Y+6
; 0000 016F     {
; 0000 0170         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x1D
; 0000 0171         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0172         if (colloc != 0x0F)        // column detected
	BREQ _0x62
; 0000 0173         {
; 0000 0174             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 0175             break;      // exit while loop
	RJMP _0x61
; 0000 0176         }
; 0000 0177         KEY_PRT = 0xDF;            // ground row 1
_0x62:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x1D
; 0000 0178         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0179         if (colloc != 0x0F)        // column detected
	BREQ _0x63
; 0000 017A         {
; 0000 017B             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 017C             break;      // exit while loop
	RJMP _0x61
; 0000 017D         }
; 0000 017E         KEY_PRT = 0xBF;            // ground row 2
_0x63:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x1D
; 0000 017F         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0180         if (colloc != 0x0F)        // column detected
	BREQ _0x64
; 0000 0181         {
; 0000 0182             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 0183             break;      // exit while loop
	RJMP _0x61
; 0000 0184         }
; 0000 0185         KEY_PRT = 0x7F;            // ground row 3
_0x64:
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 0186         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 0187         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 0188         break;                     // exit while loop
; 0000 0189     }
_0x61:
; 0000 018A     // check column and send result to Port D
; 0000 018B     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x65
; 0000 018C         cl = 0;
	LDI  R19,LOW(0)
; 0000 018D     else if (colloc == 0x0D)
	RJMP _0x66
_0x65:
	CPI  R17,13
	BRNE _0x67
; 0000 018E         cl = 1;
	LDI  R19,LOW(1)
; 0000 018F     else if (colloc == 0x0B)
	RJMP _0x68
_0x67:
	CPI  R17,11
	BRNE _0x69
; 0000 0190         cl = 2;
	LDI  R19,LOW(2)
; 0000 0191     else
	RJMP _0x6A
_0x69:
; 0000 0192         cl = 3;
	LDI  R19,LOW(3)
; 0000 0193 
; 0000 0194     KEY_PRT &= 0x0F; // ground all rows at once
_0x6A:
_0x68:
_0x66:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 0195 
; 0000 0196     // inside menu level 1
; 0000 0197     if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0x6B
; 0000 0198     {
; 0000 0199         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 019A         {
; 0000 019B         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6F
; 0000 019C             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 019D             break;
	RJMP _0x6E
; 0000 019E         case OPTION_TEMPERATURE_MONITORING:
_0x6F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x70
; 0000 019F             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 01A0             break;
	RJMP _0x6E
; 0000 01A1         case OPTION_VIEW_PRESENT_STUDENTS:
_0x70:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x71
; 0000 01A2             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 01A3             break;
	RJMP _0x6E
; 0000 01A4         case OPTION_RETRIEVE_STUDENT_DATA:
_0x71:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x72
; 0000 01A5             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 01A6             break;
	RJMP _0x6E
; 0000 01A7         case OPTION_STUDENT_MANAGEMENT:
_0x72:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x73
; 0000 01A8             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 01A9             break;
	RJMP _0x6E
; 0000 01AA         case OPTION_TRAFFIC_MONITORING:
_0x73:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x74
; 0000 01AB             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R4,R30
; 0000 01AC             break;
	RJMP _0x6E
; 0000 01AD         case OPTION_LOGIN_WITH_ADMIN:
_0x74:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x75
; 0000 01AE             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 01AF             break;
	RJMP _0x6E
; 0000 01B0         case OPTION_LOGOUT:
_0x75:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x79
; 0000 01B1 #asm("cli") // disable interrupts
	cli
; 0000 01B2             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x77
; 0000 01B3             {
; 0000 01B4                 lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 01B5                 lcd_gotoxy(1, 1);
; 0000 01B6                 lcd_print("Logout ...");
	__POINTW2MN _0x78,0
	CALL SUBOPT_0x2
; 0000 01B7                 lcd_gotoxy(1, 2);
; 0000 01B8                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x78,11
	CALL SUBOPT_0x16
; 0000 01B9                 delay_ms(2000);
; 0000 01BA                 logged_in = 0;
	CLR  R9
; 0000 01BB #asm("sei")
	sei
; 0000 01BC                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 01BD             }
; 0000 01BE             break;
_0x77:
; 0000 01BF         default:
_0x79:
; 0000 01C0             break;
; 0000 01C1         }
_0x6E:
; 0000 01C2 
; 0000 01C3         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x7A
; 0000 01C4         {
; 0000 01C5             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x7B
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,1
	RJMP _0x7C
_0x7B:
	LDI  R30,LOW(3)
_0x7C:
	MOV  R7,R30
; 0000 01C6         }
; 0000 01C7         else if (keypad[rowloc][cl] == 'R')
	RJMP _0x7E
_0x7A:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x7F
; 0000 01C8         {
; 0000 01C9             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	MOV  R7,R30
; 0000 01CA         }
; 0000 01CB         else if(keypad[rowloc][cl] == 'O')
	RJMP _0x80
_0x7F:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BREQ PC+2
	RJMP _0x81
; 0000 01CC         {
; 0000 01CD             while(1){
_0x82:
; 0000 01CE                 lcdCommand(0x1);
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 01CF                 rtc_getTime(&hour, &minute, &second);
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R20
	RCALL _rtc_getTime
	POP  R20
; 0000 01D0                 sprintf(time, "%02x:%02x:%02x  ", hour, minute, second);
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,489
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+16
	CALL SUBOPT_0x1F
	LDD  R30,Y+21
	CALL SUBOPT_0x1F
	MOV  R30,R20
	CALL SUBOPT_0x1F
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01D1                 lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x20
; 0000 01D2                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 01D3                 rtc_getDate(&year, &month, &date, &day);
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,17
	RCALL _rtc_getDate
; 0000 01D4                 sprintf(time, "20%02x/%02x/%02x  %3s", year, month, date, days[day - 1]);
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,506
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	CALL SUBOPT_0x1F
	LDD  R30,Y+17
	CALL SUBOPT_0x1F
	LDD  R30,Y+22
	CALL SUBOPT_0x1F
	LDD  R30,Y+27
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
; 0000 01D5                 lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 01D6                 lcd_print(time);
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _lcd_print
; 0000 01D7                 delay_ms(1000);
	CALL SUBOPT_0x13
; 0000 01D8             }
	RJMP _0x82
; 0000 01D9 
; 0000 01DA         }
; 0000 01DB     }
_0x81:
_0x80:
_0x7E:
; 0000 01DC     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x85
_0x6B:
	CALL SUBOPT_0x0
	BRNE _0x86
; 0000 01DD     {
; 0000 01DE         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
; 0000 01DF         {
; 0000 01E0         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x8A
; 0000 01E1             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01E2             break;
	RJMP _0x89
; 0000 01E3         case '1':
_0x8A:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x8B
; 0000 01E4             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 01E5             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 01E6             break;
	RJMP _0x89
; 0000 01E7         case '2':
_0x8B:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x8D
; 0000 01E8             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 01E9             stage = STAGE_SUBMIT_WITH_CARD;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 01EA             break;
; 0000 01EB         default:
_0x8D:
; 0000 01EC             break;
; 0000 01ED         }
_0x89:
; 0000 01EE     }
; 0000 01EF     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x8E
_0x86:
	CALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x8F
; 0000 01F0     {
; 0000 01F1 
; 0000 01F2         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x90
; 0000 01F3         {
; 0000 01F4             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 01F5             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01F6         }
; 0000 01F7         if ((keypad[rowloc][cl] - '0') < 10)
_0x90:
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x91
; 0000 01F8         {
; 0000 01F9             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x8
	SBIW R30,31
	BRSH _0x92
; 0000 01FA             {
; 0000 01FB                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x8
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 01FC                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x23
; 0000 01FD                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 01FE             }
; 0000 01FF         }
_0x92:
; 0000 0200         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x93
_0x91:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x94
; 0000 0201         {
; 0000 0202             buffer_len = strlen(buffer);
	CALL SUBOPT_0x8
	MOV  R21,R30
; 0000 0203             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x95
; 0000 0204             {
; 0000 0205                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x24
; 0000 0206                 lcdCommand(0x10);
; 0000 0207                 lcd_print(" ");
	__POINTW2MN _0x78,40
	CALL SUBOPT_0x25
; 0000 0208                 lcdCommand(0x10);
; 0000 0209             }
; 0000 020A         }
_0x95:
; 0000 020B         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x96
_0x94:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0x97
; 0000 020C         {
; 0000 020D 
; 0000 020E #asm("cli")
	cli
; 0000 020F 
; 0000 0210             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 0211                 strlen(buffer) != 8)
	CALL SUBOPT_0x9
	__POINTW1MN _0x78,42
	CALL SUBOPT_0xA
	BRNE _0x99
	CALL SUBOPT_0x8
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x98
_0x99:
; 0000 0212             {
; 0000 0213 
; 0000 0214                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0215                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0216                 lcd_gotoxy(1, 1);
; 0000 0217                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x78,45
	CALL SUBOPT_0x2
; 0000 0218                 lcd_gotoxy(1, 2);
; 0000 0219                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,75
	CALL SUBOPT_0xC
; 0000 021A                 delay_ms(2000);
; 0000 021B                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 021C             }
; 0000 021D             else if (search_student_code() > 0)
	RJMP _0x9B
_0x98:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x9C
; 0000 021E             {
; 0000 021F                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0220                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0221                 lcd_gotoxy(1, 1);
; 0000 0222                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x78,106
	CALL SUBOPT_0x2
; 0000 0223                 lcd_gotoxy(1, 2);
; 0000 0224                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,137
	CALL SUBOPT_0xC
; 0000 0225                 delay_ms(2000);
; 0000 0226                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 0227             }
; 0000 0228             else
	RJMP _0x9D
_0x9C:
; 0000 0229             {
; 0000 022A                 // save the buffer to EEPROM
; 0000 022B                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0x26
	MOV  R18,R30
; 0000 022C                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x9F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,8
	BRGE _0xA0
; 0000 022D                 {
; 0000 022E                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R18
	CALL SUBOPT_0xE
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
; 0000 022F                 }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x9F
_0xA0:
; 0000 0230                 write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0xF
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0231 
; 0000 0232                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0233                 lcd_gotoxy(1, 1);
; 0000 0234                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x78,168
	CALL SUBOPT_0x2
; 0000 0235                 lcd_gotoxy(1, 2);
; 0000 0236                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,200
	CALL SUBOPT_0x16
; 0000 0237                 delay_ms(2000);
; 0000 0238             }
_0x9D:
_0x9B:
; 0000 0239             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 023A #asm("sei")
	sei
; 0000 023B             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x165
; 0000 023C         }
; 0000 023D         else if (keypad[rowloc][cl] == 'C')
_0x97:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA2
; 0000 023E             stage = STAGE_ATTENDENC_MENU;
_0x165:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 023F     }
_0xA2:
_0x96:
_0x93:
; 0000 0240     else if (stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0xA3
_0x8F:
	CALL SUBOPT_0x5
	BRNE _0xA4
; 0000 0241     {
; 0000 0242         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA5
; 0000 0243         {
; 0000 0244             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 0245             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0246         }
; 0000 0247     }
_0xA5:
; 0000 0248     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0xA6
_0xA4:
	CALL SUBOPT_0x11
	BRNE _0xA7
; 0000 0249     {
; 0000 024A 
; 0000 024B         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA8
; 0000 024C             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 024D     }
_0xA8:
; 0000 024E     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0xA9
_0xA7:
	CALL SUBOPT_0x12
	BRNE _0xAA
; 0000 024F     {
; 0000 0250         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xAB
; 0000 0251             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0252     }
_0xAB:
; 0000 0253     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0xAC
_0xAA:
	CALL SUBOPT_0x17
	BRNE _0xAD
; 0000 0254     {
; 0000 0255         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xAE
; 0000 0256             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0257         else if (keypad[rowloc][cl] == '1')
	RJMP _0xAF
_0xAE:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0xB0
; 0000 0258             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x166
; 0000 0259         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0xB0:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xB3
	LDI  R30,LOW(1)
	CP   R30,R9
	BREQ _0xB4
_0xB3:
	RJMP _0xB2
_0xB4:
; 0000 025A             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x166
; 0000 025B         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0xB2:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xB7
	TST  R9
	BREQ _0xB8
_0xB7:
	RJMP _0xB6
_0xB8:
; 0000 025C         {
; 0000 025D             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 025E             lcd_gotoxy(1, 1);
; 0000 025F             lcd_print("You Must First Login");
	__POINTW2MN _0x78,231
	CALL SUBOPT_0x2
; 0000 0260             lcd_gotoxy(1, 2);
; 0000 0261             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x78,252
	CALL SUBOPT_0x16
; 0000 0262             delay_ms(2000);
; 0000 0263             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
_0x166:
	MOVW R4,R30
; 0000 0264         }
; 0000 0265     }
_0xB6:
_0xAF:
; 0000 0266     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0xB9
_0xAD:
	CALL SUBOPT_0x18
	BREQ PC+2
	RJMP _0xBA
; 0000 0267     {
; 0000 0268         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBB
; 0000 0269         {
; 0000 026A             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 026B             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x167
; 0000 026C         }
; 0000 026D         else if ((keypad[rowloc][cl] - '0') < 10)
_0xBB:
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xBD
; 0000 026E         {
; 0000 026F             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x8
	SBIW R30,31
	BRSH _0xBE
; 0000 0270             {
; 0000 0271                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x8
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 0272                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x23
; 0000 0273                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0274             }
; 0000 0275         }
_0xBE:
; 0000 0276         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xBF
_0xBD:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xC0
; 0000 0277         {
; 0000 0278             buffer_len = strlen(buffer);
	CALL SUBOPT_0x8
	MOV  R21,R30
; 0000 0279             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xC1
; 0000 027A             {
; 0000 027B                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x24
; 0000 027C                 lcdCommand(0x10);
; 0000 027D                 lcd_print(" ");
	__POINTW2MN _0x78,281
	CALL SUBOPT_0x25
; 0000 027E                 lcdCommand(0x10);
; 0000 027F             }
; 0000 0280         }
_0xC1:
; 0000 0281         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xC2
_0xC0:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xC3
; 0000 0282         {
; 0000 0283             // search from eeprom data
; 0000 0284             unsigned char result = search_student_code();
; 0000 0285 
; 0000 0286             if (result > 0)
	CALL SUBOPT_0x27
;	minute -> Y+14
;	hour -> Y+13
;	day -> Y+12
;	date -> Y+11
;	month -> Y+10
;	year -> Y+9
;	i -> Y+7
;	result -> Y+0
	BRLO _0xC4
; 0000 0287             {
; 0000 0288                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0289                 lcd_gotoxy(1, 1);
; 0000 028A                 lcd_print("Student Code Found");
	__POINTW2MN _0x78,283
	CALL SUBOPT_0x2
; 0000 028B                 lcd_gotoxy(1, 2);
; 0000 028C                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,302
	RJMP _0x168
; 0000 028D                 delay_ms(2000);
; 0000 028E             }
; 0000 028F             else
_0xC4:
; 0000 0290             {
; 0000 0291                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0292                 lcd_gotoxy(1, 1);
; 0000 0293                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x78,333
	CALL SUBOPT_0x2
; 0000 0294                 lcd_gotoxy(1, 2);
; 0000 0295                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,362
_0x168:
	RCALL _lcd_print
; 0000 0296                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0297             }
; 0000 0298             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 0299             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 029A         }
	ADIW R28,1
; 0000 029B         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xC6
_0xC3:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xC7
; 0000 029C             stage = STAGE_STUDENT_MANAGMENT;
_0x167:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 029D     }
_0xC7:
_0xC6:
_0xC2:
_0xBF:
; 0000 029E     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xC8
_0xBA:
	CALL SUBOPT_0x19
	BREQ PC+2
	RJMP _0xC9
; 0000 029F     {
; 0000 02A0         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCA
; 0000 02A1         {
; 0000 02A2             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 02A3             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 02A4         }
; 0000 02A5         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xCB
_0xCA:
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xCC
; 0000 02A6         {
; 0000 02A7             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x8
	SBIW R30,31
	BRSH _0xCD
; 0000 02A8             {
; 0000 02A9                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x8
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 02AA                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x23
; 0000 02AB                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02AC             }
; 0000 02AD         }
_0xCD:
; 0000 02AE         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xCE
_0xCC:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xCF
; 0000 02AF         {
; 0000 02B0             buffer_len = strlen(buffer);
	CALL SUBOPT_0x8
	MOV  R21,R30
; 0000 02B1             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xD0
; 0000 02B2             {
; 0000 02B3                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x24
; 0000 02B4                 lcdCommand(0x10);
; 0000 02B5                 lcd_print(" ");
	__POINTW2MN _0x78,393
	CALL SUBOPT_0x25
; 0000 02B6                 lcdCommand(0x10);
; 0000 02B7             }
; 0000 02B8         }
_0xD0:
; 0000 02B9         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xD1
_0xCF:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xD2
; 0000 02BA         {
; 0000 02BB             // search from eeprom data
; 0000 02BC             unsigned char result = search_student_code();
; 0000 02BD 
; 0000 02BE             if (result > 0)
	CALL SUBOPT_0x27
;	minute -> Y+14
;	hour -> Y+13
;	day -> Y+12
;	date -> Y+11
;	month -> Y+10
;	year -> Y+9
;	i -> Y+7
;	result -> Y+0
	BRLO _0xD3
; 0000 02BF             {
; 0000 02C0                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02C1                 lcd_gotoxy(1, 1);
; 0000 02C2                 lcd_print("Student Code Found");
	__POINTW2MN _0x78,395
	CALL SUBOPT_0x2
; 0000 02C3                 lcd_gotoxy(1, 2);
; 0000 02C4                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x78,414
	RCALL _lcd_print
; 0000 02C5                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 02C6                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02C7                 lcd_gotoxy(1, 1);
; 0000 02C8                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x78,433
	CALL SUBOPT_0x2
; 0000 02C9                 lcd_gotoxy(1, 2);
; 0000 02CA                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,458
	RJMP _0x169
; 0000 02CB                 delay_ms(2000);
; 0000 02CC             }
; 0000 02CD             else
_0xD3:
; 0000 02CE             {
; 0000 02CF                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02D0                 lcd_gotoxy(1, 1);
; 0000 02D1                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x78,489
	CALL SUBOPT_0x2
; 0000 02D2                 lcd_gotoxy(1, 2);
; 0000 02D3                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,518
_0x169:
	RCALL _lcd_print
; 0000 02D4                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 02D5             }
; 0000 02D6             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 02D7             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 02D8         }
	ADIW R28,1
; 0000 02D9     }
_0xD2:
_0xD1:
_0xCE:
_0xCB:
; 0000 02DA     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0xD5
_0xC9:
	CALL SUBOPT_0x1A
	BRNE _0xD6
; 0000 02DB     {
; 0000 02DC         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD7
; 0000 02DD             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02DE     }
_0xD7:
; 0000 02DF     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0xD8
_0xD6:
	CALL SUBOPT_0x1B
	BRNE _0xDA
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0xDB
_0xDA:
	RJMP _0xD9
_0xDB:
; 0000 02E0     {
; 0000 02E1         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xDC
; 0000 02E2         {
; 0000 02E3             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 02E4             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02E5         }
; 0000 02E6 
; 0000 02E7         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xDD
_0xDC:
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xDE
; 0000 02E8         {
; 0000 02E9             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x8
	SBIW R30,31
	BRSH _0xDF
; 0000 02EA             {
; 0000 02EB                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x8
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 02EC                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x23
; 0000 02ED                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02EE             }
; 0000 02EF         }
_0xDF:
; 0000 02F0         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xE0
_0xDE:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xE1
; 0000 02F1         {
; 0000 02F2             buffer_len = strlen(buffer);
	CALL SUBOPT_0x8
	MOV  R21,R30
; 0000 02F3             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xE2
; 0000 02F4             {
; 0000 02F5                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x24
; 0000 02F6                 lcdCommand(0x10);
; 0000 02F7                 lcd_print(" ");
	__POINTW2MN _0x78,549
	CALL SUBOPT_0x25
; 0000 02F8                 lcdCommand(0x10);
; 0000 02F9             }
; 0000 02FA         }
_0xE2:
; 0000 02FB         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xE3
_0xE1:
	CALL SUBOPT_0x1E
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xE4
; 0000 02FC         {
; 0000 02FD             // search from eeprom data
; 0000 02FE             unsigned int input_hash = simple_hash(buffer);
; 0000 02FF 
; 0000 0300             if (input_hash == secret)
	SBIW R28,2
;	minute -> Y+15
;	hour -> Y+14
;	day -> Y+13
;	date -> Y+12
;	month -> Y+11
;	year -> Y+10
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
	BRNE _0xE5
; 0000 0301             {
; 0000 0302                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0303                 lcd_gotoxy(1, 1);
; 0000 0304                 lcd_print("Login Successfully");
	__POINTW2MN _0x78,551
	CALL SUBOPT_0x2
; 0000 0305                 lcd_gotoxy(1, 2);
; 0000 0306                 lcd_print("Wait...");
	__POINTW2MN _0x78,570
	CALL SUBOPT_0x16
; 0000 0307                 delay_ms(2000);
; 0000 0308                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0309             }
; 0000 030A             else
	RJMP _0xE6
_0xE5:
; 0000 030B             {
; 0000 030C                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 030D                 lcd_gotoxy(1, 1);
; 0000 030E                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x78,578
	CALL SUBOPT_0x2
; 0000 030F                 lcd_gotoxy(1, 2);
; 0000 0310                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x78,604
	CALL SUBOPT_0x16
; 0000 0311                 delay_ms(2000);
; 0000 0312             }
_0xE6:
; 0000 0313             memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 0314             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0315         }
	ADIW R28,2
; 0000 0316     }
_0xE4:
_0xE3:
_0xE0:
_0xDD:
; 0000 0317     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0xE7
_0xD9:
	CALL SUBOPT_0x1B
	BRNE _0xE9
	TST  R9
	BRNE _0xEA
_0xE9:
	RJMP _0xE8
_0xEA:
; 0000 0318     {
; 0000 0319         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x1E
	LD   R30,X
	LDI  R31,0
; 0000 031A         {
; 0000 031B         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xEE
; 0000 031C             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 031D             break;
	RJMP _0xED
; 0000 031E         case '1':
_0xEE:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xF0
; 0000 031F #asm("cli") // disable interrupts
	cli
; 0000 0320             lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 0321             lcd_gotoxy(1, 1);
; 0000 0322             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x78,635
	RCALL _lcd_print
; 0000 0323             clear_eeprom();
	RCALL _clear_eeprom
; 0000 0324 #asm("sei") // enable interrupts
	sei
; 0000 0325             break;
; 0000 0326         default:
_0xF0:
; 0000 0327             break;
; 0000 0328         }
_0xED:
; 0000 0329         memset(buffer, 0, 32);
	CALL SUBOPT_0x6
; 0000 032A         stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 032B     }
; 0000 032C }
_0xE8:
_0xE7:
_0xD8:
_0xD5:
_0xC8:
_0xB9:
_0xAC:
_0xA9:
_0xA6:
_0xA3:
_0x8E:
_0x85:
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
_0x78:
	.BYTE 0x28F
;
;void lcdCommand(unsigned char cmnd)
; 0000 032F {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 0330     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x28
;	cmnd -> Y+0
; 0000 0331     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x1B,0
; 0000 0332     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x29
; 0000 0333     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0334     delay_us(1 * 16);          // wait to make EN wider
; 0000 0335     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0336     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 0337     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x2A
; 0000 0338     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0339     delay_us(1 * 16);          // wait to make EN wider
; 0000 033A     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 033B }
	RJMP _0x20C0005
; .FEND
;void lcdData(unsigned char data)
; 0000 033D {
_lcdData:
; .FSTART _lcdData
; 0000 033E     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x28
;	data -> Y+0
; 0000 033F     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x1B,0
; 0000 0340     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x29
; 0000 0341     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0342     delay_us(1 * 16);          // wait to make EN wider
; 0000 0343     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0344     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x2A
; 0000 0345     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0346     delay_us(1 * 16);          // wait to make EN wider
; 0000 0347     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0348 }
	RJMP _0x20C0005
; .FEND
;void lcd_init()
; 0000 034A {
_lcd_init:
; .FSTART _lcd_init
; 0000 034B     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 034C     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x1B,2
; 0000 034D     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 034E     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x1C
; 0000 034F     delay_us(100 * 16);        // wait
; 0000 0350     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x1C
; 0000 0351     delay_us(100 * 16);        // wait
; 0000 0352     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x1C
; 0000 0353     delay_us(100 * 16);        // wait
; 0000 0354     lcdCommand(0x0c);          // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x1C
; 0000 0355     delay_us(100 * 16);        // wait
; 0000 0356     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0357     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 0358     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x1C
; 0000 0359     delay_us(100 * 16);
; 0000 035A }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 035C {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 035D     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 035E     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0x1C
; 0000 035F     delay_us(100 * 16);
; 0000 0360 }
	RJMP _0x20C0004
; .FEND
;void lcd_print(char *str)
; 0000 0362 {
_lcd_print:
; .FSTART _lcd_print
; 0000 0363     unsigned char i = 0;
; 0000 0364     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0xF1:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0xF3
; 0000 0365     {
; 0000 0366         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 0367         i++;
	SUBI R17,-1
; 0000 0368     }
	RJMP _0xF1
_0xF3:
; 0000 0369 }
	LDD  R17,Y+0
	RJMP _0x20C0008
; .FEND
;
;void show_temperature()
; 0000 036C {
_show_temperature:
; .FSTART _show_temperature
; 0000 036D     unsigned char temperatureVal = 0;
; 0000 036E     unsigned char temperatureRep[3];
; 0000 036F 
; 0000 0370     DDRA &= ~(1 << 3);
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	CBI  0x1A,3
; 0000 0371     ADMUX = 0xE3;
	LDI  R30,LOW(227)
	OUT  0x7,R30
; 0000 0372     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0373 
; 0000 0374     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0375     lcd_gotoxy(1, 1);
; 0000 0376     lcd_print("Temperature(C):");
	__POINTW2MN _0xF4,0
	RCALL _lcd_print
; 0000 0377 
; 0000 0378     while (stage == STAGE_TEMPERATURE_MONITORING)
_0xF5:
	CALL SUBOPT_0x11
	BRNE _0xF7
; 0000 0379     {
; 0000 037A         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 037B         while ((ADCSRA & (1 << ADIF)) == 0)
_0xF8:
	SBIS 0x6,4
; 0000 037C             ;
	RJMP _0xF8
; 0000 037D         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0xFB
; 0000 037E         {
; 0000 037F             temperatureVal = ADCH;
	IN   R17,5
; 0000 0380             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 0381             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	CALL SUBOPT_0x20
; 0000 0382             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 0383             lcd_print(" ");
	__POINTW2MN _0xF4,16
	RCALL _lcd_print
; 0000 0384         }
; 0000 0385         delay_ms(500);
_0xFB:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0386     }
	RJMP _0xF5
_0xF7:
; 0000 0387 
; 0000 0388     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0389 }
	LDD  R17,Y+0
	RJMP _0x20C0006
; .FEND

	.DSEG
_0xF4:
	.BYTE 0x12
;
;void show_menu()
; 0000 038C {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 038D 
; 0000 038E     while (stage == STAGE_INIT_MENU)
_0xFC:
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0xFE
; 0000 038F     {
; 0000 0390         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0391         lcd_gotoxy(1, 1);
; 0000 0392         if (page_num == 0)
	TST  R7
	BRNE _0xFF
; 0000 0393         {
; 0000 0394             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0x100,0
	CALL SUBOPT_0x2
; 0000 0395             lcd_gotoxy(1, 2);
; 0000 0396             lcd_print("2: Student Management");
	__POINTW2MN _0x100,29
	RCALL _lcd_print
; 0000 0397             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0x101:
	TST  R7
	BRNE _0x104
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x105
_0x104:
	RJMP _0x103
_0x105:
; 0000 0398                 ;
	RJMP _0x101
_0x103:
; 0000 0399         }
; 0000 039A         else if (page_num == 1)
	RJMP _0x106
_0xFF:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x107
; 0000 039B         {
; 0000 039C             lcd_print("3: View Present Students ");
	__POINTW2MN _0x100,51
	CALL SUBOPT_0x2
; 0000 039D             lcd_gotoxy(1, 2);
; 0000 039E             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0x100,77
	RCALL _lcd_print
; 0000 039F             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0x108:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x10B
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x10C
_0x10B:
	RJMP _0x10A
_0x10C:
; 0000 03A0                 ;
	RJMP _0x108
_0x10A:
; 0000 03A1         }
; 0000 03A2         else if (page_num == 2)
	RJMP _0x10D
_0x107:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x10E
; 0000 03A3         {
; 0000 03A4             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0x100,103
	CALL SUBOPT_0x2
; 0000 03A5             lcd_gotoxy(1, 2);
; 0000 03A6             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0x100,128
	RCALL _lcd_print
; 0000 03A7             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0x10F:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x112
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x113
_0x112:
	RJMP _0x111
_0x113:
; 0000 03A8                 ;
	RJMP _0x10F
_0x111:
; 0000 03A9         }
; 0000 03AA         else if (page_num == 3)
	RJMP _0x114
_0x10E:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x115
; 0000 03AB         {
; 0000 03AC             lcd_print("7: Login With Admin");
	__POINTW2MN _0x100,150
	CALL SUBOPT_0x2
; 0000 03AD             lcd_gotoxy(1, 2);
; 0000 03AE             lcd_print("8: Logout");
	__POINTW2MN _0x100,170
	RCALL _lcd_print
; 0000 03AF             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0x116:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x119
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x11A
_0x119:
	RJMP _0x118
_0x11A:
; 0000 03B0                 ;
	RJMP _0x116
_0x118:
; 0000 03B1         }
; 0000 03B2     }
_0x115:
_0x114:
_0x10D:
_0x106:
	RJMP _0xFC
_0xFE:
; 0000 03B3 }
	RET
; .FEND

	.DSEG
_0x100:
	.BYTE 0xB4
;
;void clear_eeprom()
; 0000 03B6 {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 03B7     unsigned int i;
; 0000 03B8 
; 0000 03B9     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x11C:
	__CPWRN 16,17,1024
	BRSH _0x11D
; 0000 03BA     {
; 0000 03BB         // Wait for the previous write to complete
; 0000 03BC         while (EECR & (1 << EEWE))
_0x11E:
	SBIC 0x1C,1
; 0000 03BD             ;
	RJMP _0x11E
; 0000 03BE 
; 0000 03BF         // Set up address registers
; 0000 03C0         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 03C1         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 03C2 
; 0000 03C3         // Set up data register
; 0000 03C4         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 03C5 
; 0000 03C6         // Enable write
; 0000 03C7         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 03C8         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 03C9     }
	__ADDWRN 16,17,1
	RJMP _0x11C
_0x11D:
; 0000 03CA }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 03CD {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 03CE     unsigned char x;
; 0000 03CF     // Wait for the previous write to complete
; 0000 03D0     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x121:
	SBIC 0x1C,1
; 0000 03D1         ;
	RJMP _0x121
; 0000 03D2 
; 0000 03D3     // Set up address registers
; 0000 03D4     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x2B
; 0000 03D5     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 03D6     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 03D7     x = EEDR;
	IN   R17,29
; 0000 03D8     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0008
; 0000 03D9 }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 03DC {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 03DD     // Wait for the previous write to complete
; 0000 03DE     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x124:
	SBIC 0x1C,1
; 0000 03DF         ;
	RJMP _0x124
; 0000 03E0 
; 0000 03E1     // Set up address registers
; 0000 03E2     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x2B
; 0000 03E3     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 03E4 
; 0000 03E5     // Set up data register
; 0000 03E6     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 03E7 
; 0000 03E8     // Enable write
; 0000 03E9     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 03EA     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 03EB }
_0x20C0008:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 03EE {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 03EF     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x127:
	SBIS 0xB,5
; 0000 03F0         ;
	RJMP _0x127
; 0000 03F1     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 03F2 }
	RJMP _0x20C0005
; .FEND
;
;unsigned char USART_Receive()
; 0000 03F5 {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 03F6     while(!(UCSRA & (1 << RXC)) && stage == STAGE_SUBMIT_WITH_CARD);
_0x12A:
	SBIC 0xB,7
	RJMP _0x12D
	CALL SUBOPT_0x5
	BREQ _0x12E
_0x12D:
	RJMP _0x12C
_0x12E:
	RJMP _0x12A
_0x12C:
; 0000 03F7     return UDR;
	IN   R30,0xC
	RET
; 0000 03F8 }
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 03FB {
_USART_init:
; .FSTART _USART_init
; 0000 03FC     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 03FD     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 03FE     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 03FF     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 0400 }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 0403 {
_search_student_code:
; .FSTART _search_student_code
; 0000 0404     unsigned char st_counts, i, j;
; 0000 0405     char temp[10];
; 0000 0406 
; 0000 0407     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0x26
	MOV  R17,R30
; 0000 0408 
; 0000 0409     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x130:
	CP   R16,R17
	BRSH _0x131
; 0000 040A     {
; 0000 040B         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 040C         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x133:
	CPI  R19,8
	BRSH _0x134
; 0000 040D         {
; 0000 040E             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
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
	CALL SUBOPT_0xE
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 040F         }
	SUBI R19,-1
	RJMP _0x133
_0x134:
; 0000 0410         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0411         if (strncmp(temp, buffer, 8) == 0)
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x135
; 0000 0412             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20C0007
; 0000 0413     }
_0x135:
	SUBI R16,-1
	RJMP _0x130
_0x131:
; 0000 0414 
; 0000 0415     return 0;
	LDI  R30,LOW(0)
_0x20C0007:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 0416 }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 0419 {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 041A     unsigned char st_counts, i, j;
; 0000 041B     unsigned char temp;
; 0000 041C 
; 0000 041D     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0x26
	MOV  R17,R30
; 0000 041E 
; 0000 041F     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x137:
	CP   R17,R16
	BRLO _0x138
; 0000 0420     {
; 0000 0421         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x13A:
	CPI  R19,8
	BRSH _0x13B
; 0000 0422         {
; 0000 0423             temp = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0xE
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	MOV  R18,R30
; 0000 0424             write_byte_to_eeprom(j + ((i) * 8), temp);
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
; 0000 0425         }
	SUBI R19,-1
	RJMP _0x13A
_0x13B:
; 0000 0426     }
	SUBI R16,-1
	RJMP _0x137
_0x138:
; 0000 0427     write_byte_to_eeprom(0x0, st_counts - 1);
	CALL SUBOPT_0xF
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0428 }
	CALL __LOADLOCR4
	JMP  _0x20C0002
; .FEND
;
;void HCSR04Init()
; 0000 042B {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 042C     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 042D     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 042E }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 0431 {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 0432     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 0433     delay_us(15);                   // Wait for 15 microseconds
	__DELAY_USB 40
; 0000 0434     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 0435 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 0438 {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 0439     uint32_t i, result;
; 0000 043A 
; 0000 043B     // Wait for rising edge on Echo pin
; 0000 043C     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x13D:
	CALL SUBOPT_0x2C
	BRSH _0x13E
; 0000 043D     {
; 0000 043E         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 043F             continue;
	RJMP _0x13C
; 0000 0440         else
; 0000 0441             break;
	RJMP _0x13E
; 0000 0442     }
_0x13C:
	CALL SUBOPT_0x2D
	RJMP _0x13D
_0x13E:
; 0000 0443 
; 0000 0444     if (i == 600000)
	CALL SUBOPT_0x2C
	BRNE _0x141
; 0000 0445         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0003
; 0000 0446 
; 0000 0447     // Start timer with prescaler 8
; 0000 0448     TCCR1A = 0x00;
_0x141:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0449     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 044A     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 044B 
; 0000 044C     // Wait for falling edge on Echo pin
; 0000 044D     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x143:
	CALL SUBOPT_0x2C
	BRSH _0x144
; 0000 044E     {
; 0000 044F         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 0450             break; // Falling edge detected
	RJMP _0x144
; 0000 0451         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x146
; 0000 0452             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0003
; 0000 0453     }
_0x146:
	CALL SUBOPT_0x2D
	RJMP _0x143
_0x144:
; 0000 0454 
; 0000 0455     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 0456     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0457 
; 0000 0458     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x147
; 0000 0459         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C0003
; 0000 045A     else
_0x147:
; 0000 045B         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
	RJMP _0x20C0003
; 0000 045C }
; .FEND
;
;void startSonar()
; 0000 045F {
_startSonar:
; .FSTART _startSonar
; 0000 0460     char numberString[16];
; 0000 0461     uint16_t pulseWidth; // Pulse width from echo
; 0000 0462     int distance, previous_distance = -1;
; 0000 0463     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 0464 
; 0000 0465     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x1
; 0000 0466     lcd_gotoxy(1, 1);
; 0000 0467     lcd_print("Distance: ");
	__POINTW2MN _0x14A,0
	RCALL _lcd_print
; 0000 0468 
; 0000 0469     while (stage == STAGE_TRAFFIC_MONITORING)
_0x14B:
	CALL SUBOPT_0x1A
	BREQ PC+2
	RJMP _0x14D
; 0000 046A     {
; 0000 046B         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 046C         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 046D 
; 0000 046E         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x14E
; 0000 046F         {
; 0000 0470             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0471             lcd_gotoxy(1, 1);
; 0000 0472             lcd_print("Error"); // Display error message
	__POINTW2MN _0x14A,11
	RJMP _0x16A
; 0000 0473         }
; 0000 0474         else if (pulseWidth == US_NO_OBSTACLE)
_0x14E:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x150
; 0000 0475         {
; 0000 0476             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0477             lcd_gotoxy(1, 1);
; 0000 0478             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x14A,17
	RJMP _0x16A
; 0000 0479         }
; 0000 047A         else
_0x150:
; 0000 047B         {
; 0000 047C             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 047D 
; 0000 047E             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x152
; 0000 047F             {
; 0000 0480                 previous_distance = distance;
	MOVW R20,R18
; 0000 0481                 // Display distance on LCD
; 0000 0482                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0483                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x20
; 0000 0484                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 0485                 lcd_print(" cm ");
	__POINTW2MN _0x14A,29
	RCALL _lcd_print
; 0000 0486             }
; 0000 0487             // Counting logic based on distance
; 0000 0488             if (distance < 6)
_0x152:
	__CPWRN 18,19,6
	BRGE _0x153
; 0000 0489             {
; 0000 048A                 US_count++; // Increment count if distance is below threshold
	INC  R6
; 0000 048B             }
; 0000 048C 
; 0000 048D             // Update count on LCD only if it changes
; 0000 048E             if (US_count != previous_count)
_0x153:
	LDS  R30,_previous_count_S0000014000
	LDS  R31,_previous_count_S0000014000+1
	MOV  R26,R6
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x154
; 0000 048F             {
; 0000 0490                 previous_count = US_count;
	MOV  R30,R6
	LDI  R31,0
	STS  _previous_count_S0000014000,R30
	STS  _previous_count_S0000014000+1,R31
; 0000 0491                 lcd_gotoxy(1, 2); // Move to second line
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0492                 itoa(US_count, numberString);
	MOV  R30,R6
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0493                 lcd_print("Count: ");
	__POINTW2MN _0x14A,34
	RCALL _lcd_print
; 0000 0494                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x16A:
	RCALL _lcd_print
; 0000 0495             }
; 0000 0496         }
_0x154:
; 0000 0497         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0498     }
	RJMP _0x14B
_0x14D:
; 0000 0499 }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x14A:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 049C {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 049D     unsigned int hash = 0;
; 0000 049E     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x155:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x157
; 0000 049F     {
; 0000 04A0         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 04A1         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 04A2     }
	RJMP _0x155
_0x157:
; 0000 04A3     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0006:
	ADIW R28,4
	RET
; 0000 04A4 }
; .FEND
;
;void I2C_init()
; 0000 04A7 {
_I2C_init:
; .FSTART _I2C_init
; 0000 04A8     TWSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 04A9     TWBR = 0x47;
	LDI  R30,LOW(71)
	OUT  0x0,R30
; 0000 04AA     TWCR = 0x04;
	LDI  R30,LOW(4)
	OUT  0x36,R30
; 0000 04AB }
	RET
; .FEND
;
;void I2C_start()
; 0000 04AE {
_I2C_start:
; .FSTART _I2C_start
; 0000 04AF     TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0000 04B0     while(!(TWCR & (1 << TWINT)));
_0x158:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x158
; 0000 04B1 }
	RET
; .FEND
;
;void I2C_write(unsigned char data)
; 0000 04B4 {
_I2C_write:
; .FSTART _I2C_write
; 0000 04B5     TWDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0000 04B6     TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0000 04B7     while(!(TWCR & (1 << TWINT)));
_0x15B:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x15B
; 0000 04B8 }
	RJMP _0x20C0005
; .FEND
;
;unsigned char I2C_read(unsigned char ackVal)
; 0000 04BB {
_I2C_read:
; .FSTART _I2C_read
; 0000 04BC     TWCR = (1 << TWINT) | (1 << TWEN) | (ackVal << TWEA);
	ST   -Y,R26
;	ackVal -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
; 0000 04BD     while(!(TWCR & (1 << TWINT)));
_0x15E:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x15E
; 0000 04BE     return TWDR;
	IN   R30,0x3
_0x20C0005:
	ADIW R28,1
	RET
; 0000 04BF }
; .FEND
;
;void I2C_stop()
; 0000 04C2 {
_I2C_stop:
; .FSTART _I2C_stop
; 0000 04C3     TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0000 04C4     while(TWCR & (1 << TWSTO));
_0x161:
	IN   R30,0x36
	SBRC R30,4
	RJMP _0x161
; 0000 04C5 }
	RET
; .FEND
;
;void rtc_init()
; 0000 04C8 {
_rtc_init:
; .FSTART _rtc_init
; 0000 04C9     I2C_init();
	RCALL _I2C_init
; 0000 04CA     I2C_start();
	CALL SUBOPT_0x2E
; 0000 04CB     I2C_write(0xD0);
; 0000 04CC     I2C_write(0x07);
	LDI  R26,LOW(7)
	RCALL _I2C_write
; 0000 04CD     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x2F
; 0000 04CE     I2C_stop();
; 0000 04CF }
	RET
; .FEND
;
;void rtc_getTime(unsigned char* hour, unsigned char* minute, unsigned char* second)
; 0000 04D2 {
_rtc_getTime:
; .FSTART _rtc_getTime
; 0000 04D3     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*hour -> Y+4
;	*minute -> Y+2
;	*second -> Y+0
	CALL SUBOPT_0x2E
; 0000 04D4     I2C_write(0xD0);
; 0000 04D5     I2C_write(0x00);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x2F
; 0000 04D6     I2C_stop();
; 0000 04D7 
; 0000 04D8     I2C_start();
	CALL SUBOPT_0x30
; 0000 04D9     I2C_write(0xD1);
; 0000 04DA     *second = I2C_read(1);
; 0000 04DB     *minute = I2C_read(1);
; 0000 04DC     *hour = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 04DD     I2C_stop();
	RCALL _I2C_stop
; 0000 04DE }
_0x20C0004:
	ADIW R28,6
	RET
; .FEND
;
;void rtc_getDate(unsigned char* year, unsigned char* month, unsigned char* date, unsigned char* day)
; 0000 04E1 {
_rtc_getDate:
; .FSTART _rtc_getDate
; 0000 04E2     I2C_start();
	ST   -Y,R27
	ST   -Y,R26
;	*year -> Y+6
;	*month -> Y+4
;	*date -> Y+2
;	*day -> Y+0
	CALL SUBOPT_0x2E
; 0000 04E3     I2C_write(0xD0);
; 0000 04E4     I2C_write(0x03);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x2F
; 0000 04E5     I2C_stop();
; 0000 04E6 
; 0000 04E7     I2C_start();
	CALL SUBOPT_0x30
; 0000 04E8     I2C_write(0xD1);
; 0000 04E9     *day = I2C_read(1);
; 0000 04EA     *date = I2C_read(1);
; 0000 04EB     *month = I2C_read(1);
	LDI  R26,LOW(1)
	RCALL _I2C_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 04EC     *year = I2C_read(0);
	LDI  R26,LOW(0)
	RCALL _I2C_read
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
; 0000 04ED     I2C_stop();
	RCALL _I2C_stop
; 0000 04EE }
_0x20C0003:
	ADIW R28,8
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
_previous_count_S0000014000:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	CALL _lcdCommand
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:122 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:125 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(32)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _lcd_print
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _read_byte_from_eeprom
	MOV  R21,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _lcd_print

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16:
	CALL _lcd_print
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1C:
	CALL _lcdCommand
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:348 WORDS
SUBOPT_0x1E:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
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
SUBOPT_0x29:
	CBI  0x1B,1
	SBI  0x1B,2
	__DELAY_USB 43
	CBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2A:
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
