
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
_0x141:
	.DB  0xFF,0xFF
_0x0:
	.DB  0x31,0x3A,0x20,0x53,0x75,0x62,0x6D,0x69
	.DB  0x74,0x20,0x53,0x74,0x75,0x64,0x65,0x6E
	.DB  0x74,0x20,0x43,0x6F,0x64,0x65,0x0,0x32
	.DB  0x3A,0x20,0x53,0x75,0x62,0x6D,0x69,0x74
	.DB  0x20,0x57,0x69,0x74,0x68,0x20,0x43,0x61
	.DB  0x72,0x64,0x0,0x45,0x6E,0x74,0x65,0x72
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
	.DB  0x62,0x61,0x63,0x6B,0x0,0x4C,0x6F,0x67
	.DB  0x6F,0x75,0x74,0x20,0x2E,0x2E,0x2E,0x0
	.DB  0x47,0x6F,0x69,0x6E,0x67,0x20,0x54,0x6F
	.DB  0x20,0x41,0x64,0x6D,0x69,0x6E,0x20,0x50
	.DB  0x61,0x67,0x65,0x20,0x49,0x6E,0x20,0x32
	.DB  0x20,0x53,0x65,0x63,0x0,0x49,0x6E,0x63
	.DB  0x6F,0x72,0x72,0x65,0x63,0x74,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x43
	.DB  0x6F,0x64,0x65,0x20,0x46,0x6F,0x72,0x6D
	.DB  0x61,0x74,0x0,0x59,0x6F,0x75,0x20,0x57
	.DB  0x69,0x6C,0x6C,0x20,0x42,0x61,0x63,0x6B
	.DB  0x20,0x4D,0x65,0x6E,0x75,0x20,0x49,0x6E
	.DB  0x20,0x32,0x20,0x53,0x65,0x63,0x6F,0x6E
	.DB  0x64,0x0,0x44,0x75,0x70,0x6C,0x69,0x63
	.DB  0x61,0x74,0x65,0x20,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x45,0x6E,0x74,0x65,0x72,0x65,0x64
	.DB  0x0,0x53,0x74,0x75,0x64,0x65,0x6E,0x74
	.DB  0x20,0x43,0x6F,0x64,0x65,0x20,0x53,0x75
	.DB  0x63,0x63,0x65,0x73,0x73,0x66,0x75,0x6C
	.DB  0x6C,0x79,0x20,0x41,0x64,0x64,0x65,0x64
	.DB  0x0,0x59,0x6F,0x75,0x20,0x4D,0x75,0x73
	.DB  0x74,0x20,0x46,0x69,0x72,0x73,0x74,0x20
	.DB  0x4C,0x6F,0x67,0x69,0x6E,0x0,0x59,0x6F
	.DB  0x75,0x20,0x57,0x69,0x6C,0x6C,0x20,0x47
	.DB  0x6F,0x20,0x41,0x64,0x6D,0x69,0x6E,0x20
	.DB  0x50,0x61,0x67,0x65,0x20,0x32,0x20,0x53
	.DB  0x65,0x63,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x43,0x6F,0x64,0x65,0x20
	.DB  0x46,0x6F,0x75,0x6E,0x64,0x0,0x4F,0x70
	.DB  0x73,0x20,0x2C,0x20,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x43,0x6F,0x64,0x65
	.DB  0x20,0x4E,0x6F,0x74,0x20,0x46,0x6F,0x75
	.DB  0x6E,0x64,0x0,0x57,0x61,0x69,0x74,0x20
	.DB  0x46,0x6F,0x72,0x20,0x44,0x65,0x6C,0x65
	.DB  0x74,0x65,0x2E,0x2E,0x2E,0x0,0x53,0x74
	.DB  0x75,0x64,0x65,0x6E,0x74,0x20,0x43,0x6F
	.DB  0x64,0x65,0x20,0x57,0x61,0x73,0x20,0x44
	.DB  0x65,0x6C,0x65,0x74,0x65,0x64,0x0,0x4C
	.DB  0x6F,0x67,0x69,0x6E,0x20,0x53,0x75,0x63
	.DB  0x63,0x65,0x73,0x73,0x66,0x75,0x6C,0x6C
	.DB  0x79,0x0,0x57,0x61,0x69,0x74,0x2E,0x2E
	.DB  0x2E,0x0,0x4F,0x70,0x73,0x20,0x2C,0x20
	.DB  0x73,0x65,0x63,0x72,0x65,0x74,0x20,0x69
	.DB  0x73,0x20,0x69,0x6E,0x63,0x6F,0x72,0x72
	.DB  0x65,0x63,0x74,0x0,0x43,0x6C,0x65,0x61
	.DB  0x72,0x69,0x6E,0x67,0x20,0x45,0x45,0x50
	.DB  0x52,0x4F,0x4D,0x20,0x2E,0x2E,0x2E,0x0
	.DB  0x74,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
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
	.DB  0x6F,0x75,0x74,0x0,0x44,0x69,0x73,0x74
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
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x17
	.DW  _0xB
	.DW  _0x0*2

	.DW  0x14
	.DW  _0xB+23
	.DW  _0x0*2+23

	.DW  0x19
	.DW  _0xB+43
	.DW  _0x0*2+43

	.DW  0x1D
	.DW  _0xB+68
	.DW  _0x0*2+68

	.DW  0x03
	.DW  _0xB+97
	.DW  _0x0*2+97

	.DW  0x0D
	.DW  _0xB+100
	.DW  _0x0*2+100

	.DW  0x17
	.DW  _0xB+113
	.DW  _0x0*2+113

	.DW  0x17
	.DW  _0xB+136
	.DW  _0x0*2+136

	.DW  0x16
	.DW  _0xB+159
	.DW  _0x0*2+159

	.DW  0x18
	.DW  _0xB+181
	.DW  _0x0*2+181

	.DW  0x16
	.DW  _0xB+205
	.DW  _0x0*2+205

	.DW  0x18
	.DW  _0xB+227
	.DW  _0x0*2+227

	.DW  0x12
	.DW  _0xB+251
	.DW  _0x0*2+251

	.DW  0x12
	.DW  _0xB+269
	.DW  _0x0*2+269

	.DW  0x1F
	.DW  _0xB+287
	.DW  _0x0*2+287

	.DW  0x1F
	.DW  _0xB+318
	.DW  _0x0*2+318

	.DW  0x1E
	.DW  _0xB+349
	.DW  _0x0*2+349

	.DW  0x11
	.DW  _0xB+379
	.DW  _0x0*2+379

	.DW  0x19
	.DW  _0xB+396
	.DW  _0x0*2+396

	.DW  0x0B
	.DW  _0x76
	.DW  _0x0*2+421

	.DW  0x1D
	.DW  _0x76+11
	.DW  _0x0*2+432

	.DW  0x02
	.DW  _0x76+40
	.DW  _0x0*2+179

	.DW  0x03
	.DW  _0x76+42
	.DW  _0x0*2+97

	.DW  0x1E
	.DW  _0x76+45
	.DW  _0x0*2+461

	.DW  0x1F
	.DW  _0x76+75
	.DW  _0x0*2+491

	.DW  0x1F
	.DW  _0x76+106
	.DW  _0x0*2+522

	.DW  0x1F
	.DW  _0x76+137
	.DW  _0x0*2+491

	.DW  0x20
	.DW  _0x76+168
	.DW  _0x0*2+553

	.DW  0x1F
	.DW  _0x76+200
	.DW  _0x0*2+491

	.DW  0x15
	.DW  _0x76+231
	.DW  _0x0*2+585

	.DW  0x1D
	.DW  _0x76+252
	.DW  _0x0*2+606

	.DW  0x02
	.DW  _0x76+281
	.DW  _0x0*2+179

	.DW  0x13
	.DW  _0x76+283
	.DW  _0x0*2+635

	.DW  0x1F
	.DW  _0x76+302
	.DW  _0x0*2+491

	.DW  0x1D
	.DW  _0x76+333
	.DW  _0x0*2+654

	.DW  0x1F
	.DW  _0x76+362
	.DW  _0x0*2+491

	.DW  0x02
	.DW  _0x76+393
	.DW  _0x0*2+179

	.DW  0x13
	.DW  _0x76+395
	.DW  _0x0*2+635

	.DW  0x13
	.DW  _0x76+414
	.DW  _0x0*2+683

	.DW  0x19
	.DW  _0x76+433
	.DW  _0x0*2+702

	.DW  0x1F
	.DW  _0x76+458
	.DW  _0x0*2+491

	.DW  0x1D
	.DW  _0x76+489
	.DW  _0x0*2+654

	.DW  0x1F
	.DW  _0x76+518
	.DW  _0x0*2+491

	.DW  0x02
	.DW  _0x76+549
	.DW  _0x0*2+179

	.DW  0x13
	.DW  _0x76+551
	.DW  _0x0*2+727

	.DW  0x08
	.DW  _0x76+570
	.DW  _0x0*2+746

	.DW  0x1A
	.DW  _0x76+578
	.DW  _0x0*2+754

	.DW  0x1F
	.DW  _0x76+604
	.DW  _0x0*2+491

	.DW  0x14
	.DW  _0x76+635
	.DW  _0x0*2+780

	.DW  0x10
	.DW  _0xEC
	.DW  _0x0*2+800

	.DW  0x02
	.DW  _0xEC+16
	.DW  _0x0*2+179

	.DW  0x1D
	.DW  _0xF8
	.DW  _0x0*2+816

	.DW  0x16
	.DW  _0xF8+29
	.DW  _0x0*2+845

	.DW  0x1A
	.DW  _0xF8+51
	.DW  _0x0*2+867

	.DW  0x1A
	.DW  _0xF8+77
	.DW  _0x0*2+893

	.DW  0x19
	.DW  _0xF8+103
	.DW  _0x0*2+919

	.DW  0x16
	.DW  _0xF8+128
	.DW  _0x0*2+944

	.DW  0x14
	.DW  _0xF8+150
	.DW  _0x0*2+966

	.DW  0x0A
	.DW  _0xF8+170
	.DW  _0x0*2+986

	.DW  0x02
	.DW  _previous_count_S0000014000
	.DW  _0x141*2

	.DW  0x0B
	.DW  _0x142
	.DW  _0x0*2+996

	.DW  0x06
	.DW  _0x142+11
	.DW  _0x0*2+1007

	.DW  0x0C
	.DW  _0x142+17
	.DW  _0x0*2+1013

	.DW  0x05
	.DW  _0x142+29
	.DW  _0x0*2+1025

	.DW  0x08
	.DW  _0x142+34
	.DW  _0x0*2+1030

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
; 0000 007F             lcd_print("1: Submit Student Code");
	__POINTW2MN _0xB,0
	CALL SUBOPT_0x2
; 0000 0080             lcd_gotoxy(1, 2);
; 0000 0081             lcd_print("2: Submit With Card");
	__POINTW2MN _0xB,23
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
	__POINTW2MN _0xB,43
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
	RJMP _0x150
; 0000 0090             delay_us(100 * 16); // wait
; 0000 0091         }
; 0000 0092         else if(stage == STAGE_SUBMIT_WITH_CARD)
_0x10:
	CALL SUBOPT_0x5
	BREQ PC+2
	RJMP _0x15
; 0000 0093         {
; 0000 0094             while (stage == STAGE_SUBMIT_WITH_CARD)
_0x16:
	CALL SUBOPT_0x5
	BREQ PC+2
	RJMP _0x18
; 0000 0095             {
; 0000 0096                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0097                 lcd_gotoxy(1, 1);
; 0000 0098                 lcd_print("Bring your card near device:");
	__POINTW2MN _0xB,68
	CALL SUBOPT_0x2
; 0000 0099                 lcd_gotoxy(1, 2);
; 0000 009A                 delay_us(100 * 16); // wait
	CALL SUBOPT_0x6
; 0000 009B                 while((data = USART_Receive()) != '\r'){
_0x19:
	CALL _USART_Receive
	MOV  R20,R30
	CPI  R30,LOW(0xD)
	BREQ _0x1B
; 0000 009C                     if(stage != STAGE_SUBMIT_WITH_CARD)
	CALL SUBOPT_0x5
	BRNE _0x1B
; 0000 009D                         break;
; 0000 009E                     buffer[strlen(buffer)] = data;
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	ST   Z,R20
; 0000 009F                 }
	RJMP _0x19
_0x1B:
; 0000 00A0                 if(stage != STAGE_SUBMIT_WITH_CARD){
	CALL SUBOPT_0x5
	BREQ _0x1D
; 0000 00A1                     memset(buffer,0,32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00A2                     break;
	RJMP _0x18
; 0000 00A3                 }
; 0000 00A4                 if (strncmp(buffer, "40", 2) != 0 ||
_0x1D:
; 0000 00A5                         strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0xB,97
	CALL SUBOPT_0xA
	BRNE _0x1F
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x1E
_0x1F:
; 0000 00A6                 {
; 0000 00A7                     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00A8                     lcd_gotoxy(1, 1);
; 0000 00A9                     lcd_print("Invalid Card");
	__POINTW2MN _0xB,100
	RCALL _lcd_print
; 0000 00AA                     BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00AB                     delay_ms(2000);
	CALL SUBOPT_0xB
; 0000 00AC                     BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00AD                 }
; 0000 00AE                 else{
	RJMP _0x21
_0x1E:
; 0000 00AF                     if (search_student_code() > 0){
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x22
; 0000 00B0                         BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 00B1                         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00B2                         lcd_gotoxy(1, 1);
; 0000 00B3                         lcd_print("Duplicate Student Code");
	__POINTW2MN _0xB,113
	CALL SUBOPT_0xC
; 0000 00B4                         delay_ms(2000);
; 0000 00B5                         BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 00B6                     }
; 0000 00B7                     else{
	RJMP _0x23
_0x22:
; 0000 00B8                         // save the buffer to EEPROM
; 0000 00B9                         st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
; 0000 00BA                         for (i = 0; i < 8; i++)
	__GETWRN 16,17,0
_0x25:
	__CPWRN 16,17,8
	BRGE _0x26
; 0000 00BB                         {
; 0000 00BC                             write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
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
	RCALL _write_byte_to_eeprom
; 0000 00BD                         }
	__ADDWRN 16,17,1
	RJMP _0x25
_0x26:
; 0000 00BE                         write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0xF
	MOV  R26,R21
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 00BF                         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00C0                         lcd_gotoxy(1, 1);
; 0000 00C1                         lcd_print("Student added with ID:");
	__POINTW2MN _0xB,136
	CALL SUBOPT_0x2
; 0000 00C2                         lcd_gotoxy(1, 2);
; 0000 00C3                         lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00C4                         delay_ms(3000); // wait
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00C5                     }
_0x23:
; 0000 00C6                 }
_0x21:
; 0000 00C7                 memset(buffer,0,32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00C8             }
	RJMP _0x16
_0x18:
; 0000 00C9         }
; 0000 00CA         else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x27
_0x15:
	CALL SUBOPT_0x11
	BRNE _0x28
; 0000 00CB         {
; 0000 00CC             show_temperature();
	RCALL _show_temperature
; 0000 00CD         }
; 0000 00CE         else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0x29
_0x28:
	CALL SUBOPT_0x12
	BREQ PC+2
	RJMP _0x2A
; 0000 00CF         {
; 0000 00D0             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00D1             lcd_gotoxy(1, 1);
; 0000 00D2             lcd_print("Number of students : ");
	__POINTW2MN _0xB,159
	CALL SUBOPT_0x2
; 0000 00D3             lcd_gotoxy(1, 2);
; 0000 00D4             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
; 0000 00D5             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00D6             itoa(st_counts, buffer);
	MOV  R30,R21
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _itoa
; 0000 00D7             lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00D8             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00D9 
; 0000 00DA             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x2C:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2D
; 0000 00DB             {
; 0000 00DC                 memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00DD                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x2F:
	__CPWRN 18,19,8
	BRGE _0x30
; 0000 00DE                 {
; 0000 00DF                     buffer[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOVW R30,R18
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x13
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00E0                 }
	__ADDWRN 18,19,1
	RJMP _0x2F
_0x30:
; 0000 00E1                 buffer[j] = '\0';
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00E2                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00E3                 lcd_gotoxy(1, 1);
; 0000 00E4                 lcd_print(buffer);
	CALL SUBOPT_0x10
; 0000 00E5                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00E6             }
	__ADDWRN 16,17,1
	RJMP _0x2C
_0x2D:
; 0000 00E7 
; 0000 00E8             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00E9             lcd_gotoxy(1, 1);
; 0000 00EA             lcd_print("Press Cancel To Go Back");
	__POINTW2MN _0xB,181
	RCALL _lcd_print
; 0000 00EB             while (stage == STAGE_VIEW_PRESENT_STUDENTS)
_0x31:
	CALL SUBOPT_0x12
	BREQ _0x31
; 0000 00EC                 ;
; 0000 00ED         }
; 0000 00EE         else if (stage == STAGE_RETRIEVE_STUDENT_DATA)
	RJMP _0x34
_0x2A:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x35
; 0000 00EF         {
; 0000 00F0             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 00F1             lcd_gotoxy(1, 1);
; 0000 00F2             lcd_print("Start Transferring...");
	__POINTW2MN _0xB,205
	RCALL _lcd_print
; 0000 00F3             st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0xD
; 0000 00F4             for (i = 0; i < st_counts; i++)
	__GETWRN 16,17,0
_0x37:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x38
; 0000 00F5             {
; 0000 00F6                 for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3A:
	__CPWRN 18,19,8
	BRGE _0x3B
; 0000 00F7                 {
; 0000 00F8                     USART_Transmit(read_byte_from_eeprom(j + ((i + 1) * 8)));
	CALL SUBOPT_0x13
	MOV  R26,R30
	RCALL _USART_Transmit
; 0000 00F9                 }
	__ADDWRN 18,19,1
	RJMP _0x3A
_0x3B:
; 0000 00FA 
; 0000 00FB                 USART_Transmit('\r');
	CALL SUBOPT_0x14
; 0000 00FC                 USART_Transmit('\r');
; 0000 00FD 
; 0000 00FE                 delay_ms(500);
; 0000 00FF             }
	__ADDWRN 16,17,1
	RJMP _0x37
_0x38:
; 0000 0100             for (j = 0; j < 8; j++)
	__GETWRN 18,19,0
_0x3D:
	__CPWRN 18,19,8
	BRGE _0x3E
; 0000 0101             {
; 0000 0102                 USART_Transmit('=');
	LDI  R26,LOW(61)
	RCALL _USART_Transmit
; 0000 0103             }
	__ADDWRN 18,19,1
	RJMP _0x3D
_0x3E:
; 0000 0104 
; 0000 0105             USART_Transmit('\r');
	CALL SUBOPT_0x14
; 0000 0106             USART_Transmit('\r');
; 0000 0107             delay_ms(500);
; 0000 0108 
; 0000 0109             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 010A             lcd_gotoxy(1, 1);
; 0000 010B             lcd_print("Usart Transmit Finished");
	__POINTW2MN _0xB,227
	CALL SUBOPT_0x15
; 0000 010C             delay_ms(2000);
; 0000 010D             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 010E         }
; 0000 010F         else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0x3F
_0x35:
	CALL SUBOPT_0x16
	BRNE _0x40
; 0000 0110         {
; 0000 0111             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0112             lcd_gotoxy(1, 1);
; 0000 0113             lcd_print("1: Search Student");
	__POINTW2MN _0xB,251
	CALL SUBOPT_0x2
; 0000 0114             lcd_gotoxy(1, 2);
; 0000 0115             lcd_print("2: Delete Student");
	__POINTW2MN _0xB,269
	RCALL _lcd_print
; 0000 0116             while (stage == STAGE_STUDENT_MANAGMENT)
_0x41:
	CALL SUBOPT_0x16
	BREQ _0x41
; 0000 0117                 ;
; 0000 0118         }
; 0000 0119         else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0x44
_0x40:
	CALL SUBOPT_0x17
	BRNE _0x45
; 0000 011A         {
; 0000 011B             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 011C             lcd_gotoxy(1, 1);
; 0000 011D             lcd_print("Enter Student Code For Search:");
	__POINTW2MN _0xB,287
	CALL SUBOPT_0x2
; 0000 011E             lcd_gotoxy(1, 2);
; 0000 011F             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 0120             delay_us(100 * 16); // wait
; 0000 0121             while (stage == STAGE_SEARCH_STUDENT)
_0x46:
	CALL SUBOPT_0x17
	BREQ _0x46
; 0000 0122                 ;
; 0000 0123             lcdCommand(0x0c);   // display on, cursor off
	RJMP _0x150
; 0000 0124             delay_us(100 * 16); // wait
; 0000 0125         }
; 0000 0126         else if (stage == STAGE_DELETE_STUDENT)
_0x45:
	CALL SUBOPT_0x18
	BRNE _0x4A
; 0000 0127         {
; 0000 0128             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0129             lcd_gotoxy(1, 1);
; 0000 012A             lcd_print("Enter Student Code For Delete:");
	__POINTW2MN _0xB,318
	CALL SUBOPT_0x2
; 0000 012B             lcd_gotoxy(1, 2);
; 0000 012C             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 012D             delay_us(100 * 16); // wait
; 0000 012E             while (stage == STAGE_DELETE_STUDENT)
_0x4B:
	CALL SUBOPT_0x18
	BREQ _0x4B
; 0000 012F                 ;
; 0000 0130             lcdCommand(0x0c); // display on, cursor off
	RJMP _0x150
; 0000 0131             delay_us(100 * 16);
; 0000 0132         }
; 0000 0133         else if (stage == STAGE_TRAFFIC_MONITORING)
_0x4A:
	CALL SUBOPT_0x19
	BRNE _0x4F
; 0000 0134         {
; 0000 0135             startSonar();
	RCALL _startSonar
; 0000 0136             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0137         }
; 0000 0138         else if (stage == STAGE_LOGIN_WITH_ADMIN)
	RJMP _0x50
_0x4F:
	CALL SUBOPT_0x1A
	BRNE _0x51
; 0000 0139         {
; 0000 013A             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 013B             lcd_gotoxy(1, 1);
; 0000 013C             lcd_print("Enter Secret Code (or cancel)");
	__POINTW2MN _0xB,349
	CALL SUBOPT_0x2
; 0000 013D             lcd_gotoxy(1, 2);
; 0000 013E             lcdCommand(0x0f);   // display on, cursor blinking
	CALL SUBOPT_0x4
; 0000 013F             delay_us(100 * 16); // wait
; 0000 0140             while (stage == STAGE_LOGIN_WITH_ADMIN && logged_in == 0)
_0x52:
	CALL SUBOPT_0x1A
	BRNE _0x55
	TST  R9
	BREQ _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 0141                 ;
	RJMP _0x52
_0x54:
; 0000 0142             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x57
; 0000 0143             {
; 0000 0144                 lcdCommand(0x0c); // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x1B
; 0000 0145                 delay_us(100 * 16);
; 0000 0146                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0147                 lcd_gotoxy(1, 1);
; 0000 0148                 lcd_print("1 : Clear EEPROM");
	__POINTW2MN _0xB,379
	CALL SUBOPT_0x2
; 0000 0149                 lcd_gotoxy(1, 2);
; 0000 014A                 lcd_print("    press cancel to back");
	__POINTW2MN _0xB,396
	RCALL _lcd_print
; 0000 014B                 while (stage == STAGE_LOGIN_WITH_ADMIN)
_0x58:
	CALL SUBOPT_0x1A
	BREQ _0x58
; 0000 014C                     ;
; 0000 014D             }
; 0000 014E             else
	RJMP _0x5B
_0x57:
; 0000 014F             {
; 0000 0150                 lcdCommand(0x0c); // display on, cursor off
_0x150:
	LDI  R26,LOW(12)
	CALL SUBOPT_0x1B
; 0000 0151                 delay_us(100 * 16);
; 0000 0152             }
_0x5B:
; 0000 0153         }
; 0000 0154     }
_0x51:
_0x50:
_0x44:
_0x3F:
_0x34:
_0x29:
_0x27:
_0xF:
_0x9:
	RJMP _0x5
; 0000 0155 }
_0x5C:
	RJMP _0x5C
; .FEND

	.DSEG
_0xB:
	.BYTE 0x1A5
;
;// int0 (keypad) service routine
;interrupt[EXT_INT0] void int0_routine(void)
; 0000 0159 {

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
; 0000 015A     unsigned char colloc, rowloc, cl, st_counts, buffer_len;
; 0000 015B     int i;
; 0000 015C 
; 0000 015D     // detect the key
; 0000 015E     while (1)
	SBIW R28,2
	CALL __SAVELOCR6
;	colloc -> R17
;	rowloc -> R16
;	cl -> R19
;	st_counts -> R18
;	buffer_len -> R21
;	i -> Y+6
; 0000 015F     {
; 0000 0160         KEY_PRT = 0xEF;            // ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x1C
; 0000 0161         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0162         if (colloc != 0x0F)        // column detected
	BREQ _0x60
; 0000 0163         {
; 0000 0164             rowloc = 0; // save row location
	LDI  R16,LOW(0)
; 0000 0165             break;      // exit while loop
	RJMP _0x5F
; 0000 0166         }
; 0000 0167         KEY_PRT = 0xDF;            // ground row 1
_0x60:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x1C
; 0000 0168         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0169         if (colloc != 0x0F)        // column detected
	BREQ _0x61
; 0000 016A         {
; 0000 016B             rowloc = 1; // save row location
	LDI  R16,LOW(1)
; 0000 016C             break;      // exit while loop
	RJMP _0x5F
; 0000 016D         }
; 0000 016E         KEY_PRT = 0xBF;            // ground row 2
_0x61:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x1C
; 0000 016F         colloc = (KEY_PIN & 0x0F); // read the columns
; 0000 0170         if (colloc != 0x0F)        // column detected
	BREQ _0x62
; 0000 0171         {
; 0000 0172             rowloc = 2; // save row location
	LDI  R16,LOW(2)
; 0000 0173             break;      // exit while loop
	RJMP _0x5F
; 0000 0174         }
; 0000 0175         KEY_PRT = 0x7F;            // ground row 3
_0x62:
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 0176         colloc = (KEY_PIN & 0x0F); // read the columns
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 0177         rowloc = 3;                // save row location
	LDI  R16,LOW(3)
; 0000 0178         break;                     // exit while loop
; 0000 0179     }
_0x5F:
; 0000 017A     // check column and send result to Port D
; 0000 017B     if (colloc == 0x0E)
	CPI  R17,14
	BRNE _0x63
; 0000 017C         cl = 0;
	LDI  R19,LOW(0)
; 0000 017D     else if (colloc == 0x0D)
	RJMP _0x64
_0x63:
	CPI  R17,13
	BRNE _0x65
; 0000 017E         cl = 1;
	LDI  R19,LOW(1)
; 0000 017F     else if (colloc == 0x0B)
	RJMP _0x66
_0x65:
	CPI  R17,11
	BRNE _0x67
; 0000 0180         cl = 2;
	LDI  R19,LOW(2)
; 0000 0181     else
	RJMP _0x68
_0x67:
; 0000 0182         cl = 3;
	LDI  R19,LOW(3)
; 0000 0183 
; 0000 0184     KEY_PRT &= 0x0F; // ground all rows at once
_0x68:
_0x66:
_0x64:
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0185 
; 0000 0186     // inside menu level 1
; 0000 0187     if (stage == STAGE_INIT_MENU)
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0x69
; 0000 0188     {
; 0000 0189         switch (keypad[rowloc][cl] - '0')
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
; 0000 018A         {
; 0000 018B         case OPTION_ATTENDENCE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6D
; 0000 018C             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 018D             break;
	RJMP _0x6C
; 0000 018E         case OPTION_TEMPERATURE_MONITORING:
_0x6D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6E
; 0000 018F             stage = STAGE_TEMPERATURE_MONITORING;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 0190             break;
	RJMP _0x6C
; 0000 0191         case OPTION_VIEW_PRESENT_STUDENTS:
_0x6E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6F
; 0000 0192             stage = STAGE_VIEW_PRESENT_STUDENTS;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 0193             break;
	RJMP _0x6C
; 0000 0194         case OPTION_RETRIEVE_STUDENT_DATA:
_0x6F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x70
; 0000 0195             stage = STAGE_RETRIEVE_STUDENT_DATA;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
; 0000 0196             break;
	RJMP _0x6C
; 0000 0197         case OPTION_STUDENT_MANAGEMENT:
_0x70:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x71
; 0000 0198             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 0199             break;
	RJMP _0x6C
; 0000 019A         case OPTION_TRAFFIC_MONITORING:
_0x71:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x72
; 0000 019B             stage = STAGE_TRAFFIC_MONITORING;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R4,R30
; 0000 019C             break;
	RJMP _0x6C
; 0000 019D         case OPTION_LOGIN_WITH_ADMIN:
_0x72:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x73
; 0000 019E             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 019F             break;
	RJMP _0x6C
; 0000 01A0         case OPTION_LOGOUT:
_0x73:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x77
; 0000 01A1 #asm("cli") // disable interrupts
	cli
; 0000 01A2             if (logged_in == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x75
; 0000 01A3             {
; 0000 01A4                 lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 01A5                 lcd_gotoxy(1, 1);
; 0000 01A6                 lcd_print("Logout ...");
	__POINTW2MN _0x76,0
	CALL SUBOPT_0x2
; 0000 01A7                 lcd_gotoxy(1, 2);
; 0000 01A8                 lcd_print("Going To Admin Page In 2 Sec");
	__POINTW2MN _0x76,11
	CALL SUBOPT_0x15
; 0000 01A9                 delay_ms(2000);
; 0000 01AA                 logged_in = 0;
	CLR  R9
; 0000 01AB #asm("sei")
	sei
; 0000 01AC                 stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 01AD             }
; 0000 01AE             break;
_0x75:
; 0000 01AF         default:
_0x77:
; 0000 01B0             break;
; 0000 01B1         }
_0x6C:
; 0000 01B2 
; 0000 01B3         if (keypad[rowloc][cl] == 'L')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x4C)
	BRNE _0x78
; 0000 01B4         {
; 0000 01B5             page_num = page_num > 0 ? page_num - 1 : (MENU_PAGE_COUNT - 1);
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x79
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,1
	RJMP _0x7A
_0x79:
	LDI  R30,LOW(3)
_0x7A:
	MOV  R7,R30
; 0000 01B6         }
; 0000 01B7         if (keypad[rowloc][cl] == 'R')
_0x78:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x52)
	BRNE _0x7C
; 0000 01B8         {
; 0000 01B9             page_num = (page_num + 1) % MENU_PAGE_COUNT;
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	MOV  R7,R30
; 0000 01BA         }
; 0000 01BB     }
_0x7C:
; 0000 01BC     else if (stage == STAGE_ATTENDENC_MENU)
	RJMP _0x7D
_0x69:
	CALL SUBOPT_0x0
	BRNE _0x7E
; 0000 01BD     {
; 0000 01BE         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
; 0000 01BF         {
; 0000 01C0         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x82
; 0000 01C1             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 01C2             break;
	RJMP _0x81
; 0000 01C3         case '1':
_0x82:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x83
; 0000 01C4             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 01C5             stage = STAGE_SUBMIT_CODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 01C6             break;
	RJMP _0x81
; 0000 01C7         case '2':
_0x83:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x85
; 0000 01C8             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 01C9             stage = STAGE_SUBMIT_WITH_CARD;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 01CA             break;
; 0000 01CB         default:
_0x85:
; 0000 01CC             break;
; 0000 01CD         }
_0x81:
; 0000 01CE     }
; 0000 01CF     else if (stage == STAGE_SUBMIT_CODE)
	RJMP _0x86
_0x7E:
	CALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x87
; 0000 01D0     {
; 0000 01D1 
; 0000 01D2         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x88
; 0000 01D3         {
; 0000 01D4             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 01D5             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01D6         }
; 0000 01D7         if ((keypad[rowloc][cl] - '0') < 10)
_0x88:
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0x89
; 0000 01D8         {
; 0000 01D9             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0x8A
; 0000 01DA             {
; 0000 01DB                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 01DC                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x20
; 0000 01DD                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 01DE             }
; 0000 01DF         }
_0x8A:
; 0000 01E0         else if (keypad[rowloc][cl] == 'D')
	RJMP _0x8B
_0x89:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0x8C
; 0000 01E1         {
; 0000 01E2             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 01E3             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0x8D
; 0000 01E4             {
; 0000 01E5                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x21
; 0000 01E6                 lcdCommand(0x10);
; 0000 01E7                 lcd_print(" ");
	__POINTW2MN _0x76,40
	CALL SUBOPT_0x22
; 0000 01E8                 lcdCommand(0x10);
; 0000 01E9             }
; 0000 01EA         }
_0x8D:
; 0000 01EB         else if (keypad[rowloc][cl] == 'E')
	RJMP _0x8E
_0x8C:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x45)
	BREQ PC+2
	RJMP _0x8F
; 0000 01EC         {
; 0000 01ED 
; 0000 01EE #asm("cli")
	cli
; 0000 01EF 
; 0000 01F0             if (strncmp(buffer, "40", 2) != 0 ||
; 0000 01F1                 strlen(buffer) != 8)
	CALL SUBOPT_0x8
	__POINTW1MN _0x76,42
	CALL SUBOPT_0xA
	BRNE _0x91
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ _0x90
_0x91:
; 0000 01F2             {
; 0000 01F3 
; 0000 01F4                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 01F5                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 01F6                 lcd_gotoxy(1, 1);
; 0000 01F7                 lcd_print("Incorrect Student Code Format");
	__POINTW2MN _0x76,45
	CALL SUBOPT_0x2
; 0000 01F8                 lcd_gotoxy(1, 2);
; 0000 01F9                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,75
	CALL SUBOPT_0xC
; 0000 01FA                 delay_ms(2000);
; 0000 01FB                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 01FC             }
; 0000 01FD             else if (search_student_code() > 0)
	RJMP _0x93
_0x90:
	RCALL _search_student_code
	CPI  R30,LOW(0x1)
	BRLO _0x94
; 0000 01FE             {
; 0000 01FF                 BUZZER_PRT |= (1 << BUZZER_NUM); // turn on buzzer
	SBI  0x12,7
; 0000 0200                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0201                 lcd_gotoxy(1, 1);
; 0000 0202                 lcd_print("Duplicate Student Code Entered");
	__POINTW2MN _0x76,106
	CALL SUBOPT_0x2
; 0000 0203                 lcd_gotoxy(1, 2);
; 0000 0204                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,137
	CALL SUBOPT_0xC
; 0000 0205                 delay_ms(2000);
; 0000 0206                 BUZZER_PRT &= ~(1 << BUZZER_NUM); // turn off buzzer
; 0000 0207             }
; 0000 0208             else
	RJMP _0x95
_0x94:
; 0000 0209             {
; 0000 020A                 // save the buffer to EEPROM
; 0000 020B                 st_counts = read_byte_from_eeprom(0x0);
	CALL SUBOPT_0x23
	MOV  R18,R30
; 0000 020C                 for (i = 0; i < 8; i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x97:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,8
	BRGE _0x98
; 0000 020D                 {
; 0000 020E                     write_byte_to_eeprom(i + ((st_counts + 1) * 8), buffer[i]);
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
; 0000 020F                 }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x97
_0x98:
; 0000 0210                 write_byte_to_eeprom(0x0, st_counts + 1);
	CALL SUBOPT_0xF
	MOV  R26,R18
	SUBI R26,-LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0211 
; 0000 0212                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0213                 lcd_gotoxy(1, 1);
; 0000 0214                 lcd_print("Student Code Successfully Added");
	__POINTW2MN _0x76,168
	CALL SUBOPT_0x2
; 0000 0215                 lcd_gotoxy(1, 2);
; 0000 0216                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,200
	CALL SUBOPT_0x15
; 0000 0217                 delay_ms(2000);
; 0000 0218             }
_0x95:
_0x93:
; 0000 0219             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 021A #asm("sei")
	sei
; 0000 021B             stage = STAGE_ATTENDENC_MENU;
	RJMP _0x151
; 0000 021C         }
; 0000 021D         else if (keypad[rowloc][cl] == 'C')
_0x8F:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9A
; 0000 021E             stage = STAGE_ATTENDENC_MENU;
_0x151:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 021F     }
_0x9A:
_0x8E:
_0x8B:
; 0000 0220     else if (stage == STAGE_SUBMIT_WITH_CARD)
	RJMP _0x9B
_0x87:
	CALL SUBOPT_0x5
	BRNE _0x9C
; 0000 0221     {
; 0000 0222         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0x9D
; 0000 0223         {
; 0000 0224             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0225             stage = STAGE_ATTENDENC_MENU;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0226         }
; 0000 0227     }
_0x9D:
; 0000 0228     else if (stage == STAGE_TEMPERATURE_MONITORING)
	RJMP _0x9E
_0x9C:
	CALL SUBOPT_0x11
	BRNE _0x9F
; 0000 0229     {
; 0000 022A 
; 0000 022B         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA0
; 0000 022C             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 022D     }
_0xA0:
; 0000 022E     else if (stage == STAGE_VIEW_PRESENT_STUDENTS)
	RJMP _0xA1
_0x9F:
	CALL SUBOPT_0x12
	BRNE _0xA2
; 0000 022F     {
; 0000 0230         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA3
; 0000 0231             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0232     }
_0xA3:
; 0000 0233     else if (stage == STAGE_STUDENT_MANAGMENT)
	RJMP _0xA4
_0xA2:
	CALL SUBOPT_0x16
	BRNE _0xA5
; 0000 0234     {
; 0000 0235         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xA6
; 0000 0236             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 0237         else if (keypad[rowloc][cl] == '1')
	RJMP _0xA7
_0xA6:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x31)
	BRNE _0xA8
; 0000 0238             stage = STAGE_SEARCH_STUDENT;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x152
; 0000 0239         else if (keypad[rowloc][cl] == '2' && logged_in == 1)
_0xA8:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xAB
	LDI  R30,LOW(1)
	CP   R30,R9
	BREQ _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
; 0000 023A             stage = STAGE_DELETE_STUDENT;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x152
; 0000 023B         else if (keypad[rowloc][cl] == '2' && logged_in == 0)
_0xAA:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x32)
	BRNE _0xAF
	TST  R9
	BREQ _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
; 0000 023C         {
; 0000 023D             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 023E             lcd_gotoxy(1, 1);
; 0000 023F             lcd_print("You Must First Login");
	__POINTW2MN _0x76,231
	CALL SUBOPT_0x2
; 0000 0240             lcd_gotoxy(1, 2);
; 0000 0241             lcd_print("You Will Go Admin Page 2 Sec");
	__POINTW2MN _0x76,252
	CALL SUBOPT_0x15
; 0000 0242             delay_ms(2000);
; 0000 0243             stage = STAGE_LOGIN_WITH_ADMIN;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
_0x152:
	MOVW R4,R30
; 0000 0244         }
; 0000 0245     }
_0xAE:
_0xA7:
; 0000 0246     else if (stage == STAGE_SEARCH_STUDENT)
	RJMP _0xB1
_0xA5:
	CALL SUBOPT_0x17
	BREQ PC+2
	RJMP _0xB2
; 0000 0247     {
; 0000 0248         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xB3
; 0000 0249         {
; 0000 024A             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 024B             stage = STAGE_STUDENT_MANAGMENT;
	RJMP _0x153
; 0000 024C         }
; 0000 024D         else if ((keypad[rowloc][cl] - '0') < 10)
_0xB3:
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xB5
; 0000 024E         {
; 0000 024F             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xB6
; 0000 0250             {
; 0000 0251                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 0252                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x20
; 0000 0253                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 0254             }
; 0000 0255         }
_0xB6:
; 0000 0256         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xB7
_0xB5:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xB8
; 0000 0257         {
; 0000 0258             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 0259             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xB9
; 0000 025A             {
; 0000 025B                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x21
; 0000 025C                 lcdCommand(0x10);
; 0000 025D                 lcd_print(" ");
	__POINTW2MN _0x76,281
	CALL SUBOPT_0x22
; 0000 025E                 lcdCommand(0x10);
; 0000 025F             }
; 0000 0260         }
_0xB9:
; 0000 0261         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xBA
_0xB8:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xBB
; 0000 0262         {
; 0000 0263             // search from eeprom data
; 0000 0264             unsigned char result = search_student_code();
; 0000 0265 
; 0000 0266             if (result > 0)
	CALL SUBOPT_0x24
;	i -> Y+7
;	result -> Y+0
	BRLO _0xBC
; 0000 0267             {
; 0000 0268                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0269                 lcd_gotoxy(1, 1);
; 0000 026A                 lcd_print("Student Code Found");
	__POINTW2MN _0x76,283
	CALL SUBOPT_0x2
; 0000 026B                 lcd_gotoxy(1, 2);
; 0000 026C                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,302
	RJMP _0x154
; 0000 026D                 delay_ms(2000);
; 0000 026E             }
; 0000 026F             else
_0xBC:
; 0000 0270             {
; 0000 0271                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0272                 lcd_gotoxy(1, 1);
; 0000 0273                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x76,333
	CALL SUBOPT_0x2
; 0000 0274                 lcd_gotoxy(1, 2);
; 0000 0275                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,362
_0x154:
	RCALL _lcd_print
; 0000 0276                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0277             }
; 0000 0278             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0279             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 027A         }
	ADIW R28,1
; 0000 027B         else if (keypad[rowloc][cl] == 'C')
	RJMP _0xBE
_0xBB:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xBF
; 0000 027C             stage = STAGE_STUDENT_MANAGMENT;
_0x153:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 027D     }
_0xBF:
_0xBE:
_0xBA:
_0xB7:
; 0000 027E     else if (stage == STAGE_DELETE_STUDENT)
	RJMP _0xC0
_0xB2:
	CALL SUBOPT_0x18
	BREQ PC+2
	RJMP _0xC1
; 0000 027F     {
; 0000 0280         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xC2
; 0000 0281         {
; 0000 0282             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0283             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 0284         }
; 0000 0285         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xC3
_0xC2:
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xC4
; 0000 0286         {
; 0000 0287             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xC5
; 0000 0288             {
; 0000 0289                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 028A                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x20
; 0000 028B                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 028C             }
; 0000 028D         }
_0xC5:
; 0000 028E         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xC6
_0xC4:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xC7
; 0000 028F         {
; 0000 0290             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 0291             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xC8
; 0000 0292             {
; 0000 0293                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x21
; 0000 0294                 lcdCommand(0x10);
; 0000 0295                 lcd_print(" ");
	__POINTW2MN _0x76,393
	CALL SUBOPT_0x22
; 0000 0296                 lcdCommand(0x10);
; 0000 0297             }
; 0000 0298         }
_0xC8:
; 0000 0299         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xC9
_0xC7:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xCA
; 0000 029A         {
; 0000 029B             // search from eeprom data
; 0000 029C             unsigned char result = search_student_code();
; 0000 029D 
; 0000 029E             if (result > 0)
	CALL SUBOPT_0x24
;	i -> Y+7
;	result -> Y+0
	BRLO _0xCB
; 0000 029F             {
; 0000 02A0                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02A1                 lcd_gotoxy(1, 1);
; 0000 02A2                 lcd_print("Student Code Found");
	__POINTW2MN _0x76,395
	CALL SUBOPT_0x2
; 0000 02A3                 lcd_gotoxy(1, 2);
; 0000 02A4                 lcd_print("Wait For Delete...");
	__POINTW2MN _0x76,414
	RCALL _lcd_print
; 0000 02A5                 delete_student_code(result);
	LD   R26,Y
	RCALL _delete_student_code
; 0000 02A6                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02A7                 lcd_gotoxy(1, 1);
; 0000 02A8                 lcd_print("Student Code Was Deleted");
	__POINTW2MN _0x76,433
	CALL SUBOPT_0x2
; 0000 02A9                 lcd_gotoxy(1, 2);
; 0000 02AA                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,458
	RJMP _0x155
; 0000 02AB                 delay_ms(2000);
; 0000 02AC             }
; 0000 02AD             else
_0xCB:
; 0000 02AE             {
; 0000 02AF                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02B0                 lcd_gotoxy(1, 1);
; 0000 02B1                 lcd_print("Ops , Student Code Not Found");
	__POINTW2MN _0x76,489
	CALL SUBOPT_0x2
; 0000 02B2                 lcd_gotoxy(1, 2);
; 0000 02B3                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,518
_0x155:
	RCALL _lcd_print
; 0000 02B4                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 02B5             }
; 0000 02B6             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 02B7             stage = STAGE_STUDENT_MANAGMENT;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 02B8         }
	ADIW R28,1
; 0000 02B9     }
_0xCA:
_0xC9:
_0xC6:
_0xC3:
; 0000 02BA     else if (stage == STAGE_TRAFFIC_MONITORING)
	RJMP _0xCD
_0xC1:
	CALL SUBOPT_0x19
	BRNE _0xCE
; 0000 02BB     {
; 0000 02BC         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xCF
; 0000 02BD             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02BE     }
_0xCF:
; 0000 02BF     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 1)
	RJMP _0xD0
_0xCE:
	CALL SUBOPT_0x1A
	BRNE _0xD2
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0xD3
_0xD2:
	RJMP _0xD1
_0xD3:
; 0000 02C0     {
; 0000 02C1         if (keypad[rowloc][cl] == 'C')
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x43)
	BRNE _0xD4
; 0000 02C2         {
; 0000 02C3             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 02C4             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02C5         }
; 0000 02C6 
; 0000 02C7         else if ((keypad[rowloc][cl] - '0') < 10)
	RJMP _0xD5
_0xD4:
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
	SBIW R30,58
	BRGE _0xD6
; 0000 02C8         {
; 0000 02C9             if (strlen(buffer) <= 30)
	CALL SUBOPT_0x7
	SBIW R30,31
	BRSH _0xD7
; 0000 02CA             {
; 0000 02CB                 buffer[strlen(buffer)] = keypad[rowloc][cl];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 02CC                 buffer[strlen(buffer) + 1] = '\0';
	CALL SUBOPT_0x20
; 0000 02CD                 lcdData(keypad[rowloc][cl]);
	LD   R26,X
	RCALL _lcdData
; 0000 02CE             }
; 0000 02CF         }
_0xD7:
; 0000 02D0         else if (keypad[rowloc][cl] == 'D')
	RJMP _0xD8
_0xD6:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x44)
	BRNE _0xD9
; 0000 02D1         {
; 0000 02D2             buffer_len = strlen(buffer);
	CALL SUBOPT_0x7
	MOV  R21,R30
; 0000 02D3             if (buffer_len > 0)
	CPI  R21,1
	BRLO _0xDA
; 0000 02D4             {
; 0000 02D5                 buffer[buffer_len - 1] = '\0';
	CALL SUBOPT_0x21
; 0000 02D6                 lcdCommand(0x10);
; 0000 02D7                 lcd_print(" ");
	__POINTW2MN _0x76,549
	CALL SUBOPT_0x22
; 0000 02D8                 lcdCommand(0x10);
; 0000 02D9             }
; 0000 02DA         }
_0xDA:
; 0000 02DB         else if (keypad[rowloc][cl] == 'E')
	RJMP _0xDB
_0xD9:
	CALL SUBOPT_0x1D
	LD   R26,X
	CPI  R26,LOW(0x45)
	BRNE _0xDC
; 0000 02DC         {
; 0000 02DD             // search from eeprom data
; 0000 02DE             unsigned int input_hash = simple_hash(buffer);
; 0000 02DF 
; 0000 02E0             if (input_hash == secret)
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
	BRNE _0xDD
; 0000 02E1             {
; 0000 02E2                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02E3                 lcd_gotoxy(1, 1);
; 0000 02E4                 lcd_print("Login Successfully");
	__POINTW2MN _0x76,551
	CALL SUBOPT_0x2
; 0000 02E5                 lcd_gotoxy(1, 2);
; 0000 02E6                 lcd_print("Wait...");
	__POINTW2MN _0x76,570
	CALL SUBOPT_0x15
; 0000 02E7                 delay_ms(2000);
; 0000 02E8                 logged_in = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 02E9             }
; 0000 02EA             else
	RJMP _0xDE
_0xDD:
; 0000 02EB             {
; 0000 02EC                 lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 02ED                 lcd_gotoxy(1, 1);
; 0000 02EE                 lcd_print("Ops , secret is incorrect");
	__POINTW2MN _0x76,578
	CALL SUBOPT_0x2
; 0000 02EF                 lcd_gotoxy(1, 2);
; 0000 02F0                 lcd_print("You Will Back Menu In 2 Second");
	__POINTW2MN _0x76,604
	CALL SUBOPT_0x15
; 0000 02F1                 delay_ms(2000);
; 0000 02F2             }
_0xDE:
; 0000 02F3             memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 02F4             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02F5         }
	ADIW R28,2
; 0000 02F6     }
_0xDC:
_0xDB:
_0xD8:
_0xD5:
; 0000 02F7     else if (stage == STAGE_LOGIN_WITH_ADMIN && logged_in != 0)
	RJMP _0xDF
_0xD1:
	CALL SUBOPT_0x1A
	BRNE _0xE1
	TST  R9
	BRNE _0xE2
_0xE1:
	RJMP _0xE0
_0xE2:
; 0000 02F8     {
; 0000 02F9         switch (keypad[rowloc][cl])
	CALL SUBOPT_0x1D
	LD   R30,X
	LDI  R31,0
; 0000 02FA         {
; 0000 02FB         case 'C':
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xE6
; 0000 02FC             stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 02FD             break;
	RJMP _0xE5
; 0000 02FE         case '1':
_0xE6:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE8
; 0000 02FF #asm("cli") // disable interrupts
	cli
; 0000 0300             lcdCommand(0x1);
	CALL SUBOPT_0x1
; 0000 0301             lcd_gotoxy(1, 1);
; 0000 0302             lcd_print("Clearing EEPROM ...");
	__POINTW2MN _0x76,635
	RCALL _lcd_print
; 0000 0303             clear_eeprom();
	RCALL _clear_eeprom
; 0000 0304 #asm("sei") // enable interrupts
	sei
; 0000 0305             break;
; 0000 0306         default:
_0xE8:
; 0000 0307             break;
; 0000 0308         }
_0xE5:
; 0000 0309         memset(buffer, 0, 32);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 030A         stage = STAGE_INIT_MENU;
	CLR  R4
	CLR  R5
; 0000 030B     }
; 0000 030C }
_0xE0:
_0xDF:
_0xD0:
_0xCD:
_0xC0:
_0xB1:
_0xA4:
_0xA1:
_0x9E:
_0x9B:
_0x86:
_0x7D:
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
_0x76:
	.BYTE 0x28F
;
;void lcdCommand(unsigned char cmnd)
; 0000 030F {

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 0310     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	CALL SUBOPT_0x25
;	cmnd -> Y+0
; 0000 0311     LCD_PRT &= ~(1 << LCD_RS); // RS = 0 for command
	CBI  0x18,0
; 0000 0312     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x26
; 0000 0313     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0314     delay_us(1 * 16);          // wait to make EN wider
; 0000 0315     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0316     delay_us(20 * 16);         // wait
	__DELAY_USW 640
; 0000 0317     LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	CALL SUBOPT_0x27
; 0000 0318     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0319     delay_us(1 * 16);          // wait to make EN wider
; 0000 031A     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 031B }
	RJMP _0x20A0005
; .FEND
;void lcdData(unsigned char data)
; 0000 031D {
_lcdData:
; .FSTART _lcdData
; 0000 031E     LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x25
;	data -> Y+0
; 0000 031F     LCD_PRT |= (1 << LCD_RS);  // RS = 1 for data
	SBI  0x18,0
; 0000 0320     LCD_PRT &= ~(1 << LCD_RW); // RW = 0 for write
	CALL SUBOPT_0x26
; 0000 0321     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0322     delay_us(1 * 16);          // wait to make EN wider
; 0000 0323     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0324     LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	CALL SUBOPT_0x27
; 0000 0325     LCD_PRT |= (1 << LCD_EN);  // EN = 1 for H-to-L
; 0000 0326     delay_us(1 * 16);          // wait to make EN wider
; 0000 0327     LCD_PRT &= ~(1 << LCD_EN); // EN = 0 for H-to-L
; 0000 0328 }
	RJMP _0x20A0005
; .FEND
;void lcd_init()
; 0000 032A {
_lcd_init:
; .FSTART _lcd_init
; 0000 032B     LCD_DDR = 0xFF;            // LCD port is output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 032C     LCD_PRT &= ~(1 << LCD_EN); // LCD_EN = 0
	CBI  0x18,2
; 0000 032D     delay_us(2000 * 16);       // wait for stable power
	__DELAY_USW 64000
; 0000 032E     lcdCommand(0x33);          //$33 for 4-bit mode
	LDI  R26,LOW(51)
	CALL SUBOPT_0x1B
; 0000 032F     delay_us(100 * 16);        // wait
; 0000 0330     lcdCommand(0x32);          //$32 for 4-bit mode
	LDI  R26,LOW(50)
	CALL SUBOPT_0x1B
; 0000 0331     delay_us(100 * 16);        // wait
; 0000 0332     lcdCommand(0x28);          //$28 for 4-bit mode
	LDI  R26,LOW(40)
	CALL SUBOPT_0x1B
; 0000 0333     delay_us(100 * 16);        // wait
; 0000 0334     lcdCommand(0x0c);          // display on, cursor off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x1B
; 0000 0335     delay_us(100 * 16);        // wait
; 0000 0336     lcdCommand(0x01);          // clear LCD
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0337     delay_us(2000 * 16);       // wait
	__DELAY_USW 64000
; 0000 0338     lcdCommand(0x06);          // shift cursor right
	LDI  R26,LOW(6)
	CALL SUBOPT_0x1B
; 0000 0339     delay_us(100 * 16);
; 0000 033A }
	RET
; .FEND
;void lcd_gotoxy(unsigned char x, unsigned char y)
; 0000 033C {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 033D     unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};
; 0000 033E     lcdCommand(firstCharAdr[y - 1] + x - 1);
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
	CALL SUBOPT_0x1B
; 0000 033F     delay_us(100 * 16);
; 0000 0340 }
	ADIW R28,6
	RET
; .FEND
;void lcd_print(char *str)
; 0000 0342 {
_lcd_print:
; .FSTART _lcd_print
; 0000 0343     unsigned char i = 0;
; 0000 0344     while (str[i] != 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0xE9:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0xEB
; 0000 0345     {
; 0000 0346         lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 0347         i++;
	SUBI R17,-1
; 0000 0348     }
	RJMP _0xE9
_0xEB:
; 0000 0349 }
	LDD  R17,Y+0
	RJMP _0x20A0006
; .FEND
;
;void show_temperature()
; 0000 034C {
_show_temperature:
; .FSTART _show_temperature
; 0000 034D     unsigned char temperatureVal = 0;
; 0000 034E     unsigned char temperatureRep[3];
; 0000 034F 
; 0000 0350     ADMUX = 0xE0;
	SBIW R28,3
	ST   -Y,R17
;	temperatureVal -> R17
;	temperatureRep -> Y+1
	LDI  R17,0
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 0351     ADCSRA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0352 
; 0000 0353     lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0354     lcd_gotoxy(1, 1);
; 0000 0355     lcd_print("temperature(C):");
	__POINTW2MN _0xEC,0
	RCALL _lcd_print
; 0000 0356 
; 0000 0357     while (stage == STAGE_TEMPERATURE_MONITORING)
_0xED:
	CALL SUBOPT_0x11
	BRNE _0xEF
; 0000 0358     {
; 0000 0359         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 035A         while ((ADCSRA & (1 << ADIF)) == 0)
_0xF0:
	SBIS 0x6,4
; 0000 035B             ;
	RJMP _0xF0
; 0000 035C         if (ADCH != temperatureVal)
	IN   R30,0x5
	CP   R17,R30
	BREQ _0xF3
; 0000 035D         {
; 0000 035E             temperatureVal = ADCH;
	IN   R17,5
; 0000 035F             itoa(temperatureVal, temperatureRep);
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _itoa
; 0000 0360             lcd_gotoxy(17, 1);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0361             lcd_print(temperatureRep);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_print
; 0000 0362             lcd_print(" ");
	__POINTW2MN _0xEC,16
	RCALL _lcd_print
; 0000 0363         }
; 0000 0364         delay_ms(500);
_0xF3:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0365     }
	RJMP _0xED
_0xEF:
; 0000 0366 
; 0000 0367     ADCSRA = 0x0;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0368 }
	LDD  R17,Y+0
	RJMP _0x20A0002
; .FEND

	.DSEG
_0xEC:
	.BYTE 0x12
;
;void show_menu()
; 0000 036B {

	.CSEG
_show_menu:
; .FSTART _show_menu
; 0000 036C 
; 0000 036D     while (stage == STAGE_INIT_MENU)
_0xF4:
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0xF6
; 0000 036E     {
; 0000 036F         lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0370         lcd_gotoxy(1, 1);
; 0000 0371         if (page_num == 0)
	TST  R7
	BRNE _0xF7
; 0000 0372         {
; 0000 0373             lcd_print("1: Attendance Initialization");
	__POINTW2MN _0xF8,0
	CALL SUBOPT_0x2
; 0000 0374             lcd_gotoxy(1, 2);
; 0000 0375             lcd_print("2: Student Management");
	__POINTW2MN _0xF8,29
	RCALL _lcd_print
; 0000 0376             while (page_num == 0 && stage == STAGE_INIT_MENU)
_0xF9:
	TST  R7
	BRNE _0xFC
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0xFD
_0xFC:
	RJMP _0xFB
_0xFD:
; 0000 0377                 ;
	RJMP _0xF9
_0xFB:
; 0000 0378         }
; 0000 0379         else if (page_num == 1)
	RJMP _0xFE
_0xF7:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xFF
; 0000 037A         {
; 0000 037B             lcd_print("3: View Present Students ");
	__POINTW2MN _0xF8,51
	CALL SUBOPT_0x2
; 0000 037C             lcd_gotoxy(1, 2);
; 0000 037D             lcd_print("4: Temperature Monitoring");
	__POINTW2MN _0xF8,77
	RCALL _lcd_print
; 0000 037E             while (page_num == 1 && stage == STAGE_INIT_MENU)
_0x100:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x103
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x104
_0x103:
	RJMP _0x102
_0x104:
; 0000 037F                 ;
	RJMP _0x100
_0x102:
; 0000 0380         }
; 0000 0381         else if (page_num == 2)
	RJMP _0x105
_0xFF:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x106
; 0000 0382         {
; 0000 0383             lcd_print("5: Retrieve Student Data");
	__POINTW2MN _0xF8,103
	CALL SUBOPT_0x2
; 0000 0384             lcd_gotoxy(1, 2);
; 0000 0385             lcd_print("6: Traffic Monitoring");
	__POINTW2MN _0xF8,128
	RCALL _lcd_print
; 0000 0386             while (page_num == 2 && stage == STAGE_INIT_MENU)
_0x107:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x10A
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x10B
_0x10A:
	RJMP _0x109
_0x10B:
; 0000 0387                 ;
	RJMP _0x107
_0x109:
; 0000 0388         }
; 0000 0389         else if (page_num == 3)
	RJMP _0x10C
_0x106:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x10D
; 0000 038A         {
; 0000 038B             lcd_print("7: Login With Admin");
	__POINTW2MN _0xF8,150
	CALL SUBOPT_0x2
; 0000 038C             lcd_gotoxy(1, 2);
; 0000 038D             lcd_print("8: Logout");
	__POINTW2MN _0xF8,170
	RCALL _lcd_print
; 0000 038E             while (page_num == 3 && stage == STAGE_INIT_MENU)
_0x10E:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x111
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x112
_0x111:
	RJMP _0x110
_0x112:
; 0000 038F                 ;
	RJMP _0x10E
_0x110:
; 0000 0390         }
; 0000 0391     }
_0x10D:
_0x10C:
_0x105:
_0xFE:
	RJMP _0xF4
_0xF6:
; 0000 0392 }
	RET
; .FEND

	.DSEG
_0xF8:
	.BYTE 0xB4
;
;void clear_eeprom()
; 0000 0395 {

	.CSEG
_clear_eeprom:
; .FSTART _clear_eeprom
; 0000 0396     unsigned int i;
; 0000 0397 
; 0000 0398     for (i = 0; i <= 1023; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x114:
	__CPWRN 16,17,1024
	BRSH _0x115
; 0000 0399     {
; 0000 039A         // Wait for the previous write to complete
; 0000 039B         while (EECR & (1 << EEWE))
_0x116:
	SBIC 0x1C,1
; 0000 039C             ;
	RJMP _0x116
; 0000 039D 
; 0000 039E         // Set up address registers
; 0000 039F         EEARH = (i >> 8) & 0x03; // High byte (bits 8-9)
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
; 0000 03A0         EEARL = i & 0xFF;        // Low byte (bits 0-7)
	MOV  R30,R16
	OUT  0x1E,R30
; 0000 03A1 
; 0000 03A2         // Set up data register
; 0000 03A3         EEDR = 0; // Write 0 to EEPROM
	LDI  R30,LOW(0)
	OUT  0x1D,R30
; 0000 03A4 
; 0000 03A5         // Enable write
; 0000 03A6         EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 03A7         EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 03A8     }
	__ADDWRN 16,17,1
	RJMP _0x114
_0x115:
; 0000 03A9 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char read_byte_from_eeprom(unsigned int addr)
; 0000 03AC {
_read_byte_from_eeprom:
; .FSTART _read_byte_from_eeprom
; 0000 03AD     unsigned char x;
; 0000 03AE     // Wait for the previous write to complete
; 0000 03AF     while (EECR & (1 << EEWE))
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	x -> R17
_0x119:
	SBIC 0x1C,1
; 0000 03B0         ;
	RJMP _0x119
; 0000 03B1 
; 0000 03B2     // Set up address registers
; 0000 03B3     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x28
; 0000 03B4     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 03B5     EECR |= (1 << EERE);        // Read Enable
	SBI  0x1C,0
; 0000 03B6     x = EEDR;
	IN   R17,29
; 0000 03B7     return x;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0006
; 0000 03B8 }
; .FEND
;
;void write_byte_to_eeprom(unsigned int addr, unsigned char value)
; 0000 03BB {
_write_byte_to_eeprom:
; .FSTART _write_byte_to_eeprom
; 0000 03BC     // Wait for the previous write to complete
; 0000 03BD     while (EECR & (1 << EEWE))
	ST   -Y,R26
;	addr -> Y+1
;	value -> Y+0
_0x11C:
	SBIC 0x1C,1
; 0000 03BE         ;
	RJMP _0x11C
; 0000 03BF 
; 0000 03C0     // Set up address registers
; 0000 03C1     EEARH = (addr >> 8) & 0x03; // High byte (bits 8-9)
	CALL SUBOPT_0x28
; 0000 03C2     EEARL = addr & 0xFF;        // Low byte (bits 0-7)
; 0000 03C3 
; 0000 03C4     // Set up data register
; 0000 03C5     EEDR = value; // Write 0 to EEPROM
	LD   R30,Y
	OUT  0x1D,R30
; 0000 03C6 
; 0000 03C7     // Enable write
; 0000 03C8     EECR |= (1 << EEMWE); // Master write enable
	SBI  0x1C,2
; 0000 03C9     EECR |= (1 << EEWE);  // Start EEPROM write
	SBI  0x1C,1
; 0000 03CA }
_0x20A0006:
	ADIW R28,3
	RET
; .FEND
;
;void USART_Transmit(unsigned char data)
; 0000 03CD {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 03CE     while (!(UCSRA & (1 << UDRE)))
	ST   -Y,R26
;	data -> Y+0
_0x11F:
	SBIS 0xB,5
; 0000 03CF         ;
	RJMP _0x11F
; 0000 03D0     UDR = data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 03D1 }
_0x20A0005:
	ADIW R28,1
	RET
; .FEND
;
;unsigned char USART_Receive()
; 0000 03D4 {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 03D5     while(!(UCSRA & (1 << RXC)) && stage == STAGE_SUBMIT_WITH_CARD);
_0x122:
	SBIC 0xB,7
	RJMP _0x125
	CALL SUBOPT_0x5
	BREQ _0x126
_0x125:
	RJMP _0x124
_0x126:
	RJMP _0x122
_0x124:
; 0000 03D6     return UDR;
	IN   R30,0xC
	RET
; 0000 03D7 }
; .FEND
;
;void USART_init(unsigned int ubrr)
; 0000 03DA {
_USART_init:
; .FSTART _USART_init
; 0000 03DB     UBRRL = (unsigned char)ubrr;
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LD   R30,Y
	OUT  0x9,R30
; 0000 03DC     UBRRH = (unsigned char)(ubrr >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	OUT  0x20,R30
; 0000 03DD     UCSRB = (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 03DE     UCSRC = (1 << UCSZ1) | (1 << UCSZ0); // Set UCSZ1 and UCSZ0 for 8-bit data
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 03DF }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char search_student_code()
; 0000 03E2 {
_search_student_code:
; .FSTART _search_student_code
; 0000 03E3     unsigned char st_counts, i, j;
; 0000 03E4     char temp[10];
; 0000 03E5 
; 0000 03E6     st_counts = read_byte_from_eeprom(0x0);
	SBIW R28,10
	CALL __SAVELOCR4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> Y+4
	CALL SUBOPT_0x23
	MOV  R17,R30
; 0000 03E7 
; 0000 03E8     for (i = 0; i < st_counts; i++)
	LDI  R16,LOW(0)
_0x128:
	CP   R16,R17
	BRSH _0x129
; 0000 03E9     {
; 0000 03EA         memset(temp, 0, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 03EB         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x12B:
	CPI  R19,8
	BRSH _0x12C
; 0000 03EC         {
; 0000 03ED             temp[j] = read_byte_from_eeprom(j + ((i + 1) * 8));
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
; 0000 03EE         }
	SUBI R19,-1
	RJMP _0x12B
_0x12C:
; 0000 03EF         temp[j] = '\0';
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 03F0         if (strncmp(temp, buffer, 8) == 0)
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x12D
; 0000 03F1             return (i + 1);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	RJMP _0x20A0004
; 0000 03F2     }
_0x12D:
	SUBI R16,-1
	RJMP _0x128
_0x129:
; 0000 03F3 
; 0000 03F4     return 0;
	LDI  R30,LOW(0)
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0000 03F5 }
; .FEND
;
;void delete_student_code(unsigned char index)
; 0000 03F8 {
_delete_student_code:
; .FSTART _delete_student_code
; 0000 03F9     unsigned char st_counts, i, j;
; 0000 03FA     unsigned char temp;
; 0000 03FB 
; 0000 03FC     st_counts = read_byte_from_eeprom(0x0);
	ST   -Y,R26
	CALL __SAVELOCR4
;	index -> Y+4
;	st_counts -> R17
;	i -> R16
;	j -> R19
;	temp -> R18
	CALL SUBOPT_0x23
	MOV  R17,R30
; 0000 03FD 
; 0000 03FE     for (i = index; i <= st_counts; i++)
	LDD  R16,Y+4
_0x12F:
	CP   R17,R16
	BRLO _0x130
; 0000 03FF     {
; 0000 0400         for (j = 0; j < 8; j++)
	LDI  R19,LOW(0)
_0x132:
	CPI  R19,8
	BRSH _0x133
; 0000 0401         {
; 0000 0402             temp = read_byte_from_eeprom(j + ((i + 1) * 8));
	MOV  R26,R19
	CLR  R27
	MOV  R30,R16
	CALL SUBOPT_0xE
	ADD  R26,R30
	ADC  R27,R31
	RCALL _read_byte_from_eeprom
	MOV  R18,R30
; 0000 0403             write_byte_to_eeprom(j + ((i) * 8), temp);
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
; 0000 0404         }
	SUBI R19,-1
	RJMP _0x132
_0x133:
; 0000 0405     }
	SUBI R16,-1
	RJMP _0x12F
_0x130:
; 0000 0406     write_byte_to_eeprom(0x0, st_counts - 1);
	CALL SUBOPT_0xF
	MOV  R26,R17
	SUBI R26,LOW(1)
	RCALL _write_byte_to_eeprom
; 0000 0407 }
	CALL __LOADLOCR4
	JMP  _0x20A0001
; .FEND
;
;void HCSR04Init()
; 0000 040A {
_HCSR04Init:
; .FSTART _HCSR04Init
; 0000 040B     US_DDR |= (1 << US_TRIG_POS);  // Trigger pin as output
	SBI  0x11,5
; 0000 040C     US_DDR &= ~(1 << US_ECHO_POS); // Echo pin as input
	CBI  0x11,6
; 0000 040D }
	RET
; .FEND
;
;void HCSR04Trigger()
; 0000 0410 {
_HCSR04Trigger:
; .FSTART _HCSR04Trigger
; 0000 0411     US_PORT |= (1 << US_TRIG_POS);  // Set trigger pin high
	SBI  0x12,5
; 0000 0412     delay_us(15);                   // Wait for 15 microseconds
	__DELAY_USB 40
; 0000 0413     US_PORT &= ~(1 << US_TRIG_POS); // Set trigger pin low
	CBI  0x12,5
; 0000 0414 }
	RET
; .FEND
;
;uint16_t GetPulseWidth()
; 0000 0417 {
_GetPulseWidth:
; .FSTART _GetPulseWidth
; 0000 0418     uint32_t i, result;
; 0000 0419 
; 0000 041A     // Wait for rising edge on Echo pin
; 0000 041B     for (i = 0; i < 600000; i++)
	SBIW R28,8
;	i -> Y+4
;	result -> Y+0
	LDI  R30,LOW(0)
	__CLRD1S 4
_0x135:
	CALL SUBOPT_0x29
	BRSH _0x136
; 0000 041C     {
; 0000 041D         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 041E             continue;
	RJMP _0x134
; 0000 041F         else
; 0000 0420             break;
	RJMP _0x136
; 0000 0421     }
_0x134:
	CALL SUBOPT_0x2A
	RJMP _0x135
_0x136:
; 0000 0422 
; 0000 0423     if (i == 600000)
	CALL SUBOPT_0x29
	BRNE _0x139
; 0000 0424         return US_ERROR; // Timeout error if no rising edge detected
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0003
; 0000 0425 
; 0000 0426     // Start timer with prescaler 8
; 0000 0427     TCCR1A = 0x00;
_0x139:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0428     TCCR1B = (1 << CS11) | (1 << CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0429     TCNT1 = 0x00; // Reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 042A 
; 0000 042B     // Wait for falling edge on Echo pin
; 0000 042C     for (i = 0; i < 600000; i++)
	__CLRD1S 4
_0x13B:
	CALL SUBOPT_0x29
	BRSH _0x13C
; 0000 042D     {
; 0000 042E         if (!(US_PIN & (1 << US_ECHO_POS)))
	SBIS 0x10,6
; 0000 042F             break; // Falling edge detected
	RJMP _0x13C
; 0000 0430         if (TCNT1 > 60000)
	IN   R30,0x2C
	IN   R31,0x2C+1
	CPI  R30,LOW(0xEA61)
	LDI  R26,HIGH(0xEA61)
	CPC  R31,R26
	BRLO _0x13E
; 0000 0431             return US_NO_OBSTACLE; // No obstacle in range
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0003
; 0000 0432     }
_0x13E:
	CALL SUBOPT_0x2A
	RJMP _0x13B
_0x13C:
; 0000 0433 
; 0000 0434     result = TCNT1; // Capture timer value
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	CALL __PUTD1S0
; 0000 0435     TCCR1B = 0x00;  // Stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0436 
; 0000 0437     if (result > 60000)
	CALL __GETD2S0
	__CPD2N 0xEA61
	BRLO _0x13F
; 0000 0438         return US_NO_OBSTACLE;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20A0003
; 0000 0439     else
_0x13F:
; 0000 043A         return (result >> 1); // Return the measured pulse width
	CALL __GETD1S0
	CALL __LSRD1
; 0000 043B }
_0x20A0003:
	ADIW R28,8
	RET
; .FEND
;
;void startSonar()
; 0000 043E {
_startSonar:
; .FSTART _startSonar
; 0000 043F     char numberString[16];
; 0000 0440     uint16_t pulseWidth; // Pulse width from echo
; 0000 0441     int distance, previous_distance = -1;
; 0000 0442     static int previous_count = -1;

	.DSEG

	.CSEG
; 0000 0443 
; 0000 0444     lcdCommand(0x01);
	SBIW R28,16
	CALL __SAVELOCR6
;	numberString -> Y+6
;	pulseWidth -> R16,R17
;	distance -> R18,R19
;	previous_distance -> R20,R21
	__GETWRN 20,21,-1
	CALL SUBOPT_0x1
; 0000 0445     lcd_gotoxy(1, 1);
; 0000 0446     lcd_print("Distance: ");
	__POINTW2MN _0x142,0
	RCALL _lcd_print
; 0000 0447 
; 0000 0448     while (stage == STAGE_TRAFFIC_MONITORING)
_0x143:
	CALL SUBOPT_0x19
	BREQ PC+2
	RJMP _0x145
; 0000 0449     {
; 0000 044A         HCSR04Trigger();              // Send trigger pulse
	RCALL _HCSR04Trigger
; 0000 044B         pulseWidth = GetPulseWidth(); // Measure echo pulse
	RCALL _GetPulseWidth
	MOVW R16,R30
; 0000 044C 
; 0000 044D         if (pulseWidth == US_ERROR)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x146
; 0000 044E         {
; 0000 044F             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0450             lcd_gotoxy(1, 1);
; 0000 0451             lcd_print("Error"); // Display error message
	__POINTW2MN _0x142,11
	RJMP _0x156
; 0000 0452         }
; 0000 0453         else if (pulseWidth == US_NO_OBSTACLE)
_0x146:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x148
; 0000 0454         {
; 0000 0455             lcdCommand(0x01);
	CALL SUBOPT_0x1
; 0000 0456             lcd_gotoxy(1, 1);
; 0000 0457             lcd_print("No Obstacle"); // Display no obstacle message
	__POINTW2MN _0x142,17
	RJMP _0x156
; 0000 0458         }
; 0000 0459         else
_0x148:
; 0000 045A         {
; 0000 045B             distance = (int)((pulseWidth * 0.034 / 2) + 0.5);
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
; 0000 045C 
; 0000 045D             if (distance != previous_distance)
	__CPWRR 20,21,18,19
	BREQ _0x14A
; 0000 045E             {
; 0000 045F                 previous_distance = distance;
	MOVW R20,R18
; 0000 0460                 // Display distance on LCD
; 0000 0461                 itoa(distance, numberString); // Convert distance to string
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0462                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0463                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_print
; 0000 0464                 lcd_print(" cm ");
	__POINTW2MN _0x142,29
	RCALL _lcd_print
; 0000 0465             }
; 0000 0466             // Counting logic based on distance
; 0000 0467             if (distance < 6)
_0x14A:
	__CPWRN 18,19,6
	BRGE _0x14B
; 0000 0468             {
; 0000 0469                 US_count++; // Increment count if distance is below threshold
	INC  R6
; 0000 046A             }
; 0000 046B 
; 0000 046C             // Update count on LCD only if it changes
; 0000 046D             if (US_count != previous_count)
_0x14B:
	LDS  R30,_previous_count_S0000014000
	LDS  R31,_previous_count_S0000014000+1
	MOV  R26,R6
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x14C
; 0000 046E             {
; 0000 046F                 previous_count = US_count;
	MOV  R30,R6
	LDI  R31,0
	STS  _previous_count_S0000014000,R30
	STS  _previous_count_S0000014000+1,R31
; 0000 0470                 lcd_gotoxy(1, 2); // Move to second line
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0471                 itoa(US_count, numberString);
	MOV  R30,R6
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _itoa
; 0000 0472                 lcd_print("Count: ");
	__POINTW2MN _0x142,34
	RCALL _lcd_print
; 0000 0473                 lcd_print(numberString);
	MOVW R26,R28
	ADIW R26,6
_0x156:
	RCALL _lcd_print
; 0000 0474             }
; 0000 0475         }
_0x14C:
; 0000 0476         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0477     }
	RJMP _0x143
_0x145:
; 0000 0478 }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x142:
	.BYTE 0x2A
;
;unsigned int simple_hash(const char *str)
; 0000 047B {

	.CSEG
_simple_hash:
; .FSTART _simple_hash
; 0000 047C     unsigned int hash = 0;
; 0000 047D     while (*str)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	hash -> R16,R17
	__GETWRN 16,17,0
_0x14D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x14F
; 0000 047E     {
; 0000 047F         hash = (hash * 31) + *str; // A basic hash formula
	__MULBNWRU 16,17,31
	MOVW R0,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 0480         str++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0481     }
	RJMP _0x14D
_0x14F:
; 0000 0482     return hash;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0002:
	ADIW R28,4
	RET
; 0000 0483 }
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	__DELAY_USW 3200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(32)
	LDI  R27,0
	JMP  _memset

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	MOVW R30,R16
	ADIW R30,1
	CALL __LSLW3
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R30
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(13)
	CALL _USART_Transmit
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x15:
	CALL _lcd_print
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	CALL _lcdCommand
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	CPI  R17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:339 WORDS
SUBOPT_0x1D:
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
SUBOPT_0x1E:
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
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
SUBOPT_0x22:
	CALL _lcd_print
	LDI  R26,LOW(16)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _read_byte_from_eeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	SBIW R28,1
	CALL _search_student_code
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
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
SUBOPT_0x26:
	CBI  0x18,1
	SBI  0x18,2
	__DELAY_USB 43
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x27:
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
SUBOPT_0x28:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0x3)
	OUT  0x1F,R30
	LDD  R30,Y+1
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x29:
	__GETD2S 4
	__CPD2N 0x927C0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
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
