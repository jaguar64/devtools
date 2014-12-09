/*
 *	userobj.c
 *	builds screen
 */
#include <stdio.h>
#include "jagobj.h"
#include "allocpr.h"

BITMOBJ	*c_line(short, short, short);
BRAOBJ	*c_bras(short);
BRAOBJ	*bt(BRAOBJ *, short, short, BITMOBJ *);
BRAOBJ	*wt(BRAOBJ *, short, short *);
BRAOBJ	*wrt(BRAOBJ *, short, short *);
BRAOBJ	*wlt(BRAOBJ *, short, short *);
short	cbal(BRAOBJ **, short);

extern	long	*v_bas_ad;	/* screen base address */
#if 0
extern	long	bird1[];
extern	long	LOTUS[];
#endif

char		*tchar1;


/*
 *	our object list, bottom to top
 */

STOPOBJ stop1_obj = {
	T_STOPOBJ,		/* type 			*/
	0L, 0L			/* data				*/
};

STOPOBJ stop2_obj = {
	T_STOPOBJ,		/* type 			*/
	0L, 0L			/* data				*/
};

BITMOBJ bird1_obj = {
	T_BITMOBJ,		/* type				*/
	SCRNTOP + 25,		/* ypos				*/
	120,			/* height			*/
	&stop1_obj,		/* link				*/
	0L,			/* data				*/
	40,			/* xpos				*/
	4,			/* depth			*/
	1,			/* pitch			*/
	34,			/* dwidth			*/
	34,			/* iwidth			*/
	0,			/* index			*/
	0,			/* reflect			*/
	0,			/* rmw				*/
	1,			/* trans			*/
	0,			/* release			*/
	0,			/* firstpix			*/
	0			/* unused			*/
};


BRAOBJ	bra_obj2 = {
	T_BRAOBJ,
	0L,			/* next */
	SCRNTOP + 128 /*+ 99*/,
	YPOS_LT_VC,
	0L,			/* link */
	0L	
};

BITMOBJ chr_obj = {
	T_BITMOBJ,		/* type				*/
	SCRNTOP + 28,		/* ypos				*/
	8,			/* height			*/
	&stop2_obj,		/* link				*/
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

BRAOBJ	bra1_obj = {
	T_BRAOBJ,
	&stop1_obj,			/* next */
	SCRNTOP + 128,
	YPOS_LT_VC,
	&chr_obj,			/* link */
	0L	
};

SBITMOBJ lotus_obj = {
	T_SBITMOBJ,		/* type				*/
	SCRNTOP + 125,		/* ypos				*/
	54,			/* height			*/
	&bra1_obj,		/* link				*/
	0L,			/* data				*/
	42,			/* xpos				*/
	4,			/* depth			*/
	1,			/* pitch			*/
	38,			/* dwidth			*/
	38,			/* iwidth			*/
	0,			/* index			*/
	0,			/* reflect			*/
	0,			/* rmw				*/
	1,			/* trans			*/
	0,			/* release			*/
	0,			/* firstpix			*/
	0,			/* unused			*/
	64,			/* hscale: 2.0			*/
	64,			/* vscale: 2.0			*/
	0			/* remainder			*/
};


BITMOBJ scrn_obj = {
	T_BITMOBJ,		/* type				*/
	SCRNTOP + 25,		/* ypos				*/
	200,			/* height			*/
	&lotus_obj,		/* link				*/
	0L,			/* data				*/
	40,			/* xpos				*/
	4,			/* depth			*/
	1,			/* pitch			*/
	80,			/* dwidth			*/
	80,			/* iwidth			*/
	0,			/* index			*/
	0,			/* reflect			*/
	0,			/* rmw				*/
	0,			/* trans			*/
	0,			/* release			*/
	0,			/* firstpix			*/
	0			/* unused			*/
};

	void
*user_objs(void)
{

	BITMOBJ	*line1, *line2;
	BRAOBJ	*tree;
	short	i, y1, y2;
	short	c;

#if 0
	tchar1 = (char *) PHalloc(128L, 16L);
	bldchr(65, tchar1, 0xffff);
	chr_obj.data = (unsigned long) tchar1;

	return &bra1_obj;
#endif
#if 0
  	scrn_obj.data = (unsigned long) v_bas_ad;
	bird1_obj.data = (unsigned long) bird1;
	lotus_obj.data = (unsigned long) LOTUS;

	lotus_obj.link = (unsigned long) c_bras(SCRNTOP + 28);
#endif

/*
	return (void *) c_bras(SCRNTOP + 28);
*/
	line1 = c_line(42, SCRNTOP + 28, 0);
	tree = bt((BRAOBJ *) NULL, SCRNTOP + 28, 16, line1);

	for (i = 0, c = 40, y1 = 16, y2 = 192; i < 25; i++, y1 += 16, y2 +=16) {
		line1 = c_line(42, SCRNTOP + 28 + y1, c);
		tree = bt((BRAOBJ *) tree, SCRNTOP + 28 + y1, 16, line1);
/*
		line2 = c_line(42, SCRNTOP+ 28 + y2, c);
		tree = bt((BRAOBJ *) tree, SCRNTOP + 28 + y2, 16, line2);
*/
		c += 40;
		c = (c > 128) ? 0 : c;
	}
	
	return (void *) tree;


#if 0
	line1 = c_line(42, SCRNTOP + 28, 1);
	line2 = c_line(42, SCRNTOP + 28 + 12, 41);

	bra_obj.next = (unsigned long) line1;
	bra_obj.link = (unsigned long) line2;
#endif

#if 0	
	return &scrn_obj;
#endif
}

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
		vmemcpy(p, &chr_obj, (long)sizeof(BITMOBJ));
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

	BRAOBJ
*c_bras(ypos)
	register short	ypos;
{
	register short i;
	register BRAOBJ *p;
	BRAOBJ *start;
	STOPOBJ *q;
	short	c = 0;
	
	if ((start = (BRAOBJ *) alloc((long)sizeof(BRAOBJ))) == NULL)
		fatal();
	p = start;

	for (i = 0; i < 14; i++, ypos += 16) {
		p->type = T_BRAOBJ;
		p->cc = YPOS_GT_VC;
		p->ypos = ypos + 15;
		p->unused = 0L;
		p->link = (unsigned long) c_line(42, ypos, c);
		if ((p->next = (unsigned long) alloc((long)sizeof(BRAOBJ))) 
		== 0L)
			fatal();
		p = (BRAOBJ *) p->next;
		c += 39;
		c = (c > 255) ? 0 : c;
	}
	q = (STOPOBJ *) p;
	q->type = T_STOPOBJ;
	q->data[0] = 0L; q->data[1] = 0L;

	return start;

}

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
#if 0
	if (l > r)
		(*tree)->bal -= 1;
	else if (r > l)
		(*tree)->bal += 1;
	else
		(*tree)->bal = 0;
#endif
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
