;****************************************************************************
;
;	JAGUAR.INC  Hardware Equates for JAGUAR System
;
;	COPYRIGHT 1992 Atari Computer Corporation
;	UNAUTHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,   
;	PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR    
;	THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED. 
;	ALL RIGHTS RESERVED.		
;
;****************************************************************************

;
;	JAGUAR REGISTERS
;

	BASE	EQU	$f00000		; TOM Internal Register Base


;	TOM REGISTERS

MEMCON1		EQU	BASE + 0	; Memory Configuration Register One
MEMCON2		EQU	BASE + 2	; Memory Configuration Register Two
HC		EQU	BASE + 4	; Horizontal Count
VC		EQU	BASE + 6	; Vertical Count
LPH		EQU	BASE + 8	; Horizontal Lightpen
LPV		EQU	BASE + $0a	; Vertical Lightpen
OB0		EQU	BASE + $10	; Current Object Phrase
OB1		EQU	BASE + $12
OB2		EQU	BASE + $14
OB3		EQU	BASE + $16
OLP		EQU	BASE + $20	; Object List Pointer
OLPLO		EQU	BASE + $20
OLPHI		EQU	BASE + $22
ODP		EQU	BASE + $24	; Object Data Pointer
OBF		EQU	BASE + $26	; Object Processor Flag
VMODE		EQU	BASE + $28	; Video Mode
BORD1		EQU	BASE + $2a	; Border Color (Red & Green)
BORD2		EQU	BASE + $2c	; Border Color (Blue)
HP		EQU	BASE + $2e	; Horizontal Period
HBB		EQU	BASE + $30	; Horizontal Blanking Begin
HBE		EQU	BASE + $32	; Horizontal Blanking End
HS		EQU	BASE + $34	; Horizontal Sync
HVS		EQU	BASE + $36	; Horizontal Vertical Sync
HDB1		EQU	BASE + $38	; Horizontal Display Begin One
HDB2		EQU	BASE + $3a	; Horizontal Display Begin Two
HDE		EQU	BASE + $3c	; Horizontal Display End
VP		EQU	BASE + $3e	; Vertical Period
VBB		EQU	BASE + $40	; Vertical Blanking Begin
VBE		EQU	BASE + $42	; Vertical Blanking End
VS		EQU	BASE + $44	; Vertical Sync
VDB		EQU	BASE + $46	; Vertical Display Begin
VDE		EQU	BASE + $48	; Vertical Display End
VEB		EQU	BASE + $4a	; Vertical EQUalization Begin
VEE		EQU	BASE + $4c	; Vertical EQUalization End
VI		EQU	BASE + $4e	; Vertical Interrupt
PIT0		EQU	BASE + $50	; Programmable Interrupt Timer (Lo)
PIT1		EQU	BASE + $52	; Programmable Interrupt Timer (Hi)
HEQ		EQU	BASE + $54	; Horizontal EQUalization End
TEST1		EQU	BASE + $56	; Undocumented Register - DO NOT USE
BG		EQU	BASE + $58	; Background Color

INT1		EQU	BASE + $e0	; CPU Interrupt Control Register
INT2		EQU	BASE + $e2	; CPU Interrupt Resume Register

CLUT		EQU	BASE + $400	; Color Lookup Table

LBUFA		EQU	BASE + $800	; Line Buffer A
LBUFB		EQU	BASE + $1000	; Line Buffer B
LBUFC		EQU	BASE + $1800	; Line Buffer Current

;
;	GPU REGISTERS
;
G_FLAGS 	EQU	BASE + $2100	; GPU Flags
G_MTXC		EQU	BASE + $2104	; GPU Matrix Control
G_MTXA		EQU	BASE + $2108	; GPU Matrix Address
G_END		EQU	BASE + $210c	; GPU Data Organization
G_PC		EQU	BASE + $2110	; GPU Program Counter
G_CTRL		EQU	BASE + $2114	; GPU Operation Control/Status
G_HIDATA 	EQU	BASE + $2118	; GPU Bus Interface high data
G_REMAIN 	EQU	BASE + $211c	; GPU Division Remainder
G_DIVCTRL 	EQU	BASE + $211c	; DSP Divider control
G_RAM		EQU	BASE + $3000	; GPU Internal RAM
G_ENDRAM	EQU	G_RAM +(4*1024)	; 4K bytes
;
;	BLITTER REGISTERS
;
A1_BASE 	EQU	BASE + $2200	; A1 Base Address
A1_FLAGS	EQU	BASE + $2204	; A1 Control Flags
A1_CLIP		EQU	BASE + $2208	; A1 Clipping Size
A1_PIXEL	EQU	BASE + $220C	; A1 Pixel Pointer
A1_STEP		EQU	BASE + $2210	; A1 Step (Integer Part)
A1_FSTEP	EQU	BASE + $2214	; A1 Step (Fractional Part)
A1_FPIXEL	EQU	BASE + $2218	; A1 Pixel Pointer (Fractional)
A1_INC		EQU	BASE + $221C	; A1 Increment (Integer Part)
A1_FINC		EQU	BASE + $2220	; A1 Increment (Fractional Part)
A2_BASE		EQU	BASE + $2224	; A2 Base Address
A2_FLAGS	EQU	BASE + $2228	; A2 Control Flags
A2_MASK		EQU	BASE + $222C	; A2 Address Mask
A2_PIXEL	EQU	BASE + $2230	; A2 PIXEL
A2_STEP		EQU	BASE + $2234	; A2 Step (Integer)

B_CMD		EQU	BASE + $2238	; Command
B_COUNT		EQU	BASE + $223C	; Counters
B_SRCD		EQU	BASE + $2240	; Source Data
B_DSTD		EQU	BASE + $2248	; Destination Data
B_DSTZ		EQU	BASE + $2250	; Destination Z
B_SRCZ1		EQU	BASE + $2258	; Source Z (Integer)
B_SRCZ2		EQU	BASE + $2260	; Source Z (Fractional)
B_PATD		EQU	BASE + $2268	; Pattern Data
B_IINC		EQU	BASE + $2270	; Intensity Increment
B_ZINC		EQU	BASE + $2274	; Z Increment
B_STOP		EQU	BASE + $2278	; Collision stop control

B_I3		EQU	BASE + $227C	; Blitter Intensity 3
B_I2		EQU	BASE + $2280	; Blitter Intensity 2
B_I1		EQU	BASE + $2284	; Blitter Intensity 1
B_I0		EQU	BASE + $2288	; Blitter Intensity 0

B_Z3		EQU	BASE + $228C	; Blitter Z 3
B_Z2		EQU	BASE + $2290	; Blitter Z 2
B_Z1		EQU	BASE + $2294	; Blitter Z 1
B_Z0		EQU	BASE + $2298	; Blitter Z 0

;	JERRY REGISTERS

JPIT1		EQU	BASE + $10000

CLK1		EQU	BASE + $10010	; Processor Clock Frequency
CLK2		EQU	BASE + $10012	; Video Clock Frequency
CHRO_CLK	EQU	BASE + $10014	; Chroma clock control

JOYSTICK	EQU	BASE + $14000	; Joystick register
JOYBUTS		EQU	BASE + $14002	; Joystick register
CONFIG		EQU	BASE + $14002	; Also has NTSC/PAL

MOD_MASK	EQU	BASE + $1a118	; Mask for ADDQ(SUBQ)MOD

SCLK		EQU	BASE + $1A150	; SSI Clock Frequency
SMODE		EQU	BASE + $1A154	; SSI Control

R_DAC		EQU	BASE + $1a148	
L_DAC		EQU	BASE + $1a14c

L_I2S		EQU	BASE + $1a148	
R_I2S		EQU	BASE + $1a14c

;	ROM Tables built into Jerry 128 samples
;	16 bit samples sign extended to 32

ROM_TABLE   	EQU	BASE + $1D000	; Base of tables

; These are NEW CHANGED DIFFERENT Equates they should cause less confusion

ROM_TRI     	EQU	BASE + $1D000	; A triangle wave
ROM_SINE    	EQU	BASE + $1D200	; Full amplitude SINE
ROM_AMSINE  	EQU	BASE + $1D400	; Linear (?) ramp SINE
; This was once ROM_SINE12W which is just like ROM_SINE
ROM_12W 	EQU	BASE + $1D600	; SINE(X)+SINE(2*X)
ROM_CHIRP16 	EQU	BASE + $1D800	; SHORT SWEEP
ROM_NTRI    	EQU	BASE + $1DA00	; Triangle w/NOISE
ROM_DELTA   	EQU	BASE + $1DC00	; Positive spike
ROM_NOISE   	EQU	BASE + $1DE00	; Guess

; These are the old Equates, they were too generic
; They will disappear when I am sick of looking at them

;TRI     	EQU	BASE + $1D000	; A triangle wave
;SINE    	EQU	BASE + $1D200	; Full amplitude SINE
;AMSINE  	EQU	BASE + $1D400	; Linear (?) ramp SINE
;SINE12W 	EQU	BASE + $1D600	; SINE(X)+SINE(2*X)
;CHIRP16 	EQU	BASE + $1D800	; SHORT SWEEP
;NTRI    	EQU	BASE + $1DA00	; Triangle w/NOISE
;DELTA   	EQU	BASE + $1DC00	; Positive spike
;NOISE   	EQU	BASE + $1DE00	; Guess

;	JERRY Registers (DSP)

D_FLAGS		EQU	BASE + $1A100	; DSP Flags
D_MTXC		EQU	BASE + $1A104	; DSP Matrix Control
D_MTXA		EQU	BASE + $1A108	; DSP Matrix Address
D_END		EQU	BASE + $1A10c	; DSP Data Organization
D_PC		EQU	BASE + $1A110	; DSP Program Counter
D_CTRL		EQU	BASE + $1A114	; DSP Operation Control/Status
D_HIDATA 	EQU	BASE + $1A118	; DSP Bus Interface high data
D_REMAIN 	EQU	BASE + $1A11c	; DSP Division Remainder
D_DIVCTRL 	EQU	BASE + $1A11c	; DSP Divider control
D_RAM		EQU	BASE + $1B000	; DSP Internal RAM
D_ENDRAM	EQU	D_RAM +(8*1024)	; 8K bytes

