;*======================================================================*
;*                TITLE:    STARTUP.S                                   *
;*                Function: Startup Routines and Main Loop	        *
;*			    NOTE: Link this file <<<< FIRST >>>>	*
;*                                                                      *
;*                Project #:              JAGUAR                        *
;*                                                                      *
;*                Programmer:             Cary J. Gee                   *
;*                                                                      *
;*              COPYRIGHT 1992,1993 Atari U.S. Corporation              *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*
	.title	"STARTUP.S - System Startup Routines"

;*======================================================================*
;*	INCLUDE FILES
;*======================================================================*
	include "jaguar.inc"
	include	"joypad.inc"
	include "objlist.inc"


;*======================================================================*
;*	EXTERNAL SYMBOLS
;*======================================================================*

;*======================================================================*
;*	EXTERNAL ROUTINES
;*======================================================================*

	.extern	InitJag
	.extern	_main
;*======================================================================*
;*	PUBLIC SYMBOLS
;*======================================================================*
	.globl	framecnt
	.globl	olist
	.globl	olist_ram
	.globl	DISPBUF0
	.globl	DISPBUF1
	.globl	ZBUF
;*======================================================================*
;*	PUBLIC ROUTINES
;*======================================================================*

	.globl	startup
	.globl	done
;*======================================================================*
;*	LOCAL EQUATES
;*======================================================================*

;*======================================================================*
;*	SUBROUTINE AREA
;*======================================================================*

	.text

;*======================================================================*
;*	startup - Link this file ************** FIRST ***************
;*======================================================================*
startup:
;	move.l	#newstack,a7
	jsr	InitJag
	jsr	_main

done:
;	illegal
	rts

;*======================================================================*
;*	LOCAL RAM
;*======================================================================*

BUFFERSIZE	EQU	(320*200*2)	; screen 320 X 200 in 16 bit color mode

	.bss

	;*==============================================================*
	.phrase

olist:
	ds.l	2				;* needed for bi-phrased
	ds.l	(8*MAXOBJS)			;* need 8 longs for each object
	ds.l	2				;* 2 longs for a stop object
olist_ram:
	ds.l	(8*MAXOBJS)			;* 8 longs for each object
	ds.l	2				;* 2 longs for a stop object

;NewScreen	equ	$1a2400
;DISPBUF0	equ	$1a2400
;DISPBUF1	equ	DISPBUF0+8
;ZBUF		equ	DISPBUF1+8

.phrase
NewScreen:
DISPBUF0:	ds.b	3*BUFFERSIZE
DISPBUF1	equ	DISPBUF0+8
ZBUF		equ	DISPBUF1+8
;NewScreen:
;DISPBUF0:	ds.l	3*BUFFERSIZE
SCREENPAD:	ds.b	256
;DISPBUF1:	ds.l	2
;ZBUF:		ds.b	3*BUFFERSIZE		;3*BUFFERSIZE


		ds.l	2000			; 8k for stack
newstack:	ds.l	1
framecnt:	ds.l	1


	.end


;*======================================================================*
;*				EOF
;*======================================================================*
