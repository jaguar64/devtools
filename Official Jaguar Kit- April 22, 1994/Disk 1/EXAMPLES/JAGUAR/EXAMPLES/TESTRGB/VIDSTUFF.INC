bitmap_addr		.equ	$20000	; Buffer in main memory
WIDTH			.equ	320	; Bitmap width in pixels
HEIGHT			.equ	199	; Bitmap height in pixels (was 199)
DEPTH			.equ	16	; 16 bits per pixel

NUM_PHRASES		.equ	((WIDTH*DEPTH)/64)	; phrase = 64 bits

SCREEN_START_XPOS	.equ	10	; lower=farther left
SCREEN_START_YPOS	.equ	40	; lower=higher (n_vdb+40)
