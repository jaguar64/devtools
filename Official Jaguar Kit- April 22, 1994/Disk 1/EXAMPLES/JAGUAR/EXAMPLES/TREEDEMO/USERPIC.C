/*
 *	userobj.c
 *	defines object list for screen; just show two simple pictures
 *
 *	Copyright 1993 ATARI Corp.
 */

#include "jagobj.h"
#include "allocpr.h"

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

static short phrase_align_our_data_section[] = { 0, 0 };

extern	long	*v_bas_ad;	/* screen base address */
extern	long	bird1[];	/* picture of bird */
extern	long	LOTUS[];	/* lotus picture */

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

/*
 *	our object list, bottom to top; C format, of course
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
	&stop2_obj,		/* link				*/
	(unsigned long) bird1,	/* data				*/
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

SBITMOBJ lotus_obj = {
	T_SBITMOBJ,		/* type				*/
	SCRNTOP + 125,		/* ypos				*/
	54,			/* height			*/
	&stop1_obj,		/* link				*/
	(unsigned long) LOTUS,	/* data				*/
	84,			/* xpos				*/
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
BRAOBJ	bra_obj = {
	T_BRAOBJ,
	&bird1_obj,			/* next */
	SCRNTOP + 125,
	YPOS_LT_VC,			/* cc */
	&lotus_obj,			/* link */
	0L	
};

BITMOBJ scrn_obj = {
	T_BITMOBJ,		/* type				*/
	SCRNTOP + 25,		/* ypos				*/
	200,			/* height			*/
	&bra_obj,		/* link				*/
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
  	scrn_obj.data = (unsigned long) v_bas_ad;

	return (void *) &scrn_obj;
}
