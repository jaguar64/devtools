;**************************************************************************
; (C)1993 ATARI CORP.       SECRET & CONFIDENTIAL       ALL RIGHTS RESERVED
;
;				     CD.INC
;
;                                REVISION HISTORY
;
; REV.  DATE       BY            DESCRIPTION OF EDIT
; """"  """"       ""            """""""""""""""""""
; 1.00  20 Apr 94  LJT		 First Release
;**************************************************************************

; Jump table to ALL of the functions

CD_init		EQU	$3000
CD_mode		EQU	CD_init	+ 6
CD_ack		EQU	CD_mode	+ 6
CD_jeri		EQU	CD_ack	+ 6
CD_spin		EQU	CD_jeri	+ 6
CD_stop		EQU	CD_spin	+ 6
CD_mute		EQU	CD_stop	+ 6
CD_umute	EQU	CD_mute	+ 6
CD_paus		EQU	CD_umute+ 6
CD_upaus	EQU	CD_paus	+ 6
CD_read		EQU	CD_upaus+ 6
CD_uread	EQU	CD_read	+ 6
CD_setup	EQU	CD_uread+ 6
CD_ptr		EQU	CD_setup+ 6
CD_osamp	EQU	CD_ptr	+ 6

