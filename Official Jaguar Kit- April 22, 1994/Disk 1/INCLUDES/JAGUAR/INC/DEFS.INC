;*======================================================================*
;*                TITLE:                  DEFS.INC			*
;*                Function:               common definitions		*
;*                                                                      *
;*                Project #:              JAGUAR                        *
;*                Programmer:             Andrew J. Burgess		*
;*                                                                      *
;*	COPYRIGHT 1992 Atari Computer Corporation.			*
;*	UNAUTHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,		*
;*	PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR		*
;*	THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.		*
;*	ALL RIGHTS RESERVED.						*
;*                                                                      *
;*======================================================================*

;*======================================================================*
;*	DEFINES
;*======================================================================*

OFF		EQU	0
ON		EQU	1

FALSE		EQU	0
TRUE		EQU	1

DRAM		EQU	$000000		;* start of system RAM
ENDRAM		EQU	$200000		;* end of system RAM
STACK		EQU	DRAM+$5000-$4	;* start of system stack

NUMFACE		EQU	$6		;* offset into model pointer for
					;*	number of faces data
FACELIST	EQU	$10		;* offset into model pointer for
					;*	facelist address

BUFFERSIZE	EQU	(320*240*2)	; screen 320 X 240 in 16.16 color mode
RAMSIZE		EQU	$1000		; 4K bytes
INPUT6		EQU	G_ENDRAM-$4	; pointer to parameter 6 for GPU
INPUT5		EQU	INPUT6-$4	; pointer to parameter 5 for GPU
INPUT4		EQU	INPUT5-$4	; pointer to parameter 4 for GPU
INPUT3		EQU	INPUT4-$4	; pointer to parameter 3 for GPU
INPUT2		EQU	INPUT3-$4	; pointer to parameter 2 for GPU
INPUT1		EQU	INPUT2-$4	; pointer to parameter 1 for GPU

;*	RGB COLORS	 GGRRXXBB
RGB_BLACK	EQU	$00000000
RGB_BLUE	EQU	$000000FF
RGB_GREEN	EQU	$FF000000
RGB_RED 	EQU	$00FF0000
RGB_CYAN	EQU	$FF0000FF
RGB_YELLOW	EQU	$FFFF0000
RGB_MAGENTA 	EQU	$00FF00FF
RGB_WHITE	EQU	$FFFF00FF

;*	RGB COLORS	 GGRRXXBB
RGB_AQUA	EQU	$80000080
RGB_RUST	EQU	$00800000
RGB_VIOLET	EQU	$00800080
RGB_BROWN	EQU	$50800000
RGB_ORANGE	EQU	$80FF0000
RGB_DKGREEN	EQU	$30080000
RGB_LTGREEN	EQU	$FFB000B0
RGB_LTGREY	EQU	$B0B000B0
RGB_GREY	EQU	$80800080
RGB_DKGREY	EQU	$50500050

R60Hz		EQU	1
R30Hz		EQU	2
R20Hz		EQU	3
R10Hz		EQU	4

;****************************************************************************
;*	Generic defines
;****************************************************************************

SCRNORM		EQU	$4C1		;* 320x200 normal pixels
SCROVER		EQU	$6C1		;* 320x200 overscan square pixels

;
;	CPU INTERRUPT locations
;

LEVEL2		EQU	4*26	; 68000 Level2 Autovector ($68)
LEVEL0		EQU	$100	; 68000 Level0 Autovector (9*26)

;
;*======================================================================*
;*	MACROS
;*======================================================================*

	.macro	TIMEBAR	color
.if	BAR_ON != 0
	move.l	#\color,BORD1
.endif
	.endm

.macro	LONGALIGN	addr
	addq.l	#3,\addr		; make sure the address will remain
	andi.l	#$FFFFFFFC,\addr	; within the buffer area
.endm


;*======================================================================*
;*				EOF
;*======================================================================*
