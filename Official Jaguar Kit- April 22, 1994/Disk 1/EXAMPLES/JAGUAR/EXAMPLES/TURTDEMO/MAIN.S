;*======================================================================*
;*                TITLE:                  MAIN.S                        *
;*                Function:               Complete 3D Turtle Demo       *
;*                                                                      *
;*                Project #:              JAGUAR/SYLVESTER              *
;*                Programmer:             Rob Zdybel                    *
;*					  Andrew J Burgess              *
;*									*
;+ CHANGES:
; 93-Nov-23 nbk changed GPU.S and all *.GAS files to be able to
; use the *.BIN absolute files for include via ALN instead of converting
; to *.DAT files containing DC.L statements
; 93-Nov-20 nbk	minimal changes to fit to new VideoIni routine and to 
; new JAGUAR.INC and BLIT.INC   							
;-                                                                      *
;*              COPYRIGHT 1993 Atari Computer Corporation               *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*

	.include "jaguar.inc"
	.include "blit.inc"
	.include "joypad.inc"

;
;	EXTERNAL SYMBOLS
;
	.extern	cube		; Hand-Made Cube

	.extern	gpuload
	.extern	gpurun
	.extern	gpuwait
	.extern	make_olist
	.extern	pad_now
	.extern	pad_shot
	.extern	readpad
	
	.extern	SORT		; external address GPU sort
	.extern	TURTLPAK	; external address GPU turtlpak
	.extern	vblank

;+ redefine to fit to VideoIni
	.extern	VideoIni
	.extern a_vde
	.extern	FASTDRAW	; external adress GPU fastdraw

	.extern	framecnt

;
;	PUBLIC SYMBOLS
;
	.globl	disp_ptr
	.globl	draw_ptr
	.globl	DISPBUF1

;
;	USEFUL DEFINES

;+ as no longer defined in newer include files I define two variables
ENDRAM		.equ	$200000		; 2 MByte RAM for Sylvester/Jaguar
LEVEL0		.equ	$100		; VI for 68k CPU
;- nbk 93-Nov-20

BUFFERSIZE	.equ	(320*200*2)	; screen 320 X 200 in 16.16 color mode
DISPBUF1	.equ	ENDRAM-BUFFERSIZE
DISPBUF0	.equ	DISPBUF1-BUFFERSIZE

RAMSIZE		.equ	$1000		; 4K bytes
INPUT6		.equ	G_ENDRAM-$4	; pointer to parameter 6 for GPU
INPUT5		.equ	INPUT6-$4	; pointer to parameter 5 for GPU
INPUT4		.equ	INPUT5-$4	; pointer to parameter 4 for GPU
INPUT3		.equ	INPUT4-$4	; pointer to parameter 3 for GPU
INPUT2		.equ	INPUT3-$4	; pointer to parameter 2 for GPU
INPUT1		.equ	INPUT2-$4	; pointer to parameter 1 for GPU

;
;	LOCAL MACROS
;
.macro	LONGALIGN	addr
	addq.l	#3,\addr		; make sure the address will remain
	andi.l	#$FFFFFFFC,\addr	; within the buffer area
.endm

;*======================================================================*
;
;	PROGRAM SEGMENT
;
;*======================================================================*
	.text

main:
	move.l	#$b000,sp	; **KLUDGE** Init the stack

	jsr	initsys		; initialize the system

	jsr	initurtl	; initialize turtles

	moveq.l	#0,d0
	moveq.l	#-1,d1
	move	d0,gameover	; Game not over yet
	move.l	d1,pad_now	; Clear the joypad
	move	d0,ncubes
	move	d0,rotate_flg
	move	d1,amb_flg
	move	d1,sun_flg
	move	d1,bulb_flg
	move	d0,scrublist	; ScrubList = Nil
	move	#1,drawlist	; One Object

framelp:
	jsr	do_sort		; Start the GPU Sorting Turtles

	jsr	clrscreen	; Clear the draw buffer

	jsr	gpuwait
	lea	FASTDRAW,a0	; use UPPERCASE label, nbk 93-Nov-20
	jsr	gpuload		; Load Polyhedron Draw Routine into GPU RAM

	move	#0,newlist	; Newlist = Nil
drawlp:	move	drawlist,d0	; WHILE (DrawList <> Nil) DO Draw Object
	beq	.drawxit
	move	d0,d1
	mulu	#turtlsiz,d0
	add.l	#turtle,d0	; D0 = Ptr to Turtle
	move.l	d0,a0
	move	turtlnk(a0),drawlist
	move	newlist,turtlnk(a0)
	move	d1,newlist	; Newlist = Drawlist inverted (This speeds sorting)
	lea	turtle+turtlsiz,a1
	move.l	(a1)+,(a0)+	; Cheat rotation by copying from one cube
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.w	(a1)+,(a0)+
	jsr	gpuwait		; Wait for GPU Idle
	jsr	copymodel	; BLTTER copy Model to Instance
	jsr	do_fastdraw	; Start GPU/BLTTER Polyhedron Draw
	bra	drawlp
.drawxit:
	move	newlist,drawlist	; DrawList is now inverted
	jsr	readpad		; Read the Joypad
	jsr	gpuwait		; Wait for GPU Idle

	move.l	disp_ptr,d0
	move.l	draw_ptr,disp_ptr
	move.l	framecnt,d7	; D7 = Current Frame for sync later
	move.l	d0,draw_ptr	; Swap buffers

	jsr	input		; Interpret the Joypad input

.wsync:	cmp.l	framecnt,d7
	beq	.wsync		; Wait for video sync

	move	gameover,d0
	beq	framelp		; UNTIL (Game Over)

stop:

	illegal			; **KLUDGE** FORCE EXIT TO ADB
	nop


;*======================================================================*
;
;	SUBROUTINE AREA
;
;*======================================================================*

;*======================================================================*
;
;	INPUT  Interpret Joypad results and act accordingly
;
;	Given:
;		PAD_NOW = Current Joypad reading
;		PAD_SHOT = One-Shot Joypad
;
;	Returns:
;		Input handled
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		GPULOAD, DO_TURTLE
;
;*======================================================================*
input:
	movem.l	d0-d7/a0-a1,-(sp)

	lea	TURTLPAK,a0	; use UPPERCASE label, nbk 22-Nov-93
	jsr	gpuload		; Load Turtle Package into GPU
;
;	Handle ViewPoint Rotation and Translation
;
	move.l	pad_now,d0
	moveq	#0,d1
	btst.l	#JOY_UP,d0
	beq	.noup
	addq	#1,d1		; PITCH Down
.noup:	btst.l	#JOY_DOWN,d0
	beq	.nodwn
	subq	#1,d1		; PITCH Up
.nodwn:	moveq	#0,d2
	btst.l	#JOY_LEFT,d0
	beq	.nolft
	addq	#1,d2		; YAW Left
.nolft:	btst.l	#JOY_RIGHT,d0
	beq	.norit
	subq	#1,d2		; YAW Right
.norit:	moveq	#0,d3
	btst.l	#KEY_1,d0
	beq	.nocw
	subq	#1,d3		; ROLL Clockwise
.nocw:	btst.l	#KEY_3,d0
	beq	.noccw
	addq	#1,d3		; ROLL CounterClockwise
.noccw:	moveq	#0,d4
	btst.l	#KEY_STAR,d0
	beq	.norev
	subq	#1,d4		; REVERSE
.norev:	btst.l	#KEY_HASH,d0
	beq	.nofor
	addq	#1,d4		; FORWARD
.nofor:	btst.l	#FIRE_A,d0
	beq	.nomor
	add	#10,d4		; FAST FORWARD
.nomor:	moveq	#0,d0
	jsr	do_turtle	; ViewPoint Rotation and Translation
;
;	Handle all other input
;
	move.l	pad_shot,d0
	btst.l	#KEY_0,d0
	beq	.noquit
	move	#-1,gameover	; 0 = Exit
.noquit:
;
;	Light Source Toggle and Intensity
;
	btst.l	#FIRE_B,d0
	beq	.nob
	eor	#-1,sun_flg	; Toggle Sun On/Off
.nob:	btst.l	#FIRE_C,d0
	beq	.noc
	eor	#-1,bulb_flg	; Toggle InScene On/Off
.noc:	btst.l	#KEY_5,d0
	beq	.noa
	eor	#-1,amb_flg	; Toggle Ambient On/Off
.noa:	move.l	pad_now,d1
	moveq	#0,d2
	btst.l	#KEY_6,d1
	beq	.noinc
	addq	#1,d2		; Increase Intensity
.noinc:	btst.l	#KEY_4,d1
	beq	.nodec
	subq	#1,d2		; Decrease Intensity
.nodec:	move	amb_flg,d1
	beq	.litem		; IF (Ambient On) THEN Alter Ambient Intensity
	add.b	d2,ambient+1
.litem:
	lea	litemodel,a0
	move	ambient,(a0)+
	move	sun_flg,d1	; Build a lighting model
	beq	.nosun
	add.b	d2,sun+1	; IF (Sun On) THEN Update Intensity and add Sun
	lea	sun,a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
.nosun:	move	bulb_flg,d1
	beq	.nobulb
	add.b	d2,bulb+1	; IF (Bulb On) THEN Update Intensity and add Bulb
	lea	bulb,a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
.nobulb:
	move.w	#0,(a0)+
;
;	CUBE Rotation and Propogation
;
	btst.l	#KEY_7,d0
	bne	.less
	btst.l	#KEY_9,d0
	beq	.same
	move	ncubes,d2	; More Cubes
	addq	#1,d2
	cmp	#8,d2
	bge	.same		; BUT No more than EIGHT
	bra	.cubes	
.less:	move	ncubes,d2	; Fewer Cubes
	subq	#1,d2
	bmi	.same		; BUT No fewer than ONE
.cubes:	lea	turtle+turtlsiz,a0
	move	d2,ncubes	; Build the CUBES
	move	#0,drawlist
	move	#0,scrublist
	move	d2,d4
	move	d2,d5
	move	d2,d6
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#1,d7
.xcube:	move	d1,xposn(a0)	; Initialize a Cube
	move	d2,yposn(a0)
	move	d3,zposn(a0)
	move	scrublist,turtlnk(a0)
	move	d7,scrublist	; Link to Scrublist
	addq	#1,d7
	adda.l	#turtlsiz,a0
	add	#$200,d1
	dbra	d4,.xcube	; All X
	move	ncubes,d4
	moveq	#0,d1
	add	#$200,d2
	dbra	d5,.xcube	; All Y
	move	ncubes,d5
	moveq	#0,d2
	add	#$200,d3
	dbra	d6,.xcube	; All Z
.same:
  	btst.l	#KEY_8,d0
	beq	.norot
	eor	#-1,rotate_flg
.norot:	move	rotate_flg,d1
	beq	.done
	moveq	#1,d0
	moveq	#1,d1
	moveq	#1,d2
	moveq	#1,d3
	moveq	#0,d4
	jsr	do_turtle	; Cube Rotation
.done:
	movem.l	(sp)+,d0-d7/a0-a1
	rts


;*======================================================================*
;
;	INITSYS   Initialize the system
;
;	Given:
;		Control
;
;	Returns:
;		320x200 Double-Buffered Video Enabled
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		VideoIni, MAKE_OLIST
;
;*======================================================================*
initsys:


	move.l	d0,-(sp)

;+ that is done in the startup rom since 31-Oct-93 so I comment it out 
;
;	move.w	#$1801,MEMCON1	; Enable SOMETHING
;	move.w	#$38cc,MEMCON2	; Do the old endian thing ??
;
; G_BIGEND was only defined in older JAGUAR.INC now it is G_END
;	move.l	#$70007,G_BIGEND	; Run GPU in Motorola I/O mode, Motorola Pixel Mode

	move.l	#$70007,G_END	; Run GPU in Motorola I/O mode, Motorola Pixel Mode
;
; we use a newer routine, so I must change the label name
;	jsr	vidinit		; Initialize 320x200 NTSC Video

	jsr	VideoIni	; Initialize 320x200 NTSC Video
;- 93-Nov-20 nbk

	jsr	make_olist	; Initialize Object List to single 320x200 Object

	move.l	#DISPBUF1,disp_ptr
	move.l	#DISPBUF0,draw_ptr	; Initialize Double-Buffer Ptrs

	move.l	#vblank,LEVEL0	; Capture VBLANK Interrupt

;+ for this the new VideoIni has a variable which we want to use.
;	move.w	#467,VI		; (must be ODD) NOTE: Actually very end of screen!
; 
	move.w  a_vde,d0	; thats the downside border of the screen
	btst.l	#0,d0		; check for odd
	bne.s	.uneq		; in odd thats fine
	subq.w  #1,d0		; else use one line before as end
.uneq:	
	move.w  d0,VI
;- nbk 93-Nov-20

	move.w	#1,INT1
	move.w	sr,d0
	and.w	#$f8ff,d0
	move.w	d0,sr		; Enable Interrupt

	move.w	#$6C1,VMODE	; Turn on the display

	move.l	(sp)+,d0
	rts


;*======================================================================*
;
;	INITURTL   Initialize the TURTLE database
;
;	Given:
;		Control
;
;	Returns:
;		All Turtles initialized to Origin
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		
;
;*======================================================================*
initurtl:
	movem.l	d0-d2/a0,-(sp)

	lea	turtle,a0
	clr	d0
	move	#$4000,d1
	move	#maxturtl-1,d2
.clrlp:	move	d1,xrite(a0)	; FOR (All Turtles) DO
	move	d0,yrite(a0)	; Init to Origin - Ordirnally aligned
	move	d0,zrite(a0)
	move	d0,xdown(a0)
	move	d1,ydown(a0)
	move	d0,zdown(a0)
	move	d0,xhead(a0)
	move	d0,yhead(a0)
	move	d1,zhead(a0)
	move	d0,xposn(a0)
	move	d0,yposn(a0)
	move	d0,zposn(a0)
	move	d0,turtlnk(a0)
	add.l	#turtlsiz,a0
	dbra	d2,.clrlp

	lea	turtle,a0
	move	#$fe80,zposn(a0)	; *KLUDGE* Position Viewpt in front of object

	movem.l	(sp)+,d0-d2/a0
	rts


;*======================================================================*
;
;	CLRSCREEN   BLTTER Zero fill a 320x200 screen buffer
;
;	Given:
;		DRAW_PTR = Ptr to Draw buffer
;
;	Returns:
;		Draw buffer zeroed
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		None
;
;*======================================================================*
clrscreen:
	movem.l	d0/a0,-(sp)

 	move.l	#(PITCH1|PIXEL16|WID320|XADDPHR),A1_FLAGS

	move.l	draw_ptr,A1_BASE	; Point to Draw buffer

	move.w	#1,d0
	swap	d0
	move.w	#-320,d0
	move.l	d0,A1_STEP	; Step -320 x, +1 y each line

	move.w	#200,d0
	swap	d0
	move.w	#320,d0
	move.l	d0,B_COUNT	; Do 320x200

	clr.l	d0
	move.l	d0,A1_PIXEL
	move.l	d0,B_PATD
	move.l	d0,B_PATD+4	; Zero fill

	move.l	#(PATDSEL|UPDA1),B_CMD	; Start the BLTTER

	move.l	#B_CMD,a0
.waitblit:			; Wait for BLTTER Idle
	move.l	(a0),d0
	lsr.w	#1,d0
	bcc	.waitblit

	movem.l	(sp)+,a0/d0
	rts


;*======================================================================*
;
;	COPYMODEL   Copy a Model to the Instance
;
;	Given:
;		INSTANCE = Buffer large enuff for model
;
;	Returns:
;		INSTANCE initialized
;		MODEL_PTR = Ptr to aligned instance data
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		None
;
;*======================================================================*
copymodel:
	movem.l	a0-a1/d0-d2,-(sp)

	move.l	#cube,a0	; A0 = Ptr to Raw data

	move.l	#instance,model_ptr
	LONGALIGN model_ptr	; macro
	move.l	model_ptr,d0	; Model_ptr = Ptr to Aligned data

	move.l	d0,d1
	and.l	#$fffffff8,d0
	sub.l	d0,d1
	move.l	d0,A1_BASE	; Point to Phrase-aligned destination
	asr.l	#1,d1		; Convert to pixels
	move.l	d1,A1_PIXEL	; D1 = "pixel" offset from base

	move.l	(a0)+,d0	; D0 = Model length
	asr.l	#1,d0		; Convert to "pixels"
	or.l	#$10000,d0	; No outer loop
	move.l	d0,B_COUNT

	move.l	a0,d0
	move.l	d0,d2
	and.l	#$fffffff8,d0
	sub.l	d0,d2
	move.l	d0,A2_BASE	; Point to Phrase-aligned source
	asr.l	#1,d2		; Convert to pixels
	move.l	d2,A2_PIXEL	; D2 = "pixel" offset from base

	move.l	#PITCH1|PIXEL16|WID256|XADDPHR,d0
	move.l	d0,A1_FLAGS
	move.l	d0,A2_FLAGS	; Flat Phrase Blt

	move.l	#SRCEN|LFU_AN|LFU_A,d0

	cmp.l	d2,d1		;* cause extra read if srcOffset > dstOffset
	bpl.s	.aligned	;*	no extra read
	;	or.l	d1,d2
	;	beq.s	.aligned
	or.l	#SRCENX,d0	; Only do extra source read as needed (else fatal)

.aligned:
	move.l	d0,B_CMD	; Turn on the BLTTER
;
;	NOTE: No Wait for BLTTER Idle Here .. CAUTION!
;
	addq.l	#8,a0		; A0 = Ptr to Seglist Ptr
	move.l	a0,a1
	move.l	(a1)+,d0	; A1 = Ptr to Vertlist Ptr
	move.l	(a1),d1
	sub.l	a0,d0		; D0 = relative offset to Seglist
	sub.l	a1,d1		; D1 = Relative offset to Vertlist
	move.l	model_ptr,a0
	addq.l	#8,a0
	add.l	a0,d0		; D0 = Ptr to aligned Seglist
	move.l	d0,(a0)+	; Fixup Seglist Ptr
	add.l	a0,d1		; D1 = Ptr to aligned Vertlist
	move.l	d1,(a0)		; Fixup Vertlist Ptr

	movem.l	(sp)+,a0-a1/d0-d2
	rts


;*======================================================================*
;
;	DO_TURTLE   Execute the turtle package
;
;	Given:
;		d0 = Index of Turtle to Operate on
;		d1 = PITCH
;		d2 = YAW
;		d3 = ROLL
;		d4 = VELOCITY
;
;	Returns:
;		Turtle updated
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		GPURUN, GPUWAIT
;
;*======================================================================*
do_turtle:
	movem.l	a0/d0-d4,-(sp)

	mulu	#turtlsiz,d0
	add.l	#turtle,d0	; D0 = Address of Turtle Record
	move.l	d0,INPUT1

	move.l	d1,INPUT2
	move.l	d2,INPUT3
	move.l	d3,INPUT4
	move.l	d4,INPUT5	; Remaining inputs

	lea	TURTLPAK,a0	; use UPPERCASE label, nbk 22-Nov-93
	jsr	gpurun		; run the GPU program
	jsr	gpuwait

	movem.l	(sp)+,a0/d0-d4
	rts


;*======================================================================*
;
;	DO_SORT   Execute GPU Bubble Sort
;
;	Given:
;		DRAWLIST = Last Frame's Sorted See-ables (Inverted, Please)
;		SCRUBLIST = Last Frame's UNSee-ables
;		NCUBES = Number of Active Turtles
;		TURTLE = Turtle Record Array
;
;	Returns:
;		DRAWLIST = Painter's Sorted See-ables list root index
;		SCRUBLIST =  UNSee-ables list root index
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		GPURUN, GPULOAD
;
;*======================================================================*
do_sort:
	movem.l	a0/d0-d1,-(sp)

	lea	SORT,a0		; use UPPERCASE label, nbk 22-Nov-93
	jsr	gpuload		; Load Polyhedron Draw Routine into GPU RAM

	move.l	#turtle,INPUT1	; Address of Viewpt Record
	move.l	#drawlist,INPUT2	; Address of Drawlist Root
	move.l	#scrublist,INPUT3	; Address of Scrublist Root
	move.l	#turtle+turtlsiz,INPUT4	; Address of Turtle[1]

	move	ncubes,d0
	addq	#1,d0
	move	d0,d1
	mulu	d1,d0
	mulu	d1,d0
	move.l	d0,INPUT5	; Number of Active Turtles

	move.l	#turtlsiz,INPUT6	; Length of a Turtle Record
   
	lea	SORT,a0		; use UPPERCASE label, nbk 22-Nov-93
	jsr	gpurun		; run the GPU program

	movem.l	(sp)+,a0/d0-d1
	rts


;*======================================================================*
;
;	DO_FASTDRAW   Execute the Polyhedron Draw package
;
;	Given:
;		D0 = Ptr to Turtle to Draw
;
;	Returns:
;		Object Drawn
;
;	Register Usage:
;		All Registers Restored
;
;	Externals:
;		GPURUN
;
;*======================================================================*
do_fastdraw:
	movem.l	a0/d0,-(sp)

	move.l	d0,INPUT3	; Pass Ptr to Viewed Object

	move.l	model_ptr,INPUT1	; Ptr to Instance

	move.l	#turtle,INPUT2	; Turtle[0] is Viewer

	move.l	#litemodel,INPUT4	; Ptr to Lighting model

	move.l	draw_ptr,INPUT5	; tell GPU where to find parameters

	lea	FASTDRAW,a0	; get base address of GPU code
				; use UPPERCASE label, nbk 22-Nov-93
	jsr	gpurun		; run the GPU program

	movem.l	(sp)+,a0/d0
	rts

;*======================================================================*
;
;	VARIABLE RAM
;
;*======================================================================*
	.bss
	.even

disp_ptr:		; Display buffer ptr
	.ds.l	1
draw_ptr:		; Draw buffer ptr
	.ds.l	1

drawlist:		; Root (Index really) to List of See-able turtles
	.ds.w	1
scrublist:		; Root (Index really) to List of UNSee-able turtles
	.ds.w	1
newlist:
	.ds.w	1

model_ptr:		; Ptr to Instance
	.ds.l	1
instance:		; Storage for INSTANCE
	.ds.l	2048	; 8K Bytes
litemodel:		; Lighting Model
	.ds.w	12	; Enough for Ambient and 2 sources

gameover:		; Game Over Flag (0 ==> Game Active)
	.ds.w	1
rotate_flg:		; Cube rotation Flag (0 ==> Sit Still)
	.ds.w	1
sun_flg:		; Sun Lighting Flag (0 ==> No Sun)
	.ds.w	1
bulb_flg:		; InScene Lighting Flag (0 ==> No Bulb)
	.ds.w	1
amb_flg:		; Ambient Lighting Flag (0 ==> No Intensity Change)
	.ds.w	1
ncubes:			; Number of Cubes in space (Less One)
	.ds.w	1

;
;	TURTLE RECORDS
;
xrite	=	0		; IMPORTANT NOTE:
yrite	=	xrite+2		; These first record offsets are hard-wired
zrite	=	yrite+2		; into associated GPU routines.
xdown	=	zrite+2		; DO NOT Insert, Delete or Swap any of these
ydown	=	xdown+2		;	^
zdown	=	ydown+2		;	|
xhead	=	zdown+2		;	|
yhead	=	xhead+2		;	|
zhead	=	yhead+2		;	|
xposn	=	zhead+2		;	|
yposn	=	xposn+2		;	|
zposn	=	yposn+2		;	v
turtlnk =	zposn+2		; Dont change this or anything above here
turtlsiz =	turtlnk+2
maxturtl =	1000

turtle:			; All Motion Objects
	.ds.b	maxturtl*turtlsiz


;*======================================================================*
;
;	CONSTANT DATA
;
;*======================================================================*
	.data
	.even
ambient:			; Ambient Intensity
	.dc.w	$40
bulb:				; InScene Light
	.dc.w	$80FF		; Intensity
	.dc.w	$0000		; X
	.dc.w	$f000		; Y
	.dc.w	$0000		; Z
sun:				; Sun
	.dc.w	$FF		; Intensity
	.dc.w	$4000		; X
	.dc.w	$0000		; Y
	.dc.w	$0000		; Z
	.phrase
;*======================================================================*
;*                                 EOF                                  *
;*======================================================================*
