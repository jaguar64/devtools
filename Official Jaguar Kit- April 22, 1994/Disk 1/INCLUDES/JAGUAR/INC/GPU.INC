;*======================================================================*
;*                TITLE:                  GPU.INC			*
;*                Function:               GPU definitions		*
;*                                                                      *
;*                Project #:              JAGUAR                        *
;*                Programmer:             Andrew J. Burgess		*
;*                                                                      *
;*	COPYRIGHT 1992/1993 Atari Computer Corporation			*
;*	UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,		*
;*	PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR		*
;*	THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.		*
;*	ALL RIGHTS RESERVED.						*
;*                                                                      *
;*======================================================================*

;*======================================================================*
;* ADDRESS REGISTERS	- see jaguar.s					*
;*======================================================================*

;*======================================================================*
;* GPUFLAGS Flags register equates					*
;*======================================================================*

G_ZERO		EQU	$00000001	; ALU zero flag
G_CARRY		EQU	$00000002	; ALU carry flag
G_NEGATIVE	EQU	$00000004	; ALU negative flag
G_IMASK		EQU	$00000008	; Interrupt mask
G_INTEN0	EQU	$00000010	; Interrupt enable bits
G_INTEN1	EQU	$00000020	; Interrupt enable bits
G_INTEN2	EQU	$00000040	; Interrupt enable bits
G_INTEN3	EQU	$00000080	; Interrupt enable bits
G_INTEN4	EQU	$00000100	; Interrupt enable bits
G_INTCLR0	EQU	$00000200	; Interrupt disable bits
G_INTCLR1	EQU	$00000400	; Interrupt disable bits
G_INTCLR2	EQU	$00000800	; Interrupt disable bits
G_INTCLR3	EQU	$00001000	; Interrupt disable bits
G_INTCLR4	EQU	$00002000	; Interrupt disable bits
G_REGPAGE	EQU	$00004000	; Register Bank
G_DMAEN		EQU	$00008000	; GPU Load and Store at DMA priority

;*======================================================================*
;* GPUCTRL Matrix Control register
;*======================================================================*

GPUM3x1		EQU	$00000003	; [ 3x1] matrix
GPUM4x1		EQU	$00000004	; [ 4x1] matrix
GPUM5x1		EQU	$00000005	; [ 5x1] matrix
GPUM6x1		EQU	$00000006	; [ 6x1] matrix
GPUM7x1		EQU	$00000007	; [ 7x1] matrix
GPUM8x1		EQU	$00000008	; [ 8x1] matrix
GPUM9x1		EQU	$00000009	; [ 9x1] matrix
GPUM10x1	EQU	$0000000A	; [10x1] matrix
GPUM11x1	EQU	$0000000B	; [11x1] matrix
GPUM12x1	EQU	$0000000C	; [12x1] matrix
GPUM13x1	EQU	$0000000D	; [13x1] matrix
GPUM14x1	EQU	$0000000E	; [14x1] matrix
GPUM15x1	EQU	$0000000F	; [15x1] matrix

GPUMROW		EQU	$00000000	; Row Major matrix
GPUMCOL		EQU	$00000010	; Column Major matrix

;*======================================================================*
;* GPUCTRL Control and Status register
;*======================================================================*

GPUGO		EQU	$00000001	; Start and Stop the GPU
CPUINT		EQU	$00000002	; Allow GPU to interrupt CPU
GPU_CPUINT	EQU	$00000002	; Allow GPU to interrupt CPU
GPUINT0		EQU	$00000004	; generate a GPU type 0 interrupt
SINGLE_STEP	EQU	$00000008	; enable single stepping GPU
SINGLE_GO	EQU	$00000010	; if SINGLE_STEP execute 1 GPU instruction
DMA_ACK		EQU	$00000020	; set external DMA acknowledge
INT_LAT0	EQU	$00000040	; Interrupt latch 0
INT_LAT1	EQU	$00000080	; Interrupt latch 1
INT_LAT2	EQU	$00000100	; Interrupt latch 2
INT_LAT3	EQU	$00000200	; Interrupt latch 3
INT_LAT4	EQU	$00000400	; Interrupt latch 4
BUS_HOG		EQU	$00000800	; Allow GPU to hog BUS

;*======================================================================*
;* General GPU defines
;*======================================================================*
ARGSIZE		EQU	$384

;*======================================================================*
;*				EOF					*
;*======================================================================*
