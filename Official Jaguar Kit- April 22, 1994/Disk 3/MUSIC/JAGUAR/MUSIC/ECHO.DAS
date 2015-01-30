; Let's do a simple echo

; We will use a 32kbyte DRAM effects buffer and two pointers one to store the
; output of the effect. the other to point to what should be added. Do
; this on the sum of the left and right

; This gives an echo of about 2/3 seconds

; The input left and right are in registers r26 and r9. These values are
; 16 bit fractional/integer values to avoid truncation error.

; r15 points to the first entry PAST the voice type
; in the voice table being processed.

; The return address is in r27. Jump thru to return.

; This code is run with register bank 1 active so ALL of the registers in
; the active bank can be used (except for the 4 above). In register bank 0
; there are a few constants that you might find useful. They are placed
; there with the following code:

;	movei	#$ff,r0 	 ;=1 ish under 24.8 representation
;	moveta	r0,r11
;
;	movei	#$7fff,r0	    ; panval
;	moveta	r0,r14
;
;	movei	#-4,r0		 ;kill voice
;	moveta	r0,r15
;
;	movei	#$007fffff,r0	 ;sinetable buffer length<<16
;	moveta	r0,r19

; DO NOT CHANGE THESE OR ANY OTHER VALUES IN REGISTER BANK 0

; DO NOT SWITCH TO REGISTER BANK 0

	ORG	$f1b000		; THIS ORG JUST KEEPS SOME OF THE TOOLS HAPPY

; The output is the produced by taking the value at the adding offset tap
; of delay line, multipling by the input gain and adding to the current
; left and right values. The result is then multiplied by the output gain
; and stored in the delay at the storage offset tap.

echo:
	move	r9,r10		; make copies of left
	move	r26,r25		; and right

	sharq	#15,r10		; remember they are shifted up
	sharq	#15,r25
	add	r25,r10		; work with the sum

; It is better to split these loads up.
; Copy r15 to something and then increment it.

	load	(r15),r0	; start of buffer
	load 	(r15+1),r1	; storage offset
	load	(r15+2),r2	; adding offset
	load	(r15+3),r3	; mask of buffer size
	load	(r15+4),r4	; input gain
	load	(r15+5),r5	; output gain

	add	r0,r2
	loadw	(r2),r6		; get the data at the pointer


	imult	r4,r6		; multiply by gain
	add	r6,r9		; add to current samples
	add	r6,r26		; both channels
	
	sharq	#15,r6
	add	r6,r10

	imult	r10,r5		; multiply by gain
	sharq	#15,r5

	addq	#2,r1		; go to next sample
	addq	#2,r2		; go to next sample

	and	r3,r1		; wrap to buffer size
	and	r3,r2		; wrap to buffer size

	store 	r1,(r15+1)	; storage offset
	store	r2,(r15+2)	; adding offset

	add	r0,r1
	jump	(r27)
	storew	r5,(r1)

