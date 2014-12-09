;*======================================================================*
;*                TITLE:                  GPU.S                         *
;*                Function:               Gpu interfece routines        *
;*                                                                      *
;*                Project #:              RAPIER                        *
;*                Programmer:             Andrew J Burgess              *
;*                                        Rob Zdybel                    *
;*                                                                      *
;*              COPYRIGHT 1992/1993 Atari Computer Corporation          *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*

	include "jaguar.inc"
	include "blit.inc"
	include "gpu.inc"

;
;	PUBLIC SYMBOLS
;
	.globl	gpuload
	.globl	gpurun
	.globl	gpuwait
;	.globl	turtlpak
;	.globl	fastdraw
;	.globl	sort

	.extern	framecnt

;*======================================================================*
;* gpuload()	- load a GPU program into GPU RAM
;*
;*	input:
;*		a0	- 68000 address of GPU program
;*		a1	- destination address
;*		d0	- size of program
;*
;*	preserved:
;*		d0-d1
;*		a0-a1
;*======================================================================*
gpuload:
	movem.l	d0-d1/a0-a2,-(sp)		; save GPU address for restore

	move.l	#B_CMD,a2
.waitblit:			; Wait for BLTTER Idle
	move.l	(a2),d1
	lsr.w	#1,d1
	bcc	.waitblit

	jsr	gpuwait

	; This code will load a gpu program into the Blitter at the address
	; specified in the header 

	move.l	#PITCH1|PIXEL16|WID256|XADDPHR,d1
	move.l	d1,A1_FLAGS
	move.l	d1,A2_FLAGS
	
	; Point A1BASE to the destination
	; Read destination from header of file
	; Phrase align and find remainder

;	move.l	(a0)+,d0
;	move.l	d0,d1
;	and.l	#$fffffff8,d0
;	sub.l	d0,d1
;	move.l	d0,A1_BASE
	move.l	a1,A1_BASE
;	move.l	#$F03000,A1_BASE

	; Set the pixel pointer to the offset in d1

;	asr.l	#1,d1		; Convert to pixels
;	move.l	d1,A1_PIXEL
	move.l	#0,A1_PIXEL

	; Find size of data to load

;	move.l	(a0)+,d0
	asr.l	#1,d0		; Convert to words
	or.l	#$10000,d0	; Set 1 outer loop
	move.l	d0,B_COUNT

	; Set up Counters register to number of words

	; Point A2BASE to the source
	; a0 now points to the data
	; Phrase align and find remainder

;	move.l	a0,d0
;	move.l	d0,d2
;	and.l	#$fffffff8,d0
;	sub.l	d0,d2
;	move.l	d0,A2_BASE
	move.l	a0,A2_BASE

	; Set the pixel pointer to the offset in d1

;	asr.l	#1,d2		; Convert to pixels
;	move.l	d2,A2_PIXEL
	move.l	#0,A2_PIXEL

;	cmp.l	d1,d2
;	ble.s	.aligned

;	move.l	#SRCEN|SRCENX|LFU_AN|LFU_A,d0
;	bra.s	.blit_go
;.aligned:
	move.l	#SRCEN|LFU_AN|LFU_A,d0
.blit_go:
	move.l	d0,B_CMD
;
;	NOTE: No Wait for BLTTER Idle - I have yet to be overrun but WARNING
;
	movem.l	(sp)+,d0-d1/a0-a2
	rts

;*======================================================================*
;* gpurun()	- tell the GPU to begin execution
;*
;*	input:
;*		a0	- 68000 address of GPU program
;*
;*	preserved:
;*		d0-d1
;*		a0
;*======================================================================*
gpurun:
	movem.l	d0-d1/a0,-(sp)		; save GPU address for restore
	move.l	#$F03000,G_PC
;	move.l	(a0)+,G_PC		; load GPU PC

	move.l	#$11,G_CTRL		; Turn on the GPU

	movem.l	(sp)+,a0/d0-d1		; restore GPU address
	rts

;*======================================================================*
;* gpuwait()	- wait for the GPU to finish executing
;*
;*	input:
;*		None
;*
;*	preserved:
;*		d0
;*		a0
;*======================================================================*
gpuwait:
	movem.l	a0-a1/d0-d1,-(sp)

	lea	G_CTRL,a0
	move.l	#$400000,a1
.gpuwt:				; wait for GPU to finish
;	move.l	B_CMD,(a1)+
;	move.l	$f02110,(a1)+
	move.l	framecnt,d1
	swap	d1
	move.w	$f00006,d1
	move.l	d1,(a1)+
	move.l	#-1,(a1)
	move.l	(a0),d0
	asr	#1,d0
	bcs	.gpuwt

	movem.l	(sp)+,a0-a1/d0-d1
	rts

;
;	CONSTANT DATA (GPU PROGRAMS)
;
;.phrase
;sort:
;	.include	"sort.dat"
;.phrase
;fastdraw:
;	.include	"textdraw.dat"
;
;.phrase
;turtlpak:
;	.include	"turtle.dat"
;*======================================================================*
;*                                 EOF                                  *
;*======================================================================*

