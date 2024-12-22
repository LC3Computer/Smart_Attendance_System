
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
_0x13C:
	.DB  0xFF,0xFF
_0x0:
	.DB  0x31,0x20,0x3A,0x20,0x53,0x75,0x62,0x6D
	.DB  0x69,0x74,0x20,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x0
	.DB  0x32,0x20,0x3A,0x20,0x53,0x75,0x62,0x6D
	.DB  0x69,0x74,0x20,0x57,0x69,0x74,0x68,0x20
	.DB  0x43,0x61,0x72,0x64,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x79,0x6F,0x75,0x72,0x20
	.DB  0x73,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x63,0x6F,0x64,0x65,0x3A,0x0,0x42,0x72
	.DB  0x69,0x6E,0x67,0x20,0x79,0x6F,0x75,0x72
	.DB  0x20,0x63,0x61,0x72,0x64,0x20,0x6E,0x65
	.DB  0x61,0x72,0x20,0x64,0x65,0x76,0x69,0x63
	.DB  0x65,0x3A,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x61,0x64,0x64,0x65,0x64
	.DB  0x20,0x77,0x69,0x74,0x68,0x20,0x49,0x44
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
	.DB  0x45,0x45,0x50,0x52,0x4F,0x4D,0x0,0x20
	.DB  0x20,0x20,0x20,0x70,0x72,0x65,0x73,0x73
	.DB  0x20,0x63,0x61,0x6E,0x63,0x65,0x6C,0x20
	.DB  0x74,0x6F,0x20,0x62,0x61,0x63,0x6B,0x0
	.DB  0x4C,0x6F,0x67,0x6F,0x75,0x74,0x20,0x2E
	.DB  0x2E,0x2E,0x0,0x47,0x6F,0x69,0x6E,0x67
	.DB  0x20,0x54,0x6F,0x20,0x41,0x64,0x6D,0x69
	.DB  0x6E,0x20,0x50,0x61,0x67,0x65,0x20,0x49
	.DB  0x6E,0x20,0x32,0x20,0x53,0x65,0x63,0x0
	.DB  0x34,0x30,0x0,0x49,0x6E,0x63,0x6F,0x72
	.DB  0x72,0x65,0x63,0x74,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x43,0x6F,0x64
	.DB  0x65,0x20,0x46,0x6F,0x72,0x6D,0x61,0x74
	.DB  0x0,0x59,0x6F,0x75,0x20,0x57,0x69,0x6C
	.DB  0x6C,0x20,0x42,0x61,0x63,0x6B,0x20,0x4D
	.DB  0x65,0x6E,0x75,0x20,0x49,0x6E,0x20,0x32
	.DB  0x20,0x53,0x65,0x63,0x6F,0x6E,0x64,0x0
	.DB  0x44,0x75,0x70,0x6C,0x69,0x63,0x61,0x74
	.DB  0x65,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x45
	.DB  0x6E,0x74,0x65,0x72,0x65,0x64,0x0,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x53,0x75,0x63,0x63
	.DB  0x65,0x73,0x73,0x66,0x75,0x6C,0x6C,0x79
	.DB  0x20,0x41,0x64,0x64,0x65,0x64,0x0,0x59
	.DB  0x6F,0x75,0x20,0x4D,0x75,0x73,0x74,0x20
	.DB  0x46,0x69,0x72,0x73,0x74,0x20,0x4C,0x6F
	.DB  0x67,0x69,0x6E,0x0,0x59,0x6F,0x75,0x20
	.DB  0x57,0x69,0x6C,0x6C,0x20,0x47,0x6F,0x20
	.DB  0x41,0x64,0x6D,0x69,0x6E,0x20,0x50,0x61
	.DB  0x67,0x65,0x20,0x32,0x20,0x53,0x65,0x63
	.DB  0x0,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x46,0x6F
	.DB  0x75,0x6E,0x64,0x0,0x4F,0x70,0x73,0x20
	.DB  0x2C,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x20,0x4E
	.DB  0x6F,0x74,0x20,0x46,0x6F,0x75,0x6E,0x64
	.DB  0x0,0x57,0x61,0x69,0x74,0x20,0x46,0x6F
	.DB  0x72,0x20,0x44,0x65,0x6C,0x65,0x74,0x65
	.DB  0x2E,0x2E,0x2E,0x0,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x57,0x61,0x73,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x64,0x0,0x4C,0x6F,0x67
	.DB  0x69,0x6E,0x20,0x53,0x75,0x63,0x63,0x65
	.DB  0x73,0x73,0x66,0x75,0x6C,0x6C,0x79,0x0
	.DB  0x57,0x61,0x69,0x74,0x2E,0x2E,0x2E,0x0
	.DB  0x4F,0x70,0x73,0x20,0x2C,0x20,0x73,0x65
	.DB  0x63,0x72,0x65,0x74,0x20,0x69,0x73,0x20
	.DB  0x69,0x6E,0x63,0x6F,0x72,0x72,0x65,0x63
	.DB  0x74,0x0,0x43,0x6C,0x65,0x61,0x72,0x69
	.DB  0x6E,0x67,0x20,0x45,0x45,0x50,0x52,0x4F
	.DB  0x4D,0x20,0x2E,0x2E,0x2E,0x0,0x74,0x65
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
	.DB  0x69,0x6E,0x67,0x0,0x37,0x3A,0x20,0x4C
	.DB  0x6F,0x67,0x69,0x6E,0x20,0x57,0x69,0x74
	.DB  0x68,0x20,0x41,0x64,0x6D,0x69,0x6E,0x0
	.DB  0x38,0x3A,0x20,0x4C,0x6F,0x67,0x6F,0x75
	.DB  0x74,0x0,0x44,0x69,0x73,0x74,0x61,0x6E
	.DB  0x63,0x65,0x3A,0x20,0x0,0x45,0x72,0x72
	.DB  0x6F,0x72,0x0,0x4E,0x6F,0x20,0x4F,0x62
	.DB  0x73,0x74,0x61,0x63,0x6C,0x65,0x0,0x20
	.DB  0x63,0x6D,0x20,0x0,0x43,0x6F,0x75,0x6E
	.DB  0x74,0x3A,0x20,0x0
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

	.DW  0x15
	.DW  _0xB+24
	.DW  _0x0*2+24

	.DW  0x19
	.DW  _0xB+45
	.DW  _0x0*2+45

	.DW  0x1D
	.DW  _0xB+70
	.DW  _0x0*2+70

	.DW  0x17
	.DW  _0xB+99
	.DW  _0x0*2+99

	.DW  0x16
	.DW  _0xB+122
	.DW  _0x0*2+122

	.DW  0x18
	.DW  _0xB+144
	.DW  _0x0*2+144

	.DW  0x16
	.DW  _0xB+168
	.DW  _0x0*2+168

	.DW  0x18
	.DW  _0xB+190
	.DW  _0x0*2+190

	.DW  0x12
	.DW  _0xB+214
	.DW  _0x0*2+214

	.DW  0x12
	.DW  _0xB+232
	.DW  _0x0*2+232

	.DW  0x1F
	.DW  _0xB+250
	.DW  _0x0*2+250

	.DW  0x1F
	.DW  _0xB+281
	.DW  _0x0*2+281

	.DW  0x1E
	.DW  _0xB+312
	.DW  _0x0*2+312

	.DW  0x11
	.DW  _0xB+342
	.DW  _0x0*2+342

	.DW  0x19
	.DW  _0xB+359
	.DW  _0x0*2+359

	.DW  0x0B
	.DW  _0x71
	.DW  _0x0*2+384

	.DW  0x1D
	.DW  _0x71+11
	.DW  _0x0*2+395

	.DW  0x02
	.DW  _0x71+40
	.DW  _0x0*2+142

	.DW  0x03
	.DW  _0x71+42
	.DW  _0x0*2+424

	.DW  0x1E
	.DW  _0x71+45
	.DW  _0x0*2+427

	.DW  0x1F
	.DW  _0x71+75
	.DW  _0x0*2+457

	.DW  0x1F
	.DW  _0x71+106
	.DW  _0x0*2+488

	.DW  0x1F
	.DW  _0x71+137
	.DW  _0x0*2+457

	.DW  0x20
	.DW  _0x71+168
	.DW  _0x0*2+519

	.DW  0x1F
	.DW  _0x71+200
	.DW  _0x0*2+457

	.DW  0x15
	.DW  _0x71+231
	.DW  _0x0*2+551

	.DW  0x1D
	.DW  _0x71+252
	.DW  _0x0*2+572

	.DW  0x02
	.DW  _0x71+281
	.DW  _0x0*2+142

	.DW  0x13
	.DW  _0x71+283
	.DW  _0x0*2+601

	.DW  0x1F
	.DW  _0x71+302
	.DW  _0x0*2+457

	.DW  0x1D
	.DW  _0x71+333
	.DW  _0x0*2+620

	.DW  0x1F
	.DW  _0x71+362
	.DW  _0x0*2+457

	.DW  0x02
	.DW  _0x71+393
	.DW  _0x0*2+142

	.DW  0x13
	.DW  _0x71+395
	.DW  _0x0*2+601

	.DW  0x13
	.DW  _0x71+414
	.DW  _0x0*2+649

	.DW  0x19
	.DW  _0x71+433
	.DW  _0x0*2+668

	.DW  0x1F
	.DW  _0x71+458
	.DW  _0x0*2+457

	.DW  0x1D
	.DW  _0x71+489
	.DW  _0x0*2+620

	.DW  0x1F
	.DW  _0x71+518
	.DW  _0x0*2+457

	.DW  0x02
	.DW  _0x71+549
	.DW  _0x0*2+142

	.DW  0x13
	.DW  _0x71+551
	.DW  _0x0*2+693

	.DW  0x08
	.DW  _0x71+570
	.DW  _0x0*2+712

	.DW  0x1A
	.DW  _0x71+578
	.DW  _0x0*2+720

	.DW  0x1F
	.DW  _0x71+604
	.DW  _0x0*2+457

	.DW  0x14
	.DW  _0x71+635
	.DW  _0x0*2+746

	.DW  0x10
	.DW  _0xE7
	.DW  _0x0*2+766

	.DW  0x02
	.DW  _0xE7+16
	.DW  _0x0*2+142

	.DW  0x1D
	.DW  _0xF3
	.DW  _0x0*2+782

	.DW  0x16
	.DW  _0xF3+29
	.DW  _0x0*2+811

	.DW  0x1A
	.DW  _0xF3+51
	.DW  _0x0*2+833

	.DW  0x1A
	.DW  _0xF3+77
	.DW  _0x0*2+859

	.DW  0x19
	.DW  _0xF3+103
	.DW  _0x0*2+885

	.DW  0x16
	.DW  _0xF3+128
	.DW  _0x0*2+910

	.DW  0x14
	.DW  _0xF3+150
	.DW  _0x0*2+932

	.DW  0x0A
	.DW  _0xF3+170
	.DW  _0x0*2+952

	.DW  0x02
	.DW  _previous_count_S0000014000
	.DW  _0x13C*2

	.DW  0x0B
	.DW  _0x13D
	.DW  _0x0*2+962

	.DW  0x06
	.DW  _0x13D+11
	.DW  _0x0*2+973

	.DW  0x0C
	.DW  _0x13D+17
	.DW  _0x0*2+979

	.DW  0x05
	.DW  _0x13D+29
	.DW  _0x0*2+991

	.DW  0x08
	.DW  _0x13D+34
	.DW  _0x0*2+996

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
;unsigned char USART_Receive();
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
; 0000 0064 {

	.CSEG
_main:
; .FSTART _main
; 0000 0065     int i, j;
; 0000 0066     unsigned char st_counts;
; 0000 0067     unsigned char data;
; 0000 0068     KEY_DDR = 0xF0;
;	i -> R16,R17
;	j -> R18,R19
;	st_counts -> R21
;	data -> R20
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0069     KEY_PRT = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 006A     KEY_PRT &= 0x0F;                  // ground all rows at once
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 006B     MCUCR = 0x02;                     // make INT0 falling edge triggered
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 006C     GICR = (1 << INT0);               // enable external interrupt 0
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 006D     BUZZER_DDR |= (1 << BUZZER_NUM);  // make buzzer pin output
	SBI  0x11,7
; 0000 006E     BUZZER_PRT &= ~(1 << BUZZER_NUM); // disable buzzer
	CBI  0x12,7
; 0000 006F     USART_init(0x33);
	LDI  R26,LOW(51)
	LDI  R27,0
	CALL _USART_init
; 0000 0070     HCSR04Init(); // Initialize ultrasonic sensor
	CALL _HCSR04Init
; 0000 0071     lcd_init();
	RCALL _lcd_init
; 0000 0072 
; 0000 0073 #asm("sei")           // enable interrupts
	sei
; 0000 0074     lcdCommand(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0075     while (1)
_0x5:
; 0000 0076     {
; 0000 0077         if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x8
; 0000 0078         {
; 0000 0079             show_menu();
	RCALL _show_menu
; 0000 007A         }
; 0000 007B         else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x9
_0x8:
	CALL SUBOPT_0x0
	BRNE _0xA
; 0000 007C         {
; 0000 007D             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 007E             lcd_gotoxy(1, 1);
; 0000 007F             lcd_print("1 : Submit Student Code");
	__POINTW2MN _0xB,0
	CALL SUBOPT_0x2
; 0000 0080             lcd_gotoxy(1, 2);
; 0000 0081             lcd_print("2 : Submit With Card");
	__POINTW2MN _0xB,24
	RCALL _lcd_print
; 0000 0082             while (stage == STAGE_ATTENDENC_MENU)
_0xC:
	CALL SUBOPT_0x0
	BREQ _0xC
; 0000 0083                 ;
; 0000 0084         }
; 0000 0085         else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0xF
_0xA:
	CALL SUBOPT_0x3
	BRNE _0x10
; 0000 0086         {
; 0000 0087             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0088             lcd_gotoxy(1, 1);
; 0000 0089             lcd_print("Enter your student code:");
	__POINTW2MN _0xB,45
	CALL SUBOPT_0x2
; 0000 008A             lcd_gotoxy(1, 2);
; 0000 008B             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 008C             delay_us(100 * 16); // wait
; 0000 008D             while (stage == STAGE_SUBMIT_CODE)
_0x11:
	CALL SUBOPT_0x3
	BREQ _0x11
; 0000 008E                 ;
; 0000 008F             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x14B
; 0000 0090             delay_us(100 * 16); // wait
; 0000 0091         }
; 0000 0092         else if(stage == STAGE_SUBMIT_WITH_CARD)
_0x10:
	CALL SUBOPT_0x5
	BRNE _0x15
; 0000 0093         {
; 0000 0094             while (stage == STAGE_SUBMIT_WITH_CARD)
_0x16:
	CALL SUBOPT_0x5
	BRNE _0x18
; 0000 0095             {
; 0000 0096                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0097                 lcd_gotoxy(1, 1);
; 0000 0098                 lcd_print("Bring your card near device:");
	__POINTW2MN _0xB,70
	CALL SUBOPT_0x2
; 0000 0099                 lcd_gotoxy(1, 2);
; 0000 009A                 delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 009B                 while((data = USART_Receive()) != '\r'){
_0x19:
	RCALL _USART_Receive
	MOV  R20,R30
	CPI  R30,LOW(0xD)
	BREQ _0x1B
; 0000 009C                     if(strlen(buffer) > 10 || stage != STAGE_SUBMIT_WITH_CARD)
	CALL SUBOPT_0x7
	SBIW R30,11
	BRSH _0x1D
	CALL SUBOPT_0x5
	BREQ _0x1C
_0x1D:
; 0000 009D                         break;
	RJMP _0x1B
; 0000 009E                     buffer[strlen(buffer)] = data;
_0x1C:
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	ST   Z,R20
; 0000 009F                 }
	RJMP _0x19
_0x1B:
; 0000 00A0                 if(stage != STAGE_SUBMIT_WITH_CARD || strlen(buffer) > 10)
	CALL SUBOPT_0x5
	BRNE _0x20
	CALL SUBOPT_0x7
	SBIW R30,11
	BRLO _0x1F
_0x20:
; 0000 00A1                     break;
	RJMP _0x18
; 0000 00A2                 lcdCommand(0x01);
_0x1F:
	CALL SUBOPT_0x1
; 0000 00A3                 lcd_gotoxy(1, 1);
; 0000 00A4                 lcd_print("Student added with ID:");
	__POINTW2MN _0xB,99
	CALL SUBOPT_0x2
; 0000 00A5                 lcd_gotoxy(1, 2);
; 0000 00A6                 lcd_print(buffer);
	CALL SUBOPT_0x8
; 0000 00A7                 delay_ms(5000); // wait
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 00A8                 memset(buffer,0,32);
	CALL SUBOPT_0x9
; 0000 00A9             }
	RJMP _0x16
_0x18:
; 0000 00AA         }
; 0000 00AB         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x22
_0x15:
	CALL SUBOPT_0xA
	BRNE _0x23
; 0000 00AC         {
; 0000 00AD             show_temperature();
	RCALL _show_temperature
; 0000 00AE         }
; 0000 00AF         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x24
_0x23:
	CALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x25
; 0000 00B0         {
; 0000 00B1             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00B2             lcd_gotoxy(1, 1);
; 0000 00B3             lcd_print("Number of students : ");
	__POINTW2MN _0xB,122
	CALL SUBOPT_0x2
; 0000 00B4             lcd_gotoxy(1, 2);
; 0000 00B5             st_counts = read_byte_from_eeprom(0x0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _read_byte_from_eeprom
	MOV  R21,R30
; 0000 00B6             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 00B7             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _itoa
; 0000 00B8             lcd_print(buffer);
	CALL SUBOPT_0x8
; 0000 00B9             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00BA 
; 0000 00BB             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x27:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x28
; 0000 00BC             {
; 0000 00BD                 memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 00BE                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x2A:
	__CPWRN 18,19,8
	BRGE _0x2B
; 0000 00BF                 {
; 0000 00C0                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00C1                 }
	__ADDWRN 18,19,1
	RJMP _0x2A
_0x2B:
; 0000 00C2                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00C3                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00C4                 lcd_gotoxy(1, 1);
; 0000 00C5                 lcd_print(buffer);
	CALL SUBOPT_0x8
; 0000 00C6                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00C7             }
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 00C8 
; 0000 00C9             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00CA             lcd_gotoxy(1, 1);
; 0000 00CB             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xB,144
	RCALL _lcd_print
; 0000 00CC             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x2C:
	CALL SUBOPT_0xB
	BREQ _0x2C
; 0000 00CD                 ;
; 0000 00CE         }
; 0000 00CF         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x2F
_0x25:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x30
; 0000 00D0         {
; 0000 00D1             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00D2             lcd_gotoxy(1, 1);
; 0000 00D3             lcd_print("Start Transferring...");
	__POINTW2MN _0xB,168
	RCALL _lcd_print
; 0000 00D4             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
	MOV  R21,R30
; 0000 00D5             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x32:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x33
; 0000 00D6             {
; 0000 00D7                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x35:
	__CPWRN 18,19,8
	BRGE _0x36
; 0000 00D8                 {
; 0000 00D9                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0xC
	MOV  R26,R30
	RCALL _USART_Transmit
; 0000 00DA                 }
	__ADDWRN 18,19,1
	RJMP _0x35
_0x36:
; 0000 00DB 
; 0000 00DC                 USART_Transmit('\r');
	CALL SUBOPT_0xE
; 0000 00DD                 USART_Transmit('\r');
; 0000 00DE 
; 0000 00DF                 delay_ms(500);
; 0000 00E0             }
	__ADDWRN 16,17,1
	RJMP _0x32
_0x33:
; 0000 00E1             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x38:
	__CPWRN 18,19,8
	BRGE _0x39
; 0000 00E2             {
; 0000 00E3                 USART_Transmit('=');
	LDI  R26,LOW(61)
	RCALL _USART_Transmit
; 0000 00E4             }
	__ADDWRN 18,19,1
	RJMP _0x38
_0x39:
; 0000 00E5 
; 0000 00E6             USART_Transmit('\r');
	CALL SUBOPT_0xE
; 0000 00E7             USART_Transmit('\r');
; 0000 00E8             delay_ms(500);
; 0000 00E9 
; 0000 00EA             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00EB             lcd_gotoxy(1, 1);
; 0000 00EC             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xB,190
	CALL SUBOPT_0xF
; 0000 00ED             delay_ms(2000);
; 0000 00EE             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 00EF         }
; 0000 00F0         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x3A
_0x30:
	CALL SUBOPT_0x10
	BRNE _0x3B
; 0000 00F1         {
; 0000 00F2             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00F3             lcd_gotoxy(1, 1);
; 0000 00F4             lcd_print("1: Search Student");
	__POINTW2MN _0xB,214
	CALL SUBOPT_0x2
; 0000 00F5             lcd_gotoxy(1, 2);
; 0000 00F6             lcd_print("2: Delete Student");
	__POINTW2MN _0xB,232
	RCALL _lcd_print
; 0000 00F7             while (stage == STAGE_STUDENT_MANAGMENT)
_0x3C:
	CALL SUBOPT_0x10
	BREQ _0x3C
; 0000 00F8                 ;
; 0000 00F9         }
; 0000 00FA         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x3F
_0x3B:
	CALL SUBOPT_0x11
	BRNE _0x40
; 0000 00FB         {
; 0000 00FC             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00FD             lcd_gotoxy(1, 1);
; 0000 00FE             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xB,250
	CALL SUBOPT_0x2
; 0000 00FF             lcd_gotoxy(1, 2);
; 0000 0100             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0101             delay_us(100 * 16); // wait
; 0000 0102             while (stage == STAGE_SEARCH_STUDENT)
_0x41:
	CALL SUBOPT_0x11
	BREQ _0x41
; 0000 0103                 ;
; 0000 0104             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x14B
; 0000 0105             delay_us(100 * 16); // wait
; 0000 0106         }
; 0000 0107         else if (stage == STAGE_DELETE_STUDENT)
_0x40:
	CALL SUBOPT_0x12
	BRNE _0x45
; 0000 0108         {
; 0000 0109             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 010A             lcd_gotoxy(1, 1);
; 0000 010B             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xB,281
	CALL SUBOPT_0x2
; 0000 010C             lcd_gotoxy(1, 2);
; 0000 010D             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 010E             delay_us(100 * 16); // wait
; 0000 010F             while (stage == STAGE_DELETE_STUDENT)
_0x46:
	CALL SUBOPT_0x12
	BREQ _0x46
; 0000 0110                 ;
; 0000 0111             lcdCommand(0x0c); // display on, cursor off
	RJMP _0x14B
; 0000 0112             delay_us(100 * 16);
; 0000 0113         }
; 0000 0114         else if (stage == STAGE_TRAFFIC_MONITORING)
_0x45:
	CALL SUBOPT_0x13
	BRNE _0x4A
; 0000 0115         {
; 0000 0116             startSonar();
	RCALL _startSonar
; 0000 0117             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0118         }
; 0000 0119         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x4B
_0x4A:
	CALL SUBOPT_0x14
	BRNE _0x4C
; 0000 011A         {
; 0000 011B             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 011C             lcd_gotoxy(1, 1);
; 0000 011D             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xB,312
	CALL SUBOPT_0x2
; 0000 011E             lcd_gotoxy(1, 2);
; 0000 011F             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0120             delay_us(100 * 16); // wait
; 0000 0121             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x4D:
	CALL SUBOPT_0x14
	BRNE _0x50
	TST  R9
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 0122                 ;
	RJMP _0x4D
_0x4F:
; 0000 0123             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x52
; 0000 0124             {
; 0000 0125                 lcdCommand(0x0c); // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x15
; 0000 0126                 delay_us(100 * 16);
; 0000 0127                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0128                 lcd_gotoxy(1, 1);
; 0000 0129                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xB,342
	CALL SUBOPT_0x2
; 0000 012A                 lcd_gotoxy(1, 2);
; 0000 012B                 lcd_print("    press cancel to back");
	__POINTW2MN _0xB,359
	RCALL _lcd_print
; 0000 012C                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x53:
	CALL SUBOPT_0x14
	BREQ _0x53
; 0000 012D                     ;
; 0000 012E             }
; 0000 012F             else
	RJMP _0x56
_0x52:
; 0000 0130             {
; 0000 0131                 lcdCommand(0x0c); // display on, cursor off
_0x14B:
	LDI  R26,LOW(12)
	CALL SUBOPT_0x15
; 0000 0132                 delay_us(100 * 16);
; 0000 0133             }
_0x56:
; 0000 0134         }
; 0000 0135     }
_0x4C:
_0x4B:
_0x3F:
_0x3A:
_0x2F:
_0x24:
_0x22:
_0xF:
_0x9:
	RJMP _0x5
; 0000 0136 }
_0x57:
	RJMP _0x57
; .FEND

	.DSEG
_0xB:
	.BYTE 0x180
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 013A {

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
; 0000 013B     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 013C     int i;
; 0000 013D 
; 0000 013E     // detect the key
; 0000 013F     while (1)
	SBIW R28,2
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	i -> Y+6
; 0000 0140     {
; 0000 0141         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x16
; 0000 0142         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0143         if (colloc != 0x0F)        // column detected
	BREQ _0x5B
; 0000 0144         {
; 0000 0145             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 0146             break;      // exit while loop
	RJMP _0x5A
; 0000 0147         }
; 0000 0148         KEY_PRT = 0xDF;            // ground row 1
_0x5B:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x16
; 0000 0149         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 014A         if (colloc != 0x0F)        // column detected
	BREQ _0x5C
; 0000 014B         {
; 0000 014C             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 014D             break;      // exit while loop
	RJMP _0x5A
; 0000 014E         }
; 0000 014F         KEY_PRT = 0xBF;            // ground row 2
_0x5C:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x16
; 0000 0150         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0151         if (colloc != 0x0F)        // column detected
	BREQ _0x5D
; 0000 0152         {
; 0000 0153             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 0154             break;      // exit while loop
	RJMP _0x5A
; 0000 0155         }
; 0000 0156         KEY_PRT = 0x7F;            // ground row 3
_0x5D:
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 0157         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 0158         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 0159         break;                     // exit while loop
; 0000 015A     }
_0x5A:
; 0000 015B     // check column and send result to Port D
; 0000 015C     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x5E
; 0000 015D         cl = 0;
	LDI  R19,LOW(0)
; 0000 015E     else if (colloc == 0x0D)
	RJMP _0x5F
_0x5E:
	CPI  R17,13
	BRNE _0x60
; 0000 015F         cl = 1;
	LDI  R19,LOW(1)
; 0000 0160     else if (colloc == 0x0B)
	RJMP _0x61
_0x60:
	CPI  R17,11
	BRNE _0x62
; 0000 0161         cl = 2;
	LDI  R19,LOW(2)
; 0000 0162     else
	RJMP _0x63
_0x62:
; 0000 0163         cl = 3;
	LDI  R19,LOW(3)
; 0000 0164 
; 0000 0165     KEY_PRT &= 0x0F; // ground all rows at once
_0x63:
_0x61:
_0x5F:
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0166 
; 0000 0167     // inside menu level 1
; 0000 0168     if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0x64
; 0000 0169     {
; 0000 016A         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 016B         {
; 0000 016C         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x68
; 0000 016D             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 016E             break;
	RJMP _0x67
; 0000 016F         case OPTION_TEMPERATURE_MONITORING:
_0x68:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x69
; 0000 0170             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 0171             break;
	RJMP _0x67
; 0000 0172         case OPTION_VIEW_PRESENT_STUDENTS:
_0x69:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6A
; 0000 0173             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 0174             break;
	RJMP _0x67
; 0000 0175         case OPTION_RETRIEVE_STUDENT_DATA:
_0x6A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6B
; 0000 0176             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0177             break;
	RJMP _0x67
; 0000 0178         case OPTION_STUDENT_MANAGEMENT:
_0x6B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6C
; 0000 0179             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 017A             break;
	RJMP _0x67
; 0000 017B         case OPTION_TRAFFIC_MONITORING:
_0x6C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x6D
; 0000 017C             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R4,R30
; 0000 017D             break;
	RJMP _0x67
; 0000 017E         case OPTION_LOGIN_WITH_ADMIN:
_0x6D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x6E
; 0000 017F             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 0180             break;
	RJMP _0x67
; 0000 0181         case OPTION_LOGOUT:
_0x6E:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x72
; 0000 0182 #asm("cli") // disable interrupts
	cli
; 0000 0183             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x70
; 0000 0184             {
; 0000 0185                 lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 0186                 lcd_gotoxy(1, 1);
; 0000 0187                 lcd_print("Logout ...");
	__POINTW2MN _0x71,0
	CALL SUBOPT_0x2
; 0000 0188                 lcd_gotoxy(1, 2);
; 0000 0189                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x71,11
	CALL SUBOPT_0xF
; 0000 018A                 delay_ms(2000);
; 0000 018B                 logged_in = 0;
	CLR  R9
; 0000 018C #asm("sei")
	sei
; 0000 018D                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 018E             }
; 0000 018F             break;
_0x70:
; 0000 0190         default:
_0x72:
; 0000 0191             break;
; 0000 0192         }
_0x67:
; 0000 0193 
; 0000 0194         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x73
; 0000 0195         {
; 0000 0196             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x74
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,1
	RJMP _0x75
_0x74:
	LDI  R30,LOW(3)
_0x75:
	MOV  R7,R30
; 0000 0197         }
; 0000 0198         if (keypad[rowloc][cl] == 'R')
_0x73:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x77
; 0000 0199         {
; 0000 019A             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	MOV  R7,R30
; 0000 019B         }
; 0000 019C     }
_0x77:
; 0000 019D     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x78
_0x64:
	CALL SUBOPT_0x0
	BRNE _0x79
; 0000 019E     {
; 0000 019F         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
; 0000 01A0         {
; 0000 01A1         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x7D
; 0000 01A2             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01A3             break;
	RJMP _0x7C
; 0000 01A4         case '1':
_0x7D:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x7E
; 0000 01A5             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 01A6             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 01A7             break;
	RJMP _0x7C
; 0000 01A8         case '2':
_0x7E:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x80
; 0000 01A9             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 01AA             stage = STAGE_SUBMIT_WITH_CARD;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 01AB             break;
; 0000 01AC         default:
_0x80:
; 0000 01AD             break;
; 0000 01AE         }
_0x7C:
; 0000 01AF     }
; 0000 01B0     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x81
_0x79:
	CALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x82
; 0000 01B1     {
; 0000 01B2 
; 0000 01B3         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x83
; 0000 01B4         {
; 0000 01B5             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 01B6             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01B7         }
; 0000 01B8         if ((keypad[rowloc][cl] - '0') < 10)
_0x83:
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x84
; 0000 01B9         {
; 0000 01BA             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0x85
; 0000 01BB             {
; 0000 01BC                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 01BD                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 01BE                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 01BF             }
; 0000 01C0         }
_0x85:
; 0000 01C1         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x86
_0x84:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x87
; 0000 01C2         {
; 0000 01C3             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 01C4             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x88
; 0000 01C5             {
; 0000 01C6                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1B
; 0000 01C7                 lcdCommand(0x10);
; 0000 01C8                 lcd_print(" ");
	__POINTW2MN _0x71,40
	CALL SUBOPT_0x1C
; 0000 01C9                 lcdCommand(0x10);
; 0000 01CA             }
; 0000 01CB         }
_0x88:
; 0000 01CC         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x89
_0x87:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0x8A
; 0000 01CD         {
; 0000 01CE 
; 0000 01CF #asm("cli")
	cli
; 0000 01D0 
; 0000 01D1             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 01D2                 strlen(buffer) != 8)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x71,42
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x8C
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x8B
_0x8C:
; 0000 01D3             {
; 0000 01D4 
; 0000 01D5                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 01D6                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01D7                 lcd_gotoxy(1, 1);
; 0000 01D8                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x71,45
	CALL SUBOPT_0x2
; 0000 01D9                 lcd_gotoxy(1, 2);
; 0000 01DA                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,75
	CALL SUBOPT_0xF
; 0000 01DB                 delay_ms(2000);
; 0000 01DC                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
	CBI  0x12,7
; 0000 01DD             }
; 0000 01DE             else if (search_student_code() > 0)
	RJMP _0x8E
_0x8B:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x8F
; 0000 01DF             {
; 0000 01E0                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 01E1                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01E2                 lcd_gotoxy(1, 1);
; 0000 01E3                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x71,106
	CALL SUBOPT_0x2
; 0000 01E4                 lcd_gotoxy(1, 2);
; 0000 01E5                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,137
	CALL SUBOPT_0xF
; 0000 01E6                 delay_ms(2000);
; 0000 01E7                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
	CBI  0x12,7
; 0000 01E8             }
; 0000 01E9             else
	RJMP _0x90
_0x8F:
; 0000 01EA             {
; 0000 01EB                 // save the buffer to EEPROM
; 0000 01EC                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
	MOV  R18,R30
; 0000 01ED                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x92:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,8
	BRGE _0x93
; 0000 01EE                 {
; 0000 01EF                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
	MOV  R30,R18
	CALL SUBOPT_0x1D
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
; 0000 01F0                 }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x92
_0x93:
; 0000 01F1                 write_byte_to_eeprom(0x0, st_counts + 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 01F2 
; 0000 01F3                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01F4                 lcd_gotoxy(1, 1);
; 0000 01F5                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x71,168
	CALL SUBOPT_0x2
; 0000 01F6                 lcd_gotoxy(1, 2);
; 0000 01F7                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,200
	CALL SUBOPT_0xF
; 0000 01F8                 delay_ms(2000);
; 0000 01F9             }
_0x90:
_0x8E:
; 0000 01FA             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 01FB #asm("sei")
	sei
; 0000 01FC             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x14C
; 0000 01FD         }
; 0000 01FE         else if (keypad[rowloc][cl] == 'C')
_0x8A:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x95
; 0000 01FF             stage = STAGE_ATTENDENC_MENU;
_0x14C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0200     }
_0x95:
_0x89:
_0x86:
; 0000 0201     else if (stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0x96
_0x82:
	CALL SUBOPT_0x5
	BRNE _0x97
; 0000 0202     {
; 0000 0203         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x98
; 0000 0204         {
; 0000 0205             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 0206             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0207         }
; 0000 0208     }
_0x98:
; 0000 0209     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x99
_0x97:
	CALL SUBOPT_0xA
	BRNE _0x9A
; 0000 020A     {
; 0000 020B 
; 0000 020C         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9B
; 0000 020D             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 020E     }
_0x9B:
; 0000 020F     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x9C
_0x9A:
	CALL SUBOPT_0xB
	BRNE _0x9D
; 0000 0210     {
; 0000 0211         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9E
; 0000 0212             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0213     }
_0x9E:
; 0000 0214     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x9F
_0x9D:
	CALL SUBOPT_0x10
	BRNE _0xA0
; 0000 0215     {
; 0000 0216         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA1
; 0000 0217             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0218         else if (keypad[rowloc][cl] == '1')
	RJMP _0xA2
_0xA1:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0xA3
; 0000 0219             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x14D
; 0000 021A         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0xA3:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xA6
	LDI  R30,LOW(1)
	CP   R30,R9
	BREQ _0xA7
_0xA6:
	RJMP _0xA5
_0xA7:
; 0000 021B             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x14D
; 0000 021C         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0xA5:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xAA
	TST  R9
	BREQ _0xAB
_0xAA:
	RJMP _0xA9
_0xAB:
; 0000 021D         {
; 0000 021E             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 021F             lcd_gotoxy(1, 1);
; 0000 0220             lcd_print("You Must First Login");
	__POINTW2MN _0x71,231
	CALL SUBOPT_0x2
; 0000 0221             lcd_gotoxy(1, 2);
; 0000 0222             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x71,252
	CALL SUBOPT_0xF
; 0000 0223             delay_ms(2000);
; 0000 0224             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
_0x14D:
	MOVW R4,R30
; 0000 0225         }
; 0000 0226     }
_0xA9:
_0xA2:
; 0000 0227     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0xAC
_0xA0:
	CALL SUBOPT_0x11
	BREQ PC+2
	RJMP _0xAD
; 0000 0228     {
; 0000 0229         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xAE
; 0000 022A         {
; 0000 022B             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 022C             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x14E
; 0000 022D         }
; 0000 022E         else if ((keypad[rowloc][cl] - '0') < 10)
_0xAE:
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xB0
; 0000 022F         {
; 0000 0230             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xB1
; 0000 0231             {
; 0000 0232                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 0233                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 0234                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0235             }
; 0000 0236         }
_0xB1:
; 0000 0237         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xB2
_0xB0:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xB3
; 0000 0238         {
; 0000 0239             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 023A             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xB4
; 0000 023B             {
; 0000 023C                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1B
; 0000 023D                 lcdCommand(0x10);
; 0000 023E                 lcd_print(" ");
	__POINTW2MN _0x71,281
	CALL SUBOPT_0x1C
; 0000 023F                 lcdCommand(0x10);
; 0000 0240             }
; 0000 0241         }
_0xB4:
; 0000 0242         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xB5
_0xB3:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xB6
; 0000 0243         {
; 0000 0244             // search from eeprom data
; 0000 0245             unsigned char result = search_student_code();
; 0000 0246 
; 0000 0247             if (result > 0)
	CALL SUBOPT_0x1E
;	i -> Y+7
;	result -> Y+0
	BRLO _0xB7
; 0000 0248             {
; 0000 0249                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 024A                 lcd_gotoxy(1, 1);
; 0000 024B                 lcd_print("Student Code Found");
	__POINTW2MN _0x71,283
	CALL SUBOPT_0x2
; 0000 024C                 lcd_gotoxy(1, 2);
; 0000 024D                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,302
	RJMP _0x14F
; 0000 024E                 delay_ms(2000);
; 0000 024F             }
; 0000 0250             else
_0xB7:
; 0000 0251             {
; 0000 0252                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0253                 lcd_gotoxy(1, 1);
; 0000 0254                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x71,333
	CALL SUBOPT_0x2
; 0000 0255                 lcd_gotoxy(1, 2);
; 0000 0256                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,362
_0x14F:
	RCALL _lcd_print
; 0000 0257                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0258             }
; 0000 0259             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 025A             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 025B         }
	ADIW R28,1
; 0000 025C         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xB9
_0xB6:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBA
; 0000 025D             stage = STAGE_STUDENT_MANAGMENT;
_0x14E:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 025E     }
_0xBA:
_0xB9:
_0xB5:
_0xB2:
; 0000 025F     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xBB
_0xAD:
	CALL SUBOPT_0x12
	BREQ PC+2
	RJMP _0xBC
; 0000 0260     {
; 0000 0261         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBD
; 0000 0262         {
; 0000 0263             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 0264             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 0265         }
; 0000 0266         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xBE
_0xBD:
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xBF
; 0000 0267         {
; 0000 0268             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xC0
; 0000 0269             {
; 0000 026A                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 026B                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 026C                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 026D             }
; 0000 026E         }
_0xC0:
; 0000 026F         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xC1
_0xBF:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xC2
; 0000 0270         {
; 0000 0271             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 0272             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xC3
; 0000 0273             {
; 0000 0274                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1B
; 0000 0275                 lcdCommand(0x10);
; 0000 0276                 lcd_print(" ");
	__POINTW2MN _0x71,393
	CALL SUBOPT_0x1C
; 0000 0277                 lcdCommand(0x10);
; 0000 0278             }
; 0000 0279         }
_0xC3:
; 0000 027A         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xC4
_0xC2:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xC5
; 0000 027B         {
; 0000 027C             // search from eeprom data
; 0000 027D             unsigned char result = search_student_code();
; 0000 027E 
; 0000 027F             if (result > 0)
	CALL SUBOPT_0x1E
;	i -> Y+7
;	result -> Y+0
	BRLO _0xC6
; 0000 0280             {
; 0000 0281                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0282                 lcd_gotoxy(1, 1);
; 0000 0283                 lcd_print("Student Code Found");
	__POINTW2MN _0x71,395
	CALL SUBOPT_0x2
; 0000 0284                 lcd_gotoxy(1, 2);
; 0000 0285                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x71,414
	RCALL _lcd_print
; 0000 0286                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 0287                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0288                 lcd_gotoxy(1, 1);
; 0000 0289                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x71,433
	CALL SUBOPT_0x2
; 0000 028A                 lcd_gotoxy(1, 2);
; 0000 028B                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,458
	RJMP _0x150
; 0000 028C                 delay_ms(2000);
; 0000 028D             }
; 0000 028E             else
_0xC6:
; 0000 028F             {
; 0000 0290                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0291                 lcd_gotoxy(1, 1);
; 0000 0292                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x71,489
	CALL SUBOPT_0x2
; 0000 0293                 lcd_gotoxy(1, 2);
; 0000 0294                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,518
_0x150:
	RCALL _lcd_print
; 0000 0295                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0296             }
; 0000 0297             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 0298             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 0299         }
	ADIW R28,1
; 0000 029A     }
_0xC5:
_0xC4:
_0xC1:
_0xBE:
; 0000 029B     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0xC8
_0xBC:
	CALL SUBOPT_0x13
	BRNE _0xC9
; 0000 029C     {
; 0000 029D         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCA
; 0000 029E             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 029F     }
_0xCA:
; 0000 02A0     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0xCB
_0xC9:
	CALL SUBOPT_0x14
	BRNE _0xCD
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0xCE
_0xCD:
	RJMP _0xCC
_0xCE:
; 0000 02A1     {
; 0000 02A2         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCF
; 0000 02A3         {
; 0000 02A4             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 02A5             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02A6         }
; 0000 02A7 
; 0000 02A8         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xD0
_0xCF:
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xD1
; 0000 02A9         {
; 0000 02AA             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xD2
; 0000 02AB             {
; 0000 02AC                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 02AD                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x1A
; 0000 02AE                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02AF             }
; 0000 02B0         }
_0xD2:
; 0000 02B1         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xD3
_0xD1:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xD4
; 0000 02B2         {
; 0000 02B3             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 02B4             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xD5
; 0000 02B5             {
; 0000 02B6                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x1B
; 0000 02B7                 lcdCommand(0x10);
; 0000 02B8                 lcd_print(" ");
	__POINTW2MN _0x71,549
	CALL SUBOPT_0x1C
; 0000 02B9                 lcdCommand(0x10);
; 0000 02BA             }
; 0000 02BB         }
_0xD5:
; 0000 02BC         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xD6
_0xD4:
	CALL SUBOPT_0x17
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xD7
; 0000 02BD         {
; 0000 02BE             // search from eeprom data
; 0000 02BF             unsigned int input_hash = simple_hash(buffer);
; 0000 02C0 
; 0000 02C1             if (input_hash == secret)
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
	BRNE _0xD8
; 0000 02C2             {
; 0000 02C3                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02C4                 lcd_gotoxy(1, 1);
; 0000 02C5                 lcd_print("Login Successfully");
	__POINTW2MN _0x71,551
	CALL SUBOPT_0x2
; 0000 02C6                 lcd_gotoxy(1, 2);
; 0000 02C7                 lcd_print("Wait...");
	__POINTW2MN _0x71,570
	CALL SUBOPT_0xF
; 0000 02C8                 delay_ms(2000);
; 0000 02C9                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 02CA             }
; 0000 02CB             else
	RJMP _0xD9
_0xD8:
; 0000 02CC             {
; 0000 02CD                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02CE                 lcd_gotoxy(1, 1);
; 0000 02CF                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x71,578
	CALL SUBOPT_0x2
; 0000 02D0                 lcd_gotoxy(1, 2);
; 0000 02D1                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x71,604
	CALL SUBOPT_0xF
; 0000 02D2                 delay_ms(2000);
; 0000 02D3             }
_0xD9:
; 0000 02D4             memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 02D5             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02D6         }
	ADIW R28,2
; 0000 02D7     }
_0xD7:
_0xD6:
_0xD3:
_0xD0:
; 0000 02D8     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0xDA
_0xCC:
	CALL SUBOPT_0x14
	BRNE _0xDC
	TST  R9
	BRNE _0xDD
_0xDC:
	RJMP _0xDB
_0xDD:
; 0000 02D9     {
; 0000 02DA         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x17
	LD   R30,X
	LDI  R31,0
; 0000 02DB         {
; 0000 02DC         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xE1
; 0000 02DD             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02DE             break;
	RJMP _0xE0
; 0000 02DF         case '1':
_0xE1:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE3
; 0000 02E0 #asm("cli") // disable interrupts
	cli
; 0000 02E1             lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 02E2             lcd_gotoxy(1, 1);
; 0000 02E3             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x71,635
	RCALL _lcd_print
; 0000 02E4             clear_eeprom();
	RCALL _clear_eeprom
; 0000 02E5 #asm("sei") // enable interrupts
	sei
; 0000 02E6             break;
; 0000 02E7         default:
_0xE3:
; 0000 02E8             break;
; 0000 02E9         }
_0xE0:
; 0000 02EA         memset(buffer, 0, 32);
	CALL SUBOPT_0x9
; 0000 02EB         stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02EC     }
; 0000 02ED }
_0xDB:
_0xDA:
_0xCB:
_0xC8:
_0xBB:
_0xAC:
_0x9F:
_0x9C:
_0x99:
_0x96:
_0x81:
_0x78:
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
_0x71:
	.BYTE 0x28F
;
;void lcdCommand(unsigned char cmnd)
; 0000 02F0 {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 02F1     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x1F
;	cmnd -> Y+0
; 0000 02F2     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x18,0
; 0000 02F3     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x20
; 0000 02F4     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 02F5     delay_us(1 * 16);          // wait to make EN wider
; 0000 02F6     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 02F7     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 02F8     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x21
; 0000 02F9     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 02FA     delay_us(1 * 16);          // wait to make EN wider
; 0000 02FB     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 02FC }
	RJMP _0x20A0005
; .FEND
;void lcdData(unsigned char data)
; 0000 02FE {
_lcdData:
; .FSTART _lcdData
; 0000 02FF     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x1F
;	data -> Y+0
; 0000 0300     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x18,0
; 0000 0301     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x20
; 0000 0302     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0303     delay_us(1 * 16);          // wait to make EN wider
; 0000 0304     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0305     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x21
; 0000 0306     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0307     delay_us(1 * 16);          // wait to make EN wider
; 0000 0308     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0309 }
	RJMP _0x20A0005
; .FEND
;void lcd_init()
; 0000 030B {
_lcd_init:
; .FSTART _lcd_init
; 0000 030C     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 030D     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x18,2
; 0000 030E     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 030F     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x15
; 0000 0310     delay_us(100 * 16);        // wait
; 0000 0311     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x15
; 0000 0312     delay_us(100 * 16);        // wait
; 0000 0313     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x15
; 0000 0314     delay_us(100 * 16);        // wait
; 0000 0315     lcdCommand(0x0c);          // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x15
; 0000 0316     delay_us(100 * 16);        // wait
; 0000 0317     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0318     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 0319     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x15
; 0000 031A     delay_us(100 * 16);
; 0000 031B }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 031D {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 031E     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 031F     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0x15
; 0000 0320     delay_us(100 * 16);
; 0000 0321 }
	ADIW R28,6
	RET
; .FEND
;void lcd_print(char *str)
; 0000 0323 {
_lcd_print:
; .FSTART _lcd_print
; 0000 0324     unsigned char i = 0;
; 0000 0325     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0xE4:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0xE6
; 0000 0326     {
; 0000 0327         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 0328         i++;
	SUBI R17,-1
; 0000 0329     }
	RJMP _0xE4
_0xE6:
; 0000 032A }
	LDD  R17,Y+0
	RJMP _0x20A0006
; .FEND
;
;void show_temperature()
; 0000 032D {
_show_temperature:
; .FSTART _show_temperature
; 0000 032E     unsigned char temperatureVal = 0;
; 0000 032F     unsigned char temperatureRep[3];
; 0000 0330 
; 0000 0331     ADMUX = 0xE0;
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 0332     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0333 
; 0000 0334     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0335     lcd_gotoxy(1, 1);
; 0000 0336     lcd_print("temperature(C):");
	__POINTW2MN _0xE7,0
	RCALL _lcd_print
; 0000 0337 
; 0000 0338     while (stage == STAGE_TEMPERATURE_MONITORING)
_0xE8:
	CALL SUBOPT_0xA
	BRNE _0xEA
; 0000 0339     {
; 0000 033A         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 033B         while ((ADCSRA & (1 << ADIF)) == 0)
_0xEB:
	SBIS 0x6,4
; 0000 033C             ;
	RJMP _0xEB
; 0000 033D         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0xEE
; 0000 033E         {
; 0000 033F             temperatureVal = ADCH;
	IN   R17,5
; 0000 0340             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 0341             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0342             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 0343             lcd_print(" ");
	__POINTW2MN _0xE7,16
	RCALL _lcd_print
; 0000 0344         }
; 0000 0345         delay_ms(500);
_0xEE:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0346     }
	RJMP _0xE8
_0xEA:
; 0000 0347 
; 0000 0348     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0349 }
	LDD  R17,Y+0
	RJMP _0x20A0002
; .FEND

	.DSEG
_0xE7:
	.BYTE 0x12
;
;void show_menu()
; 0000 034C {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 034D 
; 0000 034E     while (stage == STAGE_INIT_MENU)
_0xEF:
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0xF1
; 0000 034F     {
; 0000 0350         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0351         lcd_gotoxy(1, 1);
; 0000 0352         if (page_num == 0)
	TST  R7
	BRNE _0xF2
; 0000 0353         {
; 0000 0354             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0xF3,0
	CALL SUBOPT_0x2
; 0000 0355             lcd_gotoxy(1, 2);
; 0000 0356             lcd_print("2: Student Management");
	__POINTW2MN _0xF3,29
	RCALL _lcd_print
; 0000 0357             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0xF4:
	TST  R7
	BRNE _0xF7
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xF8
_0xF7:
	RJMP _0xF6
_0xF8:
; 0000 0358                 ;
	RJMP _0xF4
_0xF6:
; 0000 0359         }
; 0000 035A         else if (page_num == 1)
	RJMP _0xF9
_0xF2:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xFA
; 0000 035B         {
; 0000 035C             lcd_print("3: View Present Students ");
	__POINTW2MN _0xF3,51
	CALL SUBOPT_0x2
; 0000 035D             lcd_gotoxy(1, 2);
; 0000 035E             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0xF3,77
	RCALL _lcd_print
; 0000 035F             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0xFB:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xFE
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xFF
_0xFE:
	RJMP _0xFD
_0xFF:
; 0000 0360                 ;
	RJMP _0xFB
_0xFD:
; 0000 0361         }
; 0000 0362         else if (page_num == 2)
	RJMP _0x100
_0xFA:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x101
; 0000 0363         {
; 0000 0364             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0xF3,103
	CALL SUBOPT_0x2
; 0000 0365             lcd_gotoxy(1, 2);
; 0000 0366             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0xF3,128
	RCALL _lcd_print
; 0000 0367             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0x102:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x105
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x106
_0x105:
	RJMP _0x104
_0x106:
; 0000 0368                 ;
	RJMP _0x102
_0x104:
; 0000 0369         }
; 0000 036A         else if (page_num == 3)
	RJMP _0x107
_0x101:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x108
; 0000 036B         {
; 0000 036C             lcd_print("7: Login With Admin");
	__POINTW2MN _0xF3,150
	CALL SUBOPT_0x2
; 0000 036D             lcd_gotoxy(1, 2);
; 0000 036E             lcd_print("8: Logout");
	__POINTW2MN _0xF3,170
	RCALL _lcd_print
; 0000 036F             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0x109:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x10C
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x10D
_0x10C:
	RJMP _0x10B
_0x10D:
; 0000 0370                 ;
	RJMP _0x109
_0x10B:
; 0000 0371         }
; 0000 0372     }
_0x108:
_0x107:
_0x100:
_0xF9:
	RJMP _0xEF
_0xF1:
; 0000 0373 }
	RET
; .FEND

	.DSEG
_0xF3:
	.BYTE 0xB4
;
;void clear_eeprom()
; 0000 0376 {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 0377     unsigned int i;
; 0000 0378 
; 0000 0379     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x10F:
	__CPWRN 16,17,1024
	BRSH _0x110
; 0000 037A     {
; 0000 037B         // Wait for the previous write to complete
; 0000 037C         while (EECR & (1 << EEWE))
_0x111:
	SBIC 0x1C,1
; 0000 037D             ;
	RJMP _0x111
; 0000 037E 
; 0000 037F         // Set up address registers
; 0000 0380         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 0381         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 0382 
; 0000 0383         // Set up data register
; 0000 0384         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 0385 
; 0000 0386         // Enable write
; 0000 0387         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 0388         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 0389     }
	__ADDWRN 16,17,1
	RJMP _0x10F
_0x110:
; 0000 038A }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 038D {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 038E     unsigned char x;
; 0000 038F     // Wait for the previous write to complete
; 0000 0390     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x114:
	SBIC 0x1C,1
; 0000 0391         ;
	RJMP _0x114
; 0000 0392 
; 0000 0393     // Set up address registers
; 0000 0394     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x22
; 0000 0395     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 0396     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 0397     x = EEDR;
	IN   R17,29
; 0000 0398     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0006
; 0000 0399 }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 039C {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 039D     // Wait for the previous write to complete
; 0000 039E     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x117:
	SBIC 0x1C,1
; 0000 039F         ;
	RJMP _0x117
; 0000 03A0 
; 0000 03A1     // Set up address registers
; 0000 03A2     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x22
; 0000 03A3     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 03A4 
; 0000 03A5     // Set up data register
; 0000 03A6     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 03A7 
; 0000 03A8     // Enable write
; 0000 03A9     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 03AA     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 03AB }
_0x20A0006:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 03AE {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 03AF     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x11A:
	SBIS 0xB,5
; 0000 03B0         ;
	RJMP _0x11A
; 0000 03B1     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 03B2 }
_0x20A0005:
	ADIW R28,1
	RET
; .FEND
;
;unsigned char USART_Receive()
; 0000 03B5 {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 03B6     while(!(UCSRA & (1 << RXC)) && stage == STAGE_SUBMIT_WITH_CARD);
_0x11D:
	SBIC 0xB,7
	RJMP _0x120
	CALL SUBOPT_0x5
	BREQ _0x121
_0x120:
	RJMP _0x11F
_0x121:
	RJMP _0x11D
_0x11F:
; 0000 03B7     return UDR;
	IN   R30,0xC
	RET
; 0000 03B8 }
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 03BB {
_USART_init:
; .FSTART _USART_init
; 0000 03BC     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 03BD     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 03BE     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 03BF     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 03C0 }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 03C3 {
_search_student_code:
; .FSTART _search_student_code
; 0000 03C4     unsigned char st_counts, i, j;
; 0000 03C5     char temp[10];
; 0000 03C6 
; 0000 03C7     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0xD
	MOV  R17,R30
; 0000 03C8 
; 0000 03C9     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x123:
	CP   R16,R17
	BRSH _0x124
; 0000 03CA     {
; 0000 03CB         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 03CC         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x126:
	CPI  R19,8
	BRSH _0x127
; 0000 03CD         {
; 0000 03CE             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
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
	CALL SUBOPT_0x1D
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	POP  R26
	POP  R27
	ST   X,R30
; 0000 03CF         }
	SUBI R19,-1
	RJMP _0x126
_0x127:
; 0000 03D0         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 03D1         if (strncmp(temp, buffer, 8) == 0)
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
	BRNE _0x128
; 0000 03D2             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20A0004
; 0000 03D3     }
_0x128:
	SUBI R16,-1
	RJMP _0x123
_0x124:
; 0000 03D4 
; 0000 03D5     return 0;
	LDI  R30,LOW(0)
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 03D6 }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 03D9 {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 03DA     unsigned char st_counts, i, j;
; 0000 03DB     unsigned char temp;
; 0000 03DC 
; 0000 03DD     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0xD
	MOV  R17,R30
; 0000 03DE 
; 0000 03DF     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x12A:
	CP   R17,R16
	BRLO _0x12B
; 0000 03E0     {
; 0000 03E1         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x12D:
	CPI  R19,8
	BRSH _0x12E
; 0000 03E2         {
; 0000 03E3             temp = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0x1D
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	MOV  R18,R30
; 0000 03E4             write_byte_to_eeprom(j + ((i) * 8), temp);
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
; 0000 03E5         }
	SUBI R19,-1
	RJMP _0x12D
_0x12E:
; 0000 03E6     }
	SUBI R16,-1
	RJMP _0x12A
_0x12B:
; 0000 03E7     write_byte_to_eeprom(0x0, st_counts - 1);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 03E8 }
	CALL __LOADLOCR4
	JMP  _0x20A0001
; .FEND
;
;void HCSR04Init()
; 0000 03EB {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 03EC     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 03ED     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 03EE }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 03F1 {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 03F2     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 03F3     delay_us(15);                   // Wait for 15 microseconds
	__DELAY_USB 40
; 0000 03F4     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 03F5 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 03F8 {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 03F9     uint32_t i, result;
; 0000 03FA 
; 0000 03FB     // Wait for rising edge on Echo pin
; 0000 03FC     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x130:
	CALL SUBOPT_0x23
	BRSH _0x131
; 0000 03FD     {
; 0000 03FE         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 03FF             continue;
	RJMP _0x12F
; 0000 0400         else
; 0000 0401             break;
	RJMP _0x131
; 0000 0402     }
_0x12F:
	CALL SUBOPT_0x24
	RJMP _0x130
_0x131:
; 0000 0403 
; 0000 0404     if (i == 600000)
	CALL SUBOPT_0x23
	BRNE _0x134
; 0000 0405         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0003
; 0000 0406 
; 0000 0407     // Start timer with prescaler 8
; 0000 0408     TCCR1A = 0x00;
_0x134:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0409     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 040A     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 040B 
; 0000 040C     // Wait for falling edge on Echo pin
; 0000 040D     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x136:
	CALL SUBOPT_0x23
	BRSH _0x137
; 0000 040E     {
; 0000 040F         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 0410             break; // Falling edge detected
	RJMP _0x137
; 0000 0411         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x139
; 0000 0412             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0003
; 0000 0413     }
_0x139:
	CALL SUBOPT_0x24
	RJMP _0x136
_0x137:
; 0000 0414 
; 0000 0415     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 0416     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0417 
; 0000 0418     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x13A
; 0000 0419         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0003
; 0000 041A     else
_0x13A:
; 0000 041B         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
; 0000 041C }
_0x20A0003:
	ADIW R28,8
	RET
; .FEND
;
;void startSonar()
; 0000 041F {
_startSonar:
; .FSTART _startSonar
; 0000 0420     char numberString[16];
; 0000 0421     uint16_t pulseWidth; // Pulse width from echo
; 0000 0422     int distance, previous_distance = -1;
; 0000 0423     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 0424 
; 0000 0425     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x1
; 0000 0426     lcd_gotoxy(1, 1);
; 0000 0427     lcd_print("Distance: ");
	__POINTW2MN _0x13D,0
	RCALL _lcd_print
; 0000 0428 
; 0000 0429     while (stage == STAGE_TRAFFIC_MONITORING)
_0x13E:
	CALL SUBOPT_0x13
	BREQ PC+2
	RJMP _0x140
; 0000 042A     {
; 0000 042B         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 042C         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 042D 
; 0000 042E         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x141
; 0000 042F         {
; 0000 0430             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0431             lcd_gotoxy(1, 1);
; 0000 0432             lcd_print("Error"); // Display error message
	__POINTW2MN _0x13D,11
	RJMP _0x151
; 0000 0433         }
; 0000 0434         else if (pulseWidth == US_NO_OBSTACLE)
_0x141:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x143
; 0000 0435         {
; 0000 0436             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0437             lcd_gotoxy(1, 1);
; 0000 0438             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x13D,17
	RJMP _0x151
; 0000 0439         }
; 0000 043A         else
_0x143:
; 0000 043B         {
; 0000 043C             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 043D 
; 0000 043E             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x145
; 0000 043F             {
; 0000 0440                 previous_distance = distance;
	MOVW R20,R18
; 0000 0441                 // Display distance on LCD
; 0000 0442                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0443                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0444                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 0445                 lcd_print(" cm ");
	__POINTW2MN _0x13D,29
	RCALL _lcd_print
; 0000 0446             }
; 0000 0447             // Counting logic based on distance
; 0000 0448             if (distance < 6)
_0x145:
	__CPWRN 18,19,6
	BRGE _0x146
; 0000 0449             {
; 0000 044A                 US_count++; // Increment count if distance is below threshold
	INC  R6
; 0000 044B             }
; 0000 044C 
; 0000 044D             // Update count on LCD only if it changes
; 0000 044E             if (US_count != previous_count)
_0x146:
	LDS  R30,_previous_count_S0000014000
	LDS  R31,_previous_count_S0000014000+1
	MOV  R26,R6
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x147
; 0000 044F             {
; 0000 0450                 previous_count = US_count;
	MOV  R30,R6
	LDI  R31,0
	STS  _previous_count_S0000014000,R30
	STS  _previous_count_S0000014000+1,R31
; 0000 0451                 lcd_gotoxy(1, 2); // Move to second line
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0452                 itoa(US_count, numberString);
	MOV  R30,R6
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0453                 lcd_print("Count: ");
	__POINTW2MN _0x13D,34
	RCALL _lcd_print
; 0000 0454                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x151:
	RCALL _lcd_print
; 0000 0455             }
; 0000 0456         }
_0x147:
; 0000 0457         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0458     }
	RJMP _0x13E
_0x140:
; 0000 0459 }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x13D:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 045C {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 045D     unsigned int hash = 0;
; 0000 045E     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x148:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x14A
; 0000 045F     {
; 0000 0460         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 0461         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0462     }
	RJMP _0x148
_0x14A:
; 0000 0463     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0002:
	ADIW R28,4
	RET
; 0000 0464 }
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:183 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _lcd_print

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:109 WORDS
SUBOPT_0x9:
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
SUBOPT_0xA:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF:
	CALL _lcd_print
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x15:
	CALL _lcdCommand
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:339 WORDS
SUBOPT_0x17:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1B:
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
SUBOPT_0x1C:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R31,0
	ADIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
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
SUBOPT_0x20:
	CBI  0x18,1
	SBI  0x18,2
	__DELAY_USB 43
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
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
SUBOPT_0x22:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x23:
	__GETD2S 4
	__CPD2N 0x927C0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
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
