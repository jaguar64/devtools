
;*======================================================================*
;*
;*	File:		cube.JAG
;*
;*	Created From:	cube.3ds
;*
;*	3DS2JAG	v2.3	Feb  3 1994	14:40:18 Andrew Burgess/Denis L. Fung
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
	.extern	MOUTH
	.extern	eyepts
	.extern	mthpts
cubesize:
	dc.l	endcube-cubesize	;* Size
.phrase
cubedata:
	DC.W	8			;* number of Vertices
	DC.W	12			;* number of Faces
	DC.L	.vertlist		;* pointer to vertices
	DC.L	.texlist		;* pointer to texture maps
	DC.L	.tboxlist		;* pointer to texture boxes

	;*===============================================================*
	;*	FACE DATA - negative values signify reversing the segment vertext pair
	;*===============================================================*

.facelist:
	DC.L	$00000000		;* Texture
	DC.W	3			;* Face   0: Segments in Face
	DC.W	$87A9			;* color GRAY MATTE (GOURAUD)
	dc.w	1 * 8	
	dc.w	6 * 8	
	dc.w	5 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   1: Segments in Face
	DC.W	$7F5B			;* color GREEN MATTE (GOURAUD)
	dc.w	4 * 8	
	dc.w	5 * 8	
	dc.w	6 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   2: Segments in Face
	DC.W	$F8FF			;* color ORANGE MATTE (GOURAUD)
	dc.w	0 * 8	
	dc.w	5 * 8	
	dc.w	4 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   3: Segments in Face
	DC.W	$CDFF			;* color YELLOW MATTE (GOURAUD)
	dc.w	2 * 8	
	dc.w	7 * 8	
	dc.w	6 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   4: Segments in Face
	DC.W	$F0D1			;* color RED MATTE (GOURAUD)
	dc.w	3 * 8	
	dc.w	0 * 8	
	dc.w	4 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   5: Segments in Face
	DC.W	$F8FF			;* color ORANGE MATTE (GOURAUD)
	dc.w	0 * 8	
	dc.w	1 * 8	
	dc.w	5 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   6: Segments in Face
	DC.W	$F0D1			;* color RED MATTE (GOURAUD)
	dc.w	3 * 8	
	dc.w	4 * 8	
	dc.w	7 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   7: Segments in Face
	DC.W	$7F5B			;* color GREEN MATTE (GOURAUD)
	dc.w	4 * 8	
	dc.w	6 * 8	
	dc.w	7 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   8: Segments in Face
	DC.W	$87A9			;* color GRAY MATTE (GOURAUD)
	dc.w	1 * 8	
	dc.w	2 * 8	
	dc.w	6 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face   9: Segments in Face
	DC.W	$CDFF			;* color YELLOW MATTE (GOURAUD)
	dc.w	2 * 8	
	dc.w	3 * 8	
	dc.w	7 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  10: Segments in Face
	DC.W	$00BD			;* color BLUE MATTE (GOURAUD)
	dc.w	0 * 8	
	dc.w	2 * 8	
	dc.w	1 * 8	
	DC.L	$FFFF0000			;* Gouraud shaded. No texture.
	DC.W	3			;* Face  11: Segments in Face
	DC.W	$00BD			;* color BLUE MATTE (GOURAUD)
	dc.w	0 * 8	
	dc.w	3 * 8	
	dc.w	2 * 8	

	;*===============================================================*
	;*	VERTEX DATA
	;*===============================================================*

.vertlist:
		;* vertex:	0
	DC.L	$FFCF0031		;* X |Y  (16.0,16.0)	(-49,49)
	DC.L	$FFCFDB0D		;* Z |Nx (16.0,0.16)	(-49)
	DC.L	$24F3DB0D		;* Ny|Nz (0.16,0.16)

		;* vertex:	1
	DC.L	$00310031		;* X |Y  (16.0,16.0)	(49,49)
	DC.L	$FFCF24F3		;* Z |Nx (16.0,0.16)	(-49)
	DC.L	$24F3DB0D		;* Ny|Nz (0.16,0.16)

		;* vertex:	2
	DC.L	$0031FFCE		;* X |Y  (16.0,16.0)	(49,-50)
	DC.L	$FFCF24F3		;* Z |Nx (16.0,0.16)	(-49)
	DC.L	$DB0DDB0D		;* Ny|Nz (0.16,0.16)

		;* vertex:	3
	DC.L	$FFCFFFCE		;* X |Y  (16.0,16.0)	(-49,-50)
	DC.L	$FFCFDB0D		;* Z |Nx (16.0,0.16)	(-49)
	DC.L	$DB0DDB0D		;* Ny|Nz (0.16,0.16)

		;* vertex:	4
	DC.L	$FFCF0031		;* X |Y  (16.0,16.0)	(-49,49)
	DC.L	$0032DB0D		;* Z |Nx (16.0,0.16)	(50)
	DC.L	$24F324F3		;* Ny|Nz (0.16,0.16)

		;* vertex:	5
	DC.L	$00310031		;* X |Y  (16.0,16.0)	(49,49)
	DC.L	$003224F3		;* Z |Nx (16.0,0.16)	(50)
	DC.L	$24F324F3		;* Ny|Nz (0.16,0.16)

		;* vertex:	6
	DC.L	$0031FFCE		;* X |Y  (16.0,16.0)	(49,-50)
	DC.L	$003224F3		;* Z |Nx (16.0,0.16)	(50)
	DC.L	$DB0D24F3		;* Ny|Nz (0.16,0.16)

		;* vertex:	7
	DC.L	$FFCFFFCE		;* X |Y  (16.0,16.0)	(-49,-50)
	DC.L	$0032DB0D		;* Z |Nx (16.0,0.16)	(50)
	DC.L	$DB0D24F3		;* Ny|Nz (0.16,0.16)

	;* Model Size = ( 236 = 0xEC ) bytes

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

