
	.include	'jaguar.inc'
	.include	'blit.inc'
	.include	'mydefs.inc'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ANALOGJOY	.equ	$F17c00
USER0		.equ	4*$40
X_NUM_POS	.equ	15
Y_NUM_POS	.equ	30

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.text
prgstart::
	move.l	#$00070007,G_END	; Run the GPU/BLIT interface in CORRECT mode ALWAYS

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy the palette into the chip

	move.l	#256,d0	   	; 256 colors
	move.l	#CLUT,a0	; moved into address CLUT
	move.l	#cry_data,a1	; from address cry_data

cloop:
	move.w	(a1)+,(a0)+
	dbra	d0,cloop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Goto main program loop, and if ever exits, bail out to an illegal instruction...

	jsr	Main

	illegal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main::
	lea	BM2_ADDR,a0	; Draw some colors into bitmap #2
	move.l	#255,d0		; which is our joystick pointer.
.loop2:
	move.b	d0,(a0)+	; This will look like a little CRY color space diagram...
	dbra	d0,.loop2	; ...coincidentally, not on purpose.

;;;;;;;;;;;;;;;;;;;;
; Draw Bounding Box

	move.w	#100,linecolor

	move.w	#8,lx1
	move.w	#308,lx2
	move.w	#25,ly1
	bsr	hline

	move.w	#8,lx1
	move.w	#25,ly1
	move.w	#210,ly2
	bsr	vline

	move.w	#8,lx1
	move.w	#308,lx2
	move.w	#210,ly1
	bsr	hline

	move.w	#308,lx1	
	move.w	#25,ly1
	move.w	#210,ly2
	bsr	vline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move around pointer on screen...

.moveloop:
	move.w	#4,ANALOGJOY		; We want to read x-pos of Analog Joystick 0
	bsr	.readdelay		; We must wait a little bit before reading results
	move.w	ANALOGJOY,d0		; Get XPOS
	andi.w	#$00ff,d0		; Mask off garbage in high byte of word
	move.w	d0,raw_joy_xpos		; Save it for examination purposes...
	mulu	#9,d0			; Scale joystick XPOS value to fill screen better
	divu	#8,d0
	add.w	#20,d0			; And offset position to center it (more or less)
	move.w	d0,pointer_xpos		; Save it so that object list routine can read it

	move.w	#5,ANALOGJOY            ; We want to read y-pos of Analog Joystick 0
	bsr	.readdelay
	move.w	ANALOGJOY,d0		; Get YPOS
	andi.w	#$00ff,d0		; Mask off garbage in high byte of word
	move.w	d0,raw_joy_ypos		; Save it for examination purposes...
	mulu	#4,d0			; Scale joystick YPOS value to fill screen better
	divu	#3,d0
	add.w	#60,d0			; And offset position to center it (more or less)
	move.w	d0,pointer_ypos		; Save it so that object list routine can read it

	bsr	printpos

	bra.s	.moveloop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We're supposed to write our analog-input request, then wait 40us before
; reading result.  With a 13mhz clock on the 68000, that's about 52000
; cycles.  Therefore, we should time for about 52000 cycles then return.

.readdelay:
	move.l	#2500,d0
.dloop:
	sub.l	#1,d0
	bne	.dloop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clear_rect:
.loop:
	bsr	hline		; Draw a horizontal line
	add.w	#1,ly1		; Move to next scanline...
	move.w	ly1,d0
	cmp	ly2,d0		; Keep going until done!
	bls	.loop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printpos:
	moveq.l	#0,d0			; Clear it.
	move.w	raw_joy_xpos,d0		; Get value to print
	cmp.w	last_xpos,d0		; If same as last time, then exit
	beq	.try_ypos

	move.w	d0,last_xpos		; Otherwise save value for next test.

	move.w	d0,d1
	divu	#100,d0			; How many in 100's position?
	andi.l	#$ff,d0			; Mask off remainder in high word
	move.b	d0,numbuf		; Save into buffer.
	mulu	#100,d0			; now subtract this from original
	sub.w	d0,d1			; value...

	move.w	d1,d0			; Keep it for later
	divu	#10,d0			; How many in 10's position
	andi.l	#$ff,d0			; Mask off remainder in high word
	move.b	d0,numbuf+1		; Save into buffer
	mulu	#10,d0			; Subtract from original value
	sub.w	d0,d1

	move.b	d1,numbuf+2		; and save 1's pos into buffer

;;;;;;;;

	move.w	#X_NUM_POS-3,lx1
	move.w	#X_NUM_POS+26,lx2
	move.w	#Y_NUM_POS,ly1
	move.w	#Y_NUM_POS+15,ly2
	move.w	#128,linecolor
	bsr	clear_rect
	move.w	#250,linecolor

;;;;;;;;

	moveq	#0,d0
	move.b	numbuf,d0	; Get letter
	cmpi.w	#9,d0
	bhi	.exit
	mulu	#4,d0		; convert to offset into data ptr table
	lea	ltrtab,a0
	add.l	d0,a0		; ok, a0 -> pointer to data for letter
	move.l	(a0),a0
	move.w	#X_NUM_POS,cx1
	move.w	#Y_NUM_POS,cy1
	bsr	drawltr		; draw it!
	
	moveq	#0,d0
	move.b	numbuf+1,d0	; Get letter
	cmpi.w	#9,d0
	bhi	.exit
	mulu	#4,d0		; convert to offset into data ptr table
	lea	ltrtab,a0
	add.l	d0,a0		; ok, a0 -> pointer to data for letter
	move.l	(a0),a0
	move.w	#X_NUM_POS+8,cx1
	bsr	drawltr		; draw it!
	
	moveq	#0,d0
	move.b	numbuf+2,d0	; Get letter
	cmpi.w	#9,d0
	bhi	.exit
	mulu	#4,d0		; convert to offset into data ptr table
	lea	ltrtab,a0
	add.l	d0,a0		; ok, a0 -> pointer to data for letter
	move.l	(a0),a0
	move.w	#X_NUM_POS+16,cx1
	bsr	drawltr		; draw it!
	

.try_ypos:
	moveq.l	#0,d0			; Clear it.
	move.w	raw_joy_ypos,d0		; Get value to print
	cmp.w	last_ypos,d0		; If same as last time, then exit
	beq	.exit

	move.w	d0,last_ypos		; Otherwise save value for next test.

	move.w	d0,d1
	divu	#100,d0			; How many in 100's position?
	andi.l	#$ff,d0			; Mask off remainder in high word
	move.b	d0,numbuf		; Save into buffer.
	mulu	#100,d0			; now subtract this from original
	sub.w	d0,d1			; value...

	move.w	d1,d0			; Keep it for later
	divu	#10,d0			; How many in 10's position
	andi.l	#$ff,d0			; Mask off remainder in high word
	move.b	d0,numbuf+1		; Save into buffer
	mulu	#10,d0			; Subtract from original value
	sub.w	d0,d1

	move.b	d1,numbuf+2		; and save 1's pos into buffer

;;;;;;;;

	move.w	#X_NUM_POS-3,lx1
	move.w	#X_NUM_POS+26,lx2
	move.w	#Y_NUM_POS+16,ly1
	move.w	#Y_NUM_POS+30,ly2
	move.w	#128,linecolor
	bsr	clear_rect
	move.w	#250,linecolor

;;;;;;;;

	moveq	#0,d0
	move.b	numbuf,d0	; Get letter
	cmpi.w	#9,d0
	bhi	.exit
	mulu	#4,d0		; convert to offset into data ptr table
	lea	ltrtab,a0
	add.l	d0,a0		; ok, a0 -> pointer to data for letter
	move.l	(a0),a0
	move.w	#X_NUM_POS,cx1
	move.w	#Y_NUM_POS+16,cy1
	bsr	drawltr		; draw it!
	
	moveq	#0,d0
	move.b	numbuf+1,d0	; Get letter
	cmpi.w	#9,d0
	bhi	.exit
	mulu	#4,d0		; convert to offset into data ptr table
	lea	ltrtab,a0
	add.l	d0,a0		; ok, a0 -> pointer to data for letter
	move.l	(a0),a0
	move.w	#X_NUM_POS+8,cx1
	bsr	drawltr		; draw it!
	
	moveq	#0,d0
	move.b	numbuf+2,d0	; Get letter
	cmpi.w	#9,d0
	bhi	.exit
	mulu	#4,d0		; convert to offset into data ptr table
	lea	ltrtab,a0
	add.l	d0,a0		; ok, a0 -> pointer to data for letter
	move.l	(a0),a0
	move.w	#X_NUM_POS+16,cx1
	bsr	drawltr		; draw it!
	
.exit:
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Draw a horizontal line into BITMAP #1 (our background)
; This is specialized to draw into an 8-bit per pixel bitmap
; Blitter would be faster...

hline:
	lea	BM1_ADDR,a0
	move.w	ly1,d0
	mulu	#BM1_WIDTH,d0

	move.w	lx1,d1
	add.w	d1,d0
	move.w	lx2,d2
	sub.l	d1,d2

	move.w	linecolor,d1
	add.l	d0,a0	; pointer to start of line
.loop:
	move.b	d1,(a0)+
	dbra	d2,.loop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Draw a vertical line into BITMAP #1 (our background)
; This is specialized to draw into an 8-bit per pixel bitmap
; Blitter would be faster...

vline:
	lea	BM1_ADDR,a0	; Get pointer to bitmap
	add.w	lx1,a0		; get pointer x-pos of line
	move.w	ly1,d0		; Get offset to starting row
	mulu	#BM1_WIDTH,d0
	adda.l	d0,a0		; Now a0 -> first pixel

	move.w	ly2,d0		; Get end line
	sub.w	ly1,d0		; sub start to get count
	move.w	linecolor,d1
.loop:
	move.b	d1,(a0)		; draw a pixel
	add.l	#BM1_WIDTH,a0	; increment to next line
	dbra	d0,.loop	; keep going until we're done
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawltr:
	move.w	(a0)+,d7	; Get number of line segments
	bra.s	.loopend	; start by decrementing DBRA loop

.segloop:
	lea	lx1,a1		; Get pointer to line segment coordinate list

	move.w	(a0)+,d0	; Get component number
	mulu	#8,d0		; Create offset into coordinate array
	lea	lcd_components,a2
	add.l	d0,a2		; and get pointer to coordinates for component.

	move.w	(a2)+,(a1)+	; Copy over component's coordinates
	move.w	(a2)+,(a1)+
	move.w	(a2)+,(a1)+
	move.w	(a2)+,(a1)+

	move.w	cx1,d0
	add.w	d0,lx1		; Offset using the character coordinates
	add.w	d0,lx2
	move.w	cy1,d0
	add.w	d0,ly1
	add.w	d0,ly2

	movem.l	d7/a0,-(sp)

	move.w	lx1,d0
	move.w	lx2,d1
	cmp.l	d0,d1
	bne	.hline		; If horizontal values are different, it's a horizontal line
	bsr	vline		; otherwise it's a vertical line.
	bra.s	.loop
.hline:
	bsr	hline
.loop:
	movem.l	(sp)+,d7/a0
.loopend:
	dbra	d7,.segloop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lcd_components:
	dc.w	0,1,0,13	; left t/b    (0,6,8)
	dc.w	0,1,0,6		; left t      (4,5)
	dc.w	0,6,0,13	; left b      (2)
	dc.w	5,1,5,13	; right t/b   (3,4,7,8,9)
	dc.w	5,1,5,6		; right t     (2)
	dc.w	5,6,5,13	; right b     (5,6)
	dc.w	3,1,3,13	; center t/b  (1)
	dc.w	0,1,5,1		; top         (0,2,3,5,6,7,8,9)
	dc.w	0,6,5,6		; middle      (2,3,4,5,6,8)
	dc.w	0,13,5,13	; bottom      (0,2,3,5,6,8)

; structure is [count],[component list...]

ltr0:	dc.w	4,0,3,9,7

ltr1:	dc.w	1,6

ltr2:	dc.w	5,7,4,8,2,9

ltr3:	dc.w	4,7,3,8,9

ltr4:	dc.w	3,1,8,3

ltr5:	dc.w	5,7,1,8,5,9

ltr6:	dc.w	5,7,0,9,5,8

ltr7:	dc.w	2,7,3

ltr8:	dc.w	5,7,8,9,0,3

ltr9:	dc.w	4,7,8,1,3

ltrtab::
	dc.l	ltr0,ltr1,ltr2,ltr3,ltr4,ltr5,ltr6,ltr7,ltr8,ltr9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; At this point, we will attempt to set up an object list
; This list will contain:
;
; Offset   Description
; ------   -----------
;   +0     branch object - goto stop object if line > n_vde
;   +8     branch object - goto stop object if line < n_vdb
;  +16     bitmap object - 256 pixels wide by 240 pixels tall.
;  +24      (bitmap obj continued)
;  +32     bitmap object - 16 pixels wide by 16 pixels tall.
;  +40      (bitmap obj continued)
;  +48     stop object
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BR1_OBJ		.equ	0
BR2_OBJ		.equ	8
BM1_OBJ		.equ	16
BM2_OBJ		.equ	32
STOP_OBJ	.equ	48

Lister::
	move.w	#0,BG			; Init background color

	move.l	#listbuf,d0		; Space alloted for Object List
	and.l	#$ffffffe0,d0		; Assure alignment
	move.l	d0,d5			; save address for later
	move.l	d0,a0			; a0 has the ACTUAL OL start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start out by creating the two BRANCH objects (keeps HW happy!)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
; BRANCH Object #1 -- Goto STOP if greater than n_vde
;;;;;;;;;;;;;;;;;;;


; LINK field

	add.l	#STOP_OBJ,d0		; address of stop object (relative to start of object list)
	lsr.l	#3,d0			; address in phrases
	move.l	d0,d2			; save for later use
	lsr.l	#8,d0
	move.l	d0,(a0)+		; Save part 1 of LINK field

; LINK field (continued)

	move.l	d2,d0
	moveq	#24,d1
	lsl.l	d1,d0			; d0 now = part 2 of LINK field

; TYPE field

	or.l	#3,d0			; make it a branch object

; YPOS field

	move.w	a_vde,d3
	ext.l	d3
	lsl.l	#3,d3
	or.l	d3,d0
	or.l	#2<<14,d0		; branch greater than
	move.l	d0,(a0)+		; One down one to go!

;;;;;;;;;;;;;;;;;;;
; BRANCH Object #2 -- Goto STOP if less than n_vdb
;;;;;;;;;;;;;;;;;;;

; LINK field

	move.l	d2,d0			; save for later use
	lsr.l	#8,d0
	move.l	d0,(a0)+

; LINK field (continued)

	move.l	d2,d0
	moveq	#24,d1
	lsl.l	d1,d0

; TYPE field

	ori.l	#3,d0			; make it a branch object

; YPOS field

	move.w	a_vdb,d3
	ext.l	d3
	lsl.l	#3,d3
	or.l	d3,d0
	or.l	#1<<14,d0		; branch less than
	move.l	d0,(a0)+		; all done

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Create bitmap object #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;
; DATA field
;;;;;;;;;;;;

	move.l	#BM1_ADDR,d0		; get data address
	moveq	#8,d1
	lsl.l	d1,d0			; shift into position
	and.l	#$fffff800,d0		; mask off junk
	move.l	d0,(a0)			; store

;;;;;;;;;;;;;
; LINK field
;;;;;;;;;;;;;

; This places the partial result in the correct spot in memory
; Then, in the next part, it 'or's the rest of the data in.
; Doing it all in registers would be faster, but I want to see the results

	move.l	d5,d0			; This points to the start of the OL
	add.l	#BM2_OBJ,d0		; Point to the next object
	move.l	d0,d2			; Save pointer for bottom half
	moveq	#11,d1
	lsr.l	d1,d0			; shift for top part
	or.l	d0,(a0)+		; or in the new data

;;;;;;;;;;;;;
; LINK field (continued... do the bottom half in the next long word)
;;;;;;;;;;;;;

	moveq	#21,d1
	lsl.l	d1,d2			; shift for bottom part
	and.l	#$ff000000,d2		; mask off junk
	move.l	d2,(a0)			; store (prematurely)

;;;;;;;;;;;;;;;
; HEIGHT field
;;;;;;;;;;;;;;;

	move.w	#BM1_HEIGHT,d0
	moveq	#14,d1
	lsl.l	d1,d0			; shift it again
	or.l	d0,(a0)			; or in the new data

;;;;;;;;;;;;;
; YPOS field
;;;;;;;;;;;;;

	move.w	a_vdb,d0
	ext.l	d0
	add.l	#BM1_YPOS,d0
	lsl.l	#3,d0
	or.l	d0,(a0)			; or in the new data

;;;;;;;;;;;;;
; TYPE field
;;;;;;;;;;;;;

	or.l	#0,(a0)+		; or in the object type

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First phrase done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unused, FIRSTPIX, RELEASE, TRANS, RMW, REFLECT, INDEX,
; and IWIDTH fields (high 6 bits)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 256 pixels/line = 32 (0x20) phrases.
; 320 pixels/line = 40 (0x28) phrases.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	move.l	#$00000002,d0		; This sets the transparent flag ONLY
	move.l	d0,(a0)+		; Set for 0x28 phrases

; That completes another long word

;;;;;;;;;;;;;;;
; IWIDTH field (continued... bottom 4 bits of value)
;;;;;;;;;;;;;;;

	moveq	#0,d0			; Make Room For Data
	ori.l	#8,d0			; 0x28 phrases has 0x0008 in low order bits
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The next block of stuff builds the next long word.
; It OR's in the data and then shifts until everything is
; in place.  Note that the moveq # lsl pattern can be
; replaced by lsl # for all cases where the shift is less
; than 9.  This is not done here for consistency.  The
; speed hit this way IS noticable.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;
; DWIDTH field (Data width in phrases)
;;;;;;;;;;;;;;;

	moveq	#10,d1			; make room for dwidth
	lsl.l	d1,d0
	ori.l	#BM1_NUMPHRASES,d0

;;;;;;;;;;;;;;
; PITCH field (offset between pixels.)
;;;;;;;;;;;;;;

	moveq	#3,d1			; make room for pitch
	lsl.l	d1,d0
	ori.l	#$1,d0			; 1 = contiguous data

;;;;;;;;;;;;;;
; DEPTH field (bits per pixel)
;;;;;;;;;;;;;;

	moveq	#3,d1			; make room for depth
	lsl.l	d1,d0
	ori.l	#$3,d0			; 3 = 8 bits per pixel

;;;;;;;;;;;;;
; XPOS field
;;;;;;;;;;;;;

	moveq	#12,d1			; make room for xpos
	lsl.l	d1,d0
	ori.l	#BM1_XPOS,d0
	move.l	d0,(a0)+

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; That completes bitmap object #1
; Create bitmap object #2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;
; DATA field
;;;;;;;;;;;;

	move.l	#BM2_ADDR,d0		; get data address
	moveq	#8,d1
	lsl.l	d1,d0			; shift into position
	and.l	#$fffff800,d0		; mask off junk
	move.l	d0,(a0)			; store

;;;;;;;;;;;;;
; LINK field
;;;;;;;;;;;;;

; This places the partial result in the correct spot in memory
; Then, in the next part, it 'or's the rest of the data in.
; Doing it all in registers would be faster, but I want to see the results

	move.l	d5,d0			; This points to the start of the OL
	add.l	#STOP_OBJ,d0		; Point to the next object
	move.l	d0,d2			; Save pointer for bottom half
	moveq	#11,d1
	lsr.l	d1,d0			; shift for top part
	or.l	d0,(a0)+		; or in the new data

;;;;;;;;;;;;;
; LINK field (continued... do the bottom half in the next long word)
;;;;;;;;;;;;;

	moveq	#21,d1
	lsl.l	d1,d2			; shift for bottom part
	and.l	#$ff000000,d2		; mask off junk
	move.l	d2,(a0)			; store (prematurely)

;;;;;;;;;;;;;;;
; HEIGHT field
;;;;;;;;;;;;;;;

	move.w	#BM2_HEIGHT,d0
	moveq	#14,d1
	lsl.l	d1,d0			; shift it again
	or.l	d0,(a0)			; or in the new data

;;;;;;;;;;;;;
; YPOS field
;;;;;;;;;;;;;

	move.w	a_vdb,d0
	ext.l	d0
	add.w	pointer_ypos,d0
	lsl.l	#3,d0
	or.l	d0,(a0)			; or in the new data

;;;;;;;;;;;;;
; TYPE field
;;;;;;;;;;;;;

	or.l	#0,(a0)+		; or in the object type

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First phrase done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unused, FIRSTPIX, RELEASE, TRANS, RMW, REFLECT, INDEX,
; and IWIDTH fields (high 6 bits)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 16 pixels/line = 2 phrases.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	move.l	#$00000000,d0		; This sets the transparent flag ONLY
	move.l	d0,(a0)+		; Set for 0x02 phrases

; That completes another long word

;;;;;;;;;;;;;;;
; IWIDTH field (continued... bottom 4 bits of value)
;;;;;;;;;;;;;;;

	moveq	#0,d0			; Make Room For Data
	ori.l	#2,d0			; 0x02 phrases has 0x0002 in low order bits
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The next block of stuff builds the next long word.
; It OR's in the data and then shifts until everything is
; in place.  Note that the moveq # lsl pattern can be
; replaced by lsl # for all cases where the shift is less
; than 9.  This is not done here for consistency.  The
; speed hit this way IS noticable.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;
; DWIDTH field (Data width in phrases)
;;;;;;;;;;;;;;;

	moveq	#10,d1			; make room for dwidth
	lsl.l	d1,d0
	ori.l	#BM2_NUMPHRASES,d0

;;;;;;;;;;;;;;
; PITCH field (offset between pixels.)
;;;;;;;;;;;;;;

	moveq	#3,d1			; make room for pitch
	lsl.l	d1,d0
	ori.l	#$1,d0			; 1 = contiguous data

;;;;;;;;;;;;;;
; DEPTH field (bits per pixel)
;;;;;;;;;;;;;;

	moveq	#3,d1			; make room for depth
	lsl.l	d1,d0
	ori.l	#$3,d0			; 3 = 8 bits per pixel

;;;;;;;;;;;;;
; XPOS field
;;;;;;;;;;;;;

	moveq	#12,d1			; make room for xpos
	lsl.l	d1,d0
	or.w	pointer_xpos,d0
	move.l	d0,(a0)+

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; That completes the bitmapped object
; Now do the stop object
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
; DATA Field
;;;;;;;;;;;;;

	move.l	#$0,d0			; This one is always 0
	move.l	d0,(a0)+		; That sure was easy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DATA field (continued), INTENABLE field, TYPE field
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	move.l	#$c,d0			; $C = $8 for INTENABLE + $4 for TYPE (STOP object)
	move.l	d0,(a0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; That was a stop object with all zeros for data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Object list should be set up now
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	swap	d5	; Now the correct value to place into OLP is in d5
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This will set up the VI (Vertical line counter Interrupt)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IntInit::
	move.l  #Frame,USER0            ; Set up the vector

	move.w  a_vde,d0
	or.w    #1,d0
	move.w  d0,VI                   ; Get the maximum VBLANK time

	move.w  INT1,d0
	or.w    #$1,d0
	move.w  d0,INT1

	move.w  sr,d0
	and.w   #$f8ff,d0               ; Lower the 68K IPL
	move.w  d0,sr

	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is our vertical blank interrupt handler, calls setup for object list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Frame:
	movem.l d0-d5/a0-a5,-(sp)
	jsr     Lister
	move.w  #$101,INT1
	move.w  #0,INT2
	movem.l (sp)+,d0-d5/a0-a5
	rte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This routine does a fast clear of the bitmap located at 'BM1_ADDR'.
;
; OK, let's just set up enough Blitter stuff to do a block draw.
; This means set A1_FLAGS to:
;
;	Contiguous data, 8 bits per pixel, Width of 256 pixels,
;	Add increment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Clear::
	move.l	#PITCH1|PIXEL8|WID320|XADDPIX,d0
	move.l	d0,A1_FLAGS

; Point A1BASE to the data

	move.l	#BM1_ADDR,d0
	move.l	d0,A1_BASE

; Set the pixel point to 0,0

	move.w	#0,d0			; y
	swap	d0
	move.w	#0,d0			; x
	move.l	d0,A1_PIXEL

; Set fractional pixel pointer

	move.w	#0,d0			; y
	swap	d0
	move.w	#0,d0			; x
	move.l	d0,A1_FPIXEL
	
; Set up the step size to -BM1_WIDTH in x, 1 in y
; The x step requires that the pixel pointer by

	move.w	#1,d0			; y
	swap	d0
	move.w	#-(BM1_WIDTH),d0		; x
	move.l	d0,A1_STEP

; Set up the fractional step size to 0 in x, 0 in y

	move.w	#0,d0		; y
	swap	d0
	move.w	#0,d0		; x
	move.l	d0,A1_FSTEP

; Set up Counters register to BM1_WIDTH in x write long to clear upper
; 256 in y, or in y as a word

	move.w	#(BM1_HEIGHT+1),d0
	swap	d0
	move.w	#BM1_WIDTH,d0	; x
	move.l	d0,B_COUNT

; Put some data in the blitter for it to write
; This is a cheat I am using all 0 so there is
; no need to word swap

	move.l	#0,B_PATD	
	move.l	#0,B_PATD+4

; Now Turn IT ON !!!!!!!!!!!!!

; NO SOURCE DATA
; NO OUTER LOOP
; Turn on pattern data
; Allow outer loop update

	move.l	#PATDSEL|UPDA1,d0
	move.l	d0,B_CMD

	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The size of the horizontal and vertical active areas
; are based on a given center position and then built
; as offsets of half the size off of these.
;
; In the horizontal direction this needs to take into
; account the variable resolution that is possible.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THESE ARE THE NTSC DEFINITIONS

ntsc_width      .equ     1409
ntsc_hmid       .equ     823
ntsc_height     .equ     241
ntsc_vmid       .equ     266

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THESE ARE THE PAL DEFINITIONS

pal_width       .equ     1381
pal_hmid        .equ     843
pal_height      .equ     287
pal_vmid        .equ     322


VideoIni::
	movem.l d0-d6,-(sp)

	move.w  CONFIG,d0		; Check if NTSC or PAL
	and.w   #$10,d0			; For now assume NTSC
	beq     ispal

	move.w  #ntsc_hmid,d2
	move.w  #ntsc_width,d0

	move.w  #ntsc_vmid,d6
	move.w  #ntsc_height,d4

	bra     doit

ispal:
	move.w  #pal_hmid,d2
	move.w  #pal_width,d0

	move.w  #pal_vmid,d6
	move.w  #pal_height,d4

doit:
	move.w  d0,width
	move.w  d4,height

	move.w  d0,d1
	asr     #1,d1                   ; Max width/2

	sub.w   d1,d2                   ; middle-width/2
	add.w   #4,d2                   ; (middle-width/2)+4
	
	sub.w   #1,d1                   ; Width/2-1
	or.w    #$400,d1                ; (Width/2-1)|$400

	move.w  d1,a_hde
	move.w  d1,HDE

	move.w  d2,a_hdb
	move.w  d2,HDB1
	move.w  d2,HDB2

	move.w  d6,d5
	sub.w   d4,d5                   ; already in half lines
	move.w  d5,a_vdb

	add.w   d4,d6
	move.w  d6,a_vde

	move.w  a_vdb,VDB
	move.w  #$FFFF,VDE

; Also lets set up some default colors

	move.w  #$f0ff,BG
	move.l  #$ffffffff,BORD1

	movem.l (sp)+,d0-d6
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.bss
	.phrase

	.ds.l	8	; Allow for alignment going backwards... not really need if using .phrase above
listbuf:
	.ds.l	32	; only need 16, but give ourselves room for expansion
	
height:
	.ds.w	1
a_vdb::
	.ds.w	1
a_vde::
	.ds.w	1
width:
	.ds.w	1
a_hdb:
	.ds.w	1
a_hde:
	.ds.w	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Raw and scaled/offset analog joystick values

raw_joy_xpos:
	.ds.w	1
raw_joy_ypos:
	.ds.w	1
pointer_xpos:
	.ds.w	1
pointer_ypos:
	.ds.w	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Coordinates for 'hline' and 'vline' routines

lx1:
	.ds.w	1
ly1:
	.ds.w	1
lx2:
	.ds.w	1
ly2:
	.ds.w	1
linecolor:
	.ds.w	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Letter printing coordinates

cx1:
	.ds.w	1
cy1:
	.ds.w	1

;;;;;;;;;;;;;;;;;;;;;;;;;
; Number printing buffer

last_xpos:
	.ds.w	1
last_ypos:
	.ds.w	1

numbuf:
	.ds.b	4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; 256 colors' worth of CRY-based Palette Data

cry_data:
	.dc.w            $00FF,$01FF,$02FF,$03FF,$04FF,$05FF,$06FF,$07FF
	.dc.w            $08FF,$09FF,$0AFF,$0BFF,$0CFF,$0DFF,$0EFF,$0FFF
	.dc.w            $10FF,$11FF,$12FF,$13FF,$14FF,$15FF,$16FF,$17FF
	.dc.w            $18FF,$19FF,$1AFF,$1BFF,$1CFF,$1DFF,$1EFF,$1FFF
	.dc.w            $20FF,$21FF,$22FF,$23FF,$24FF,$25FF,$26FF,$27FF
	.dc.w            $28FF,$29FF,$2AFF,$2BFF,$2CFF,$2DFF,$2EFF,$2FFF
	.dc.w            $30FF,$31FF,$32FF,$33FF,$34FF,$35FF,$36FF,$37FF
	.dc.w            $38FF,$39FF,$3AFF,$3BFF,$3CFF,$3DFF,$3EFF,$3FFF
	.dc.w            $40FF,$41FF,$42FF,$43FF,$44FF,$45FF,$46FF,$47FF
	.dc.w            $48FF,$49FF,$4AFF,$4BFF,$4CFF,$4DFF,$4EFF,$4FFF
	.dc.w            $50FF,$51FF,$52FF,$53FF,$54FF,$55FF,$56FF,$57FF
	.dc.w            $58FF,$59FF,$5AFF,$5BFF,$5CFF,$5DFF,$5EFF,$5FFF
	.dc.w            $60FF,$61FF,$62FF,$63FF,$64FF,$65FF,$66FF,$67FF
	.dc.w            $68FF,$69FF,$6AFF,$6BFF,$6CFF,$6DFF,$6EFF,$6FFF
	.dc.w            $70FF,$71FF,$72FF,$73FF,$74FF,$75FF,$76FF,$77FF
	.dc.w            $78FF,$79FF,$7AFF,$7BFF,$7CFF,$7DFF,$7EFF,$7FFF
	.dc.w            $80FF,$81FF,$82FF,$83FF,$84FF,$85FF,$86FF,$87FF
	.dc.w            $88FF,$89FF,$8AFF,$8BFF,$8CFF,$8DFF,$8EFF,$8FFF
	.dc.w            $90FF,$91FF,$92FF,$93FF,$94FF,$95FF,$96FF,$97FF
	.dc.w            $98FF,$99FF,$9AFF,$9BFF,$9CFF,$9DFF,$9EFF,$9FFF
	.dc.w            $A0FF,$A1FF,$A2FF,$A3FF,$A4FF,$A5FF,$A6FF,$A7FF
	.dc.w            $A8FF,$A9FF,$AAFF,$ABFF,$ACFF,$ADFF,$AEFF,$AFFF
	.dc.w            $B0FF,$B1FF,$B2FF,$B3FF,$B4FF,$B5FF,$B6FF,$B7FF
	.dc.w            $B8FF,$B9FF,$BAFF,$BBFF,$BCFF,$BDFF,$BEFF,$BFFF
	.dc.w            $C0FF,$C1FF,$C2FF,$C3FF,$C4FF,$C5FF,$C6FF,$C7FF
	.dc.w            $C8FF,$C9FF,$CAFF,$CBFF,$CCFF,$CDFF,$CEFF,$CFFF
	.dc.w            $D0FF,$D1FF,$D2FF,$D3FF,$D4FF,$D5FF,$D6FF,$D7FF
	.dc.w            $D8FF,$D9FF,$DAFF,$DBFF,$DCFF,$DDFF,$DEFF,$DFFF
	.dc.w            $E0FF,$E1FF,$E2FF,$E3FF,$E4FF,$E5FF,$E6FF,$E7FF
	.dc.w            $E8FF,$E9FF,$EAFF,$EBFF,$ECFF,$EDFF,$EEFF,$EFFF
	.dc.w            $F0FF,$F1FF,$F2FF,$F3FF,$F4FF,$F5FF,$F6FF,$F7FF
	.dc.w            $F8FF,$F9FF,$FAFF,$FBFF,$FCFF,$FDFF,$FEFF,$0000
