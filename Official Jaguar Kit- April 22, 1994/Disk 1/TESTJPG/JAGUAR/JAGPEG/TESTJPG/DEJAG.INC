DQ_Adr		 .equ	$F03E00	; The start of DQ??.ABS (Dequantize table)
In_Adr		 .equ	$F03F40	; Points to start of JAG data
Out_Adr		 .equ	$F03F44	; Points to start of output area
Dehuff_Adr	 .equ	$F03F48	; Points to start of DEHUFF.ABS
Out_Width	 .equ	$F03F4C	; Width of the output space in blocks
Out_E_Width	 .equ	$F03F50	; Encloded pixel width (#WID320 for example)
All_Done	 .equ	$F03F54	; Contains: 1-In progress 0-Done
