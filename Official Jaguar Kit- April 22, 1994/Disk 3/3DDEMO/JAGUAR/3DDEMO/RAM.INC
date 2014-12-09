;*======================================================================*
;*                TITLE:                  RAM.INC                       *
;*                Function:               ram definitions		*
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

PICTBASE	EQU	$100000			;* start address of picture ram

BKG0		EQU	PICTBASE		;* Background image address
BKG1		EQU	BKG0   +(320*240*2)	;* Background RIP image address
CUBE0		EQU	BKG1   +(320*240*2)	;* Spinning Cube object
CUBE1		EQU	CUBE0  +(128*128*2)	;* Spinning Cube object
JAG		EQU	CUBE1  +(128*128*2)	;* jaguar image address

;*======================================================================*
;*				EOF					*
;*======================================================================*
