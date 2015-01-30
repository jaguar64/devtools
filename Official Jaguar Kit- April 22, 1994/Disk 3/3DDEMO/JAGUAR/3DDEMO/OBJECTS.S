;*======================================================================*
;*                TITLE:                  OBJECTS.S                     *
;*                Function:               Object Header data		*
;*                                                                      *
;*                Project #:              JAGUAR			*
;*                Programmer:             Andrew J Burgess              *
;*                                                                      *
;*              COPYRIGHT 1993 Atari Computer Corporation               *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*
;*======================================================================*

 	include "jaguar.inc"
 	include "defs.inc"
 	include "video.inc"
 	include "objlist.inc"


;*======================================================================*
;*	EXTERNAL SYMBOLS
;*======================================================================*

	.extern DISPBUF0

;*======================================================================*
;*	EXTERNAL ROUTINES
;*======================================================================*

;*======================================================================*
;*	PUBLIC SYMBOLS
;*======================================================================*

	.globl	Objects

;*======================================================================*
;*	PUBLIC ROUTINES
;*======================================================================*

;*======================================================================*
;*	DEFINES
;*======================================================================*

;*======================================================================*
;*	CONSTANT DATA
;*======================================================================*

	.data
	.phrase

	;*==============================================================*

	.phrase

Objects:
	dc.w	1			;* Number of objects in list

	dc.w	0			;*  o_xpos	
	dc.w	SCRNTOP			;*  o_ypos
	dc.l	DISPBUF0		;*  o_data
	dc.w	200			;*  o_height
	dc.w	160	;* 320		;*  o_dwidth (width/(64/bits per pixel))
	dc.w	80	;* 320		;*  o_iwidth (width/(64/bits per pixel))
	dc.b	0			;*  o_flags
	dc.b	0			;*  o_firstpix
	dc.b	BITOBJ			;*  o_type	unScaled Bit Mapped type
	dc.b	4			;*  o_depth
	dc.b	2			;*  o_pitch
	dc.b	0			;*  o_index
	dc.w	0			;*  o_desc
	dc.w	$0020			;*  unused byte, remainder=1.0 (3.5 format)
	dc.w	$2020			;*  vscale=1.0 (3.5 format), hscale=1.0 (3.5 format)
	dc.l	0			;*  o_rom
	dc.l	M_ACTIVE		;*  mode flags

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Force segment end at phrase boundary... ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.phrase
