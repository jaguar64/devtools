;*======================================================================*
;*                TITLE:    VIDOBJ.S                                     *
;*                Function: Video and Object Processor Routines         *
;*                                                                      *
;*                Project #:              RAPIER                        *
;*                                                                      *
;*                Programmer:             Leonard Tramiel               *
;*                                        Andrew J Burgess              *
;*                                        Rob Zdybel                    *
;*                                                                      *
;*              COPYRIGHT 1992,1993 Atari U.S. Corporation              *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*

	.include	"jaguar.inc"

;
;	PUBLIC SYMBOLS
;
	.globl	make_olist
	.globl	vblank
	.globl	vidinit
	.globl	waitsync

	.globl	framecnt


;
;	EXTERNAL SYMBOLS
;
	.extern	disp_ptr
	.extern	DISPBUF1


;
;	LOCAL EQUATES
;
OBJSIZE		.equ	3*2	; Object List length in Longs

;+  we DO NOT WANT TO USE OLD INITALISATION stuff, so we leave it out
USETHIS		.equ 	0	; by defining a flag that avoids assembly

	.if USETHIS		; we will NOT use ALL following
				; up to .endif ; USETHIS 
;- nbk 20-Nov-93

;	VIDEO DEFINES
;
;vclk		.equ	400	;* 25.0 Hz
;vclk		.equ	399	;* 25.5 Hz
vclk		.equ	376	;* 26.6 Hz

horiz_per	.equ	317778
sync_per	.equ	46050
eq_per		.equ	23500
front_porch	.equ	17450
line_blank	.equ	109500

; disp_width	.equ	1152	;this is in pixels (Leonard Uses)
; disp_width	.equ	1280	;this is in pixels (Leonard Advocates)
disp_width	.equ	1356	;this is in pixels (Gives best center)
disp_height	.equ	200	;this is in lines

; Horizontal computations

n_hp		.equ	horiz_per/vclk
n_hbb		.equ	((horiz_per-sync_per-front_porch)/vclk)|$400
n_hbe		.equ	(line_blank-sync_per-front_porch)/vclk
n_hs		.equ	((horiz_per-sync_per)/vclk)|$400
n_hvs		.equ	(horiz_per-(2*sync_per))/vclk
n_heq		.equ	(horiz_per-eq_per)/vclk
n_hde		.equ	((disp_width/2)-1)|$400
n_hdb1		.equ	((n_hp)-(disp_width/2))
n_hdb2		.equ	n_hdb1

; Vertical

n_vp		.equ	523
n_vee		.equ	6
n_vbe		.equ	40
n_vdb		.equ	n_vbe+26
n_vde		.equ	n_vdb+(disp_height*2)
n_vbb		.equ	n_vde+40
n_vs		.equ	n_vp-10
n_veb		.equ	n_vs-n_vee

;+
; ALL THIS STUFF IS BETTER DONE WITH VideoIni, an EXTERNAL routine
; DONT USE THE STUFF in here, it might NOT RUN ON ALL SYSTEMS
;-
;	vidinit Initialize Video to 320x200 NTSC
;
;	Given:
;		Control
;
;	Returns:
;		Video Disabled, but ready for 320x200 NTSC
;
;	Register Usage:
;		None
;
;	Externals:
;		None
;
vidinit:
	move.w	#0,VMODE	; Stop the Video (I want to get off)

	move.w	#$8000,$f10014	; Turn-on Video (I guess)

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

	move.w	#$0,BG		; Also set up some default colors 
	move.l	#$0,BORD1

	rts

	.endif ; USETHIS

;
;	VBLANK   Vertical Sync Interrupt Handler
;
;	Given:
;		Control
;
;	Returns:
;		Object List restored for next frame
;
;	Register Usage:
;		All Registers Preserved
;
;	Externals:
;		framecnt, disp_ptr, olist_ptr
;
vblank:
	movem.l	d0-d1/a0-a1,-(sp)

	move.l	olist_ptr,a0
	move.l	#OBJSIZE-1,d1
	lea	olist,a1
.cpylp:	move.l	(a1)+,(a0)+	; Copy Object list to display space
	dbra	d1,.cpylp
				
	move.l	disp_ptr,d0	; D0 = Current display buffer
	lsr.l	#3,d0		; Phrase address
	lsl.l	#3,d0
	lsl.l	#8,d0		; pack into upper nybbles
	move.l	olist_ptr,a0
	move.l	(a0),d1
	and.l	#$000007FF,d1	; d1 = Upper 11 bits of Link Field
	or.l	d1,d0
	move.l	d0,(a0)		; Point Object Processor at the display buffer

	addq.l	#1,framecnt	; Count a video frame

	move.w	#$101,INT1
	move.w	#0,INT2


	movem.l	(sp)+,d0-d1/a0-a1
	rte


;
;	MAKE_OLIST   Build Object-List for 320x200 bitmap object
;
;	Given:
;		Control
;
;	Returns:
;		OLIST = Master Object List
;		OLIST_PTR = Ptr to a displayable Object List
;
;	Register Usage:
;		All Registers Preserved
;
;	Externals:
;		None
;
make_olist:
	movem.l	d0-d2/a0-a1,-(sp)
;
; At this point I will set up an object list
; containing a Bit map object and a Stop object.
;
	move	#OBJSIZE-1,d1
	lea	olist_data,a1
	lea	olist,a0
.ocopy:	move.l	(a1)+,(a0)+	; Copy Raw Object list to Master Olist
	dbra	d1,.ocopy
;
; The address of ObjectList must be a multiple of 16
; so the bit mapped object starts at a 16 byte boundary
;
	move.l	#olist_ram,d0
	add.l	#15,d0
	and.l	#$fffffff0,d0	; Adjust ptr to 2*Phrase Boundary
	move.l	d0,olist_ptr	; OLIST_PTR = Ptr to Displayable Object List
	add.l	#16,d0
	lsr.l	#3,d0
	move.l	d0,d1		; d0 = d1 = Link to Stop Object
	ror.l	#8,d0		; Split for Hardware
	and.l	#$ff000000,d0	; d0 = Lo Link
	lsr.l	#8,d1
	and.l	#$7ff,d1	; d1 = Hi Link
	lea	olist,a0	; point to olist once again
	or.l	d0,4(a0)	; Patch-Up Bitmap Object

	move.l	#DISPBUF1,d0
	lsr.l	#3,d0
	lsl.l	#3,d0
	lsl.l	#8,d0
	or.l	d0,d1
	move.l	d1,(a0)		; Patch-Up Bitmap Object

	move	#OBJSIZE-1,d1
	move.l	olist_ptr,a0
	lea	olist,a1
.cpylp:	move.l	(a1)+,(a0)+	; Copy Object list to display space
	dbra	d1,.cpylp

	move.l	olist_ptr,d0
	swap	d0		; THIS SWAP IS REQUIRED (Register is designed English)
	move.l	d0,OLP		; Point to finished Object List

	movem.l	(sp)+,d0-d2/a0-a1
	rts


;
;	WAITSYNC   Wait for VSYNC Interrupt
;
;	Given:
;		Control
;
;	Returns:
;		Nothing
;
;	Register Usage:
;		All Registers Preserved
;
;	Externals:
;		None
;
waitsync:
	move.l	d0,-(sp)

	move.l	framecnt,d0
.wait:	cmp.l	framecnt,d0
	beq	.wait

	move.l	(sp)+,d0
	rts

;
;	VARIABLE RAM
;
	.bss
	.even

framecnt:			; Count of Video Frames
	.ds.l	1

olist_ptr:			; Ptr to Active Mungable ObjList
	.ds.l	1

olist_ram:			; Storage for Mungable ObjList
	.ds.l	OBJSIZE+4	; Extra room for alignment

olist:				; Storage for Master ObjList
	.ds.l	OBJSIZE


;
;	CONSTANT DATA
;
	.data
	.even

olist_data:			; Prepackaged Object List
	.dc.l	$00000000	; BitMap Object		d63-d32
	.dc.l	$00320220	;			d31-d00
	.dc.l	$00000005	;	phrase 2	d63-d32
	.dc.l	$0140c000	;			d31-d00

	.dc.l	$00000000	; Stop Object		d63-d32
	.dc.l	$00000004	;			d31-d00


;*======================================================================*
;*				EOF
;*======================================================================*
