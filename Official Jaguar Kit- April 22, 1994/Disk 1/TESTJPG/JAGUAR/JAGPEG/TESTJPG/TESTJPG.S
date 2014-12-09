
	.include	'jaguar.inc'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.extern VideoIni
	.extern IntInit
	.extern Lister
	.extern BlitLine
	.extern Clear
	.extern	test_jagpeg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;
; 2) Set up the size of borders
;
; 3) Set up an object list
;
; 4) Set VMODE to the desired resolution and color model
;
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
	move.w	#$6C7,VMODE	; Set 16 bit RGB; 320 overscanned
	jsr	Clear		; Clear our bitmap

;;;;;;;;;;;;;;;;;;;
; Draw the pictures

	jsr	test_jagpeg	; This should never return
	illegal			; So we should never get here...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.bss
	.even

	.ds.l	 8
listbuf::
	.ds.l	 16
