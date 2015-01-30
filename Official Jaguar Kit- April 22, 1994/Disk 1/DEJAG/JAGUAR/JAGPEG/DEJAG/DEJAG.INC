DQ_Adr		 EQU $F03E00      ; The start of DQ??.ABS (Dequantize table)
In_Adr		 EQU $F03F40		; Points to start of JAG data
Out_Adr		 EQU $F03F44		; Points to start of output area
Dehuff_Adr	 EQU $F03F48		; Points to start of DEHUFF.ABS
Out_Width    EQU $F03F4C      ; Width of the output space in blocks
Out_E_Width	 EQU $F03F50		; Encloded pixel width (#WID320 for example)
All_Done		 EQU $F03F54      ; Contains: 1-In progress 0-Done

;In_Adr		 EQU $F03B00		; Points to start of JAG data
;Out_Adr		 EQU $F03B04		; Points to start of output area
;Dehuff_Adr	 EQU $F03B08		; Points to start of DEHUFF.ABS
;Out_Width    EQU $F03B14      ; Width of the output space in blocks
;Out_E_Width	 EQU $F03B18		; Encloded pixel width (#WID320 for example)
;DQ_Adr		 EQU $F03BB8      ; The start of DQ??.ABS (Dequantize table)
;All_Done		 EQU $F03B34      ; Contains: 1-In progress 0-Done

