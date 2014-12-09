;*======================================================================*
;*                TITLE:                  MACROS.INC                    *
;*                Function:               GPU macros                    *
;*                                                                      *
;*                Project #:              RAPIER                        *
;*                Programmer:             Robert J Zydbel               *
;*                                        Andrew J Burgess              *
;*                                                                      *
;*              COPYRIGHT 1992 Atari Computer Corporation               *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*

;*======================================================================*
;*	REGISTER EQUATES
;*======================================================================*

	.if	DEBUG_ON
DbTemp1	.equr	r26
DbTemp2	.equr	r27
DbOut	.equr	r28
	.endif

;*======================================================================*
;*	MACROS
;*======================================================================*
;
;	General Purpose JSR
;
	.macro	JSR			; Jump to subroutine macro
					; trashes R0
	subq	4,SP			; adjust the stack pointer
	nop
	move	PC,r0			; determine current program address
	addq	16,r0			; new address for after this macro
	store	r0,(SP)			; push return address onto stack
	movei	@1,r0			; load up subroutine address
	jump	(r0)			; jump to subroutine
	nop				; jump doesn't occur until this instr
	.endm

	.macro	RTS			; Return from Subroutine macro
					;	trashes r0
	load	(SP),r0			; load up return address
	addq	4,SP			; adjust the stack pointer
	jump	(r0)			; jump back to return address
	nop				; jump doesn't occur until this instr
	.endm

	.macro	PUSH			; push a value onto the stack
	store	@1,(SP)			; put argument onto the stack
	subq	4,SP			; adjust the stack pointer
	nop
	.endm

	.macro	POP			; pop a value off the stack
	load	(SP),@1			; take arguement off the stack
	addq	4,SP			; adjust stack pointer
	nop
	.endm

	.macro	CLEAR			; set a register to 0
	xor	@1,@1			; XOR of self is 0, quicker than movei **I'm not convinced this is true!!**
	.endm


	.macro	DEBUG
	.if	DEBUG_ON
	nop
	moveta	r0,DbTemp1		; save r0 to use for output
	moveta	r1,DbTemp2		; save r1
	move	@1,r1
	movefa	DbOut,r0		; load output address
	store	r1,(r0)			; output register contents
	addq	#4,r0			; advance output address
	nop
	moveta	r0,DbOut		; save output address
	move	r1,@1			; restore data
	movefa	DbTemp2,r1		; restore r1
	nop
	movefa	DbTemp1,r0		; restore r0
	nop
	.endif
	.endm

	.macro	DEBUG_INIT		; initialize debug area
	.if	DEBUG_ON
	movei	#$00f03e00,r0		; Debug output address
	moveta	r0,DbOut		; Debug in alternate register bank
	.endif
	.endm

	.macro	LEAVE			; forced exit of GPU program
	.if	DEBUG_ON
	movei	#gpuend,r0
	nop
	jump	(r0)
	nop
	.endif
	.endm

	.macro	VOMIT
	moveta	@1,r0			; **WARNING: Lark's Vomit**
	.endm

	.macro	TIMEBAR			; timing bar utility
	.if	BAR_ON
	moveta	r0,r0			; save r0 to use for output
	moveta	r1,r1			; save r1
	movei	#@1,r0
	movei	#(BORD1+$7000000),r1
	store	r0,(r1)
	nop
	movefa	r1,r1			; restore r1
	nop
	movefa	r0,r0			; restore r0
	nop
	.endif
	.endm

;*	RGB COLORS	 XXBBGGRR
RGB_BLACK	.equ	$00000000
RGB_BLUE	.equ	$00FF0000
RGB_GREEN	.equ	$0000FF00
RGB_RED 	.equ	$000000FF
RGB_CYAN	.equ	$00FFFF00
RGB_YELLOW	.equ	$0000FFFF
RGB_MAGENTA 	.equ	$00FF00FF
RGB_WHITE	.equ	$00FFFFFF

RGB_AQUA	.equ	$00808000
RGB_RUST	.equ	$00000080
RGB_VIOLET	.equ	$00800080
RGB_BROWN	.equ	$00005080
RGB_ORANGE	.equ	$000080FF
RGB_DKGREEN	.equ	$00003008
RGB_DTGREEN	.equ	$00B0FFB0
RGB_LTGREY	.equ	$00B0B0B0
RGB_GREY	.equ	$00808080
RGB_DKGREY	.equ	$00505050

;*======================================================================*
;*                                 EOF                                  *
;*======================================================================*

