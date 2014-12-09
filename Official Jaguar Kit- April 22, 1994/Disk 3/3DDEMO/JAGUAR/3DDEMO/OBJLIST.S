;*======================================================================*
;*                TITLE:                  OBJLIST.S                     *
;*                Function:               Object List Driver            *
;*                                                                      *
;*                Project #:              JAGUAR                        *
;*                Programmer:             Eric Ginner                   *
;*                                        Andrew J Burgess              *
;*                                                                      *
;*              COPYRIGHT 1993 Atari Computer Corporation               *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*
;*======================================================================*

       	include	"jaguar.inc"
	include	"video.inc"
	include	"objlist.inc"

;*======================================================================*
;*	EXTERNAL SYMBOLS
;*======================================================================*



;*======================================================================*
;*	EXTERNAL ROUTINES
;*======================================================================*


;*======================================================================*
;*	PUBLIC SYMBOLS
;*======================================================================*

	.globl	objData		;* object data information
	.globl	olist_ram	;* dynamic obj list pointer
	.globl	olist		;* mungeable obj list pointer
	.globl	lastObj		;* last object in list index
	.globl  dlistptr	;* bi-phrased ptr to olist

;*======================================================================*
;*	PUBLIC ROUTINES
;*======================================================================*

	.globl	BuildObjList	;* build the object display list
	.globl	InitObjList
	.globl	CopyObjList


;*======================================================================*
;*	PROGRAM SEGMENT
;*======================================================================*
	.text

;*======================================================================*
;*	BuildObjList()	build the object display list
;*
;*	Given:
;*		A1 = address of object
;*		D6 = total number of objects to be processed
;*
;*	Register Useage:
;*		A0 = the address of the object list used by the object processor
;*		A2 = the address of the object list being built
;*		D0 = holds the long being built
;*		D1 = used for temporary calculations
;*		D2 = the lines off screen, calculated in set_odata, used by set_oheight
;*		D3 = #12 for shifting d0
;*		D4 = #10 for shifting d0
;*		D5 = #11 for shifting d0
;*		D6 = counts the objects being processed
;*		D7 = the address of the boject used by the object processor divided by 8
;*
;*		All registers preserved
;*
;*======================================================================*

BuildObjList:
	movem.l	a0-a2/d0-d7,-(sp)

	moveq	#12,d3			;* for doing lsl.l on d0
	moveq	#10,d4			;* for doing lsl.l on d0
	moveq	#11,d5			;* for doing lsl.l on d0

;*	move.l	#olist,d7		;* address of packed olist
	move.l	dlistptr,d7		;* Here it is, bi-phrased
;*
	lsr.l	#3,d7			;* divide by 8 for object processor
	lea	olist_ram,a2		;* address of copy of packed olist
;	move.w	d6,lastObj		;* remember index of last object
	sub.w	#1,d6			;* start dbra counter at total objects - 1
proc_obj:				;* process an object
	tst.b	O_TYPE(a1)		;* check the delete flag for this object
	bmi	next_obj		;* skip this object if negative bit is set

	;*==============================================================*
	;* PHRASE 1
	;*==============================================================*

set_odata:

	;* if the object is above top line of the screen,
	;* the data pointer is set to the first line of the object that is on screen

	move.l	O_DATA(a1),d0		;* get normal data address
	move.w	#SCRNTOP-1,d2
	sub.w	O_YPOS(a1),d2		;* top of screen - ypos = half lines off top of screen
	bpl	.above			;* if object is above top of screen, use normal data address
	clr.w	d2			;* 0 lines off screen, use normal data address
	bra	.setlink
.above:
	lsr.w	#1,d2			;* convert half lines to lines
	move.w	O_DWIDTH(a1),d1		;* get phrases per line of data in the object
	lsl.w	#3,d1			;* multiply phrases * 8 bytes per phrase
	mulu.w	d2,d1			;* lines off screen * bytes per line in the object
	add.l	d1,d0			;* skip the total bytes that are off the top of the screen

.setlink:
	lsr.l	#3,d0			;* divide by 8
	lsl.l	d5,d0			;* shift left 11 bits to make room for link pointer

	;* set the link pointer to the next object
	cmpi.b	#BITOBJ,O_TYPE(a1)	;* see if this is a bit map object
	bne	.chk_scal
	add.l	#BITSIZE,d7		;* skip past bitmapped object
	bra	.adjlink
.chk_scal:
	cmpi.b	#SCBITOBJ,O_TYPE(a1)	;* see if this is a scaled bit map object
	bne	.chk_gpu
	add.l	#SCBITSIZE,d7		;* skip past scaled bit map object
	bra	.adjlink
.chk_gpu:
	cmpi.b	#GPUOBJ,O_TYPE(a1)	;* see if this is a GPU object
	bne	.chk_branch
	add.l	#GPUSIZE,d7		;* skip past GPU object
	bra	.adjlink
.chk_branch:
	cmpi.b	#BRANCHOBJ,O_TYPE(a1)	;* see if this is a branch object
	bne	.chk_stop
	add.l	#BRANCHSIZE,d7		;* skip past branch object
	bra	.adjlink
.chk_stop:
	add.l	#STOPSIZE,d7		;* skip past branch object

.adjlink:
	move.l	d7,d1			;* get address in olist of next object
	
	lsr.l	#8,d1			;* the rightmost 8 bits go in the next long, so remove them
	or.l	d1,d0			;* or with data pointer
	move.l	d0,(a2)+		;* save first long in phrase 1, advance the pointer to next long

	move.b	d7,d0			;* get the low 8 bits of the link pointer that was saved earlier
	lsl.l	d4,d0			;* shift left 10 bits to make room for height

set_oheight:

	;* d2.w is set to the number of lines that are above the top of the screen
	;* if part of the object is above the top line of the screen,
	;* the height is reduced by the number of lines off the top of the screen

	move.w	O_HEIGHT(a1),d1		;* get the height of the object
	cmpi.b	#1,O_TYPE(a1)		;* see if this is a scaled bit map object
	bne.b	.notscaled		;* branch if object is not scaled
	sub.w	#1,d1			;* an extra line is displayed at the bottom
					;*	of large scaled objects if this is not here
.notscaled:
	sub.w	d2,d1			;* subtract lines off screen from scaled height
	bmi.b	.gtheight		;* if lines off screen > height
					;*	make height 0 instead of negative
	or.w	d1,d0			;* or with link pointer in second half of phrase 1
.gtheight:
	lsl.l	d5,d0			;* shift left 11 bits to make room for ypos

set_oypos:

	;* if ypos is negative, it gets set to 0
	;* set_odata and set_oheight will adjust the data pointer and height accordingly

	move.w	O_YPOS(a1),d1
	bmi.b	.negypos		;* if ypos is negative
					;*	object would not be displayed, so set ypos to 0
	and.w	#$7ff,d1		;* only write 11 bits for ypos
	or.w	d1,d0			;* or with link pointer and height
.negypos:
	lsl.l	#3,d0			;* shift left 3 bits to make room for type

set_otype: 
	or.b	O_TYPE(a1),d0		;* object type
	move.l	d0,(a2)+		;* write second half of phrase 1

	;*==============================================================*
	;* PHRASE 2
	;*==============================================================*

set_ofirstpix:
	move.b	O_FIRSTPIX(a1),d0
	lsl.l	#4,d0			;* shift left 4 bits to make room for release, transparent, rmw, reflect bits

set_flags:
	or.b	O_FLAGS(a1),d0		;* or with firstpix
	lsl.l	#7,d0			;* shift left 7 bits to make room for index

set_oindex:
	or.b	O_INDEX(a1),d0		;* or with firstpix and flags
	lsl.l	#6,d0			;* shift left 6 bits to make room for part of iwidth

set_oiwidth:
	move.w	O_IWIDTH(a1),d1			
	lsr.w	#4,d1			;* right 4 bits go in the next long, so remove them
	or.b	d1,d0
	move.l	d0,(a2)+		;* write first long of phrase 2

	move.w	O_IWIDTH(a1),d0			
	and.w	#$F,d0			;* get low 4 bits of iwidth
	lsl.l	d4,d0			;* shift left 10 bits to make room for dwidth

set_odwidth:
	or.w	O_DWIDTH(a1),d0		;* or with part of iwidth
	lsl.l	#3,d0			;* shift left 3 bits to make room for pitch

set_opitch:
	or.b	O_PITCH(a1),d0		;* or with dwidth and iwidth
	lsl.l	#3,d0			;* shift left 3 bits to make room for depth

set_odepth:
	or.b	O_DEPTH(a1),d0		;* or with dwidth, iwidth, pitch
	lsl.l	d3,d0			;* shift left 12 bits to make room for xpos

set_oxpos:
	move.w	O_XPOS(a1),d1		;* object xpos
	and.w	#$fff,d1		;* only write 12 bits for xpos
	or.w	d1,d0			;* or with the rest of the stuff
	move.l	d0,(a2)+		;* write second half of phrase 2

	cmpi.b	#1,O_TYPE(a1)		;* see if this is a scaled bit map object
	bne	next_obj			;* branch if object is not scaled

	;*==============================================================*
	;* PHRASE 3
	;*==============================================================*

	;* for scaled bit map object only
	move.l	O_SCALE(a1),4(a2)	;* write remainder, vscale, hscale bytes in 2nd long of phrase 3
	adda.l	#16,a2			;* add extra 2 phrases for scaled object

next_obj:				;* jump to here if delete flag is on
	adda.l	#OBJSIZE,a1		;* point to next object in pseudo object list
	dbra	d6,proc_obj		;* repeat until all objects have been processed
	
	;* write a stop object at the end of the list
	move.l	#0,(a2)+		
	move.l	#4,(a2)			;* write object type 4 (stop object)

	movem.l	(sp)+,d0-d7/a0-a2
 	rts	

;*======================================================================*
;*	InitObjList   Initialize the Object List
;*
;*	Given:
;*		A0 = source object data
;*		Control
;*
;*	Returns:
;*		OBJ_DATA = object data for headers
;*
;*	Register Usage:
;*		All Registers Preserved
;*
;*	Externals:
;*		None
;*
;*======================================================================*

InitObjList:
	movem.l	d0-d2/a0-a1,-(sp)

	clr.l	d1
	lea.l	objData,a1		;* beginning of RAM object list
	move.w	(a0)+,d1		;* number objects in list
	move.l	d1,d2			;* copy for size
	sub.l	#1,d1			;* last object index
	move.w	d1,lastObj		;* remember last object
	mulu	#OBJSIZE,d2		;* total bytes in list
	subq.l	#1,d2			;* -1 for DBRA
	lsr.l	#1,d2			;* total words
.cpyloop:
	move.w	(a0)+,(a1)+		;* copy objROMData to objData
	dbra	d2,.cpyloop

	movem.l	(sp)+,a0-a1/d0-d2
	rts

;*======================================================================*
;*	CopyObjList   Build Object List
;*
;*	Given:
;*		Control
;*
;*	Returns:
;*		OLIST_RAM = Master Object List
;*		OLIST     = Ptr to a displayable (and mungeable) Object List
;*
;*	Register Usage:
;*		All Registers Preserved
;*
;*	Externals:
;*		None
;*
;*======================================================================*

CopyObjList:
	movem.l	a0-a1,-(sp)

	lea	olist_ram,a0		;* beginning of olist_ram

;	lea	olist,a1		;* beginning of olist
	move.l	dlistptr,a1		;* bi-phrased olist

.cpyloop:
	move.l	(a0),(a1)+		;* copy olist_ram to olist
	cmpi.l	#STOPOBJ,(a0)+		;* see if we are at the stop object
	bne.b	.cpyloop

	movem.l	(sp)+,a0-a1
	rts

;*======================================================================*
;*	LOCAL RAM
;*======================================================================*

	.bss

trash:	ds.l	100	
;	.even
	.phrase

dlistptr:
	ds.l	1	;pointer to our display list, bi-phrase aligned

objData:
	ds.b	(MAXOBJS*OBJSIZE)		;* need 26 bytes for each object

lastObj:					;* index of last object in list
	ds.w	1

	;*==============================================================*

	.phrase
;*======================================================================*
;*				EOF
;*======================================================================*
