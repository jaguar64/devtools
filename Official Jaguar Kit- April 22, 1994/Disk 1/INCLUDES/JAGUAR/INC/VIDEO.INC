;*======================================================================*
;*                TITLE:                  VIDEO.INC                     *
;*                Function:               video definitions		*
;*                                                                      *
;*                Project #:              JAGUAR                        *
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

vclk		EQU	376		; NTSC = 399, PAL = 376
ivclk		EQU	vclk


horiz_per	EQU	317778
sync_per	EQU	46050
eq_per		EQU	23500
front_porch	EQU	17450
line_blank	EQU	109500


;disp_width	EQU	1347		;* (448 + 1) * 3	for SCRNORM
;disp_width	EQU	1796		;* (448 + 1) * 4	for SCROVER
;disp_width	EQU	963		;* (320 + 1) * 3	for SCRNORM
;disp_width	EQU	1284		;* (320 + 1) * 4	for SCROVER
disp_width 	EQU	1152
disp_height	EQU	200		;* this is in lines


; Horizontal computations

n_hp		EQU	horiz_per/vclk
n_hbb		EQU	((horiz_per-sync_per-front_porch)/vclk)|$400
n_hbe		EQU	(line_blank-sync_per-front_porch)/vclk
n_hs		EQU	((horiz_per-sync_per)/vclk)|$400
n_hvs		EQU	(horiz_per-(2*sync_per))/vclk
n_heq		EQU	(horiz_per-eq_per)/vclk
n_hde		EQU	((disp_width/2)-1)|$400
n_hdb1		EQU	((n_hp)-(disp_width/2))
n_hdb2		EQU	n_hdb1

; Vertical

n_vp		EQU	523

n_vee		EQU	6
n_vbe		EQU	40
n_vdb		EQU	n_vbe+26
;n_vdb		EQU	n_vbe+26-20
n_vde		EQU	n_vdb+(disp_height*2)
n_vbb		EQU	n_vde+40
n_vs		EQU	n_vp-10
n_veb		EQU	n_vs-n_vee

SCRNTOP		EQU	66		;ypos of first line at top of screen
SCRNBOTTOM	EQU	199		;xpos of first line below screen

.if 0
; Horizontal computations

n_hp		EQU	horiz_per/vclk
n_hbb		EQU	((horiz_per-sync_per-front_porch)/vclk)+$400
n_hbe		EQU	(line_blank-sync_per-front_porch)/vclk
n_hs		EQU	((horiz_per-sync_per)/vclk)+$400
n_hvs		EQU	(horiz_per-(2*sync_per))/vclk
n_heq		EQU	(horiz_per-eq_per)/vclk
n_hde		EQU	((disp_width/2)-1)|$400
n_hdb1		EQU	((n_hp)-(disp_width/2))
n_hdb2		EQU	n_hdb1

n_vp		EQU	523
n_vee		EQU	6
n_vbe		EQU	40
n_vdb		EQU	n_vbe-2
n_vde		EQU	n_vdb+(disp_height*2)
n_vbb		EQU	n_vde
n_vs		EQU	n_vp-10
n_veb		EQU	n_vs-n_vee


SCRNTOP		EQU	n_vdb		;ypos of first line at top of screen
SCRNBOTTOM	EQU	n_vde		;xpos of first line below screen
.endif

SCRNLEFT	EQU	0			;xpos of left edge of screen
SCRNRIGHT	EQU	((disp_width/4)-1)	;xpos of right edge of screen

SCRNXCTR	EQU	((SCRNRIGHT-SCRNLEFT)/2);ypos of first line at top of screen
SCRNYCTR	EQU	((SCRNBOTTOM-SCRNTOP)/2);xpos of first line below screen

;*======================================================================*
;*				EOF					*
;*======================================================================*
