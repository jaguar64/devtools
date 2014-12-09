 /*
 *	jagobj.c
 *	Copyright 1993 ATARI Corporation
 *
 *	Routines to convert an unpacked object list into a packed Jaguar
 *	object list.
 */

/* #include <stdio.h> */
#define NULL (0L)

#include "jagobj.h"
#include "allocpr.h"

char *vmemcpy(char *, char *, long);

/*
 * 	Sizes of packed objects in bytes
 */
unsigned long size_obj[] = { 16L, 24L, 8L, 8L, 8L, 0L }; 


/*	THESE GLOBALS ARE USED BY COPYJLIST()
 *
 *	Our two Jaguar object lists
 */

unsigned long	*wrkaJlist;	/* work list	  		*/
unsigned long	*wrkbJlist;	/* work list	  		*/
unsigned long	*orgaJlist;	/* original copy		*/
unsigned long	*orgbJlist;	/* original copy		*/

unsigned long	sizeJlist;	/* number of bytes in Jlist	*/
unsigned short	flagJlist;	/* use list A or list B		*/

/*
 *	:build_obj()
 *
 *	Get the data from an unpacked object and put it into a
 *	packed Jaguar object.
 */

	void			/* return ptr to next obj in unpacked list */
*build_obj(op, vp, next_ob)
	void	*op;		/* addr of packed obj			   */
	void	*vp;		/* addr of unpacked obj (values)	   */
	void	*next_ob;	/* addr of next unpacked obj		   */
{
	void *next_listp;	/* ptr to next obj in unpacked obj list	   */

	/*
	 *	Put data in according to object type
	 */
	switch (*((short *)vp)) {
	case T_BITMOBJ:
	case T_SBITMOBJ: {
		register PBITMOBJ *o = (PBITMOBJ *) op;
		register  BITMOBJ *v = ( BITMOBJ *) vp;
		unsigned long link;
		unsigned long data;

		o->ph1[0] = 0L;
		o->ph1[1] = 0L;

		o->ph2[0] = 0L;	
		o->ph2[1] = 0L;
		
		next_listp = (void *) v->link;
		link = (unsigned long) next_ob;
		link = link >> 3L;

		data = v->data >> 3L;

		oset_type(o, v->type);
		oset_ypos(o, v->ypos);
		oset_height(o, v->height);
		oset_link(o, link);
		oset_data(o, data);

		oset_xpos(o, v->xpos);
		oset_depth(o, v->depth);
		oset_pitch(o, v->pitch);
		oset_dwidth(o, v->dwidth);
		oset_iwidth(o, v->iwidth);
		oset_index(o, v->index);
		oset_reflect(o, v->reflect);
		oset_rmw(o, v->rmw);
		oset_trans(o, v->trans);
		oset_firstpix(o, v->firstpix);
		oset_unused2(o, v->unused);

		if (v->type == T_SBITMOBJ) {
			PSBITMOBJ *o = (PSBITMOBJ *) op;
			SBITMOBJ *v = ( SBITMOBJ *) vp;

			o->ph3[0] = 0L;	
			o->ph3[1] = 0L;
			oset_hscale(o, v->hscale);
			oset_vscale(o, v->vscale);
			oset_remainder(o, v->remainder);
			oset_unused3(o, 0L);

		}
	     }
	     break;
	case T_BRAOBJ: {
		register PBRAOBJ *o = (PBRAOBJ *) op;
		register  BRAOBJ *v = ( BRAOBJ *) vp;
		unsigned long link;
		
		o->ph1[0] = 0L;
		o->ph1[1] = 0L;

		next_listp = (void *) v->link;
		link = (unsigned long) next_ob;
		link = link >> 3L;

		oset_type(o, v->type);
		oset_ypos(o, v->ypos);
		oset_cc(o, v->cc);
		oset_link(o, link);
	     }
	     break;
	case T_GPUOBJ: {
		register PGPUOBJ *o = (PGPUOBJ *) op;
		register  GPUOBJ *v = ( GPUOBJ *) vp;
		
		o->ph1[0] = 0L;
		o->ph1[1] = 0L;

		oset_type(o, v->type);
		oset_ypos(o, v->ypos);
		oset_gpu(o, v->data[1], v->data[2]);
	     }
	     break;

	case T_STOPOBJ: {
		register PSTOPOBJ *o = (PSTOPOBJ *) op;
		register  STOPOBJ *v = ( STOPOBJ *) vp;
		
		o->ph1[0] = 0L;
		o->ph1[1] = 0L;

		next_listp = (void *) NULL;

		oset_type(o, v->type);
		/*oset_stopdata(o, v->data);*/ /* not needed, or? */
	    }
	    break;
	}

	return next_listp;
}

/*
 *	:cnvt_objlst()
 *
 *	Convert a list of unpacked objects into packed Jaguar objects.
 *
 *	Sets up these global variables:
 *					wrkaJlist
 *					orgaJlist
 *					wrkbJlist
 *					orgbJlist
 *					sizeJlist
 */

	unsigned long	/* returns wrkJlist */
*cnvt_objlst(olist)
	void *olist;	/* addr of unpacked object list */
{
	unsigned long	n = 0L;
	unsigned long	delta;
	unsigned long	nr = 0L;

	/*
	 * allocate memory for objects
	 */

	n = obj_nbytes(olist, 0L, &nr);  /* size in bytes */
	sizeJlist = n; /* / 4L;*/    /* in long words */ /* (now in bytes) */

	if ((wrkaJlist = (unsigned long *)PHalloc(n, 32L)) == NULL)
		return NULL;

	if ((orgaJlist = (unsigned long *) PHalloc(n, 32L)) == NULL)
		return NULL;


	delta = _cnvt_objlst(olist, wrkaJlist);

	wrkaJlist += delta;
	orgaJlist += delta;

	vmemcpy((char *)orgaJlist, (char *)wrkaJlist, n); 
					/* copy work list to org list */
	/*
	 * Now do it again
	 */
	if ((wrkbJlist = (unsigned long *)PHalloc(n, 32L)) == NULL)
		return NULL;

	if ((orgbJlist = (unsigned long *) PHalloc(n, 32L)) == NULL)
		return NULL;

	delta = _cnvt_objlst(olist, wrkbJlist);

	wrkbJlist += delta;
	orgbJlist += delta;

	vmemcpy((char *)orgbJlist, (char *)wrkbJlist, n); 
					/* copy work list to org list */

	return wrkaJlist;
}

/*
 *	:_cnvt_objlst()
 *
 *	This is doing the actual work, going through the list...
 *
 */
	unsigned long
_cnvt_objlst(olist, ob)
	register void *olist;
	register unsigned long *ob;
{
	register unsigned long	*nxt_ob = ob;
	register short type;
	register void  *nxt_olist;
	unsigned long delta = 0L;
	unsigned long nxtdelta = 0L;
	unsigned long m = 0L;
	unsigned long d;	/* dummy */

	type = *((short *)olist);

	switch (type) {
	case T_BITMOBJ:
		nxt_ob += 4L;
		if ((m = (unsigned long) ob % 16L)) {
			delta = (16L - m) >> 2L;
			ob += delta;
			nxt_ob += delta;
		} 
		nxt_olist = (void *) ((BITMOBJ *)olist)->link;

		nxtdelta = _cnvt_objlst(nxt_olist, nxt_ob);
		nxt_ob += nxtdelta;
		break;
	case T_SBITMOBJ:
		nxt_ob += 6L;
		if ((m = (unsigned long) ob % 32L)) {
			delta = (32L - m) >> 2L;
			ob += delta;
			nxt_ob += delta;
		} 
		nxt_olist = (void*) ((SBITMOBJ *)olist)->link;

		nxtdelta = _cnvt_objlst(nxt_olist, nxt_ob);
		nxt_ob += nxtdelta;
		break; 
	case T_GPUOBJ:
		nxt_ob += 2L;
		nxt_olist = (void *) ((GPUOBJ *)olist)->next;

		delta += _cnvt_objlst(nxt_olist, nxt_ob + delta);
		nxt_ob += delta;
		ob += delta;
		break;
	case T_BRAOBJ:
		nxt_ob += 2L;
		/* 
		 * fall through part first
		 */
		nxt_olist = (void *) ((BRAOBJ *)olist)->next;		
		delta = _cnvt_objlst(nxt_olist, nxt_ob);
		nxt_ob += ((obj_nbytes(nxt_olist, (unsigned long) nxt_ob, &d) - 
			(long)nxt_ob) >> 2L);
		nxt_ob += delta;
		ob += delta;

		/*
		 * go on with the branch
		 */
		nxt_olist = (void *) ((BRAOBJ *)olist)->link;
		nxtdelta = _cnvt_objlst(nxt_olist, nxt_ob);
		nxt_ob += nxtdelta;
		break;
	case T_STOPOBJ:
		nxt_ob += 2L;
		break;
	}

	build_obj(ob, olist, nxt_ob);

	return delta;
}

/*
 *	:obj_nbytes
 *
 *	returns the number of bytes a branch needs
 */

	unsigned long
obj_nbytes(cp, n, nr)
	register void *cp;	   /* current ptr */
	register unsigned long n;  /* next obj addr./pos. (starting from 0) */
	unsigned long *nr;	   /* count number of objects, too */
{
	register short ct;	/* current type	*/
	register void *np;	/* next ptr 	*/
	register void *lp;	/* link ptr 	*/
	long m;			/* modulo result*/

	ct = *((short *) cp);
	switch (ct) {
	case T_BITMOBJ:
		if (n % 16L)
			n += 8L;	/* insert gap */
		n += 16L;		/* obj needs 16 bytes */
		np = (void *) ((BITMOBJ *) cp)->link;
		break;
	case T_SBITMOBJ:
		if ((m = n % 32L))
			n += (32L - m);		/* insert gap */
		n += 24L;		/* obj needs 24 bytes */
		np = (void *) ((SBITMOBJ *) cp)->link;
		break;

	case T_GPUOBJ:
		n += 8L;		/* obj needs 8 bytes */
		np = (void *) ((GPUOBJ *) cp)->next;
		break;
	case T_BRAOBJ:
		n += 8L;		/* obj needs 8 bytes */
		np = (void *) ((BRAOBJ *) cp)->next;
		lp = (void *) ((BRAOBJ *) cp)->link;
			
		n = obj_nbytes((void *) np, n, nr);

		np = lp;
		break;
	case T_STOPOBJ:
		n += 8L;		/* obj needs 8 bytes */
		break;
	}
	(*nr)++;

	if (ct != T_STOPOBJ)
		n = obj_nbytes(np, n, nr);
	
	return n;
}


/*
 * Phrase alligned malloc
 */

	void
*PHalloc(nb, ph)
	unsigned long nb;  /* number of bytes to allocate 		 */
	long ph;	   /* bi phrase allign, 16 -> 64 bits, 32 -> 128 bits */
{
	void *p;
	unsigned long iop;


	if ((p = alloc(nb + ph)) == NULL)
		return NULL;
	ph -= 1L;
	iop = (unsigned long) p;
	iop += ph;
	iop &= ~ph;
	p = (void *) iop;

	return p;
}

	void
fatal()
{
	/* ok, this should do something */
}

/*
 *	There are two copies of the object proc. list.
 *	One gets restored while the other one is displayed.
 *	This functions uses memcpy to restore the none shown list.
 */
	void
restoreJlist()
{
	if (flagJlist == 1) {
		vmemcpy((char *)wrkaJlist, (char *)orgaJlist, sizeJlist);
		flagJlist = 0;
	} else if (flagJlist == 2) {
		vmemcpy((char *)wrkbJlist, (char *)orgbJlist, sizeJlist);
		flagJlist = 0;
	}
}
