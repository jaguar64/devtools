; This is a simple sample program to play a tune
; on the synth code.

	.include	'jaguar.inc'
	.include	'fulsyn.def'

	.extern		FULSYN_S
	.extern		FULSYN_E

	.extern		SYNTHEND

	.extern		VOLUME

	.extern		DSPORG

	.extern		TABLES_S
	.extern		TABLES_E

	.extern		ECHO_S
	.extern		ECHO_E

	.extern		c_hi_hat

	.extern		scoretab

	.extern		PATCHLOC
	.extern		SCORE_ADD
	.extern		TIMER_ADD

	.extern		LEAD
	.extern		COMP1
	.extern		BASS1
	.extern		SIMPLE

	HIBIT		equ		$80000000

	move.l	#$00070007,D_END	; Set GOOD mode

	move.l	#0,D_CTRL		; Turn DSP off

	move.l	#0,D_FLAGS		; Set known state

; First we copy the Jerry code into Jerry
; The label GPUSTART will be created by LTXCONV/ALN
; at the start of the block.

; The code gets loaded into the DSP at DSPORG

	move.l	#DSPORG,a1
	move.l	#FULSYN_S,a0
	move.l	a0,d0
	move.l	#FULSYN_E,d1
	sub.l	d0,d1
	asr.l	#2,d1
translop:
	move.l	(a0)+,(a1)+
	dbra	d1,translop

; Now we copy the Jerry tables into Jerry
; The label tabs will be created by LTXCONV/ALN
; at the start of the block.

; The tables get loaded into the DSP at TABLESTART

	move.l	#TABLESTART,a1
	move.l	#TABLES_S,a0
	move.l	a0,d0
	move.l	#TABLES_E,d1
	sub.l	d0,d1
	asr.l	#2,d1
tablop:
	move.l	(a0)+,(a1)+
	dbra	d1,tablop

; Set up the I2S interface

	move.l	#19,SCLK
	move.l	#$15,SMODE

; Set the Volume to full blast

	move.l	#$7fff,VOLUME

; Now it should be safe to turn on the DSP

	move.l	#DSPORG,D_PC	; Set up D_PC

	move.l	#$1,D_CTRL	; LET 'R RIP

; Now we copy the score to an arbitrary location

	move.l	#scoretab,a0
	move.l	#$50000,a1

scorelop:
	move.l	(a0)+,d0
	move.l	d0,(a1)+
	cmp.l	#$7fffffff,d0
	bne	scorelop

; Now lets set up a patch table	

	move.l	#patches,a0
	move.w	(a0)+,d0
	move.l	#PATCHTAB,a1

patchlop:
	move.l	(a0)+,(a1)+
	dbra	d0,patchlop

; Tell the synth where the patches are

	move.l	#PATCHTAB,PATCHLOC

; At this point the synth is running but the MIDI player is not

; This where you set up a score or start a loaded one
; Now tell the system where the score is

replay:
	move.l	#$50000,SCORE_ADD

; Set the beginning of time

	move.l	#0,TIMER_ADD

; Enable sound (mute bit off)

	move.w	#$100,JOYSTICK

; Set up Timer1
; This starts the MIDI player

	move.w	#$5f,$F10002
	move.w	#$114,$F10000

;******************************************************************************************************
;
;
;			The following code only need be here if extra synth/effect
;			modules are needed. Start reading again at illegal
;
;
;******************************************************************************************************

; Load in the echo effect to the top 256 bytes of DSP RAM
; Note: The effect is only 58 bytes long!!
	move.l	#$f1cf00,a1
	move.l	#ECHO_S,a0
	move.l	a0,d0
	move.l	#ECHO_E,d1
	sub.l	d0,d1
	asr.l	#2,d1
echolop:
	move.l	(a0)+,(a1)+
	dbra	d1,echolop

; Find the first available slot for the effect

; SYNTHEND is a label at the end of the jump table
; that points to all of the synth modules

; Start at SYNTHEND and look for a sensible address
	move.l	#SYNTHEND,a0
	add.l	#4,a0		; prepare for predecrement
flop:
	move.l	-(a0),d0
	cmp.l	#D_RAM,d0
	bmi	flop
; This is the last occupied voice, so put
; the address of the echo module at the next
; one. The current value there is the correct
; synth type to use!

	add.l	#4,a0
	move.l	(a0),d0
	move.l	#$f1cf00,(a0)

; Add in the echo effect
; Since the MIDI file uses only 8 voices we put echo
; in voicetable position 8 and the stop in location 9

; First the new stop

	move.l	#0,TABLESTART+(9*TABOFF)

; Now load up the parameters, see echo.das for more info 
; on this implementation of echo.

	move.l	#TABLESTART+(8*TABOFF),a0
	move.l	#$100000,(4,a0)			; First table entry is address of buffer
	move.l	#0,(8,a0)			; Second table entry is offset of writeptr
	move.l	#2,(12,a0)			; Third table entry is offset of readptr
	move.l	#$7fff,(16,a0)			; Fourth table entry is mask of buffer size ($7fff=>32k)
	move.l	#$7fff,(20,a0)			; Fifth table entry is input gain ($7fff=>full)
	move.l	#$6000,(24,a0)			; Sixth table entry is output gain ($7fff=>full)

; The effect needs a clear buffer

	move.l	#$100000,a1
	move.w	#$1fff,d1			; $2000 longs is 32768 bytes
lop:
	clr.l	(a1)+
	dbra	d1,lop

; Put the value read from the jump table into
; the voice table

	move.l	d0,(a0)

	illegal


; ************************ END OF MAIN CODE ***********************


.data
.even
	
patches:
; MAKE SURE TO CHANGE THIS SO THAT THE CORRECT NUMBER ARE COPIED!!!!!!!!!
	dc.w	19*20		; number of longs to copy

; Patch 0
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$b00		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	$80000100	; 13
	dc.l	$100		; 14
	dc.l	0		; 15
	dc.l	$80000100	; 16
	dc.l	$80		; 17
	dc.l	$f1d000		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 1
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_TRI		; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000400	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 2
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_TRI		; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$100		; 8 Frequency of carrier,fixed
	dc.l	$a00		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 3
	dc.l	12		; 0 Synth type = 16 bit sampler
	dc.l	0		; 1 Loop Flag/Volume
	dc.l	c_hi_hat	; 2 Start of sample
	dc.l	$1000		; 3 Pitch shift ($1000 = No shift)
	dc.l	((8976/2)<<8)-1	; 4 End of loop
	dc.l	0		; 5 No loop length
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	((8976/2)<<8)-1	; 8 End of sample
	dc.l	0		; 9
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 4
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 5
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 6
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 7
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 8
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 9
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 10
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 11
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 12
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 13
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 14
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 15
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 16
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 17
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_SINE	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$00		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered

; Patch 18
	dc.l	8		; 0 Synth type = Simple FM
	dc.l	ROM_CHIRP16	; 1 Carrier wave
	dc.l	ROM_SINE	; 2 Modulation wave
	dc.l	0		; 3
	dc.l	0		; 4
	dc.l	0		; 5
	dc.l	0		; 6
	dc.l	0		; 7
	dc.l	$80000100	; 8 Frequency of carrier locked to pitch
	dc.l	$400		; 9 Depth of Modultion
	dc.l	0		; 10
	dc.l	0		; 11
	dc.l	0		; 12
	dc.l	0		; 13
	dc.l	0		; 14
	dc.l	0		; 15
	dc.l	0		; 16
	dc.l	0		; 17
	dc.l	0		; 18
	dc.l	$3fff		; 19 Pan value = centered


