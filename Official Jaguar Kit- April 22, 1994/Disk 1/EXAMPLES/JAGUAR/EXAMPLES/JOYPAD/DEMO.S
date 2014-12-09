;================================================================================================
;
;  DEMO.S
;
;================================================================================================
;
;  This is an example program which demonstrates how to read controller
;  information.  It sets up the system for display and executes the main loop
;  which evaluates any controller input, then rebuilds the object list, then
;   via interrupts displays any output to the screen.
;
;  This example code demonstrates how to interrogate the input matrix (for 2
;  players) and how to process the results.  Specifically, a cursor is moved
;  around the screen by using the joypad and if any buttons are pressed it is
;  reflected on the screen.
;
;  IMPORTANT MODIFICATION:
;
;  8/3/93 JS - The masks which are stored in JOYSTICK and then retrieved via
;  JOYSTICK now ensure that bit #8 is high which is imperitive for audio to be
;  audible.  Your initialization routine should store $100 into JOYSTICK in
;  case your "readpad" function is not called right away (I can see it now,
;  "HEY, why isn't my title screen music playing???").
;
;================================================================================================

	.include	"jaguar.inc"
	.include	"objlist.inc"
	.include	"joypad.inc"

;*********** VIDEO ***********************************************

vclk		equ	376

horiz_per	equ	317778
sync_per	equ	46050
eq_per		equ	23500
front_porch	equ	17450
line_blank	equ	109500
disp_width	equ	1155					;(pixel width + 1) * 3
disp_height	equ	226					;this is in lines

; Horizontal computations

n_hp		equ	horiz_per/vclk
n_hbb		equ	((horiz_per-sync_per-front_porch)/vclk)+$400
n_hbe		equ	(line_blank-sync_per-front_porch)/vclk
n_hs		equ	((horiz_per-sync_per)/vclk)+$400
n_hvs		equ	(horiz_per-(2*sync_per))/vclk
n_heq		equ	(horiz_per-eq_per)/vclk
n_hde		equ	((disp_width/2)-1)+$400
n_hdb1		equ	((n_hp)-(disp_width/2))
n_hdb2		equ	n_hdb1

n_vp		equ	523
n_vee		equ	6
n_vbe		equ	40
n_vdb		equ	n_vbe+4
n_vde		equ	n_vdb+(disp_height*2)
n_vbb		equ	n_vde+40
n_vs		equ	n_vp-10
n_veb		equ	n_vs-n_vee

SCRN_TOP	equ	n_vdb				;ypos of first line at top of screen
SCRN_BOTTOM	equ	n_vde				;xpos of first line below screen

;*******************************************************************
;
;  LONG LIVE HOMER SIMPSON!!!!
;
;*******************************************************************

NUM_OF_PLAYERS	equ	1


CURSOR_X	equ	40	    ; position of objects on the screen
CURSOR_Y	equ	130
FIRE_X		equ	40
FIRE_Y		equ	90
KEY_X		equ	56
KEY_Y		equ	90

;================================================================================================

	.extern	cry_table

TOTAL_OBJS	equ	6

;================================================================================================

start:
	move.l	#$00070007,G_END	; don't need to swap for GPU
	move.w	#$35cc,MEMCON2		; Do the old endian thing
	move.w	#$8000,CHRO_CLK

	lea	mypal,a0
	jsr	set_palette		;load in the palette

	jsr	VideoIni
	jsr	IntInit

;***************************************************************
; Just do once to ensure audio is audible
	move.w	#$100, JOYSTICK		; turns off audio mute
;***************************************************************

	move.w	#TOTAL_OBJS,d6
	lea	obj_data,a1
	jsr	build			; initialize the object lists
	jsr	copy_olist
	move.l	#olist,d0		; get address of start of object list
	swap	d0
	move.l	d0,OLP

	move.w	#$4C1,VMODE		; Turn on the display

loop:

	jsr	readpad			; read in the controller status
	jsr	handle_input		; respond to controller input

	move.w	#TOTAL_OBJS,d6		; number of Object Headers
	lea	obj_data,a1		; beginning of object list
	jsr	build			; rebuild the object list
	jsr	wait_int

	bra	loop


;================================================================================================
handle_input::
;--------------------------------------------------------------
;  Evaluate each direction of the joypad button and execute
;  code independent to each direction.
;--------------------------------------------------------------
	lea	cursor1, a1
	move.l	joyedge,d0
ck_up:
	btst.l	#JOY_UP,d0
	beq.b	ck_down
	sub.w	#16, O_YPOS(a1)		; move cursor UP 1 pixel
	bra.b	ck_left
ck_down:
	btst.l	#JOY_DOWN,d0
	beq.b	ck_left
	add.w	#16, O_YPOS(a1)		; move cursor DOWN 1 pixel
;	bra	ck_left
ck_left:
	btst.l	#JOY_LEFT,d0
	beq.b	ck_right
	sub.w	#9, O_XPOS(a1)		; move cursor LEFT 1 pixel
	bra	ck_firebuts
ck_right:
	btst.l	#JOY_RIGHT,d0
	beq.b	ck_joy_2player
	add.w	#9, O_XPOS(a1)		; move cursor RIGHT 1 pixel

ck_joy_2player::
	lea	cursor2, a0
	cmpa.l	a0, a1
	beq.b	ck_firebuts
	lea	cursor2, a1
	move.l	joyedge+4, d0		; necessary to perform following modulo 32 BTST
	bra	ck_up

;------------------------------------------------------------------------------------------------
ck_firebuts::
;--------------------------------------------------------------
;  Evaluate each fire button status and execute code
;  independent to each fire button.
;--------------------------------------------------------------
	lea	fire1, a1
	move.l	joycur, d0
ck_fireA:
	btst.l	#FIRE_A,d0
	beq.b	ck_fireB
	move.l	#numA, O_DATA(a1)	; display the letter 'A'
ck_fireB:
	btst.l	#FIRE_B,d0
	beq.b	ck_fireC
	move.l	#numB, O_DATA(a1)	; display the letter 'B'
ck_fireC:
	btst.l	#FIRE_C,d0
	beq.b	ck_Option
	move.l	#numC, O_DATA(a1)	; display the letter 'C'
ck_Option:
	btst.l	#OPTION,d0
	beq.b	ck_Pause
	move.l	#Option, O_DATA(a1)	; display the letter 'O'
ck_Pause:
	btst.l	#PAUSE,d0
	beq.b	fire_done
	move.l	#Pause, O_DATA(a1)	; display the letter 'P'
fire_done:
	and.l	#ANY_FIRE,d0
	bne	ck_fire_2player

;------------------------------
; No firebuttons were pressed
	move.l	#dash,O_DATA(a1)	; display a '-'

ck_fire_2player::
	lea	fire2, a0
	cmpa.l	a0, a1
	beq.b	ck_keypad
	lea	fire2, a1
	move.l	joycur+4,d0		; necessary to perform following modulo 32 BTST
	bra	ck_fireA

;------------------------------------------------------------------------------------------------
ck_keypad:
;--------------------------------------------------------------
;  Evaluate each 12-key button from the keypad and execute
;  code independent to each button.
;--------------------------------------------------------------
	lea	keys1, a1
	move.l	joycur, d0		; necessary to perform following modulo 32 BTST
ck_key1:
	btst.l	#KEY_1, d0
	beq.b	ck_key2
	move.l	#num1, O_DATA(a1)	; display the number '1'
ck_key2:
	btst.l	#KEY_2, d0
	beq.b	ck_key3
	move.l	#num2, O_DATA(a1)	; display the number '2'
ck_key3:
	btst.l	#KEY_3, d0
	beq.b	ck_key4
	move.l	#num3, O_DATA(a1)	; display the number '3'
ck_key4:
	btst.l	#KEY_4, d0
	beq.b	ck_key5
	move.l	#num4, O_DATA(a1)	; display the number '4'
ck_key5:
	btst.l	#KEY_5, d0
	beq.b	ck_key6
	move.l	#num5, O_DATA(a1)	; display the number '5'
ck_key6:
	btst.l	#KEY_6, d0
	beq.b	ck_key7
	move.l	#num6, O_DATA(a1)	; display the number '6'
ck_key7:
	btst.l	#KEY_7, d0
	beq.b	ck_key8
	move.l	#num7, O_DATA(a1)	; display the number '7'
ck_key8:
	btst.l	#KEY_8, d0
	beq.b	ck_key9
	move.l	#num8, O_DATA(a1)	; display the number '8'
ck_key9:
	btst.l	#KEY_9, d0
	beq.b	ck_keyS
	move.l	#num9, O_DATA(a1)	; display the number '9'
ck_keyS:
	btst.l	#KEY_STAR, d0
	beq.b	ck_key0
	move.l	#numS, O_DATA(a1)	; display a '*'
ck_key0:
	btst.l	#KEY_0, d0
	beq.b	ck_keyH
	move.l	#num0, O_DATA(a1)	; display the number '0'
ck_keyH:
	btst.l	#KEY_HASH, d0
	beq.b	keypad_done
	move.l	#numH, O_DATA(a1)	; display a '#'
keypad_done:
	and.l	#ANY_KEY,d0
	bne	ck_key_2player
;----------------------------------------
; No buttons on the keypad were pressed
	move.l	#dash, O_DATA(a1)	; display a '-'

ck_key_2player::
	lea	keys2, a0
	cmpa.l	a0, a1
	beq.b	hi_end
	lea	keys2, a1
	move.l	joycur+4, d0		; necessary to perform following modulo 32 BTST
	bra	ck_key1

hi_end:					; handle input end
	rts

;================================================================================================
readpad::
;scan for player 1
	move.l	#$f0fffffc,d1		; d1 = Joypad data mask
	moveq.l	#-1,d2			; d2 = Cumulative joypad reading

	move.w	#$81fe,JOYSTICK
	move.l	JOYSTICK,d0		; Read joypad, pause button, A button
	or.l	d1,d0			; Mask off unused bits
	ror.l	#4,d0
	and.l	d0,d2			; d2 = xxAPxxxx RLDUxxxx xxxxxxxx xxxxxxxx
	move.w	#$81fd,JOYSTICK
	move.l	JOYSTICK,d0		; Read *741 keys, B button
	or.l	d1,d0			; Mask off unused bits
	ror.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxxxxxxx xxxxxxxx
	move.w	#$81fb,JOYSTICK
	move.l	JOYSTICK,d0		; Read 2580 keys, C button
	or.l	d1,d0			; Mask off unused bits
	rol.l	#6,d0
	rol.l	#6,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxxx 2580xxxx
	move.w	#$81f7,JOYSTICK
	move.l	JOYSTICK,d0		; Read 369# keys, Option button
	or.l	d1,d0			; Mask off unused bits
	rol.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== inputs active low

	moveq.l	#-1,d1
	eor.l	d2,d1			; d1 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== now inputs active high

	move.l	joycur,d0		; old joycur needed for determining the new joyedge
	move.l	d1,joycur		; Current joypad reading stored into joycur
	eor.l	d1,d0
	and.l	d1,d0
	move.l	d0,joyedge		;joypad, buttons, keys that were just pressed

;scan for player 2
	move.l	#$0ffffff3,d1		; d1 = Joypad data mask
	moveq.l	#-1,d2			; d2 = Cumulative joypad reading

	move.w	#$817f,JOYSTICK
	move.l	JOYSTICK,d0		; Read joypad, pause button, A button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	ror.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxxx RLDUxxxx xxxxxxxx xxxxxxxx
	move.w	#$81bf,JOYSTICK
	move.l	JOYSTICK,d0		; Read *741 keys, B button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	ror.l	#8,d0
	ror.l	#4,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxxxxxxx xxxxxxxx
	move.w	#$81df,JOYSTICK
	move.l	JOYSTICK,d0		; Read 2580 keys, C button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	rol.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxxx 2580xxxx
	move.w	#$81ef,JOYSTICK
	move.l	JOYSTICK,d0		; Read 369# keys, Option button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	rol.l	#4,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== inputs active low

	moveq.l	#-1,d1
	eor.l	d2,d1			; d1 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== now inputs active high

	move.l	joycur+4,d0		; old joycur needed for determining the new joyedge
	move.l	d1,joycur+4		; Current joypad reading stored into joycur
	eor.l	d1,d0
	and.l	d1,d0
	move.l	d0,joyedge+4		;joypad, buttons, keys that were just pressed

	rts


joyedge::		dc.l		0,0
joycur::		dc.l		0,0

;================================================================================================

build::						;pack the object data into olist_ram
;A1 = need address of first object
;D6 = total number of objects to be processed

;register use
;A0 is the address of the object list used by the object processor
;A2 is the address of the object list being built
;D0 holds the long being built
;D1 is used for temporary calculations
;D2 is the lines off screen, calculated in set_odata, used by set_oheight
;D3 is #12 for shifting d0
;D4 is #10 for shifting d0
;D5 is #11 for shifting d0
;D6 counts the objects being processed
;D7 is the address of the boject used by the object processor divided by 8

	moveq	#12,d3			;for doing lsl.l on d0
	moveq	#10,d4			;for doing lsl.l on d0
	moveq	#11,d5			;for doing lsl.l on d0
	move.l	#olist,d7		;address of packed olist
	lsr.l	#3,d7			;divide by 8 for object processor
	lea	olist_ram,a2		;address of copy of packed olist
	sub.w	#1,d6			;start dbra counter at total objects - 1
proc_obj:				;process an object
	tst.b	O_TYPE(a1)		;check the delete flag for this object
	bmi	next_obj		;skip this object if negative bit is set

;PHRASE 1
set_odata:
;if the object is above top line of the screen,
;the data pointer is set to the first line of the object that is on screen
	move.l	O_DATA(a1),d0		;get normal data address
	move.w	#SCRN_TOP-1,d2
	sub.w	O_YPOS(a1),d2		;top of screen - ypos = half lines off top of screen
	bpl.b	.05			;if object is above top of screen, use normal data address
	clr.w	d2			;0 lines off screen, use normal data address
	bra.b	.10
.05:	lsr.w	#1,d2			;convert half lines to lines
	move.w	O_DWIDTH(a1),d1	        ;get phrases per line of data in the object
	lsl.w	#3,d1			;multiply phrases * 8 bytes per phrase
	mulu.w	d2,d1			;lines off screen * bytes per line in the object
	add.l	d1,d0			;skip the total bytes that are off the top of the screen
.10:	lsr.l	#3,d0			;divide by 8
	lsl.l	d5,d0			;shift left 11 bits to make room for link pointer

;set the link pointer to the next object
	add.l	#4,d7			;next object is 4 phrases ahead
	move.l	d7,d1			;get address in olist of next object
	
	lsr.l	#8,d1			;the rightmost 8 bits go in the next long, so remove them
	or.l	d1,d0			;or with data pointer
	move.l	d0,(a2)+		;save first long in phrase 1, advance the pointer to next long

	move.b	d7,d0			;get the low 8 bits of the link pointer that was saved earlier
	lsl.l	d4,d0			;shift left 10 bits to make room for height

set_oheight:
;d2.w is set to the number of lines that are above the top of the screen
;if part of the object is above the top line of the screen,
;the height is reduced by the number of lines off the top of the screen
	move.w	O_HEIGHT(a1),d1	;get the height of the object
	cmpi.b	#1,O_TYPE(a1)		;see if this is a scaled bit map object
	bne.b	.10			;branch if object is not scaled
	sub.w	#1,d1			;an extra line is displayed at the bottom of the object if this is not here
.10:	sub.w	d2,d1			;subtract lines off screen from scaled height
	bmi.b	.20			;if lines off screen > height, make height 0 instead of negative
	or.w	d1,d0	        	;or with link pointer in second half of phrase 1
.20:	lsl.l	d5,d0			;shift left 11 bits to make room for ypos

set_oypos:
;if ypos is negative, it gets set to 0
;set_odata and set_oheight will adjust the data pointer and height accordingly
	move.w	O_YPOS(a1),d1
	bmi.b	.10			;if ypos is negative, object would not be displayed, so set ypos to 0
	and.w	#$7ff,d1		;only write 11 bits for ypos
	or.w	d1,d0			;or with link pointer and height
.10:	lsl.l	#3,d0			;shift left 3 bits to make room for type

set_otype: 
	or.b	O_TYPE(a1),d0		;object type
	move.l	d0,(a2)+		;write second half of phrase 1

;PHRASE 2
set_ofirstpix:
	move.b	O_FIRSTPIX(a1),d0
	lsl.l	#4,d0			;shift left 4 bits to make room for release, transparent, rmw, reflect bits

set_flags:
	or.b	O_FLAGS(a1),d0		;or with firstpix
	lsl.l	#7,d0			;shift left 7 bits to make room for index

set_oindex:
	or.b	O_INDEX(a1),d0		;or with firstpix and flags
	lsl.l	#6,d0			;shift left 6 bits to make room for part of iwidth

set_oiwidth:
	move.w	O_IWIDTH(a1),d1			
	lsr.w	#4,d1			;right 4 bits go in the next long, so remove them
	or.b	d1,d0
	move.l	d0,(a2)+		;write first long of phrase 2

	move.w	O_IWIDTH(a1),d0			
	and.w	#$F,d0			;get low 4 bits of iwidth
	lsl.l	d4,d0			;shift left 10 bits to make room for dwidth

set_odwidth:
	or.w	O_DWIDTH(a1),d0 	;or with part of iwidth
	lsl.l	#3,d0			;shift left 3 bits to make room for pitch

set_opitch:
	or.b	O_PITCH(a1),d0		;or with dwidth and iwidth
	lsl.l	#3,d0			;shift left 3 bits to make room for depth

set_odepth:
	or.b	O_DEPTH(a1),d0		;or with dwidth, iwidth, pitch
	lsl.l	d3,d0			;shift left 12 bits to make room for xpos

set_oxpos:
	move.w	O_XPOS(a1),d1		;object xpos
	and.w	#$fff,d1		;only write 12 bits for xpos
	or.w	d1,d0   		;or with the rest of the stuff
	move.l	d0,(a2)+		;write second half of phrase 2

;PHRASE 3
;for scaled bit map object only
	move.l	O_SCALE(a1),4(a2)	;write remainder, vscale, hscale bytes in 2nd long of phrase 3
	adda.l	#16,a2			;move pointer past the last 2 phrases for current object

next_obj:				;jump to here if delete flag is on
	adda.l	#OBJSIZE,a1		;point to next object in pseudo object list
	dbra	d6,proc_obj		;repeat until all objects have been processed
	
;write a stop object at the end of the list
	move.l	#0,(a2)+		
	move.l	#4,(a2)			;write object type 4 (stop object)
 	rts	

copy_olist::
	lea	olist_ram,a0		;beginning of olist_ram
	lea	olist,a1		;beginning of olist
.10:	move.l	(a0),(a1)+		;copy olist_ram to olist
	cmpi.l	#4,(a0)+		;see if we are at the stop object
	bne.b	.10
	rts


VideoIni::
    	move.w	#n_hp,HP
	move.w	#n_hbb,HBB
	move.w	#n_hbe,HBE
	move.w	#n_hs,HS
	move.w	#n_hvs,HVS
	move.w	#n_heq,HEQ
	move.w	#n_hde,HDE
	move.w	#n_hdb1,HDB1
	move.w	#n_hdb2,HDB2

	move.w	#n_vp,VP
	move.w	#n_vee,VEE
	move.w	#n_vbe,VBE
	move.w	#n_vdb,VDB
	move.w	#n_vde,VDE
	move.w	#n_vbb,VBB
	move.w	#n_veb,VEB
	move.w	#n_vs,VS
	move.w	#$0000,BG       	;default background color (16 bit RGB or CRY color)
	move.l	#$00000000,BORD1	;default border color (green,red,unused,blue)
	rts

set_palette::
;A0 must be the address of the palette data
;palette data is 256 words of colors
	lea	CLUT,a1	    	    ;get address of color lookup table
	move.w	#255,d0			;number of colors to set
.10:	move.w	(a0)+,(a1)+		;put color value into color lookup table
	dbra	d0,.10			;continue through palette table
	rts

wait_int::
	move.b	framecnt,d0
.10:	cmp.b	intcount,d0
	bgt.b	.10
	clr.b	intcount
	rts


intcount::	dc.b	0
framecnt::	dc.b	1			;60 frames per second

LEVEL2	equ	4*$40


IntInit::
	move.l	#Frame,LEVEL2
	move.w	#n_vde+1,VI
	move.w	#1,INT1
	move.w	sr,d0
	and.w	#$f8ff,d0
	move.w	d0,sr
	rts
Frame:
	movem.l	d0-d6/a0-a6,-(sp)
	jsr	copy_olist
	add.b	#1,intcount
	move.w	#$101,INT1
	move.w	#0,INT2
	movem.l	(sp)+,d0-d6/a0-a6
	rte

	.phrase
mypal:
	dc.w	$0000,$01FF,$02FF,$03FF,$04FF,$05FF,$06FF,$07FF,$08FF,$09FF,$0AFF,$0BFF,$0CFF,$0DFF,$0EFF,$0FFF
	dc.w	$10FF,$11FF,$12FF,$13FF,$14FF,$15FF,$16FF,$17FF,$18FF,$19FF,$1AFF,$1BFF,$1CFF,$1DFF,$1EFF,$1FFF
	dc.w	$20FF,$21FF,$22FF,$23FF,$24FF,$25FF,$26FF,$27FF,$28FF,$29FF,$2AFF,$2BFF,$2CFF,$2DFF,$2EFF,$2FFF
	dc.w	$30FF,$31FF,$32FF,$33FF,$34FF,$35FF,$36FF,$37FF,$38FF,$39FF,$3AFF,$3BFF,$3CFF,$3DFF,$3EFF,$3FFF
	dc.w	$40FF,$41FF,$42FF,$43FF,$44FF,$45FF,$46FF,$47FF,$48FF,$49FF,$4AFF,$4BFF,$4CFF,$4DFF,$4EFF,$4FFF
	dc.w	$50FF,$51FF,$52FF,$53FF,$54FF,$55FF,$56FF,$57FF,$58FF,$59FF,$5AFF,$5BFF,$5CFF,$5DFF,$5EFF,$5FFF
	dc.w	$60FF,$61FF,$62FF,$63FF,$64FF,$65FF,$66FF,$67FF,$68FF,$69FF,$6AFF,$6BFF,$6CFF,$6DFF,$6EFF,$6FFF
	dc.w	$70FF,$71FF,$72FF,$73FF,$74FF,$75FF,$76FF,$77FF,$78FF,$79FF,$7AFF,$7BFF,$7CFF,$7DFF,$7EFF,$7FFF
	dc.w	$80FF,$81FF,$82FF,$83FF,$84FF,$85FF,$86FF,$87FF,$88FF,$89FF,$8AFF,$8BFF,$8CFF,$8DFF,$8EFF,$8FFF
	dc.w	$90FF,$91FF,$92FF,$93FF,$94FF,$95FF,$96FF,$97FF,$98FF,$99FF,$9AFF,$9BFF,$9CFF,$9DFF,$9EFF,$9FFF
	dc.w	$A0FF,$A1FF,$A2FF,$A3FF,$A4FF,$A5FF,$A6FF,$A7FF,$A8FF,$A9FF,$AAFF,$ABFF,$ACFF,$ADFF,$AEFF,$AFFF
	dc.w	$B0FF,$B1FF,$B2FF,$B3FF,$B4FF,$B5FF,$B6FF,$B7FF,$B8FF,$B9FF,$BAFF,$BBFF,$BCFF,$BDFF,$BEFF,$BFFF
	dc.w	$C0FF,$C1FF,$C2FF,$C3FF,$C4FF,$C5FF,$C6FF,$C7FF,$C8FF,$C9FF,$CAFF,$CBFF,$CCFF,$CDFF,$CEFF,$CFFF
	dc.w	$D0FF,$D1FF,$D2FF,$D3FF,$D4FF,$D5FF,$D6FF,$D7FF,$D8FF,$D9FF,$DAFF,$DBFF,$DCFF,$DDFF,$DEFF,$DFFF
	dc.w	$E0FF,$E1FF,$E2FF,$E3FF,$E4FF,$E5FF,$E6FF,$E7FF,$E8FF,$E9FF,$EAFF,$EBFF,$ECFF,$EDFF,$EEFF,$EFFF
	dc.w	$F0FF,$F1FF,$F2FF,$F3FF,$F4FF,$F5FF,$F6FF,$F7FF,$F8FF,$F9FF,$FAFF,$FBFF,$FCFF,$FDFF,$FEFF,$FFFF


	.bss
	.phrase
olist::
	ds.l	((8*TOTAL_OBJS)+2)		;object list used by object processor
						;need 8 longs for each object
						;and 2 longs for a stop object
olist_ram::
	ds.l	((8*TOTAL_OBJS)+2)		;packed version of objects in obj_data
						;need 8 longs for each object
						;and 2 longs for a stop object


	.data
	.phrase
;================================================================================================
;  Cursor and Font graphic data
cursor_data:
	dc.b	$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78
	dc.b	$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78,$78

	.phrase
num0:
	dc.b	$00,$00,$78,$78,$78,$00,$00,$00
	dc.b	$00,$78,$00,$00,$00,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$00,$00,$00,$78,$00,$00
	dc.b	$00,$00,$78,$78,$78,$00,$00,$00

	.phrase
num1:
	dc.b	$00,$00,$00,$78,$00,$00,$00,$00
	dc.b	$00,$00,$78,$78,$00,$00,$00,$00
	dc.b	$00,$00,$00,$78,$00,$00,$00,$00
	dc.b	$00,$00,$00,$78,$00,$00,$00,$00
	dc.b	$00,$00,$00,$78,$00,$00,$00,$00
	dc.b	$00,$00,$00,$78,$00,$00,$00,$00
	dc.b	$00,$00,$78,$78,$78,$00,$00,$00

	.phrase
num2:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$78,$78,$78,$78,$00,$00
	dc.b	$00,$78,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00

	.phrase
num3:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$78,$78,$78,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00

	.phrase
num4:
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00

	.phrase
num5:
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00

	.phrase
num6:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00

	.phrase
num7:
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$78,$00,$00
	dc.b	$00,$00,$00,$00,$78,$00,$00,$00
	dc.b	$00,$00,$00,$78,$00,$00,$00,$00
	dc.b	$00,$00,$78,$00,$00,$00,$00,$00
	dc.b	$00,$78,$00,$00,$00,$00,$00,$00

	.phrase
num8:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00

	.phrase
num9:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$78,$78,$78,$78,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$00,$78,$78,$78,$78,$00,$00

	.phrase
numA:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00

	.phrase
numB:
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00

	.phrase
numC:
	dc.b	$00,$78,$78,$78,$78,$78,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$78,$78,$78,$78,$78,$78,$00

	.phrase
Option:
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$00,$78,$78,$78,$78,$78,$00,$00

	.phrase
Pause:
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$00,$00,$00,$00,$00,$78,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$00,$00,$00,$00,$00,$00,$00

	.phrase
numS:
	dc.b	$78,$00,$00,$78,$00,$00,$78,$00
	dc.b	$00,$78,$00,$78,$00,$78,$00,$00
	dc.b	$00,$00,$78,$78,$78,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00
	dc.b	$00,$00,$78,$78,$78,$00,$00,$00
	dc.b	$00,$78,$00,$78,$00,$78,$00,$00
	dc.b	$78,$00,$00,$78,$00,$00,$78,$00

	.phrase
numH:
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$78,$00,$00,$78,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$00,$78,$00,$00,$78,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$00,$00
	dc.b	$00,$78,$00,$00,$78,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00

	.phrase
dash:
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$78,$78,$78,$78,$78,$78,$78,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00

;================================================================================================
;  Object List Headers

	.phrase
obj_data:
cursor1::
	dc.w	CURSOR_X		; o_xpos	
	dc.w	CURSOR_Y		; o_ypos
	dc.l	cursor_data             ; o_data
	dc.w	10			; o_height
	dc.w	2			; o_dwidth
	dc.w	2			; o_iwidth
	dc.b	0			; o_flags
	dc.b	0			; o_firstpix
	dc.b	0			; o_type
	dc.b	3			; o_depth
	dc.b	1			; o_pitch
	dc.b	0			; o_index
	dc.w	0			; o_desc
	dc.l	$00202020		; scaling info
	dc.l	0			; o_rom
	dc.l	0			; o_mode
;---------------------------------------------------------------------
fire1::
	dc.w	FIRE_X		        ; o_xpos	
	dc.w	FIRE_Y		        ; o_ypos
	dc.l	dash			; o_data
	dc.w	7			; o_height
	dc.w	1			; o_dwidth
	dc.w	1			; o_iwidth
	dc.b	0			; o_flags
	dc.b	0			; o_firstpix
	dc.b	0			; o_type
	dc.b	3			; o_depth
	dc.b	1			; o_pitch
	dc.b	0			; o_index
	dc.w	0			; o_desc
	dc.l	$00202020		; scaling info
	dc.l	0			; o_rom
	dc.l	0			; o_mode
;---------------------------------------------------------------------
keys1::
	dc.w	KEY_X		        ; o_xpos	
	dc.w	KEY_Y		        ; o_ypos
	dc.l	dash			; o_data
	dc.w	7			; o_height
	dc.w	1			; o_dwidth
	dc.w	1			; o_iwidth
	dc.b	0			; o_flags
	dc.b	0			; o_firstpix
	dc.b	0			; o_type
	dc.b	3			; o_depth
	dc.b	1			; o_pitch
	dc.b	0			; o_index
	dc.w	0			; o_desc
	dc.l	$00202020		; scaling info
	dc.l	0			; o_rom
	dc.l	0			; o_mode
;---------------------------------------------------------------------
cursor2::
	dc.w	CURSOR_X+100	        ; o_xpos	
	dc.w	CURSOR_Y		; o_ypos
	dc.l	cursor_data	        ; o_data
	dc.w	10			; o_height
	dc.w	2			; o_dwidth
	dc.w	2			; o_iwidth
	dc.b	0			; o_flags
	dc.b	0			; o_firstpix
	dc.b	0			; o_type
	dc.b	3			; o_depth
	dc.b	1			; o_pitch
	dc.b	0			; o_index
	dc.w	0			; o_desc
	dc.l	$00202020		; scaling info
	dc.l	0			; o_rom
	dc.l	0			; o_mode
;---------------------------------------------------------------------
fire2::
	dc.w	FIRE_X+100	        ; o_xpos	
	dc.w	FIRE_Y		        ; o_ypos
	dc.l	dash			; o_data
	dc.w	7			; o_height
	dc.w	1			; o_dwidth
	dc.w	1			; o_iwidth
	dc.b	0			; o_flags
	dc.b	0			; o_firstpix
	dc.b	0			; o_type
	dc.b	3			; o_depth
	dc.b	1			; o_pitch
	dc.b	0			; o_index
	dc.w	0			; o_desc
	dc.l	$00202020		; scaling info
	dc.l	0			; o_rom
	dc.l	0			; o_mode
;---------------------------------------------------------------------
keys2::
	dc.w	KEY_X+100		; o_xpos	
	dc.w	KEY_Y		        ; o_ypos
	dc.l	dash			; o_data
	dc.w	7			; o_height
	dc.w	1			; o_dwidth
	dc.w	1			; o_iwidth
	dc.b	0			; o_flags
	dc.b	0			; o_firstpix
	dc.b	0			; o_type
	dc.b	3			; o_depth
	dc.b	1			; o_pitch
	dc.b	0			; o_index
	dc.w	0			; o_desc
	dc.l	$00202020		; scaling info
	dc.l	0			; o_rom
	dc.l	0			; o_mode
;---------------------------------------------------------------------
	.phrase
	.end

