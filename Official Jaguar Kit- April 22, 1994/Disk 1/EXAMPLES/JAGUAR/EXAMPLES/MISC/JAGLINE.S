	.include	'jaguar.inc'

	.extern VideoIni
	.extern	IntInit
	.extern Lister
	.extern BlitLine
	.extern	Clear
	.extern	VDB

	.globl	listbuf

PATTERN		equ	$20000

.text
; Run the GPU/BLIT interface in CORRECT mode ALWAYS
	move.l	#$00070007,G_END
; At this point we don't know what state the video is in
; It may be active or not and may be using an interrupt or not
; Since we may not turn video off we use the following procedure
; Disable VI by setting to a VERY large number.
;	The existing screen will fail to be refreshed so all bit maps vanish
; Set up an object list consisting of a stop object.
; Clear the spot the screen will be
; Set up the desired object list
; Set up an interrupt and start
; Set up the size of borders
; Point the Object Processor at the real object list
; Set VMODE to the desired resolution and color model

; NOTE: To blank the screen point the object processor at a stop object


	move.l	#$200000,a7		; Put the stack at the top of DRAM

	move.w	#$FFFF,VI		; Guarantee NO VI interrupts

	move.l	#0,stopobj
	move.l	#4,stopobj+4

	move.l	#stopobj,d0
	swap	d0
	move.l	d0,OLP			; Set up object processor to SAFE stop object!!!!

	jsr	Clear

	jsr	Lister

	jsr	IntInit

	jsr	VideoIni

	move.l	d5,OLP			; This is setup by Lister

	move.w	#$6C1,VMODE		; Set 16 bit CRY; 320 overscanned

; Now a cleared bar is being displayed

	jsr	BlitLine

	illegal

.bss
.phrase
listbuf:	ds.l	16

.phrase
stopobj:
		ds.l	2


		
