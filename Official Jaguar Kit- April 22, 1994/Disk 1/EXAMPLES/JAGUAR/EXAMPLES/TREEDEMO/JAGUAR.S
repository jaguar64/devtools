;*======================================================================*
;*                TITLE:    JAGUAR.S                                    *
;*                Function: System Initialization Routines	        *
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
	.title	"JAGUAR.S - System Initialization Routines"

BAR_ON EQU	0


;*======================================================================*
;*	INCLUDE FILES
;*======================================================================*

	.include	'jaguar.inc'
	.include	'blit.inc'
	.include	'defs.inc'
	.include	'video.inc'

;*======================================================================*
;*	EXTERNAL SYMBOLS
;*======================================================================*

	.extern	_v_bas_ad
	.extern NewScreen
	.extern _wrkaJlist
	.extern _orgJlist

	.extern _updlst
	.extern _nupdlst

;*======================================================================*
;*	EXTERNAL ROUTINES
;*======================================================================*

	.extern vidinit
	.extern vblank
	.extern vblinit
	.extern	_user_objs
	.extern _cnvt_objlst
	.extern _copyJlist
	.extern	_setup_gpucpy

;*======================================================================*
;*	PUBLIC SYMBOLS
;*======================================================================*


;*======================================================================*
;*	PUBLIC ROUTINES
;*======================================================================*

	.globl	InitJag
	.globl	_Clear

;*======================================================================*
;*	LOCAL EQUATES
;*======================================================================*


;*======================================================================*
;*	SUBROUTINE AREA
;*======================================================================*

	.text

;*======================================================================*
;*	InitJag   Initialize Jaguar video and object list
;*
;*	Given:
;*		Control
;*
;*	Returns:
;*		
;*
;*	Register Usage:
;*
;*	Externals:
;*		None
;*
;*======================================================================*

InitJag:
	movem.l	a0/d0,-(sp)

	move.l	#NewScreen,_v_bas_ad
	and.l	#$fffff000,_v_bas_ad
	add.l	#$1000,_v_bas_ad	; promote to next phrase

	jsr	vidinit			; Initialize video

	jsr	vblinit			; Initialize VBlank routine

	jsr	_user_objs		; returns ptr to list in d0

	move.l	d0, -(a7)		; pass list ptr to cnvt_objlst()
	
	jsr	_cnvt_objlst		; convert list into packed format
	addq.l	#4, a7

	move.l	#$00070007,G_END	; set the endian thing

	move.l	_wrkaJlist,d0		;* use bi-phrase ptr to olist
	swap	d0			;* and set the OLP
	move.l	d0,OLP

	move.w	#$4C7,VMODE		;Turn on display w/RGB

	movem.l	(sp)+,a0/d0

	rts

	illegal



;*======================================================================*
;*	CLEAR   Do a Block Draw and Clear a 320x200 area at v_bas_ad
;*		This means set A1_FLAGS to
;*		o Contiguous Data
;*		o 16 bit per pixel
;*		o width of 320 pixels
;*		o add increment
;*======================================================================*
_Clear:
	move.l	#PITCH1 | PIXEL16 | WID320 | XADDPIX,d0
	move.l	d0,A1_FLAGS

; Point A1BASE to the data
	move.l	_v_bas_ad,d0
	move.l	d0,A1_BASE

; Set the pixel point to 0,0
	move.w	#0,d0			; y
	swap	d0
	move.w	#0,d0			; x
	move.l	d0,A1_PIXEL

; Set up the step size to -320 in x
; 1 in y
; The x step requires that the pixel pointer by 
	move.w	#1,d0			; y
	swap	d0
	move.w	#(-320),d0		; x
	move.l	d0,A1_STEP

; Set up Counters register to 256 in x write long to clear upper
; 256 in y, or in y as a word

	move.w	#200,d0			; y
	swap	d0
	move.w	#320,d0			; x
	move.l	d0,B_COUNT

; Put some data in the blitter for it to write
; This is a cheat I am using all 0 so there is 
; no need to word swap

	move.l	#0,d0
	move.l	d0,B_PATD	
	move.l	#0,d0
	move.l	d0,B_PATD+4

; Now Turn IT ON !!!!!!!!!!!!!

; NO SOURCE DATA
; NO OUTER LOOP
; Turn on pattern data
; Allow outer loop update

	move.l	#PATDSEL|UPDA1,d0
	move.l	d0,B_CMD

	rts

	.end

;*======================================================================*
;*				EOF
;*======================================================================*
