*	vea gemlib memcpy
*	a very fast memory copy
*
*	call: 	vmemcpy(to, from, count)
*
*		char	*to;
*		char	*from;
*		long	count;
*

		.globl _vmemcpy

_vmemcpy:
		movem.l	d1-d7/a0-a6,-(sp)	; 14 regs @ 4 bytes each = 56 bytes

; Grab parameters off stack... (reg save area is 56 bytes long)

		movea.l	60(sp),a0		; to:     4 + 56 = 60
		movea.l	64(sp),a1		; from:   8 + 56 = 64
		move.l	68(sp),d1		; count: 12 + 56 = 68

		cmp.l	#$7,d1
		ble	blt7e

		move.w	a0,d0
		and.w	#$1,d0
		move.w	a1,d2
		and.w	#$1,d2
		cmp.w	d2,d0
		bne	blt7e

		tst.w	d0
		beq	blt3c

		move.b	(a1)+,(a0)+
		subq.l	#$1,d1
blt3c:
		move.l	d1,d0
		asr.l	#$2,d0
		and.l	#$3,d1
		sub.l	#$d,d0
		blt	blt70

		movem.l	d1-d7/a2-a6,-(sp)
blt54:
		movem.l	(a1)+,d1-d7/a2-a6
		movem.l	d1-d7/a2-a6,(a0)
		adda.l	#$30,a0
		sub.l	#$c,d0
		bge	blt54

		movem.l	(sp)+,d1-d7/a2-a6
blt70:
		add.l	#$c,d0
blt76:
		move.l	(a1)+,(a0)+
		subq.l	#$1,d0
		bge	blt76

blt7e:
		tst.l	d1
		ble	blt8c

blt84:
		move.b	(a1)+,(a0)+
		subq.l	#$1,d1
		bgt	blt84

		move.l	4(sp),d0
blt8c:
		movem.l	(sp)+,d1-d7/a0-a6	; restore regs
		rts

	
