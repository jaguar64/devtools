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
;	.include	'defs.inc'
	.include	'video.inc'
	.include	'objlist.inc'

;*======================================================================*
;*	EXTERNAL SYMBOLS
;*======================================================================*

	.extern Objects
	.extern objData
	.extern lastObj
	.extern olist
	.extern olist_ram
	.extern	dlistptr

;*======================================================================*
;*	EXTERNAL ROUTINES
;*======================================================================*

	.extern InitObjList
	.extern BuildObjList
	.extern CopyObjList
	.extern vidinit
	.extern vblank
	.extern vblinit

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

	jsr	vidinit			; Initialize video

	jsr	vblinit			; Initialize VBlank routine

	move.l	#olist+15,d0		;force bi-phrase alignement
	andi.w	#~15,d0			;at first bi-phrase boundary in olist
	move.l	d0,dlistptr		;save for use by v_blank

	lea.l	Objects,a0
	jsr	InitObjList


	lea.l	objData,a1

	clr.l	d6
	move.w	lastObj,d6
	add.w	#1,d6

	jsr 	BuildObjList
	jsr	CopyObjList

;	move.l	#olist,d0		;* Hey, this is not bi-phrased!

	move.l	dlistptr,d0		;* use bi-phrase ptr to olist
	swap	d0			;* and set the OLP
	move.l	d0,OLP

	move.l	#$00070007,G_END	; set the endian thing

;	move.w	#$4C7,VMODE		;Turn on display w/RGB
	move.w	#$4C1,VMODE		;Turn on display w/CRY

	movem.l	(sp)+,a0/d0

	rts

	illegal



	.end

;*======================================================================*
;*				EOF
;*======================================================================*
