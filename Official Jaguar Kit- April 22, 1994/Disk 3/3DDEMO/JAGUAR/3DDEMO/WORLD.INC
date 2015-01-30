;*======================================================================*
;*                TITLE:                  WORLD.INC                     *
;*                Function:               World definitions (MOBS)      *
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

MAX3DOBJS	EQU	256
NUM_PLANETS	EQU	1
CAM_XPOS	EQU	$0000
CAM_YPOS	EQU	$0000
CAM_ZPOS	EQU	-($0180)

MAXXPOS		EQU	$4000		;* +1
MINXPOS		EQU	$8000		;* -1

MAXYPOS		EQU	$4000		;* +1
MINYPOS		EQU	$8000		;* -1

MAXZPOS		EQU	$4000		;* +1
MINZPOS		EQU	$8000		;* -1

;*======================================================================*
;*
;*	TURTLE RECORDS
;*
;*======================================================================*

;* World Object Types
CAMERA_TYP	=	0
PLAYER_TYP	=	1
TITLE0_TYP	=	2		;* A
TITLE1_TYP	=	3		;* T
TITLE2_TYP	=	4		;* A
TITLE3_TYP	=	5		;* R
TITLE4_TYP	=	6		;* I
TITLE10_TYP	=	7		;* A flat
TITLE11_TYP	=	8		;* T flat
TITLE12_TYP	=	9		;* A flat
TITLE13_TYP	=	10		;* R flat
TITLE14_TYP	=	11		;* I flat
BULB_TYP	=	12		;* light bulb


;* Rotation axis specifiers
XYAXIS		=	0
YZAXIS		=	1
XZAXIS		=	2

;* World Data Structure
wldtype		=	0		;* type of world object
wldxstart	=	wldtype+2	;* world object starting X position
wldystart	=	wldxstart+2	;* world object starting Y position
wldzstart	=	wldystart+2	;* world object starting Z position
wldxend		=	wldzstart+2	;* world object ending   X position
wldyend		=	wldxend+2	;* world object ending   Y position
wldzend		=	wldyend+2	;* world object ending   Z position
wldxdelta       =	wldzend+2	;* world object delta    X
wldydelta       =	wldxdelta+2	;* world object delta    Y
wldzdelta       =	wldydelta+2	;* world object delta    Z
wldsroll        =	wldzdelta+2	;* world object start    roll
wldspitch       =	wldsroll+2	;* world object start    pitch
wldsyaw         =	wldspitch+2	;* world object start    yaw
wldroll         =	wldsyaw+2	;* world object delta    roll
wldpitch        =	wldroll+2	;* world object delta    pitch
wldyaw          =	wldpitch+2	;* world object delta    yaw
wldsize 	=	wldyaw+2	;* world object size

;*======================================================================*
;*                                 EOF                                  *
;*======================================================================*
