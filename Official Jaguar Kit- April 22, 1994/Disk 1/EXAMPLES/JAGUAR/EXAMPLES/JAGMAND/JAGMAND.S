	.include	'jaguar.inc'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.extern VideoIni
	.extern IntInit
	.extern Lister
	.extern BlitLine
	.extern Clear
	.extern Mandle

; Symbols in GPU code...

	.extern mandGPU
	.extern start_mandGPU
	.extern end_mandGPU

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.globl	listbuf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PATTERN .equ	$20000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.text

; Run the GPU/BLIT interface in CORRECT mode ALWAYS
        
	move.l	#$00070007,G_END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; At this point we don't know what state the video is in
; It may be active or not and may be using an interrupt or not
; Since we may not turn video off we use the following procedure
;
; 1) Disable all 68K interrupts, this includes VI.
;    The existing screen will fail to be refreshed so all bit maps vanish
; 2) Set up the size of borders
; 3) Set up an object list
; 4) Set VMODE to the desired resolution and color model
; 5) Set up an interrupt and start
;
; NOTE: Steps 2, 3 and 4 may be done in any order. If the gap between
; steps 1 and 5 is too long the screen may look funny. To blank the screen
; point the object processor at a stop object
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	move.w	#$1F00,INT1	; Clear latches and disable interrupts

	jsr	VideoIni
	jsr	Lister		; Set up object list
	jsr	IntInit

	move.l	d5,OLP		; This is setup by Lister
	move.w	#$6C1,VMODE	; Set 16 bit CRY; 320 overscanned

	jsr	Clear		; Clear our bitmap

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy over the GPU program

	move.l	#0,G_CTRL	; Make sure the GPU is stopped

	move.l	#mandGPU,a0		; Get the address of the GPU code
	move.l	#start_mandGPU,a1	; Get destination address
	move.l	#end_mandGPU,d0		; and calculate length of GPU code
	sub.l	#start_mandGPU,d0
	asr.l	#2,d0			; divide by 4 since we're copying longs
loop:
	move.l	(a0)+,(a1)+	; actually copy the code...
	dbra	d0,loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy the palette into the chip

	move.l	#256,d0
	move.l	#CLUT,a0
	move.l	#cry_data,a1

cloop:
	move.w	(a1)+,(a0)+
	dbra	d0,cloop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the fractal, then just bail out to an illegal instruction...

	jsr	Mandle

	illegal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.bss
	.even

	.ds.l	 8
listbuf:        
	.ds.l	 16
	        
	.data

; This file has a label cry_data that has, in 68k format the top level
; of cry for 8 bits
        
	.include "cry.pal"
