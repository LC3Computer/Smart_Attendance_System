
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
	.DB  0x31,0x3A,0x73,0x75,0x62,0x20,0x73,0x74
	.DB  0x64,0x20,0x63,0x6F,0x64,0x65,0x0,0x63
	.DB  0x61,0x6E,0x63,0x65,0x6C,0x3A,0x20,0x62
	.DB  0x61,0x63,0x6B,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x79,0x6F,0x75,0x72,0x20,0x63
	.DB  0x6F,0x64,0x65,0x3A,0x0,0x54,0x65,0x6D
	.DB  0x70,0x28,0x43,0x29,0x3A,0x0,0x31,0x3A
	.DB  0x20,0x61,0x74,0x74,0x65,0x6E,0x64,0x20
	.DB  0x69,0x6E,0x69,0x74,0x0,0x32,0x3A,0x20
	.DB  0x73,0x74,0x64,0x20,0x6D,0x61,0x6E,0x61
	.DB  0x67,0x65,0x0,0x33,0x3A,0x20,0x70,0x72
	.DB  0x65,0x73,0x65,0x6E,0x74,0x20,0x73,0x74
	.DB  0x64,0x0,0x34,0x3A,0x20,0x63,0x68,0x65
	.DB  0x63,0x6B,0x20,0x74,0x65,0x6D,0x70,0x0
	.DB  0x35,0x3A,0x67,0x65,0x74,0x20,0x73,0x74
	.DB  0x64,0x20,0x64,0x61,0x74,0x61,0x0,0x36
	.DB  0x3A,0x20,0x74,0x72,0x61,0x66,0x66,0x69
	.DB  0x63,0x20,0x6D,0x6F,0x6E,0x69,0x74,0x6F
	.DB  0x72,0x20,0x0
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

	.DW  0x0F
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x0D
	.DW  _0xA+15
	.DW  _0x0*2+15

	.DW  0x11
	.DW  _0xA+28
	.DW  _0x0*2+28

	.DW  0x09
	.DW  _0x41
	.DW  _0x0*2+45

	.DW  0x0F
	.DW  _0x49
	.DW  _0x0*2+54

	.DW  0x0E
	.DW  _0x49+15
	.DW  _0x0*2+69

	.DW  0x0F
	.DW  _0x49+29
	.DW  _0x0*2+83

	.DW  0x0E
	.DW  _0x49+44
	.DW  _0x0*2+98

	.DW  0x0F
	.DW  _0x49+58
	.DW  _0x0*2+112

	.DW  0x14
	.DW  _0x49+73
	.DW  _0x0*2+127

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
;
;#define LCD_PRT PORTB   // LCD DATA PORT
;#define LCD_DDR DDRB    // LCD DATA DDR
;#define LCD_PIN PINB    // LCD DATA PIN
;#define LCD_RS 0        // LCD RS
;#define LCD_RW 1        // LCD RW
;#define LCD_EN 2        // LCD EN
;#define KEY_PRT PORTC // keyboard PORT
;#define KEY_DDR DDRC  // keyboard DDR
;#define KEY_PIN PINC  // keyboard PIN
;
;void lcdCommand( unsigned char cmnd );
;void lcdData( unsigned char data );
;void lcd_init();
;void lcd_gotoxy(unsigned char x, unsigned char y);
;void lcd_print( char * str );
;void LCM35_init();
;void show_temp();
;void show_menu();
;
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
;
;
;
;unsigned int stage = 0;
;
;
;enum stages  {STAGE_INIT_MENU,STAGE_ATTENDENC_MENU,STAGE_SUBMIT_CODE,STAGE_TEMPERATURE_MONITORING};
;enum menu_options {OPTION_ATTENDENCE=1,OPTION_STUDENT_MANAGEMENT,OPTION_VIEW_PRESENT_STUDENTS,OPTION_TEMPERATURE_MONITOR ...
;
;
;
;void main(void)
; 0000 0032 {

	.CSEG
_main:
; .FSTART _main
; 0000 0033     KEY_DDR = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0034     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0035     KEY_PRT &= 0x0F;// ground all rows at once
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0036     MCUCR = 0x02; //make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0037     GICR = (1<<INT0); //enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0038     lcd_init();
	RCALL _lcd_init
; 0000 0039 
; 0000 003A 
; 0000 003B     #asm("sei") //enable interrupts
	sei
; 0000 003C     lcdCommand(0x01); //clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 003D     LCM35_init();
	RCALL _LCM35_init
; 0000 003E     while(1){
_0x4:
; 0000 003F         if(stage==STAGE_INIT_MENU){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x7
; 0000 0040             show_menu();
	RCALL _show_menu
; 0000 0041         }else if(stage==STAGE_ATTENDENC_MENU){
	RJMP _0x8
_0x7:
	CALL SUBOPT_0x0
	BRNE _0x9
; 0000 0042             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0043             lcd_gotoxy(1,1);
; 0000 0044             lcd_print("1:sub std code");
	__POINTW2MN _0xA,0
	CALL SUBOPT_0x2
; 0000 0045             lcd_gotoxy(1,2);
; 0000 0046             lcd_print("cancel: back");
	__POINTW2MN _0xA,15
	RCALL _lcd_print
; 0000 0047             while(stage==STAGE_ATTENDENC_MENU);
_0xB:
	CALL SUBOPT_0x0
	BREQ _0xB
; 0000 0048         }else if(stage==STAGE_SUBMIT_CODE){
	RJMP _0xE
_0x9:
	CALL SUBOPT_0x3
	BRNE _0xF
; 0000 0049             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 004A             lcd_gotoxy(1,1);
; 0000 004B             lcd_print("Enter your code:");
	__POINTW2MN _0xA,28
	CALL SUBOPT_0x2
; 0000 004C             lcd_gotoxy(1,2);
; 0000 004D             while(stage==STAGE_SUBMIT_CODE);
_0x10:
	CALL SUBOPT_0x3
	BREQ _0x10
; 0000 004E         }else if(stage==STAGE_TEMPERATURE_MONITORING){
	RJMP _0x13
_0xF:
	CALL SUBOPT_0x4
	BRNE _0x14
; 0000 004F             show_temp();
	RCALL _show_temp
; 0000 0050         }
; 0000 0051 
; 0000 0052     }
_0x14:
_0x13:
_0xE:
_0x8:
	RJMP _0x4
; 0000 0053 
; 0000 0054 
; 0000 0055 }
_0x15:
	RJMP _0x15
; .FEND

	.DSEG
_0xA:
	.BYTE 0x2D
;
;
;
;//int0 (keypad) service routine
;interrupt [EXT_INT0] void int0_routine(void){
; 0000 005A interrupt [2] void int0_routine(void){

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
; 0000 005B     unsigned char colloc, rowloc , cl;
; 0000 005C 
; 0000 005D     //detect the key
; 0000 005E       while (1)
	CALL __SAVELOCR4
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
; 0000 005F         {
; 0000 0060             KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x5
; 0000 0061             colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0062             if (colloc != 0x0F)        // column detected
	BREQ _0x19
; 0000 0063             {
; 0000 0064                 rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 0065                 break;      // exit while loop
	RJMP _0x18
; 0000 0066             }
; 0000 0067             KEY_PRT = 0xDF;            // ground row 1
_0x19:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x5
; 0000 0068             colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0069             if (colloc != 0x0F)        // column detected
	BREQ _0x1A
; 0000 006A             {
; 0000 006B                 rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 006C                 break;      // exit while loop
	RJMP _0x18
; 0000 006D             }
; 0000 006E             KEY_PRT = 0xBF;            // ground row 2
_0x1A:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x5
; 0000 006F             colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0070             if (colloc != 0x0F)        // column detected
	BREQ _0x1B
; 0000 0071             {
; 0000 0072                 rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 0073                 break;      // exit while loop
	RJMP _0x18
; 0000 0074             }
; 0000 0075             KEY_PRT = 0x7F;            // ground row 3
_0x1B:
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 0076             colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 0077             rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 0078             break;                     // exit while loop
; 0000 0079         }
_0x18:
; 0000 007A         // check column and send result to Port D
; 0000 007B         if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x1C
; 0000 007C             cl=0;
	LDI  R19,LOW(0)
; 0000 007D         else if (colloc == 0x0D)
	RJMP _0x1D
_0x1C:
	CPI  R17,13
	BRNE _0x1E
; 0000 007E              cl=1;
	LDI  R19,LOW(1)
; 0000 007F         else if (colloc == 0x0B)
	RJMP _0x1F
_0x1E:
	CPI  R17,11
	BRNE _0x20
; 0000 0080               cl=2;
	LDI  R19,LOW(2)
; 0000 0081         else
	RJMP _0x21
_0x20:
; 0000 0082             cl=3;
	LDI  R19,LOW(3)
; 0000 0083 
; 0000 0084     KEY_PRT &= 0x0F;// ground all rows at once
_0x21:
_0x1F:
_0x1D:
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0085 
; 0000 0086     //inside menu level 1
; 0000 0087     if(stage==STAGE_INIT_MENU){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x22
; 0000 0088         switch (keypad[rowloc][cl]-'0')
	CALL SUBOPT_0x6
	SBIW R30,48
; 0000 0089         {
; 0000 008A         case OPTION_ATTENDENCE :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26
; 0000 008B              stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 008C             break;
	RJMP _0x25
; 0000 008D 
; 0000 008E         case OPTION_TEMPERATURE_MONITORING :
_0x26:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x28
; 0000 008F             stage=STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0090             break;
; 0000 0091 
; 0000 0092         default:
_0x28:
; 0000 0093             break;
; 0000 0094         }
_0x25:
; 0000 0095     }else if(stage==STAGE_ATTENDENC_MENU){
	RJMP _0x29
_0x22:
	CALL SUBOPT_0x0
	BRNE _0x2A
; 0000 0096         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x6
; 0000 0097         {
; 0000 0098         case 'C' :
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x2E
; 0000 0099             stage=STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 009A             break;
	RJMP _0x2D
; 0000 009B         case '1' :
_0x2E:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x30
; 0000 009C             stage=STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 009D             break;
; 0000 009E         default:
_0x30:
; 0000 009F             break;
; 0000 00A0         }
_0x2D:
; 0000 00A1     }else if(stage==STAGE_SUBMIT_CODE){
	RJMP _0x31
_0x2A:
	CALL SUBOPT_0x3
	BRNE _0x32
; 0000 00A2 
; 0000 00A3         if((keypad[rowloc][cl]-'0')<10)
	CALL SUBOPT_0x6
	SBIW R30,58
	BRGE _0x33
; 0000 00A4             lcdData(keypad[rowloc][cl]);
	CALL SUBOPT_0x7
	RCALL _lcdData
; 0000 00A5         else if(keypad[rowloc][cl]=='E'){
	RJMP _0x34
_0x33:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x45)
	BRNE _0x35
; 0000 00A6 
; 0000 00A7             stage=STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 00A8 
; 0000 00A9 
; 0000 00AA         }else if(keypad[rowloc][cl]=='C')
	RJMP _0x36
_0x35:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x43)
	BRNE _0x37
; 0000 00AB             stage=STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 00AC 
; 0000 00AD     }else if(stage==STAGE_TEMPERATURE_MONITORING){
_0x37:
_0x36:
_0x34:
	RJMP _0x38
_0x32:
	CALL SUBOPT_0x4
	BRNE _0x39
; 0000 00AE 
; 0000 00AF         if(keypad[rowloc][cl]=='C')
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x43)
	BRNE _0x3A
; 0000 00B0             stage=STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 00B1     }
_0x3A:
; 0000 00B2 
; 0000 00B3 
; 0000 00B4 
; 0000 00B5 
; 0000 00B6 
; 0000 00B7 
; 0000 00B8 }
_0x39:
_0x38:
_0x31:
_0x29:
	CALL __LOADLOCR4
	ADIW R28,4
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
;
;
;void lcdCommand(unsigned char cmnd)
; 0000 00BC {
_lcdCommand:
; .FSTART _lcdCommand
; 0000 00BD     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x8
;	cmnd -> Y+0
; 0000 00BE     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x18,0
; 0000 00BF     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x9
; 0000 00C0     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 00C1     delay_us(1);               // wait to make EN wider
; 0000 00C2     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 00C3     delay_us(20);              // wait
	__DELAY_USB 53
; 0000 00C4     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	RJMP _0x2080001
; 0000 00C5     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 00C6     delay_us(1);               // wait to make EN wider
; 0000 00C7     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 00C8 }
; .FEND
;void lcdData(unsigned char data)
; 0000 00CA {
_lcdData:
; .FSTART _lcdData
; 0000 00CB     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x8
;	data -> Y+0
; 0000 00CC     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x18,0
; 0000 00CD     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x9
; 0000 00CE     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 00CF     delay_us(1);               // wait to make EN wider
; 0000 00D0     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 00D1     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
_0x2080001:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x18,R30
; 0000 00D2     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
	SBI  0x18,2
; 0000 00D3     delay_us(1);               // wait to make EN wider
	__DELAY_USB 3
; 0000 00D4     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
	CBI  0x18,2
; 0000 00D5 }
	ADIW R28,1
	RET
; .FEND
;void lcd_init()
; 0000 00D7 {
_lcd_init:
; .FSTART _lcd_init
; 0000 00D8     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00D9     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x18,2
; 0000 00DA     delay_us(2000);            // wait for stable power
	__DELAY_USW 4000
; 0000 00DB     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0xA
; 0000 00DC     delay_us(100 * 8);             // wait
; 0000 00DD     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0xA
; 0000 00DE     delay_us(100 * 8);             // wait
; 0000 00DF     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0xA
; 0000 00E0     delay_us(100 * 8);             // wait
; 0000 00E1     lcdCommand(0x0e);          // display on, cursor on
	LDI  R26,LOW(14)
	CALL SUBOPT_0xA
; 0000 00E2     delay_us(100 * 8);             // wait
; 0000 00E3     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 00E4     delay_us(2000);            // wait
	__DELAY_USW 4000
; 0000 00E5     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0xA
; 0000 00E6     delay_us(100 * 8);
; 0000 00E7 }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 00E9 {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 00EA     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 00EB     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0xA
; 0000 00EC     delay_us(100 * 8);
; 0000 00ED }
	ADIW R28,6
	RET
; .FEND
;void lcd_print(char *str)
; 0000 00EF {
_lcd_print:
; .FSTART _lcd_print
; 0000 00F0     unsigned char i = 0;
; 0000 00F1     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x3B:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x3D
; 0000 00F2     {
; 0000 00F3         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 00F4         i++;
	SUBI R17,-1
; 0000 00F5     }
	RJMP _0x3B
_0x3D:
; 0000 00F6 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;
;void LCM35_init()
; 0000 00F9 {
_LCM35_init:
; .FSTART _LCM35_init
; 0000 00FA     ADMUX = 0xE0;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 00FB     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 00FC 
; 0000 00FD }
	RET
; .FEND
;
;void show_temp()
; 0000 0100 {
_show_temp:
; .FSTART _show_temp
; 0000 0101     unsigned char temperatureVal = 0;
; 0000 0102     unsigned char temperatureRep[3];
; 0000 0103 
; 0000 0104 
; 0000 0105     while(stage==STAGE_TEMPERATURE_MONITORING)
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
_0x3E:
	CALL SUBOPT_0x4
	BRNE _0x40
; 0000 0106     {
; 0000 0107         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0108         lcd_gotoxy(1,1);
; 0000 0109         lcd_print("Temp(C):");
	__POINTW2MN _0x41,0
	RCALL _lcd_print
; 0000 010A         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 010B         while((ADCSRA & (1 << ADIF)) == 0);
_0x42:
	SBIS 0x6,4
	RJMP _0x42
; 0000 010C         temperatureVal = ADCH;
	IN   R17,5
; 0000 010D         itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 010E         lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 010F         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0110     }
	RJMP _0x3E
_0x40:
; 0000 0111 }
	LDD  R17,Y+0
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x41:
	.BYTE 0x9
;
;
;
;void show_menu()
; 0000 0116 {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 0117     unsigned char page_num = 0;
; 0000 0118     while(stage==STAGE_INIT_MENU){
	ST   -Y,R17
;	page_num -> R17
	LDI  R17,0
_0x45:
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x47
; 0000 0119     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 011A     lcd_gotoxy(1,1);
; 0000 011B     if(page_num==0){
	CPI  R17,0
	BRNE _0x48
; 0000 011C         lcd_print("1: attend init");
	__POINTW2MN _0x49,0
	CALL SUBOPT_0x2
; 0000 011D         lcd_gotoxy(1,2);
; 0000 011E         lcd_print("2: std manage");
	__POINTW2MN _0x49,15
	CALL SUBOPT_0xB
; 0000 011F         if(stage==STAGE_INIT_MENU)
	BRNE _0x4A
; 0000 0120             delay_ms(250);
	CALL SUBOPT_0xC
; 0000 0121         page_num=(page_num+1)%3;
_0x4A:
	RJMP _0x51
; 0000 0122     }else if(page_num==1){
_0x48:
	CPI  R17,1
	BRNE _0x4C
; 0000 0123         lcd_print("3: present std");
	__POINTW2MN _0x49,29
	CALL SUBOPT_0x2
; 0000 0124         lcd_gotoxy(1,2);
; 0000 0125         lcd_print("4: check temp");
	__POINTW2MN _0x49,44
	CALL SUBOPT_0xB
; 0000 0126         if(stage==STAGE_INIT_MENU)
	BRNE _0x4D
; 0000 0127             delay_ms(250);
	CALL SUBOPT_0xC
; 0000 0128         page_num=(page_num+1)%3;
_0x4D:
	RJMP _0x51
; 0000 0129     }else if(page_num==2){
_0x4C:
	CPI  R17,2
	BRNE _0x4F
; 0000 012A         lcd_print("5:get std data");
	__POINTW2MN _0x49,58
	CALL SUBOPT_0x2
; 0000 012B         lcd_gotoxy(1,2);
; 0000 012C         lcd_print("6: traffic monitor ");
	__POINTW2MN _0x49,73
	CALL SUBOPT_0xB
; 0000 012D         if(stage==STAGE_INIT_MENU)
	BRNE _0x50
; 0000 012E             delay_ms(250);
	CALL SUBOPT_0xC
; 0000 012F         page_num=(page_num+1)%3;
_0x50:
_0x51:
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	MOV  R17,R30
; 0000 0130     }
; 0000 0131 
; 0000 0132     }
_0x4F:
	RJMP _0x45
_0x47:
; 0000 0133 
; 0000 0134 
; 0000 0135 
; 0000 0136 
; 0000 0137 
; 0000 0138 }
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x49:
	.BYTE 0x5D

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

	.CSEG

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x10
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	CALL _lcdCommand
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x6:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x7:
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
SUBOPT_0x8:
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
SUBOPT_0x9:
	CBI  0x18,1
	SBI  0x18,2
	__DELAY_USB 3
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xA:
	CALL _lcdCommand
	__DELAY_USW 1600
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _lcd_print
	MOV  R0,R4
	OR   R0,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(250)
	LDI  R27,0
	JMP  _delay_ms


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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
