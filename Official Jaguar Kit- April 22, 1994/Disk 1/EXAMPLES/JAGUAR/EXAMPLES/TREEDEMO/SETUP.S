	.globl	_setup_gpucpy
	.globl	_oblstcpy
	.globl  GPUEND
	.globl	GPUSTART
	.globl  OBLSTCPY

;
; Sets up the GPU with the arbitrary line code, this is called from jin.s
;
_setup_gpucpy:
; Copy over the GPU program
;	move.l	#$00f03000,a1
	move.l	#OBLSTCPY,a1
	move.l	#GPUEND,d0
	sub.l	#GPUSTART,d0
	asr.l	#2,d0		; make count in longs
	sub.l	#1,d0		; for dbra
	move.l	#GPUSTART,a0
loop:	move.l	(a0)+,(a1)+
	dbra	d0,loop
	rts

;_oblstcpy:
;	move.l	#$00000008,$00f02114	; Stop the GPU
;	
;	move.l	#OBLSTCPY,$00f02110	; GPU Program counter gets $00f03000
;	move.l	#$00000011,$00f02114	; Set the GPU going
;
;wait:	move.l	$00f02114,d0
;	and.b	#$01,d0			; test GPUGO bit
;	bne	wait			
;
;	rts
