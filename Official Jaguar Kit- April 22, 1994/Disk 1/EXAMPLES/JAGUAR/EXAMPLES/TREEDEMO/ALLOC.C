/*
 *	alloc.c
 *	from K&R
 */

#include "alloc.h"
#include "allocpr.h"

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

HEADER	*morecore(unsigned long);

static HEADER	base;		/* empty list to get started */
static HEADER	*allocp = 0L;	/* last allocated block */

extern unsigned char bss_end;		/* end of bss */

static short phrase_align_our_data_section[] = { 0, 0, 0, 0 };

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

char *alloc(nbytes)		/* general purpose storag allocator */
unsigned long nbytes;
{
	HEADER *morecore();
	register HEADER *p, *q;
	register unsigned long nunits;

	nunits = 1L + (nbytes + sizeof(HEADER) - 1L) / sizeof(HEADER);
	if ((q = allocp) == NULL) {  /* no free list yet */
		base.s.ptr = allocp = q = &base;
		base.s.size = 0L;
	}
	for (p = q->s.ptr; ; q = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {	/* big enough ? */
			if (p->s.size == nunits) /* exactly */
				q->s.ptr = p->s.ptr;
			else {			/* allocate tail end */
				p->s.size -= nunits;
				p += p->s.size;
				p->s.size = nunits;
			}
			allocp = q;
			return ((char*)(p + 1));
		}
		if (p == allocp) 	/* wrapped around free list */
			if ((p = morecore(nunits)) == NULL)
				return NULL; /* none left */
	}
}


HEADER *morecore(nu)	/* ask system for memory */
unsigned long nu;
{
	char	*sbrk();
	register char *cp;
	register HEADER *up;
	register long rnu;

	rnu = NALLOC * ((nu + NALLOC - 1L) / NALLOC);
	cp = sbrk(rnu * sizeof(HEADER));
	if (cp == NULL)
		return NULL;	/* no space at all */
	up = (HEADER *) cp;
	up->s.size = rnu;
	free((char*)(up + 1L));
	return (allocp);
}

void
free(ap)	/* put block ap in free list */
char *ap;
{
	register HEADER	*p, *q;

	p = (HEADER *)ap - 1;

	for (q = allocp; !(p > q && p < q->s.ptr); q = q->s.ptr)
		if (q >= q->s.ptr && (p > q || p < q->s.ptr))
			break;

	if (p + p->s.size == q->s.ptr) { /* join to upper nbr */
		p->s.size += q->s.ptr->s.size;
		p->s.ptr = q->s.ptr->s.ptr;
	} else
		p->s.ptr = q->s.ptr;
	if (q + q->s.size == p) {	/* join to loer nbr */
		q->s.size += p->s.size;
		q->s.ptr = p->s.ptr;
	} else
		q->s.ptr = p;
	allocp = q;
}


unsigned long	memavlbl = 2048L * 1024L; /* 2 MB of RAM */
unsigned char	*memptr;

char *sbrk(nb)
unsigned long nb;
{
	char *rptr;
	static short flag = 0;

/* It's the all new KLUDGE-O-MATIC!!!!  Set the memptr to 60000 to get
   around bug in linker that shuffles everything in the BSS... including
   our handy-dandy end-of-bss symbol.
*/
	
	if (!flag)
	{
		memptr = (char *)0x60000L;
		flag = 1;
	}
	
	if ((unsigned long)(memptr + nb) > memavlbl)
		return NULL;
	else {
		rptr = memptr;
		memptr += nb;

		return rptr;
	}	
	
}
