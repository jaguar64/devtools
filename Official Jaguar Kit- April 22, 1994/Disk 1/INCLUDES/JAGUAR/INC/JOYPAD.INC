;*======================================================================*
;*                TITLE:                  JOYPAD.INC                    *
;*                Function:               Joypad bit definitions	*
;*                                                                      *
;*                Project #:              JAGUAR\SYLVESTER              *
;*                Programmer:             Rob Zdybel                    *
;*                                                                      *
;*              COPYRIGHT 1993 Atari Computer Corporation               *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*

;*======================================================================*
; CHANGES
; nbk 93-Nov-23 inserting this comment
;
; the following definitions from OLDER versions of JOYPAD.INC do NO LONGER 
; EXIST and should be REPLACED (instead of redefined) in older sourcecode
; JOYDEFS.INC is even more outdated. DO NOT USE IT ANY LONGER. It contains
; bit number definitions that do not reflect the current hardware any
; more.
;
; instead of	use
; OLD NAME	NEW NAME
; ----------------------
; JOYIN		JOYSTICK	; this is a LONG variable
; JOYOUT	JOYSTICK	
;
; despite of all DONT'S here some hints for sources relying on old JOYDEFS.INC
; instead of	use
; OLD NAME	NEW NAME
; ----------------------
; FIRE_A_BIT	FIRE_A		; most bits have a new bit number
; FIRE_B_BIT	FIRE_B		; not only new names 
; FIRE_C_BIT	FIRE_C		; check thoroughly with the definitions 
; OPTION_BIT	OPTION		; following later in this file
; PAUSE_BIT	PAUSE
; KEY_S		KEY_STAR
; KEY_P		KEY_HASH
; YES		NO LONGER PREDEFINED. Put into your own code.
; NO		NO LONGER PREDEFINED. Put into your own code.
; NUM_OF_PLAYERS	NO LONGER PREDEFINED. Put into your own code.
; TWO_PLAYERS	NO LONGER PREDEFINED. Put into your own code.
;
; JOYIN and JOYOUT are found under name JOYSTICK in JAGUAR.INC
;
;- nbk 93-Nov-23
;*======================================================================*



;*======================================================================*
; JOYSTICK longword contains
;
;	Format = xxApxxBx RLDU147* xxCxxxox 2580369#
;*======================================================================*

JOY_UP		EQU	20		;joypad
JOY_DOWN	EQU	21
JOY_LEFT	EQU	22
JOY_RIGHT	EQU	23

FIRE_A		EQU	29		;fire buttons
FIRE_B		EQU	25
FIRE_C		EQU	13
OPTION		EQU	9
PAUSE		EQU	28

KEY_STAR	EQU	16		;keypad
KEY_7		EQU	17
KEY_4		EQU	18
KEY_1		EQU	19

KEY_0		EQU	4
KEY_8		EQU	5
KEY_5		EQU	6
KEY_2		EQU	7

KEY_HASH	EQU	0
KEY_9		EQU	1
KEY_6		EQU	2
KEY_3		EQU	3

ANY_JOY		EQU	$00F00000	; AND joyedge with this - joypad was pressed if result is not 0
ANY_FIRE	EQU	$32002200	; AND joyedge with this - A,B C, Option or Pause was pressed if result is not 0
ANY_KEY		EQU	$000F00FF	; AND joyedge with this - 123456789*0# was pressed if result is not 0

;*======================================================================*
;*                              EOF
;*======================================================================*

