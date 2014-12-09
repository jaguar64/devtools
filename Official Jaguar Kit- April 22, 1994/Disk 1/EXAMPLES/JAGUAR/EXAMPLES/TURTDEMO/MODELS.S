;*======================================================================*
;*                TITLE:                  MODELS.S                      *
;*                Function:               CUBE MODEL data               *
;*                                                                      *
;*                Project #:              RAPIER                        *
;*                Programmer:             Andrew J Burgess              *
;*                                                                      *
;*              COPYRIGHT 1992 Atari Computer Corporation               *
;*          UNATHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,         *
;*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
;*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
;*                            ALL RIGHTS RESERVED.                      *
;*                                                                      *
;*======================================================================*
;*
;*======================================================================*

	.globl	cube

	.data
	.even

cube:
	.dc.l	16+(6*12)+(13*4)+(8*12)

	.dc.w	0		; Zmin
	.dc.w	8		; #Vertices
	.dc.w	12		; #Segments
	.dc.w	6		; #Faces
	.dc.l	seglist		; Ptr to SEGMENTS
	.dc.l	vertlist	; Ptr to VERTICES

;	FACE data

	.dc.l	$00040000		; 4 segments, color Blue
	.dc.w	4*1
	.dc.w	4*2
	.dc.w	4*3
	.dc.w	4*4

	.dc.l	$00040080		; 4 segments, color Magenta
	.dc.w	4*9
	.dc.w	4*6
	.dc.w	4*10
	.dc.w	-4*2

	.dc.l	$000400F0		; 4 segments, color Red
	.dc.w	4*5
	.dc.w	-4*9
	.dc.w	-4*1
	.dc.w	4*11

	.dc.l	$0004008F		; 4 segments, color Green
	.dc.w	4*7
	.dc.w	4*12
	.dc.w	-4*3
	.dc.w	-4*10

	.dc.l	$0004000F		; 4 segments, color Cyan
	.dc.w	-4*11
	.dc.w	-4*4
	.dc.w	-4*12
	.dc.w	4*8

	.dc.l	$000400FF		; 4 segments, color Yellow
	.dc.w	-4*5
	.dc.w	-4*8
	.dc.w	-4*7
	.dc.w	-4*6

;	SEGMENT data
seglist:
	.dc.l	$FFFFFFFF	; THIS IS A NULL ENTRY - 0 Cannot be Used
	.dc.l	$00000008	; Pairs of Indices into VertexList
	.dc.l	$00080010
	.dc.l	$00100018
	.dc.l	$00180000
	.dc.l	$00200028
	.dc.l	$00280030
	.dc.l	$00300038
	.dc.l	$00380020
	.dc.l	$00080028
	.dc.l	$00300010
	.dc.l	$00000020
	.dc.l	$00380018

;	VERTEX data
vertlist:
	.dc.l	$FFB0FFB0	; X |Y	(16.0,16.0) (-80,-80)
	.dc.l	$FFB0DB0D	; Z |Nx	(16.0,0.16) (-80)
	.dc.l	$DB0DDB0D	; Ny|Nz	(0.16,0.16)

	.dc.l	$0050FFB0	; X |Y	(16.0,16.0) ( 80,-80)
	.dc.l	$FFB024F3	; Z |Nx	(16.0, 8.8) (-80)
	.dc.l	$DB0DDB0D	; Ny|Nz	( 8.0, 8.8)

	.dc.l	$00500050	; X |Y	(16.0,16.0) ( 80, 80)
	.dc.l	$FFB024F3	; Z |Nx	(16.0, 8.8) (-80)
	.dc.l	$24F3DB0D	; Ny|Nz	( 8.0, 8.8)

	.dc.l	$FFB00050	; X |Y	(16.0,16.0) (-80, 80)
	.dc.l	$FFB0DB0D	; Z |Nx	(16.0, 8.8) (-80)
	.dc.l	$24F3DB0D	; Ny|Nz	( 8.0, 8.8)

	.dc.l	$FFB0FFB0	; X |Y	(16.0,16.0) (-80,-80)
	.dc.l	$0050DB0D	; Z |Nx	(16.0, 8.8) ( 80)
	.dc.l	$DB0D24F3	; Ny|Nz	( 8.0, 8.8)

	.dc.l	$0050FFB0	; X |Y	(16.0,16.0) ( 80,-80)
	.dc.l	$005024F3	; Z |Nx	(16.0, 8.8) ( 80)
	.dc.l	$DB0D24F3	; Ny|Nz	( 8.0, 8.8)

	.dc.l	$00500050	; X |Y	(16.0,16.0) ( 80, 80)
	.dc.l	$005024F3	; Z |Nx	(16.0, 8.8) ( 80)
	.dc.l	$24F324F3	; Ny|Nz	( 8.0, 8.8)

	.dc.l	$FFB00050	; X |Y	(16.0,16.0) (-80, 80)
	.dc.l	$0050DB0D	; Z |Nx	(16.0, 8.8) ( 80)
	.dc.l	$24F324F3	; Ny|Nz	( 8.0, 8.8)

;*======================================================================*
;*                                 EOF                                  *
;*======================================================================*

