/*
 *	userobj.c
 *	defines object list for screen; 
 *	this builds a 40x25 character mapped screen. each character is
 *	represented by one obj. proc. object. to get that many objects on
 * 	the screen a binary tree using branch objects is used.
 *
 *	Copyright 1993 ATARI Corp.
 */
#include "jagobj.h"
#include "allocpr.h"

#ifndef NULL
#define NULL	0L
#endif

char *vmemcpy(char *, char *, long);
void bldchr(short, short *, short);

BITMOBJ	*c_line(short, short, short);
BRAOBJ	*bt(BRAOBJ *, short, short, BITMOBJ *);
BRAOBJ	*wt(BRAOBJ *, short, short *);
BRAOBJ	*wrt(BRAOBJ *, short, short *);
BRAOBJ	*wlt(BRAOBJ *, short, short *);
short	cbal(BRAOBJ **, short);

extern	long	*v_bas_ad;	/* screen base address */

/*
 * define an object for a character cell
 */
BITMOBJ chr_obj = {
	T_BITMOBJ,		/* type				*/
	SCRNTOP + 28,		/* ypos				*/
	8,			/* height			*/
	0L,			/* link				*/
	0L,			/* data				*/
	42,			/* xpos				*/
	4,			/* depth			*/
	1,			/* pitch			*/
	2,			/* dwidth			*/
	2,			/* iwidth			*/
	0,			/* index			*/
	0,			/* reflect			*/
	0,			/* rmw				*/
	1,			/* trans			*/
	0,			/* release			*/
	0,			/* firstpix			*/
	0			/* unused			*/
};

	void
*user_objs(void)	/* return ptr. to object list which then will get */
			/* converted to an obj. prc. object list. 	  */
{

	BITMOBJ	*line1;
	BRAOBJ	*tree;
	short	i, y1, y2;
	short	c;


	line1 = c_line(42, SCRNTOP + 28, 0);	/* build first line */
	tree = bt((BRAOBJ *) NULL, SCRNTOP + 28, 16, line1);

	/*
 	 * build the other 24 lines 
	 */
	for (i = 0, c = 40, y1 = 16, y2 = 192; i < 24; i++, y1 += 16, y2 +=16) {
		line1 = c_line(42, SCRNTOP + 28 + y1, c);
		tree = bt((BRAOBJ *) tree, SCRNTOP + 28 + y1, 16, line1);

		c += 40;
		c = (c > 128) ? 0 : c;
	}
	
	return (void *) tree;
}

/*
 *	create a line of 40 objects for 40 characters
 */
	BITMOBJ	
*c_line(xpos, ypos, fchr)
	short xpos, ypos;
	short fchr;	/* first char, ascii */
{
	register short i;
	register BITMOBJ *p;
	BITMOBJ *start;
	STOPOBJ *q;
		
	if ((start = (BITMOBJ *) alloc((long)sizeof(BITMOBJ))) == NULL)
		fatal();
	p = start;

	for (i = 0; i < 40; i++, xpos += 8) {
		vmemcpy((char *) p, (char *) &chr_obj, (long)sizeof(BITMOBJ));
		p->data = (unsigned long) PHalloc(128L, 16L);
		bldchr(fchr + i, p->data, 0xffff);
		p->xpos = xpos;
		p->ypos = ypos;
		if ((p->link = (unsigned long) alloc((long)sizeof(BITMOBJ))) 
		== 0L)
			fatal();
		p = (BITMOBJ *) p->link;

	}
	q = (STOPOBJ *) p;
	q->type = T_STOPOBJ;
	q->data[0] = 0L; q->data[1] = 0L;

	return start;
}

/*
 * 	connect the lines with branch objects using a balanced binary tree
 *	one call inserts one line
 */
	BRAOBJ
*bt(tree, ypos, height, line)
	BRAOBJ	*tree;
	short	ypos;
	short	height;
	BITMOBJ	*line;
{
	BRAOBJ	*bra;
	STOPOBJ	*stop;
	BRAOBJ	*p;
	void	*q;
	short	type;

	if (tree == NULL) {
		if ((bra = (BRAOBJ *) alloc((long)sizeof(BRAOBJ))) == NULL)
			fatal();
		bra->type = T_BRAOBJ;
		bra->cc = YPOS_GT_VC;
		bra->ypos = ypos + height - 1;
		bra->link = (unsigned long) line;
		bra->unused = 0L;
		if ((stop = (STOPOBJ *) alloc((long)sizeof(STOPOBJ))) == NULL)
			fatal();
		stop->type = T_STOPOBJ;
		stop->data[0] = 0L; stop->data[1] = 0L;
		bra->next = (unsigned long) stop;
		bra->bal = -1;

		return bra;
	} else {
		if (ypos > tree->ypos)
			p = wrt(tree, ypos, &type);
		else
			p = wlt(tree, ypos, &type);

		if (type == T_STOPOBJ) {
			q = (void *)((BRAOBJ *)p)->next;
			p->next = (unsigned long) line;
			free(q);
		} else {
			q = (void *) ((BRAOBJ *)p)->next;
			if ((bra = (BRAOBJ *) alloc((long)sizeof(BRAOBJ))) == NULL)
				fatal();
			p->next = (unsigned long) bra;

			bra->type = T_BRAOBJ;
			bra->cc = YPOS_GT_VC;
			type = *((short *) q);
			switch (type) {
			case T_BITMOBJ:
			case T_SBITMOBJ:
				ypos = ((BITMOBJ *)q)->ypos;
				break;	
			case T_BRAOBJ:
			case T_GPUOBJ:
				ypos = ((BRAOBJ *)q)->ypos;
				break;
			}
			bra->ypos = ypos + height - 1;
			bra->unused = 0L;
			bra->next = (unsigned long) line;
			bra->link = (unsigned long) q;
			bra->bal = 0;

			cbal(&tree, -1);
		}
		return tree;
	}
}

/*
 *	walk through the tree
 */
	BRAOBJ
*wt(tree, ypos, type)
	BRAOBJ	*tree;
	short	ypos;
	short	*type;
{
	BRAOBJ	*next;

	if (ypos > tree->ypos)
		next = (BRAOBJ *) tree->next;
	else
		next = (BRAOBJ *) tree->link;

	if (next->type != T_BRAOBJ) {
		*type = next->type;
		return tree;
	} else
		return wt(next, ypos, type);
}

/*
 *	do a right rotation of the tree
 */
	BRAOBJ
*wrt(tree, ypos, type)
	BRAOBJ	*tree;
	short	ypos;
	short	*type;
{
	BRAOBJ	*next;

	next = (BRAOBJ *) tree->next;

	if ((next->type != T_BRAOBJ) || (ypos < next->ypos)) {
		*type = next->type;
		return tree;
	} else
		return wrt(next, ypos, type);
}

/*
 *	do a left rotation of the tree
 */
	BRAOBJ
*wlt(tree, ypos, type)
	BRAOBJ	*tree;
	short	ypos;
	short	*type;
{
	BRAOBJ	*next;


	next = (BRAOBJ *) tree->link;

	if ((next->type != T_BRAOBJ) || (next->ypos < ypos)) {
		*type = next->type;
		return tree;
	} else
		return wlt(next, ypos, type);
}

/*
 *	see if tree is balanced
 */

	short
cbal(tree, n)
	BRAOBJ	**tree;
	short	n;
{
	BRAOBJ	*p, *lp, *rp;
	short	l, r;

	n++;
	if ((*tree)->type == T_BITMOBJ) {
		return n;
	} else if ((*tree)->type == T_STOPOBJ) {
		return n - 1;
	}

	l = cbal((BRAOBJ **) &((*tree)->link), n);
	r = cbal((BRAOBJ **) &((*tree)->next), n);

	(*tree)->bal = l - r;

	if ((*tree)->bal < -1) {
		p = *tree;
		rp = (BRAOBJ *) p->next;
		p->next = (unsigned long) ((BRAOBJ *)p->next)->link; 
		*tree = rp;
 		rp->link = (unsigned long) p;
		(*tree)->bal = 0;
 	} else if ((*tree)->bal > 1) {
		p = *tree;
		lp = (BRAOBJ *) p->link;
		p->link = (unsigned long) ((BRAOBJ *)p->link)->next;
		*tree = lp;
		lp->next = (unsigned long) p;
		(*tree)->bal = 0;
	}
             
	return (l > r) ? l : r;
}
