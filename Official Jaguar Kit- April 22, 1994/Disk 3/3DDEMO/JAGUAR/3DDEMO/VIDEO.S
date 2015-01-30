;*======================================================================*
;*                TITLE:    VIDEO.S                                     *
;*                Function: Video and Object Processor Routines         *
;*                                                                      *
;*                Project #:              JAGUAR                        *
;*                                                                      *
;*                Programmer:             Leonard Tramiel               *
;*                                        Andrew J Burgess              *
;*                                        Rob Zdybel                    *
;*                                                                      *
;*              COPYRIGHT 1992,1993 Atari U.S. Corporation              *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*

	.title	"VIDEO.S - video initialization and VBLANK routines"

BAR_ON	EQU	0

	.include	"jaguar.inc"
	.include	"defs.inc"
	.include	"video.inc"

;*======================================================================*
;*	EXTERNAL SYMBOLS
;*======================================================================*

	.extern	disp_ptr		;* Display buffer ptr
;	.extern	sync			;* interrupt synchronization
	.extern	rate			;* frame rate specifier
	.extern	ratecnt			;* frame rate count
	.extern	framecnt		;* Count of Video Frames

;*======================================================================*
;*	EXTERNAL ROUTINES
;*======================================================================*

	.extern	CopyObjList

;*======================================================================*
;*	PUBLIC SYMBOLS
;*======================================================================*



;*======================================================================*
;*	PUBLIC ROUTINES
;*======================================================================*

	.globl	vblank
	.globl	vidinit
	.globl	vblinit

;*======================================================================*
;*	LOCAL EQUATES
;*======================================================================*

PHRASE		EQU	8
SCRNADDR	EQU	PHRASE
OBJSIZE		EQU	3*2


;*======================================================================*
;*	SUBROUTINE AREA
;*======================================================================*


;*======================================================================*
;*	VIDINIT   Initialize Video to 320x288 NTSC
;*
;*	Given:
;*		Control
;*
;*	Returns:
;*		Video Disabled, but ready for 320x288 NTSC
;*
;*	Register Usage:
;*		None
;*
;*	Externals:
;*		None
;*
;*======================================================================*

vidinit:
;	move.w	#0,VMODE	; Stop the Video (I want to get off)

	clr.l	framecnt
;	move.w	#R60Hz,rate
;	clr.w	ratecnt
;	clr.w	sync

;	move.w	#n_hp,HP
;	move.w	#n_hbb,HBB
;	move.w	#n_hbe,HBE
;	move.w	#n_hs,HS
;	move.w	#n_hvs,HVS
;	move.w	#n_heq,HEQ
	move.w	#n_hde,HDE
	move.w	#n_hdb1,HDB1
	move.w	#n_hdb2,HDB2

;	move.w	#n_vp,VP
;	move.w	#n_vee,VEE
;	move.w	#n_vbe,VBE
	move.w	#n_vdb,VDB
	move.w	#n_vde,VDE
;	move.w	#n_vbb,VBB
;	move.w	#n_veb,VEB
;	move.w	#n_vs,VS
;
;	move.w	#$8000,$f10014
;
;	move.w	#$35cc,MEMCON2	;* do the old endian thing
;	move.w	#$8000,CHRO_CLK

;	move.w	#$7c0,BG	; set the background color
	move.w	#$0,BG	; set the background color
	move.w	#$0,BORD1	; set the border color

	rts

;*======================================================================*
;*	VBLANK   Vertical Sync Interrupt Handler
;*
;*	Given:
;*		Control
;*
;*	Returns:
;*		Object List restored for next frame
;*
;*	Register Usage:
;*		All Registers Preserved
;*
;*	Externals:
;*		framecnt, disp_ptr, olist_ptr
;*
;*======================================================================*
vblank:
	movem.l	a0-a1/d0-d1,-(sp)

	move.w	INT1,d0
	cmp.w	#1,d0		;* is this a video interrupt?
	bne	.done

	jsr	CopyObjList
	addq.l	#1,framecnt	;* Count a video frame

.done:
	move.w	#$101,INT1	;* enable Video interrupt and clear all others pending
	move.w	#0,INT2

	movem.l	(sp)+,d0-d1/a0-a1
	rte



;
;
; This will set up the VI (Vertical line counter Interrupt)
; Or it would if the low order bit of INT1 REALLY was the VI interrupt
;
;
vblinit:

	movem.l	d0,-(sp)

	move.l	#vblank,LEVEL0

	move.w	#(n_vde | 1 ),VI
	move.w	#$1,INT1

	move.w	sr,d0
	and.w	#$f8ff,d0
	move.w	d0,sr

	movem.l	(sp)+,d0

	rts

;*======================================================================*
;*				EOF
;*======================================================================*
