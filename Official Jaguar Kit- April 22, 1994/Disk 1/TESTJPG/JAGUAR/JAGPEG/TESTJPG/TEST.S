
	.include "jaguar.inc"
	.include "blit.inc"
	.include "dejag.inc"
	.include "vidstuff.inc"

	.text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.extern	dhuf_abs
	.extern	djag_gpu
	.extern	dq75_abs
	.extern	dq40_abs
	.extern	dq25_abs
	.extern	fish_jpg
	.extern	pat_jpg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	DEHUFF_ADDR	.equ	$50000
	DEHUFF_SIZE	.equ	1400

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

test_jagpeg::
	bsr	copy_dejag
	bsr	copy_dehuff

.show_fish:
	bsr	copy_dq25		; Copy over 25% quality table
	move.l	#fish_jpg,In_Adr
	move.l	#bitmap_addr,Out_Adr
	move.l	#DEHUFF_ADDR,Dehuff_Adr
	move.l	#(WIDTH/8),Out_Width
	move.l	#WID320,Out_E_Width
	bsr	start_gpu
	bsr	wait_for_gpu
	bsr	delay
;;;;;;;;
	bsr	copy_dq75
	move.l	#pat_jpg,In_Adr
	move.l	#bitmap_addr,Out_Adr
	move.l	#DEHUFF_ADDR,Dehuff_Adr
	move.l	#(WIDTH/8),Out_Width
	move.l	#WID320,Out_E_Width
	bsr	start_gpu
	bsr	wait_for_gpu
	bsr	delay

	bra	.show_fish	; Switch back and forth
	rts			; til reset or powerdown.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Icky software timing loop... replace with something
; based on hardware if you need a more precise timer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

delay:
	move.l	#500000,d0
.timer:
	sub.l	#1,d0
	bpl.s	.timer
	rts

start_gpu:
	move.l	#G_RAM,G_PC	; Start up GPU
	move.l	#1,G_CTRL
	rts

wait_for_gpu:
	move.l	All_Done,d0
	cmpi.l	#$12345678,d0
	bne	wait_for_gpu
	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

copy_dejag:
	lea	djag_gpu,a0
;	bra	copy_binfile


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This copies the BIN file at location (a0) to its intended destination.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

copy_binfile::
	move.l	(a0)+,a1	; Get starting address (destination)
	move.l	(a0)+,d0	; Get length of code segment...
	asr	#2,d0		; Divide by 4 (do longs)
.loop:
	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

copy_dehuff:
	lea	dhuf_abs,a0
	lea	DEHUFF_ADDR,a1
	move.l	#(DEHUFF_SIZE/4),d0	; Divide by 4 so we can copy longs
.loop:
	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

copy_dq75:
	lea	dq75_abs,a0
	bra.s	copy_dq

copy_dq40:
	lea	dq40_abs,a0
	bra.s	copy_dq

copy_dq25:
	lea	dq25_abs,a0
;	bra.s	copy_dq

copy_dq:
	lea	DQ_Adr,a1
	move.l	#(320/4),d0	; Divide by 4 so we can copy longs
.loop:
	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts

	.phrase
