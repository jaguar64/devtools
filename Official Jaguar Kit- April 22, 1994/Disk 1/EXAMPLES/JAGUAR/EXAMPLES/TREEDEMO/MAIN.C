/*
 *	main.c
 */

void main( void );
void change_color( long );
void set_clip( long, long *);
void abline( long *);

long pts[4];
long i;

void
main( void )
{
	/* ----- Does nothing else then restoring the obj proc list. */

	while (1) {
		restoreJlist();
	}
	return;
}
