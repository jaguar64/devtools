;*======================================================================*
;*                TITLE:                  DSP.INC			*
;*                Function:               DSP definitions		*
;*                                                                      *
;*                Project #:              JAGUAR                        *
;*                Programmer:             Andrew J. Burgess		*
;*                                                                      *
;*	COPYRIGHT 1993 Atari Computer Corporation			*
;*	UNAUTHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,		*
;*	PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR		*
;*	THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.		*
;*	ALL RIGHTS RESERVED.						*
;*                                                                      *
;*======================================================================*

;*======================================================================*
;* ADDRESS REGISTERS	- see jaguar.inc				*
;*======================================================================*

;*======================================================================*
;* DSPFLAGS Flags register equates					*
;*======================================================================*

INT_ENA5	EQU	$00010000	; d16:     DSP interrupt enable
INT_CLR5	EQU	$00020000	; d17:     DSP interrupt disable

;*======================================================================*
;*				EOF					*
;*======================================================================*
