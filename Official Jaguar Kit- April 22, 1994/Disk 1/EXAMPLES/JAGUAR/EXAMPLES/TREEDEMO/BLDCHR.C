/*
 * 	bldchr.c
 *	Copyright 1993 ATARI Corp.
 */


/*
 *	font data
 */ 

extern char font8x8[];
extern char newstack[];

	
	void
bldchr(ascii, dp, color)	/* build 8x8 char for TrueColor */
	short ascii;		/* ascii code of char */
	short *dp;		/* data pointer, where to put the character */
	short color;		/* color of char */
{
	register short i, j;
	register char *fp, chr;

	if( ascii < 0 || ascii > 255 )
	  illegal();

	if( dp < newstack )
	  illegal();
	  
	fp = font8x8 + ascii;
	
	for (i = 0; i < 8; i++, fp += 256L)
	{
		for (j = 7; j >= 0; j--)
		{
			chr = *fp;
			*dp++ = ((chr >> j) & 1) ? color : 0;
		}
	}
}
