
;*======================================================================*
;*
;*	File:		head.JAG
;*
;*	Created From:	head.3ds
;*
;*	3DS2JAG	v2.3	Nov 29 0993	01:27:48 Andrew Burgess/Denis L. Fung
;*
;*======================================================================*

	.data
	.phrase

SEGOFFSET	EQU	$4


.include	"blit.inc"
;*======================================================================*

	.globl	cubesize
	.globl	cubedata
	.globl	endcube
	.extern	EYECRY
	.extern MOUTH
	.extern	eyepts
	.extern	mthpts
cubesize:
	dc.l	endcube-cubesize	;* Size
.phrase
cubedata:
	DC.W	133			;* number of Vertices
	DC.W	250			;* number of Faces
	DC.L	.vertlist		;* pointer to vertices
	DC.L	.texlist		;* pointer to texture maps
	DC.L	.tboxlist		;* pointer to texture boxes

	;*===============================================================*
	;*	FACE DATA - negative values signify reversing the segment vertext pair
	;*===============================================================*

.facelist:
	DC.L	$00000000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   0: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	49 * 8	
	dc.w	63 * 8	
	dc.w	50 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   1: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	122 * 8	
	dc.w	132 * 8	
	dc.w	123 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   2: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	128 * 8	
	dc.w	116 * 8	
	dc.w	127 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   3: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	127 * 8	
	dc.w	114 * 8	
	dc.w	126 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   4: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	125 * 8	
	dc.w	132 * 8	
	dc.w	126 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   5: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	126 * 8	
	dc.w	132 * 8	
	dc.w	127 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   6: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	127 * 8	
	dc.w	132 * 8	
	dc.w	128 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   7: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	112 * 8	
	dc.w	125 * 8	
	dc.w	113 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   8: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	126 * 8	
	dc.w	113 * 8	
	dc.w	125 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   9: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	124 * 8	
	dc.w	132 * 8	
	dc.w	125 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  10: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	128 * 8	
	dc.w	132 * 8	
	dc.w	129 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  11: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	103 * 8	
	dc.w	90 * 8	
	dc.w	106 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  12: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	123 * 8	
	dc.w	132 * 8	
	dc.w	124 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  13: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	129 * 8	
	dc.w	132 * 8	
	dc.w	130 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  14: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	34 * 8	
	dc.w	16 * 8	
	dc.w	33 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  15: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	76 * 8	
	dc.w	62 * 8	
	dc.w	75 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  16: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	69 * 8	
	dc.w	84 * 8	
	dc.w	70 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  17: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	130 * 8	
	dc.w	132 * 8	
	dc.w	131 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  18: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	131 * 8	
	dc.w	132 * 8	
	dc.w	122 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  19: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	97 * 8	
	dc.w	112 * 8	
	dc.w	108 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  20: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	111 * 8	
	dc.w	124 * 8	
	dc.w	112 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  21: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	125 * 8	
	dc.w	112 * 8	
	dc.w	124 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  22: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	20 * 8	
	dc.w	17 * 8	
	dc.w	22 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  23: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	83 * 8	
	dc.w	97 * 8	
	dc.w	84 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  24: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	108 * 8	
	dc.w	84 * 8	
	dc.w	97 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  25: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	21 * 8	
	dc.w	19 * 8	
	dc.w	20 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  26: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	35 * 8	
	dc.w	18 * 8	
	dc.w	34 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  27: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	4 * 8	
	dc.w	27 * 8	
	dc.w	6 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  28: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	49 * 8	
	dc.w	34 * 8	
	dc.w	48 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  29: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	27 * 8	
	dc.w	41 * 8	
	dc.w	28 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  30: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	41 * 8	
	dc.w	55 * 8	
	dc.w	42 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  31: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	82 * 8	
	dc.w	97 * 8	
	dc.w	83 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  32: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	106 * 8	
	dc.w	118 * 8	
	dc.w	103 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  33: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	96 * 8	
	dc.w	111 * 8	
	dc.w	97 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  34: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	112 * 8	
	dc.w	97 * 8	
	dc.w	111 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  35: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	131 * 8	
	dc.w	119 * 8	
	dc.w	130 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  36: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	124 * 8	
	dc.w	111 * 8	
	dc.w	123 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  37: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	63 * 8	
	dc.w	49 * 8	
	dc.w	62 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  38: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	55 * 8	
	dc.w	69 * 8	
	dc.w	56 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  39: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	77 * 8	
	dc.w	63 * 8	
	dc.w	76 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  40: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	91 * 8	
	dc.w	76 * 8	
	dc.w	90 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  41: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	68 * 8	
	dc.w	83 * 8	
	dc.w	69 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  42: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	120 * 8	
	dc.w	122 * 8	
	dc.w	121 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  43: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	23 * 8	
	dc.w	26 * 8	
	dc.w	4 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  44: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	18 * 8	
	dc.w	35 * 8	
	dc.w	22 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  45: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	27 * 8	
	dc.w	4 * 8	
	dc.w	26 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  46: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	50 * 8	
	dc.w	35 * 8	
	dc.w	49 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  47: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	64 * 8	
	dc.w	50 * 8	
	dc.w	63 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  48: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	91 * 8	
	dc.w	103 * 8	
	dc.w	92 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  49: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	105 * 8	
	dc.w	92 * 8	
	dc.w	103 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  50: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	103 * 8	
	dc.w	119 * 8	
	dc.w	105 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  51: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	120 * 8	
	dc.w	105 * 8	
	dc.w	119 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  52: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	123 * 8	
	dc.w	110 * 8	
	dc.w	122 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  53: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	105 * 8	
	dc.w	120 * 8	
	dc.w	104 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  54: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	97 * 8	
	dc.w	82 * 8	
	dc.w	96 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  55: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	26 * 8	
	dc.w	40 * 8	
	dc.w	27 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  56: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	41 * 8	
	dc.w	27 * 8	
	dc.w	40 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  57: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	40 * 8	
	dc.w	54 * 8	
	dc.w	41 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  58: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	55 * 8	
	dc.w	41 * 8	
	dc.w	54 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  59: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	54 * 8	
	dc.w	68 * 8	
	dc.w	55 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  60: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	63 * 8	
	dc.w	77 * 8	
	dc.w	64 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  61: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	69 * 8	
	dc.w	55 * 8	
	dc.w	68 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  62: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	76 * 8	
	dc.w	91 * 8	
	dc.w	77 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  63: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	92 * 8	
	dc.w	77 * 8	
	dc.w	91 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  64: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	83 * 8	
	dc.w	68 * 8	
	dc.w	82 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  65: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	121 * 8	
	dc.w	104 * 8	
	dc.w	120 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  66: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	111 * 8	
	dc.w	109 * 8	
	dc.w	110 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  67: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	96 * 8	
	dc.w	81 * 8	
	dc.w	109 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  68: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	22 * 8	
	dc.w	36 * 8	
	dc.w	20 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  69: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	20 * 8	
	dc.w	24 * 8	
	dc.w	21 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  70: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	35 * 8	
	dc.w	50 * 8	
	dc.w	36 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  71: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	50 * 8	
	dc.w	64 * 8	
	dc.w	51 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  72: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	64 * 8	
	dc.w	78 * 8	
	dc.w	65 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  73: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	77 * 8	
	dc.w	92 * 8	
	dc.w	78 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  74: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	93 * 8	
	dc.w	95 * 8	
	dc.w	94 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  75: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	110 * 8	
	dc.w	95 * 8	
	dc.w	121 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  76: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	82 * 8	
	dc.w	67 * 8	
	dc.w	81 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  77: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	68 * 8	
	dc.w	54 * 8	
	dc.w	67 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  78: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	36 * 8	
	dc.w	38 * 8	
	dc.w	24 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  79: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	40 * 8	
	dc.w	26 * 8	
	dc.w	39 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  80: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	54 * 8	
	dc.w	40 * 8	
	dc.w	53 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  81: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	39 * 8	
	dc.w	25 * 8	
	dc.w	38 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  82: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	51 * 8	
	dc.w	52 * 8	
	dc.w	38 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  83: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	65 * 8	
	dc.w	79 * 8	
	dc.w	52 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  84: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	67 * 8	
	dc.w	53 * 8	
	dc.w	66 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  85: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	78 * 8	
	dc.w	93 * 8	
	dc.w	79 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  86: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	81 * 8	
	dc.w	66 * 8	
	dc.w	94 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  87: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	87 * 8	
	dc.w	100 * 8	
	dc.w	88 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  88: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	107 * 8	
	dc.w	115 * 8	
	dc.w	100 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  89: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	100 * 8	
	dc.w	86 * 8	
	dc.w	107 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  90: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	114 * 8	
	dc.w	127 * 8	
	dc.w	115 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  91: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	99 * 8	
	dc.w	114 * 8	
	dc.w	107 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  92: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	102 * 8	
	dc.w	89 * 8	
	dc.w	101 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  93: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	88 * 8	
	dc.w	101 * 8	
	dc.w	89 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  94: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	10 * 8	
	dc.w	30 * 8	
	dc.w	9 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  95: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	107 * 8	
	dc.w	86 * 8	
	dc.w	99 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  96: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	117 * 8	
	dc.w	102 * 8	
	dc.w	116 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  97: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	7 * 8	
	dc.w	10 * 8	
	dc.w	9 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  98: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	74 * 8	
	dc.w	60 * 8	
	dc.w	73 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  99: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	89 * 8	
	dc.w	74 * 8	
	dc.w	88 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 100: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	32 * 8	
	dc.w	12 * 8	
	dc.w	31 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 101: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	71 * 8	
	dc.w	86 * 8	
	dc.w	80 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 102: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	85 * 8	
	dc.w	99 * 8	
	dc.w	86 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 103: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	98 * 8	
	dc.w	114 * 8	
	dc.w	99 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 104: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	47 * 8	
	dc.w	32 * 8	
	dc.w	46 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 105: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	61 * 8	
	dc.w	47 * 8	
	dc.w	60 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 106: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	100 * 8	
	dc.w	116 * 8	
	dc.w	101 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 107: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	31 * 8	
	dc.w	9 * 8	
	dc.w	37 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 108: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	87 * 8	
	dc.w	80 * 8	
	dc.w	86 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 109: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	86 * 8	
	dc.w	71 * 8	
	dc.w	85 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 110: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	57 * 8	
	dc.w	71 * 8	
	dc.w	58 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 111: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	14 * 8	
	dc.w	11 * 8	
	dc.w	12 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 112: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	29 * 8	
	dc.w	43 * 8	
	dc.w	30 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 113: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	43 * 8	
	dc.w	57 * 8	
	dc.w	44 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 114: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	8 * 8	
	dc.w	29 * 8	
	dc.w	10 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 115: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	101 * 8	
	dc.w	88 * 8	
	dc.w	100 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 116: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	86 * 8	
	dc.w	100 * 8	
	dc.w	87 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 117: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	16 * 8	
	dc.w	13 * 8	
	dc.w	14 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 118: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	10 * 8	
	dc.w	7 * 8	
	dc.w	8 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 119: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	129 * 8	
	dc.w	117 * 8	
	dc.w	128 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 120: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	72 * 8	
	dc.w	88 * 8	
	dc.w	73 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 121: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	30 * 8	
	dc.w	44 * 8	
	dc.w	37 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 122: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	73 * 8	
	dc.w	88 * 8	
	dc.w	74 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 123: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	116 * 8	
	dc.w	100 * 8	
	dc.w	115 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 124: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	115 * 8	
	dc.w	107 * 8	
	dc.w	114 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 125: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	9 * 8	
	dc.w	31 * 8	
	dc.w	12 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 126: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	115 * 8	
	dc.w	127 * 8	
	dc.w	116 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 127: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	9 * 8	
	dc.w	12 * 8	
	dc.w	11 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 128: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	101 * 8	
	dc.w	116 * 8	
	dc.w	102 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 129: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	102 * 8	
	dc.w	117 * 8	
	dc.w	106 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 130: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	118 * 8	
	dc.w	106 * 8	
	dc.w	117 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 131: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	80 * 8	
	dc.w	58 * 8	
	dc.w	71 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 132: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	88 * 8	
	dc.w	72 * 8	
	dc.w	87 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 133: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	18 * 8	
	dc.w	15 * 8	
	dc.w	16 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 134: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	98 * 8	
	dc.w	84 * 8	
	dc.w	108 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 135: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	113 * 8	
	dc.w	126 * 8	
	dc.w	114 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 136: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	116 * 8	
	dc.w	128 * 8	
	dc.w	117 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 137: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	37 * 8	
	dc.w	9 * 8	
	dc.w	30 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 138: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	46 * 8	
	dc.w	31 * 8	
	dc.w	45 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 139: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	80 * 8	
	dc.w	87 * 8	
	dc.w	72 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 140: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	5 * 8	
	dc.w	8 * 8	
	dc.w	7 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 141: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	23 * 8	
	dc.w	1 * 8	
	dc.w	2 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 142: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	75 * 8	
	dc.w	61 * 8	
	dc.w	74 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 143: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	74 * 8	
	dc.w	89 * 8	
	dc.w	75 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 144: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	90 * 8	
	dc.w	75 * 8	
	dc.w	89 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 145: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	89 * 8	
	dc.w	102 * 8	
	dc.w	90 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 146: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	106 * 8	
	dc.w	90 * 8	
	dc.w	102 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 147: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	113 * 8	
	dc.w	108 * 8	
	dc.w	112 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 148: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	6 * 8	
	dc.w	3 * 8	
	dc.w	4 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 149: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	33 * 8	
	dc.w	14 * 8	
	dc.w	32 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 150: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	4 * 8	
	dc.w	1 * 8	
	dc.w	23 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 151: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	32 * 8	
	dc.w	47 * 8	
	dc.w	33 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 152: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	48 * 8	
	dc.w	33 * 8	
	dc.w	47 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 153: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	47 * 8	
	dc.w	61 * 8	
	dc.w	48 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 154: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	62 * 8	
	dc.w	48 * 8	
	dc.w	61 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 155: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	30 * 8	
	dc.w	10 * 8	
	dc.w	29 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 156: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	37 * 8	
	dc.w	45 * 8	
	dc.w	31 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 157: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	44 * 8	
	dc.w	58 * 8	
	dc.w	45 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 158: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	16 * 8	
	dc.w	34 * 8	
	dc.w	18 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 159: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	28 * 8	
	dc.w	6 * 8	
	dc.w	27 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 160: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	33 * 8	
	dc.w	48 * 8	
	dc.w	34 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 161: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	31 * 8	
	dc.w	46 * 8	
	dc.w	32 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 162: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	59 * 8	
	dc.w	73 * 8	
	dc.w	60 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 163: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	73 * 8	
	dc.w	59 * 8	
	dc.w	72 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 164: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	72 * 8	
	dc.w	58 * 8	
	dc.w	80 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 165: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	90 * 8	
	dc.w	103 * 8	
	dc.w	91 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 166: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	3 * 8	
	dc.w	6 * 8	
	dc.w	5 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 167: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	42 * 8	
	dc.w	28 * 8	
	dc.w	41 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 168: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	48 * 8	
	dc.w	62 * 8	
	dc.w	49 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 169: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	70 * 8	
	dc.w	85 * 8	
	dc.w	71 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 170: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	45 * 8	
	dc.w	37 * 8	
	dc.w	44 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 171: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	56 * 8	
	dc.w	42 * 8	
	dc.w	55 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 172: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	62 * 8	
	dc.w	76 * 8	
	dc.w	63 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 173: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	70 * 8	
	dc.w	56 * 8	
	dc.w	69 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 174: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	84 * 8	
	dc.w	98 * 8	
	dc.w	85 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 175: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	99 * 8	
	dc.w	85 * 8	
	dc.w	98 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 176: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	60 * 8	
	dc.w	46 * 8	
	dc.w	59 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 177: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	59 * 8	
	dc.w	45 * 8	
	dc.w	58 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 178: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	75 * 8	
	dc.w	90 * 8	
	dc.w	76 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 179: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	84 * 8	
	dc.w	69 * 8	
	dc.w	83 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 180: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	108 * 8	
	dc.w	113 * 8	
	dc.w	98 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 181: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	114 * 8	
	dc.w	98 * 8	
	dc.w	113 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 182: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	28 * 8	
	dc.w	42 * 8	
	dc.w	29 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 183: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	43 * 8	
	dc.w	29 * 8	
	dc.w	42 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 184: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	42 * 8	
	dc.w	56 * 8	
	dc.w	43 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 185: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	57 * 8	
	dc.w	43 * 8	
	dc.w	56 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 186: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	12 * 8	
	dc.w	32 * 8	
	dc.w	14 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 187: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	56 * 8	
	dc.w	70 * 8	
	dc.w	57 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 188: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	71 * 8	
	dc.w	57 * 8	
	dc.w	70 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 189: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	45 * 8	
	dc.w	59 * 8	
	dc.w	46 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 190: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	46 * 8	
	dc.w	60 * 8	
	dc.w	47 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 191: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	60 * 8	
	dc.w	74 * 8	
	dc.w	61 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 192: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	119 * 8	
	dc.w	131 * 8	
	dc.w	120 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 193: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	6 * 8	
	dc.w	28 * 8	
	dc.w	8 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 194: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	29 * 8	
	dc.w	8 * 8	
	dc.w	28 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 195: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	58 * 8	
	dc.w	72 * 8	
	dc.w	59 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 196: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	8 * 8	
	dc.w	5 * 8	
	dc.w	6 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 197: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	11 * 8	
	dc.w	14 * 8	
	dc.w	13 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 198: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	44 * 8	
	dc.w	30 * 8	
	dc.w	43 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 199: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	58 * 8	
	dc.w	44 * 8	
	dc.w	57 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 200: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	117 * 8	
	dc.w	129 * 8	
	dc.w	118 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 201: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	17 * 8	
	dc.w	20 * 8	
	dc.w	19 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 202: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	130 * 8	
	dc.w	118 * 8	
	dc.w	129 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 203: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	110 * 8	
	dc.w	123 * 8	
	dc.w	111 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 204: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	36 * 8	
	dc.w	22 * 8	
	dc.w	35 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 205: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	78 * 8	
	dc.w	64 * 8	
	dc.w	77 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 206: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	81 * 8	
	dc.w	96 * 8	
	dc.w	82 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 207: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	104 * 8	
	dc.w	92 * 8	
	dc.w	105 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 208: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	109 * 8	
	dc.w	111 * 8	
	dc.w	96 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 209: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	14 * 8	
	dc.w	33 * 8	
	dc.w	16 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 210: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	51 * 8	
	dc.w	36 * 8	
	dc.w	50 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 211: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	61 * 8	
	dc.w	75 * 8	
	dc.w	62 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 212: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	85 * 8	
	dc.w	70 * 8	
	dc.w	84 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 213: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	67 * 8	
	dc.w	82 * 8	
	dc.w	68 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 214: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	93 * 8	
	dc.w	78 * 8	
	dc.w	92 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 215: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	95 * 8	
	dc.w	110 * 8	
	dc.w	109 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 216: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	2 * 8	
	dc.w	25 * 8	
	dc.w	23 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 217: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	25 * 8	
	dc.w	39 * 8	
	dc.w	26 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 218: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	39 * 8	
	dc.w	53 * 8	
	dc.w	40 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 219: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	65 * 8	
	dc.w	51 * 8	
	dc.w	64 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 220: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	53 * 8	
	dc.w	67 * 8	
	dc.w	54 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 221: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	15 * 8	
	dc.w	18 * 8	
	dc.w	17 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 222: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	22 * 8	
	dc.w	17 * 8	
	dc.w	18 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 223: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	118 * 8	
	dc.w	130 * 8	
	dc.w	119 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 224: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	2 * 8	
	dc.w	0 * 8	
	dc.w	21 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 225: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	119 * 8	
	dc.w	103 * 8	
	dc.w	118 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 226: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	0 * 8	
	dc.w	2 * 8	
	dc.w	1 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 227: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	1 * 8	
	dc.w	4 * 8	
	dc.w	3 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 228: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	13 * 8	
	dc.w	16 * 8	
	dc.w	15 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 229: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	121 * 8	
	dc.w	122 * 8	
	dc.w	110 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 230: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	34 * 8	
	dc.w	49 * 8	
	dc.w	35 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 231: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	94 * 8	
	dc.w	95 * 8	
	dc.w	81 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 232: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	95 * 8	
	dc.w	93 * 8	
	dc.w	104 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 233: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	109 * 8	
	dc.w	81 * 8	
	dc.w	95 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 234: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	104 * 8	
	dc.w	121 * 8	
	dc.w	95 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 235: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	21 * 8	
	dc.w	24 * 8	
	dc.w	2 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 236: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	24 * 8	
	dc.w	20 * 8	
	dc.w	36 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 237: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	38 * 8	
	dc.w	36 * 8	
	dc.w	51 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 238: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	52 * 8	
	dc.w	51 * 8	
	dc.w	65 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 239: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	79 * 8	
	dc.w	65 * 8	
	dc.w	78 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 240: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	66 * 8	
	dc.w	81 * 8	
	dc.w	67 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 241: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	24 * 8	
	dc.w	38 * 8	
	dc.w	25 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 242: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	38 * 8	
	dc.w	52 * 8	
	dc.w	39 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 243: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	52 * 8	
	dc.w	66 * 8	
	dc.w	53 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 244: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	94 * 8	
	dc.w	79 * 8	
	dc.w	93 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 245: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	26 * 8	
	dc.w	23 * 8	
	dc.w	25 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 246: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	25 * 8	
	dc.w	2 * 8	
	dc.w	24 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 247: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	122 * 8	
	dc.w	120 * 8	
	dc.w	131 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 248: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	53 * 8	
	dc.w	39 * 8	
	dc.w	52 * 8	
	DC.L	$ffff0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face 249: Segments in Face
	DC.W	$0001			;* color  (GOURAUD)
	dc.w	92 * 8	
	dc.w	104 * 8	
	dc.w	93 * 8	

	;*===============================================================*
	;*	VERTEX DATA
	;*===============================================================*
.vertlist:
		;* vertex:	0
	DC.L	$FFADFFE0		;* X |Y  (16.0,16.0)	(-83,-32)
	DC.L	$FF850000		;* Z |Nx (16.0,0.16)	(-123)
	DC.L	$3D89EE6B		;* Ny|Nz (0.16,0.16)

		;* vertex:	1
	DC.L	$FFAFFFE0		;* X |Y  (16.0,16.0)	(-81,-32)
	DC.L	$FF851674		;* Z |Nx (16.0,0.16)	(-123)
	DC.L	$39A7EFA3		;* Ny|Nz (0.16,0.16)

		;* vertex:	2
	DC.L	$FFAFFFDE		;* X |Y  (16.0,16.0)	(-81,-34)
	DC.L	$FF7E0962		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$3E52F4E1		;* Ny|Nz (0.16,0.16)

		;* vertex:	3
	DC.L	$FFBAFFDD		;* X |Y  (16.0,16.0)	(-70,-35)
	DC.L	$FF8D31A8		;* Z |Nx (16.0,0.16)	(-115)
	DC.L	$22FDEBDB		;* Ny|Nz (0.16,0.16)

		;* vertex:	4
	DC.L	$FFB6FFDB		;* X |Y  (16.0,16.0)	(-74,-37)
	DC.L	$FF82290C		;* Z |Nx (16.0,0.16)	(-126)
	DC.L	$2EB5F0DA		;* Ny|Nz (0.16,0.16)

		;* vertex:	5
	DC.L	$FFBCFFDD		;* X |Y  (16.0,16.0)	(-68,-35)
	DC.L	$FF963CDC		;* Z |Nx (16.0,0.16)	(-106)
	DC.L	$13C40133		;* Ny|Nz (0.16,0.16)

		;* vertex:	6
	DC.L	$FFBBFFD9		;* X |Y  (16.0,16.0)	(-69,-39)
	DC.L	$FF8B3946		;* Z |Nx (16.0,0.16)	(-117)
	DC.L	$1879F14B		;* Ny|Nz (0.16,0.16)

		;* vertex:	7
	DC.L	$FFB8FFD7		;* X |Y  (16.0,16.0)	(-72,-41)
	DC.L	$FFA22B3E		;* Z |Nx (16.0,0.16)	(-94)
	DC.L	$1F96230B		;* Ny|Nz (0.16,0.16)

		;* vertex:	8
	DC.L	$FFBEFFD6		;* X |Y  (16.0,16.0)	(-66,-42)
	DC.L	$FF973DCF		;* Z |Nx (16.0,0.16)	(-105)
	DC.L	$0DBC0951		;* Ny|Nz (0.16,0.16)

		;* vertex:	9
	DC.L	$FFACFFD3		;* X |Y  (16.0,16.0)	(-84,-45)
	DC.L	$FFAA076F		;* Z |Nx (16.0,0.16)	(-86)
	DC.L	$22F83515		;* Ny|Nz (0.16,0.16)

		;* vertex:	10
	DC.L	$FFB9FFD5		;* X |Y  (16.0,16.0)	(-71,-43)
	DC.L	$FFA32E2E		;* Z |Nx (16.0,0.16)	(-93)
	DC.L	$1AB5235A		;* Ny|Nz (0.16,0.16)

		;* vertex:	11
	DC.L	$FFA5FFD7		;* X |Y  (16.0,16.0)	(-91,-41)
	DC.L	$FFA4DFBC		;* Z |Nx (16.0,0.16)	(-92)
	DC.L	$24F42918		;* Ny|Nz (0.16,0.16)

		;* vertex:	12
	DC.L	$FFA2FFD3		;* X |Y  (16.0,16.0)	(-94,-45)
	DC.L	$FFA7DE96		;* Z |Nx (16.0,0.16)	(-89)
	DC.L	$20072C32		;* Ny|Nz (0.16,0.16)

		;* vertex:	13
	DC.L	$FF9EFFDE		;* X |Y  (16.0,16.0)	(-98,-34)
	DC.L	$FF9BC47D		;* Z |Nx (16.0,0.16)	(-101)
	DC.L	$156909C8		;* Ny|Nz (0.16,0.16)

		;* vertex:	14
	DC.L	$FF9DFFD5		;* X |Y  (16.0,16.0)	(-99,-43)
	DC.L	$FF9DCAC4		;* Z |Nx (16.0,0.16)	(-99)
	DC.L	$1ED411A4		;* Ny|Nz (0.16,0.16)

		;* vertex:	15
	DC.L	$FFA2FFDE		;* X |Y  (16.0,16.0)	(-94,-34)
	DC.L	$FF8CD39A		;* Z |Nx (16.0,0.16)	(-116)
	DC.L	$2B26EFCA		;* Ny|Nz (0.16,0.16)

		;* vertex:	16
	DC.L	$FF9FFFD9		;* X |Y  (16.0,16.0)	(-97,-39)
	DC.L	$FF8AC9F8		;* Z |Nx (16.0,0.16)	(-118)
	DC.L	$2126F731		;* Ny|Nz (0.16,0.16)

		;* vertex:	17
	DC.L	$FFA9FFE0		;* X |Y  (16.0,16.0)	(-87,-32)
	DC.L	$FF86E996		;* Z |Nx (16.0,0.16)	(-122)
	DC.L	$3A3FF1D5		;* Ny|Nz (0.16,0.16)

		;* vertex:	18
	DC.L	$FFA4FFDC		;* X |Y  (16.0,16.0)	(-92,-36)
	DC.L	$FF82D7BB		;* Z |Nx (16.0,0.16)	(-126)
	DC.L	$305BF45B		;* Ny|Nz (0.16,0.16)

		;* vertex:	19
	DC.L	$FFADFFE0		;* X |Y  (16.0,16.0)	(-83,-32)
	DC.L	$FF860000		;* Z |Nx (16.0,0.16)	(-122)
	DC.L	$3E16F07B		;* Ny|Nz (0.16,0.16)

		;* vertex:	20
	DC.L	$FFA8FFDE		;* X |Y  (16.0,16.0)	(-88,-34)
	DC.L	$FF7EEEA2		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$3C6DF40F		;* Ny|Nz (0.16,0.16)

		;* vertex:	21
	DC.L	$FFADFFDE		;* X |Y  (16.0,16.0)	(-83,-34)
	DC.L	$FF7E0000		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$3ECFF3BA		;* Ny|Nz (0.16,0.16)

		;* vertex:	22
	DC.L	$FFA6FFDD		;* X |Y  (16.0,16.0)	(-90,-35)
	DC.L	$FF80DD03		;* Z |Nx (16.0,0.16)	(-128)
	DC.L	$34C0F694		;* Ny|Nz (0.16,0.16)

		;* vertex:	23
	DC.L	$FFB2FFDD		;* X |Y  (16.0,16.0)	(-78,-35)
	DC.L	$FF7F1DB3		;* Z |Nx (16.0,0.16)	(-129)
	DC.L	$37E8F69A		;* Ny|Nz (0.16,0.16)

		;* vertex:	24
	DC.L	$FFADFFDD		;* X |Y  (16.0,16.0)	(-83,-35)
	DC.L	$FF76FB03		;* Z |Nx (16.0,0.16)	(-138)
	DC.L	$36CFDF57		;* Ny|Nz (0.16,0.16)

		;* vertex:	25
	DC.L	$FFB0FFDD		;* X |Y  (16.0,16.0)	(-80,-35)
	DC.L	$FF761816		;* Z |Nx (16.0,0.16)	(-138)
	DC.L	$2C1BD860		;* Ny|Nz (0.16,0.16)

		;* vertex:	26
	DC.L	$FFB4FFDB		;* X |Y  (16.0,16.0)	(-76,-37)
	DC.L	$FF7A2FC8		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$2116E534		;* Ny|Nz (0.16,0.16)

		;* vertex:	27
	DC.L	$FFB9FFD7		;* X |Y  (16.0,16.0)	(-71,-41)
	DC.L	$FF7F35EA		;* Z |Nx (16.0,0.16)	(-129)
	DC.L	$17FDE73C		;* Ny|Nz (0.16,0.16)

		;* vertex:	28
	DC.L	$FFBDFFD2		;* X |Y  (16.0,16.0)	(-67,-46)
	DC.L	$FF8A3CFA		;* Z |Nx (16.0,0.16)	(-118)
	DC.L	$1079F5B4		;* Ny|Nz (0.16,0.16)

		;* vertex:	29
	DC.L	$FFBDFFD0		;* X |Y  (16.0,16.0)	(-67,-48)
	DC.L	$FF9939AF		;* Z |Nx (16.0,0.16)	(-103)
	DC.L	$1A9907CF		;* Ny|Nz (0.16,0.16)

		;* vertex:	30
	DC.L	$FFBAFFD1		;* X |Y  (16.0,16.0)	(-70,-47)
	DC.L	$FFA52AE1		;* Z |Nx (16.0,0.16)	(-91)
	DC.L	$1B0A2710		;* Ny|Nz (0.16,0.16)

		;* vertex:	31
	DC.L	$FFA3FFD1		;* X |Y  (16.0,16.0)	(-93,-47)
	DC.L	$FFA8E2CF		;* Z |Nx (16.0,0.16)	(-88)
	DC.L	$0B6337CD		;* Ny|Nz (0.16,0.16)

		;* vertex:	32
	DC.L	$FF9AFFD0		;* X |Y  (16.0,16.0)	(-102,-48)
	DC.L	$FF9FC8F3		;* Z |Nx (16.0,0.16)	(-97)
	DC.L	$0FA81CA3		;* Ny|Nz (0.16,0.16)

		;* vertex:	33
	DC.L	$FF9CFFD4		;* X |Y  (16.0,16.0)	(-100,-44)
	DC.L	$FF89C440		;* Z |Nx (16.0,0.16)	(-119)
	DC.L	$164FFAB7		;* Ny|Nz (0.16,0.16)

		;* vertex:	34
	DC.L	$FFA0FFD8		;* X |Y  (16.0,16.0)	(-96,-40)
	DC.L	$FF7FC999		;* Z |Nx (16.0,0.16)	(-129)
	DC.L	$1E2CF0FB		;* Ny|Nz (0.16,0.16)

		;* vertex:	35
	DC.L	$FFA3FFDA		;* X |Y  (16.0,16.0)	(-93,-38)
	DC.L	$FF7AD1EB		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$25E6E8D9		;* Ny|Nz (0.16,0.16)

		;* vertex:	36
	DC.L	$FFA7FFDC		;* X |Y  (16.0,16.0)	(-89,-36)
	DC.L	$FF77DD75		;* Z |Nx (16.0,0.16)	(-137)
	DC.L	$2051D4E5		;* Ny|Nz (0.16,0.16)

		;* vertex:	37
	DC.L	$FFADFFD1		;* X |Y  (16.0,16.0)	(-83,-47)
	DC.L	$FFAB03A9		;* Z |Nx (16.0,0.16)	(-85)
	DC.L	$0F4C3E09		;* Ny|Nz (0.16,0.16)

		;* vertex:	38
	DC.L	$FFACFFD2		;* X |Y  (16.0,16.0)	(-84,-46)
	DC.L	$FF74F968		;* Z |Nx (16.0,0.16)	(-140)
	DC.L	$0942C105		;* Ny|Nz (0.16,0.16)

		;* vertex:	39
	DC.L	$FFB2FFD2		;* X |Y  (16.0,16.0)	(-78,-46)
	DC.L	$FF7521AA		;* Z |Nx (16.0,0.16)	(-139)
	DC.L	$064CC9F0		;* Ny|Nz (0.16,0.16)

		;* vertex:	40
	DC.L	$FFB5FFD1		;* X |Y  (16.0,16.0)	(-75,-47)
	DC.L	$FF792F68		;* Z |Nx (16.0,0.16)	(-135)
	DC.L	$0915D5FA		;* Ny|Nz (0.16,0.16)

		;* vertex:	41
	DC.L	$FFBAFFCF		;* X |Y  (16.0,16.0)	(-70,-49)
	DC.L	$FF7E3682		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$0B1AE05C		;* Ny|Nz (0.16,0.16)

		;* vertex:	42
	DC.L	$FFBFFFCE		;* X |Y  (16.0,16.0)	(-65,-50)
	DC.L	$FF893D1B		;* Z |Nx (16.0,0.16)	(-119)
	DC.L	$0DCFF2ED		;* Ny|Nz (0.16,0.16)

		;* vertex:	43
	DC.L	$FFC0FFCE		;* X |Y  (16.0,16.0)	(-64,-50)
	DC.L	$FF993A73		;* Z |Nx (16.0,0.16)	(-103)
	DC.L	$18D907DD		;* Ny|Nz (0.16,0.16)

		;* vertex:	44
	DC.L	$FFBAFFCF		;* X |Y  (16.0,16.0)	(-70,-49)
	DC.L	$FFA52E99		;* Z |Nx (16.0,0.16)	(-91)
	DC.L	$05872B84		;* Ny|Nz (0.16,0.16)

		;* vertex:	45
	DC.L	$FFADFFCF		;* X |Y  (16.0,16.0)	(-83,-49)
	DC.L	$FFAB05C4		;* Z |Nx (16.0,0.16)	(-85)
	DC.L	$028C3FB0		;* Ny|Nz (0.16,0.16)

		;* vertex:	46
	DC.L	$FFA3FFCE		;* X |Y  (16.0,16.0)	(-93,-50)
	DC.L	$FFA9E3F1		;* Z |Nx (16.0,0.16)	(-87)
	DC.L	$089438E0		;* Ny|Nz (0.16,0.16)

		;* vertex:	47
	DC.L	$FF9AFFCE		;* X |Y  (16.0,16.0)	(-102,-50)
	DC.L	$FF9FC2A6		;* Z |Nx (16.0,0.16)	(-97)
	DC.L	$07BE107C		;* Ny|Nz (0.16,0.16)

		;* vertex:	48
	DC.L	$FF9BFFD0		;* X |Y  (16.0,16.0)	(-101,-48)
	DC.L	$FF89C27E		;* Z |Nx (16.0,0.16)	(-119)
	DC.L	$0ECCF653		;* Ny|Nz (0.16,0.16)

		;* vertex:	49
	DC.L	$FF9FFFD1		;* X |Y  (16.0,16.0)	(-97,-47)
	DC.L	$FF7DC829		;* Z |Nx (16.0,0.16)	(-131)
	DC.L	$0B3DE2D3		;* Ny|Nz (0.16,0.16)

		;* vertex:	50
	DC.L	$FFA3FFD2		;* X |Y  (16.0,16.0)	(-93,-46)
	DC.L	$FF7AD4EC		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$0469D0E1		;* Ny|Nz (0.16,0.16)

		;* vertex:	51
	DC.L	$FFA7FFD2		;* X |Y  (16.0,16.0)	(-89,-46)
	DC.L	$FF76DBAE		;* Z |Nx (16.0,0.16)	(-138)
	DC.L	$063ACBAD		;* Ny|Nz (0.16,0.16)

		;* vertex:	52
	DC.L	$FFABFFCA		;* X |Y  (16.0,16.0)	(-85,-54)
	DC.L	$FF73F84C		;* Z |Nx (16.0,0.16)	(-141)
	DC.L	$0E75C222		;* Ny|Nz (0.16,0.16)

		;* vertex:	53
	DC.L	$FFB2FFCA		;* X |Y  (16.0,16.0)	(-78,-54)
	DC.L	$FF7525A2		;* Z |Nx (16.0,0.16)	(-139)
	DC.L	$0039CC3C		;* Ny|Nz (0.16,0.16)

		;* vertex:	54
	DC.L	$FFB6FFCA		;* X |Y  (16.0,16.0)	(-74,-54)
	DC.L	$FF782AF5		;* Z |Nx (16.0,0.16)	(-136)
	DC.L	$03DCD0B8		;* Ny|Nz (0.16,0.16)

		;* vertex:	55
	DC.L	$FFBAFFCA		;* X |Y  (16.0,16.0)	(-70,-54)
	DC.L	$FF7E3707		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$09A6E0C9		;* Ny|Nz (0.16,0.16)

		;* vertex:	56
	DC.L	$FFBEFFCB		;* X |Y  (16.0,16.0)	(-66,-53)
	DC.L	$FF893DF7		;* Z |Nx (16.0,0.16)	(-119)
	DC.L	$06B3F179		;* Ny|Nz (0.16,0.16)

		;* vertex:	57
	DC.L	$FFC1FFCB		;* X |Y  (16.0,16.0)	(-63,-53)
	DC.L	$FF9A3D11		;* Z |Nx (16.0,0.16)	(-102)
	DC.L	$10210A4F		;* Ny|Nz (0.16,0.16)

		;* vertex:	58
	DC.L	$FFBAFFCC		;* X |Y  (16.0,16.0)	(-70,-52)
	DC.L	$FFA527AA		;* Z |Nx (16.0,0.16)	(-91)
	DC.L	$09D13141		;* Ny|Nz (0.16,0.16)

		;* vertex:	59
	DC.L	$FFACFFCD		;* X |Y  (16.0,16.0)	(-84,-51)
	DC.L	$FFABFE5A		;* Z |Nx (16.0,0.16)	(-85)
	DC.L	$08B53F62		;* Ny|Nz (0.16,0.16)

		;* vertex:	60
	DC.L	$FFA3FFCC		;* X |Y  (16.0,16.0)	(-93,-52)
	DC.L	$FFA9DDD0		;* Z |Nx (16.0,0.16)	(-87)
	DC.L	$0B4F34E8		;* Ny|Nz (0.16,0.16)

		;* vertex:	61
	DC.L	$FF9AFFCC		;* X |Y  (16.0,16.0)	(-102,-52)
	DC.L	$FFA0C498		;* Z |Nx (16.0,0.16)	(-96)
	DC.L	$0F2B1259		;* Ny|Nz (0.16,0.16)

		;* vertex:	62
	DC.L	$FF9AFFCD		;* X |Y  (16.0,16.0)	(-102,-51)
	DC.L	$FF88C348		;* Z |Nx (16.0,0.16)	(-120)
	DC.L	$0C53EFF7		;* Ny|Nz (0.16,0.16)

		;* vertex:	63
	DC.L	$FF9FFFCD		;* X |Y  (16.0,16.0)	(-97,-51)
	DC.L	$FF7DCFC1		;* Z |Nx (16.0,0.16)	(-131)
	DC.L	$0383D61A		;* Ny|Nz (0.16,0.16)

		;* vertex:	64
	DC.L	$FFA3FFCB		;* X |Y  (16.0,16.0)	(-93,-53)
	DC.L	$FF79D4ED		;* Z |Nx (16.0,0.16)	(-135)
	DC.L	$FE8AD0B1		;* Ny|Nz (0.16,0.16)

		;* vertex:	65
	DC.L	$FFA6FFCA		;* X |Y  (16.0,16.0)	(-90,-54)
	DC.L	$FF76D353		;* Z |Nx (16.0,0.16)	(-138)
	DC.L	$FCABD24D		;* Ny|Nz (0.16,0.16)

		;* vertex:	66
	DC.L	$FFABFFC3		;* X |Y  (16.0,16.0)	(-85,-61)
	DC.L	$FF6F2CB8		;* Z |Nx (16.0,0.16)	(-145)
	DC.L	$F207D467		;* Ny|Nz (0.16,0.16)

		;* vertex:	67
	DC.L	$FFB1FFC6		;* X |Y  (16.0,16.0)	(-79,-58)
	DC.L	$FF761F8A		;* Z |Nx (16.0,0.16)	(-138)
	DC.L	$ED0BCBA4		;* Ny|Nz (0.16,0.16)

		;* vertex:	68
	DC.L	$FFB7FFC6		;* X |Y  (16.0,16.0)	(-73,-58)
	DC.L	$FF7827AD		;* Z |Nx (16.0,0.16)	(-136)
	DC.L	$FE3DCDD1		;* Ny|Nz (0.16,0.16)

		;* vertex:	69
	DC.L	$FFBCFFC6		;* X |Y  (16.0,16.0)	(-68,-58)
	DC.L	$FF7D37E7		;* Z |Nx (16.0,0.16)	(-131)
	DC.L	$0767E1BD		;* Ny|Nz (0.16,0.16)

		;* vertex:	70
	DC.L	$FFBFFFC6		;* X |Y  (16.0,16.0)	(-65,-58)
	DC.L	$FF883E2B		;* Z |Nx (16.0,0.16)	(-120)
	DC.L	$0931F3E9		;* Ny|Nz (0.16,0.16)

		;* vertex:	71
	DC.L	$FFC2FFC7		;* X |Y  (16.0,16.0)	(-62,-57)
	DC.L	$FF9B3BB2		;* Z |Nx (16.0,0.16)	(-101)
	DC.L	$0DB6128D		;* Ny|Nz (0.16,0.16)

		;* vertex:	72
	DC.L	$FFADFFC7		;* X |Y  (16.0,16.0)	(-83,-57)
	DC.L	$FFAD0610		;* Z |Nx (16.0,0.16)	(-83)
	DC.L	$17213B5D		;* Ny|Nz (0.16,0.16)

		;* vertex:	73
	DC.L	$FFA2FFC7		;* X |Y  (16.0,16.0)	(-94,-57)
	DC.L	$FFAAE492		;* Z |Nx (16.0,0.16)	(-86)
	DC.L	$146B3618		;* Ny|Nz (0.16,0.16)

		;* vertex:	74
	DC.L	$FF99FFC7		;* X |Y  (16.0,16.0)	(-103,-57)
	DC.L	$FFA1CD00		;* Z |Nx (16.0,0.16)	(-95)
	DC.L	$12272222		;* Ny|Nz (0.16,0.16)

		;* vertex:	75
	DC.L	$FF99FFC8		;* X |Y  (16.0,16.0)	(-103,-56)
	DC.L	$FF89C1F4		;* Z |Nx (16.0,0.16)	(-119)
	DC.L	$0905F32C		;* Ny|Nz (0.16,0.16)

		;* vertex:	76
	DC.L	$FF9EFFC6		;* X |Y  (16.0,16.0)	(-98,-58)
	DC.L	$FF7DCAB5		;* Z |Nx (16.0,0.16)	(-131)
	DC.L	$FF1FDC93		;* Ny|Nz (0.16,0.16)

		;* vertex:	77
	DC.L	$FFA3FFC6		;* X |Y  (16.0,16.0)	(-93,-58)
	DC.L	$FF79D7DA		;* Z |Nx (16.0,0.16)	(-135)
	DC.L	$FDEFCE35		;* Ny|Nz (0.16,0.16)

		;* vertex:	78
	DC.L	$FFA7FFC7		;* X |Y  (16.0,16.0)	(-89,-57)
	DC.L	$FF77D898		;* Z |Nx (16.0,0.16)	(-137)
	DC.L	$EF42D070		;* Ny|Nz (0.16,0.16)

		;* vertex:	79
	DC.L	$FFACFFC4		;* X |Y  (16.0,16.0)	(-84,-60)
	DC.L	$FF6FC938		;* Z |Nx (16.0,0.16)	(-145)
	DC.L	$F880DFC6		;* Ny|Nz (0.16,0.16)

		;* vertex:	80
	DC.L	$FFBBFFC7		;* X |Y  (16.0,16.0)	(-69,-57)
	DC.L	$FFA62874		;* Z |Nx (16.0,0.16)	(-90)
	DC.L	$15672CBB		;* Ny|Nz (0.16,0.16)

		;* vertex:	81
	DC.L	$FFAFFFBD		;* X |Y  (16.0,16.0)	(-81,-67)
	DC.L	$FF7A1CAF		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$F935C732		;* Ny|Nz (0.16,0.16)

		;* vertex:	82
	DC.L	$FFB5FFBD		;* X |Y  (16.0,16.0)	(-75,-67)
	DC.L	$FF7A1CAB		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$F5DFC7B0		;* Ny|Nz (0.16,0.16)

		;* vertex:	83
	DC.L	$FFBAFFBE		;* X |Y  (16.0,16.0)	(-70,-66)
	DC.L	$FF7F312A		;* Z |Nx (16.0,0.16)	(-129)
	DC.L	$F43CD8C2		;* Ny|Nz (0.16,0.16)

		;* vertex:	84
	DC.L	$FFC0FFBF		;* X |Y  (16.0,16.0)	(-64,-65)
	DC.L	$FF893D00		;* Z |Nx (16.0,0.16)	(-119)
	DC.L	$0192ECB5		;* Ny|Nz (0.16,0.16)

		;* vertex:	85
	DC.L	$FFC2FFC2		;* X |Y  (16.0,16.0)	(-62,-62)
	DC.L	$FF9C3EAC		;* Z |Nx (16.0,0.16)	(-100)
	DC.L	$0A320800		;* Ny|Nz (0.16,0.16)

		;* vertex:	86
	DC.L	$FFBCFFC2		;* X |Y  (16.0,16.0)	(-68,-62)
	DC.L	$FFA827F5		;* Z |Nx (16.0,0.16)	(-88)
	DC.L	$12C62E54		;* Ny|Nz (0.16,0.16)

		;* vertex:	87
	DC.L	$FFAEFFC2		;* X |Y  (16.0,16.0)	(-82,-62)
	DC.L	$FFAF06AF		;* Z |Nx (16.0,0.16)	(-81)
	DC.L	$13FC3C6E		;* Ny|Nz (0.16,0.16)

		;* vertex:	88
	DC.L	$FFA2FFC3		;* X |Y  (16.0,16.0)	(-94,-61)
	DC.L	$FFACE496		;* Z |Nx (16.0,0.16)	(-84)
	DC.L	$138C366D		;* Ny|Nz (0.16,0.16)

		;* vertex:	89
	DC.L	$FF98FFC2		;* X |Y  (16.0,16.0)	(-104,-62)
	DC.L	$FFA2C59B		;* Z |Nx (16.0,0.16)	(-94)
	DC.L	$0D68167E		;* Ny|Nz (0.16,0.16)

		;* vertex:	90
	DC.L	$FF98FFC2		;* X |Y  (16.0,16.0)	(-104,-62)
	DC.L	$FF8AC347		;* Z |Nx (16.0,0.16)	(-118)
	DC.L	$08EBEDDF		;* Ny|Nz (0.16,0.16)

		;* vertex:	91
	DC.L	$FF9FFFBE		;* X |Y  (16.0,16.0)	(-97,-66)
	DC.L	$FF7FCCA6		;* Z |Nx (16.0,0.16)	(-129)
	DC.L	$0232D9DF		;* Ny|Nz (0.16,0.16)

		;* vertex:	92
	DC.L	$FFA2FFBD		;* X |Y  (16.0,16.0)	(-94,-67)
	DC.L	$FF7ADE00		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$04EDCA02		;* Ny|Nz (0.16,0.16)

		;* vertex:	93
	DC.L	$FFAAFFBD		;* X |Y  (16.0,16.0)	(-86,-67)
	DC.L	$FF79D753		;* Z |Nx (16.0,0.16)	(-135)
	DC.L	$FA95CEE4		;* Ny|Nz (0.16,0.16)

		;* vertex:	94
	DC.L	$FFABFFBC		;* X |Y  (16.0,16.0)	(-85,-68)
	DC.L	$FF76EF6A		;* Z |Nx (16.0,0.16)	(-138)
	DC.L	$E403C8E4		;* Ny|Nz (0.16,0.16)

		;* vertex:	95
	DC.L	$FFACFFB7		;* X |Y  (16.0,16.0)	(-84,-73)
	DC.L	$FF77FC24		;* Z |Nx (16.0,0.16)	(-137)
	DC.L	$FA30C062		;* Ny|Nz (0.16,0.16)

		;* vertex:	96
	DC.L	$FFB6FFB6		;* X |Y  (16.0,16.0)	(-74,-74)
	DC.L	$FF7A1F41		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$FEDBC82B		;* Ny|Nz (0.16,0.16)

		;* vertex:	97
	DC.L	$FFBBFFB8		;* X |Y  (16.0,16.0)	(-69,-72)
	DC.L	$FF8033CC		;* Z |Nx (16.0,0.16)	(-128)
	DC.L	$FC20DA9D		;* Ny|Nz (0.16,0.16)

		;* vertex:	98
	DC.L	$FFC3FFBB		;* X |Y  (16.0,16.0)	(-61,-69)
	DC.L	$FF9B3FBC		;* Z |Nx (16.0,0.16)	(-101)
	DC.L	$003705D0		;* Ny|Nz (0.16,0.16)

		;* vertex:	99
	DC.L	$FFBFFFBD		;* X |Y  (16.0,16.0)	(-65,-67)
	DC.L	$FFA83129		;* Z |Nx (16.0,0.16)	(-88)
	DC.L	$049B28B7		;* Ny|Nz (0.16,0.16)

		;* vertex:	100
	DC.L	$FFB0FFBD		;* X |Y  (16.0,16.0)	(-80,-67)
	DC.L	$FFB006E8		;* Z |Nx (16.0,0.16)	(-80)
	DC.L	$05D43F5B		;* Ny|Nz (0.16,0.16)

		;* vertex:	101
	DC.L	$FFA1FFBC		;* X |Y  (16.0,16.0)	(-95,-68)
	DC.L	$FFAEDD76		;* Z |Nx (16.0,0.16)	(-82)
	DC.L	$05F2358C		;* Ny|Nz (0.16,0.16)

		;* vertex:	102
	DC.L	$FF97FFBB		;* X |Y  (16.0,16.0)	(-105,-69)
	DC.L	$FFA2C40B		;* Z |Nx (16.0,0.16)	(-94)
	DC.L	$048E15E8		;* Ny|Nz (0.16,0.16)

		;* vertex:	103
	DC.L	$FF9DFFB9		;* X |Y  (16.0,16.0)	(-99,-71)
	DC.L	$FF7FCBDD		;* Z |Nx (16.0,0.16)	(-129)
	DC.L	$053BDB42		;* Ny|Nz (0.16,0.16)

		;* vertex:	104
	DC.L	$FFA6FFB7		;* X |Y  (16.0,16.0)	(-90,-73)
	DC.L	$FF78F456		;* Z |Nx (16.0,0.16)	(-136)
	DC.L	$FE1CC11A		;* Ny|Nz (0.16,0.16)

		;* vertex:	105
	DC.L	$FFA1FFB7		;* X |Y  (16.0,16.0)	(-95,-73)
	DC.L	$FF7ADAFF		;* Z |Nx (16.0,0.16)	(-134)
	DC.L	$FB8ECBFA		;* Ny|Nz (0.16,0.16)

		;* vertex:	106
	DC.L	$FF95FFB9		;* X |Y  (16.0,16.0)	(-107,-71)
	DC.L	$FF8DC19E		;* Z |Nx (16.0,0.16)	(-115)
	DC.L	$02E3F203		;* Ny|Nz (0.16,0.16)

		;* vertex:	107
	DC.L	$FFBAFFBB		;* X |Y  (16.0,16.0)	(-70,-69)
	DC.L	$FFAA1DDB		;* Z |Nx (16.0,0.16)	(-86)
	DC.L	$FEA43897		;* Ny|Nz (0.16,0.16)

		;* vertex:	108
	DC.L	$FFC1FFBB		;* X |Y  (16.0,16.0)	(-63,-69)
	DC.L	$FF8C3D06		;* Z |Nx (16.0,0.16)	(-116)
	DC.L	$FF9CECB8		;* Ny|Nz (0.16,0.16)

		;* vertex:	109
	DC.L	$FFB1FFB6		;* X |Y  (16.0,16.0)	(-79,-74)
	DC.L	$FF78158F		;* Z |Nx (16.0,0.16)	(-136)
	DC.L	$FEDCC3C1		;* Ny|Nz (0.16,0.16)

		;* vertex:	110
	DC.L	$FFB0FFA9		;* X |Y  (16.0,16.0)	(-80,-87)
	DC.L	$FF7B079C		;* Z |Nx (16.0,0.16)	(-133)
	DC.L	$DD63CAB6		;* Ny|Nz (0.16,0.16)

		;* vertex:	111
	DC.L	$FFB5FFA9		;* X |Y  (16.0,16.0)	(-75,-87)
	DC.L	$FF7E248C		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$E376D3E5		;* Ny|Nz (0.16,0.16)

		;* vertex:	112
	DC.L	$FFBCFFAC		;* X |Y  (16.0,16.0)	(-68,-84)
	DC.L	$FF843539		;* Z |Nx (16.0,0.16)	(-124)
	DC.L	$EA43E3E3		;* Ny|Nz (0.16,0.16)

		;* vertex:	113
	DC.L	$FFC3FFB2		;* X |Y  (16.0,16.0)	(-61,-78)
	DC.L	$FF943DB9		;* Z |Nx (16.0,0.16)	(-108)
	DC.L	$EF1CFF04		;* Ny|Nz (0.16,0.16)

		;* vertex:	114
	DC.L	$FFBDFFB4		;* X |Y  (16.0,16.0)	(-67,-76)
	DC.L	$FFA72DA5		;* Z |Nx (16.0,0.16)	(-89)
	DC.L	$EA9F276F		;* Ny|Nz (0.16,0.16)

		;* vertex:	115
	DC.L	$FFAFFFB4		;* X |Y  (16.0,16.0)	(-81,-76)
	DC.L	$FFB00EEE		;* Z |Nx (16.0,0.16)	(-80)
	DC.L	$F0583C3B		;* Ny|Nz (0.16,0.16)

		;* vertex:	116
	DC.L	$FFA0FFB3		;* X |Y  (16.0,16.0)	(-96,-77)
	DC.L	$FFACDEF4		;* Z |Nx (16.0,0.16)	(-84)
	DC.L	$ED293377		;* Ny|Nz (0.16,0.16)

		;* vertex:	117
	DC.L	$FF95FFB2		;* X |Y  (16.0,16.0)	(-107,-78)
	DC.L	$FF9AC3E9		;* Z |Nx (16.0,0.16)	(-102)
	DC.L	$ECDA0ADE		;* Ny|Nz (0.16,0.16)

		;* vertex:	118
	DC.L	$FF9BFFAD		;* X |Y  (16.0,16.0)	(-101,-83)
	DC.L	$FF84C878		;* Z |Nx (16.0,0.16)	(-124)
	DC.L	$EA61E8AA		;* Ny|Nz (0.16,0.16)

		;* vertex:	119
	DC.L	$FFA0FFAA		;* X |Y  (16.0,16.0)	(-96,-86)
	DC.L	$FF7ED666		;* Z |Nx (16.0,0.16)	(-130)
	DC.L	$E3C5D867		;* Ny|Nz (0.16,0.16)

		;* vertex:	120
	DC.L	$FFA5FFAA		;* X |Y  (16.0,16.0)	(-91,-86)
	DC.L	$FF7BF1D0		;* Z |Nx (16.0,0.16)	(-133)
	DC.L	$DEE0CB1D		;* Ny|Nz (0.16,0.16)

		;* vertex:	121
	DC.L	$FFABFFA9		;* X |Y  (16.0,16.0)	(-85,-87)
	DC.L	$FF7CFB23		;* Z |Nx (16.0,0.16)	(-132)
	DC.L	$E096C875		;* Ny|Nz (0.16,0.16)

		;* vertex:	122
	DC.L	$FFABFFA0		;* X |Y  (16.0,16.0)	(-85,-96)
	DC.L	$FF86FA87		;* Z |Nx (16.0,0.16)	(-122)
	DC.L	$C88FE081		;* Ny|Nz (0.16,0.16)

		;* vertex:	123
	DC.L	$FFB0FF9F		;* X |Y  (16.0,16.0)	(-80,-97)
	DC.L	$FF870B09		;* Z |Nx (16.0,0.16)	(-121)
	DC.L	$C69AE5F0		;* Ny|Nz (0.16,0.16)

		;* vertex:	124
	DC.L	$FFB6FFA0		;* X |Y  (16.0,16.0)	(-74,-96)
	DC.L	$FF8B2116		;* Z |Nx (16.0,0.16)	(-117)
	DC.L	$CBA9EFD5		;* Ny|Nz (0.16,0.16)

		;* vertex:	125
	DC.L	$FFBBFFA3		;* X |Y  (16.0,16.0)	(-69,-93)
	DC.L	$FF912BCD		;* Z |Nx (16.0,0.16)	(-111)
	DC.L	$D1A9FA86		;* Ny|Nz (0.16,0.16)

		;* vertex:	126
	DC.L	$FFBBFFA3		;* X |Y  (16.0,16.0)	(-69,-93)
	DC.L	$FF9A27FB		;* Z |Nx (16.0,0.16)	(-102)
	DC.L	$D1F31368		;* Ny|Nz (0.16,0.16)

		;* vertex:	127
	DC.L	$FFADFFA6		;* X |Y  (16.0,16.0)	(-83,-90)
	DC.L	$FFA80460		;* Z |Nx (16.0,0.16)	(-88)
	DC.L	$D2772CC1		;* Ny|Nz (0.16,0.16)

		;* vertex:	128
	DC.L	$FF9EFFA7		;* X |Y  (16.0,16.0)	(-98,-89)
	DC.L	$FFA1DB27		;* Z |Nx (16.0,0.16)	(-95)
	DC.L	$D4201C83		;* Ny|Nz (0.16,0.16)

		;* vertex:	129
	DC.L	$FF9CFFA4		;* X |Y  (16.0,16.0)	(-100,-92)
	DC.L	$FF91D1D4		;* Z |Nx (16.0,0.16)	(-111)
	DC.L	$D3B00071		;* Ny|Nz (0.16,0.16)

		;* vertex:	130
	DC.L	$FFA1FFA1		;* X |Y  (16.0,16.0)	(-95,-95)
	DC.L	$FF8ADC48		;* Z |Nx (16.0,0.16)	(-118)
	DC.L	$CD34F085		;* Ny|Nz (0.16,0.16)

		;* vertex:	131
	DC.L	$FFA6FFA0		;* X |Y  (16.0,16.0)	(-90,-96)
	DC.L	$FF87F028		;* Z |Nx (16.0,0.16)	(-121)
	DC.L	$C776E68C		;* Ny|Nz (0.16,0.16)

		;* vertex:	132
	DC.L	$FFABFF9E		;* X |Y  (16.0,16.0)	(-85,-98)
	DC.L	$FF97FC9D		;* Z |Nx (16.0,0.16)	(-105)
	DC.L	$C07A06FE		;* Ny|Nz (0.16,0.16)

	;* Model Size = ( 4116 = 0x1014 ) bytes

.texlist:
	dc.l	EYECRY
	dc.l	(PITCH1|PIXEL16|WID128|XADDINC)
	dc.l	MOUTH
	dc.l	(PITCH1|PIXEL16|WID192|XADDINC)

.tboxlist:
	dc.l	eyepts
	dc.l	mthpts
endcube:

;*======================================================================*

	.phrase


	.end

;*======================================================================*
;*                                    EOF                               *
;*======================================================================*

