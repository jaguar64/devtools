;*======================================================================*
;*                TITLE:                  TURTLE.INC                    *
;*                Function:               Turtle definitions (MOBS)     *
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
;*
;*	TURTLE RECORDS
;*
;*======================================================================*

;* Shading Types
SMOOTH		=	0
FLAT		=	1

;* Turtle flags
EMPTY		=	$00000000	;* Turtle is inactive
ACTIVE		=	$00000001	;* Turtle is alive
MOMOVE		=	$00000002
MOSLOW_FLG	=	$00000004
UNUSED03_FLG	=	$00000008
UNUSED04_FLG	=	$00000010
UNUSED05_FLG	=	$00000020
UNUSED06_FLG	=	$00000040
UNUSED07_FLG	=	$00000080
UNUSED08_FLG	=	$00000100
UNUSED09_FLG	=	$00000200
UNUSED10_FLG	=	$00000400
UNUSED11_FLG	=	$00000800
UNUSED12_FLG	=	$00001000
UNUSED13_FLG	=	$00002000
UNUSED14_FLG	=	$00004000
UNUSED15_FLG	=	$00008000
UNUSED16_FLG	=	$00010000
UNUSED17_FLG	=	$00020000
UNUSED18_FLG	=	$00040000
UNUSED19_FLG	=	$00080000
UNUSED20_FLG	=	$00100000
UNUSED21_FLG	=	$00200000
UNUSED22_FLG	=	$00400000
UNUSED23_FLG	=	$00800000
UNUSED24_FLG	=	$01000000
UNUSED25_FLG	=	$02000000
UNUSED26_FLG	=	$04000000
UNUSED27_FLG	=	$08000000
UNUSED28_FLG	=	$10000000
UNUSED29_FLG	=	$20000000
UNUSED30_FLG	=	$40000000
UNUSED31_FLG	=	$80000000

;* Turtle Data Structure
xrite	   =	0		; IMPORTANT NOTE:
yrite	   =	xrite+2		; These first record offsets are hard-wired
zrite	   =	yrite+2		; into associated GPU routines.
xdown	   =	zrite+2		; DO NOT Insert, Delete or Swap any of these
ydown	   =	xdown+2		;	^
zdown	   =	ydown+2		;	|
xhead	   =	zdown+2		;	|
yhead	   =	xhead+2		;	|
zhead	   =	yhead+2		;	|
xposn	   =	zhead+2		;	|
yposn	   =	xposn+2		;	|
zposn	   =	yposn+2		;	v
link       =	zposn+2		; Dont change this or anything above here
endx       =	link+2		;* ending X position
endy       =	endx+2		;* ending Y position
endz       =	endy+2		;* ending Z position
xdelta     =	endz+2		;* delta  X position
ydelta     =	xdelta+2	;* delta  Y position
zdelta     =	ydelta+2	;* delta  Z position
rollstrt   =	zdelta+2	;* start  roll  angle
pitchstrt  =	rollstrt+2	;* start  pitch angle
yawstrt    =	pitchstrt+2	;* start  yaw   angle
rollinc    =	yawstrt+2	;* delta  roll  inc
pitchinc   =	rollinc+2	;* delta  pitch inc
yawinc     =	pitchinc+2	;* delta  yaw   inc
type       =	yawinc+2	;* type field
flags      =	type+2		;* flags field
turtlsiz   =	flags+4		;* size

;*======================================================================*
;*                                 EOF                                  *
;*======================================================================*
