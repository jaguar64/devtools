/*
 *	jagobj.h
 *	ATARI JAGUAR OBJECT PROCESSOR'S OBJECTS
 *	Copyright 1993 Atari Corp.
 */

#define T_BITMOBJ	0
#define T_SBITMOBJ	1
#define T_GPUOBJ	2
#define T_BRAOBJ	3
#define T_STOPOBJ	4

#define LINK_ADDR	0xfff90L



/* 
 *	Packed Objects
 */
 
typedef struct {
	unsigned long ph1[2];
	unsigned long ph2[2];
} PBITMOBJ;

typedef struct {
	unsigned long ph1[2];
	unsigned long ph2[2];
	unsigned long ph3[2];
} PSBITMOBJ;

typedef struct {
	unsigned long ph1[2];
} PSTOPOBJ;

typedef struct {
	unsigned long ph1[2];
} PGPUOBJ;

typedef struct {
	unsigned long ph1[2];
} PBRAOBJ;

/*
 *	Get data from unpacked objects into packed objects
 */

#define oset_type(o, v)		((o)->ph1[1]  |= ((unsigned long) v & 0x0007L))
#define oset_ypos(o, v) 	((o)->ph1[1]  |= (((unsigned long)v & 0x07ffL) << 3L))
#define oset_height(o, v)	((o)->ph1[1]  |= (((unsigned long)v & 0x0003ffL) << 14L))
#define oset_link(o, v)		(((o)->ph1[1] |= (((unsigned long)v & 0x0000ffL) << 24L)),\
				 ((o)->ph1[0] |= ((((unsigned long)v & 0x07ff00L) >> 8L) & 0x0007ffL)))
#define oset_data(o, v)		((o)->ph1[0] |= (((unsigned long)v & 0x1fffffL) << 11L))

#define oset_xpos(o, v)		((o)->ph2[1]  |= ((unsigned long) v & 0x0fffL))
#define oset_depth(o, v)	((o)->ph2[1]  |= (((unsigned long) v & 0x0007L) << 12L))
#define oset_pitch(o, v)	((o)->ph2[1]  |= (((unsigned long) v & 0x0007L) << 15L))
#define oset_dwidth(o, v)	((o)->ph2[1]  |= (((unsigned long)v & 0x03ffL) << 18L))
#define oset_iwidth(o, v)	((((o)->ph2[1] |= (((unsigned long)v & 0x000fL) << 28L))),\
				 ((o)->ph2[0] |= ((((unsigned long)v & 0x03f0L) >> 4L) & 0x003fL)))
#define oset_index(o, v)	((o)->ph2[0]  |= (((unsigned long)v & 0x007fL) << 6L))
#define oset_reflect(o, v)	((o)->ph2[0]  |= (((unsigned long)v & 0x0001L) << 13L))
#define oset_rmw(o, v)		((o)->ph2[0]  |= (((unsigned long)v & 0x0001L) << 14L))
#define oset_trans(o, v)	((o)->ph2[0]  |= (((unsigned long)v & 0x0001L) << 15L))
#define oset_release(o, v)	((o)->ph2[0]  |= (((unsigned long)v & 0x0001L) << 16L))
#define oset_firstpix(o, v)	((o)->ph2[0]  |= (((unsigned long)v & 0x003fL) << 17L))
#define oset_unused2(o, v)	((o)->ph2[0]  |= (((unsigned long)v & 0x01ffL) << 23L)) 

#define oset_hscale(o, v)	((o)->ph3[1]  |= ((unsigned long)v & 0x00ffL))
#define oset_vscale(o, v)	((o)->ph3[1]  |= (((unsigned long)v & 0x00ffL) << 8L))
#define oset_remainder(o, v)	((o)->ph3[1]  |= (((unsigned long)v & 0x00ffL) << 16L))
#define oset_unused3(o, v)	(((o)->ph3[1] |= (((unsigned long)v & 0x00ffL) << 24L)), \
				 ((o)->ph3[0] = 0L)) 


#define oset_gpu(o, v, w)	(((o)->ph1[1] |= (((unsigned long)w & 0x03ffL) << 14L)), \
				 ((o)->ph1[0] |= (((unsigned long)v & 0xffffffffL))))

#define	oset_cc(o, v)		((o)->ph1[1] |= (((unsigned long)v & 0x0003L) << 14L))

/*
 *	Clear fields in packed objects
 */

#define oclr_type(o)		((o)->ph1[1]  &= ((unsigned long) 0xfffffff8L))
#define oclr_ypos(o)	 	((o)->ph1[1]  &= ((unsigned long) 0xffffx007L))
#define oclr_height(o)		((o)->ph1[1]  &= ((unsigned long) 0xff003fffL))
#define oclr_link(o)		(((o)->ph1[1] &= ((unsigned long) 0x00ffffffL)),\
				 ((o)->ph1[0] &= ((unsigned long) 0xfffff800L)))
#define oclr_data(o)		((o)->ph1[0]  &= ((unsigned long) 0x000007ffL))

#define oclr_xpos(o)		((o)->ph2[1]  &= ((unsigned long) 0xfffff000L))
#define oclr_depth(o)		((o)->ph2[1]  &= ((unsigned long) 0xffff8fffL))
#define oclr_pitch(o)		((o)->ph2[1]  &= ((unsigned long) 0xfffc7fffL))
#define oclr_dwidth(o)		((o)->ph2[1]  &= ((unsigned long) 0xffc00000L))
#define oclr_iwidth(o)		((((o)->ph2[1] &= ((unsigned long) 0xf0000000L))),\
				 ((o)->ph2[0]  &= ((unsigned long) 0xffffffc0)))
#define oclr_index(o)		((o)->ph2[0]  &= ((unsigned long) 0xfffffe3fL))
#define oclr_reflect(o)		((o)->ph2[0]  &= ((unsigned long) 0xffffdfffL))
#define oclr_rmw(o)		((o)->ph2[0]  &= ((unsigned long) 0xffffbfffL))
#define oclr_trans(o)		((o)->ph2[0]  &= ((unsigned long) 0xffff7fffL))
#define oclr_release(o)		((o)->ph2[0]  &= ((unsigned long) 0xfffeffffL))
#define oclr_firstpix(o)	((o)->ph2[0]  &= ((unsigned long) 0xfff9ffffL))
#define oclr_unused2(o)		((o)->ph2[0]  &= ((unsigned long) 0xff800000L)) 

#define oclr_hscale(o)		((o)->ph3[1]  &= ((unsigned long) 0xffffff00L))
#define oclc_vscale(o)		((o)->ph3[1]  &= ((unsigned long) 0xffff00ffL))
#define oclr_remainder(o)	((o)->ph3[1]  &= ((unsigned long) 0xff00ffffL))
#define oclr_unused3(o)		(((o)->ph3[1] &= ((unsigned long) 0xff000000L)), \
				 ((o)->ph3[0] = 0L)) 


#define oclr_gpu(o)		(((o)->ph1[1] &= ((unsigned long) 0xff003fff)), \
				 ((o)->ph1[0] = 0L ))

#define	oclr_cc(o)		((o)->ph1[1] &= ((unsigned long) 0xffff3fffL))


/*
 *	Unpacked Objects
 */

typedef struct {
	short		type;
	short		ypos;
	short		height;
	unsigned long	link;
	unsigned long	data;
	short		xpos;
	short		depth;
	short		pitch;
	short		dwidth;
	short		iwidth;
	short		index;
	char		reflect;
	short		rmw;
	short		trans;
	short		release;
	short		firstpix;
	short		unused;		/* fill with 0! */
	short		bal;
} BITMOBJ;

typedef struct {
	short		type;
	short		ypos;
	short		height;
	unsigned long	link;
	unsigned long	data;
	short		xpos;
	short		depth;
	short		pitch;
	short		dwidth;
	short		iwidth;
	short		index;
	char		reflect;
	short		rmw;
	short		trans;
	short		release;
	short		firstpix;
	short		unused;		/* fill with 0! */
	short		hscale;
	short		vscale;
	short		remainder;
	short		bal;
} SBITMOBJ;


typedef struct {
	char		type;
	unsigned long	next;		/* DO NOT MOVE THIS */
	short		ypos;
	long		data[2];
} GPUOBJ;

#define YPOS_EQ_VC	0
#define YPOS_GT_VC	1
#define YPOS_LT_VC	2
#define OBJ_FLAG_SET	3
#define HC10_SET	4	

typedef struct {
	short		type;
	unsigned long	next;		/* DO NOT MOVE THIS!!! */
	short		ypos;
	short		cc;
	unsigned long	link;
	long		unused;
	short		bal;
} BRAOBJ;

typedef struct {
	short	type;
	long 	data[2];
	short	bal;
} STOPOBJ;


#ifndef SCRNTOP
#define SCRNTOP	38
#endif

/*
 * Prototypes
 */

void		*build_obj(void *, void *, void *);
unsigned long	*cnvt_objlst(void *);
void		copyJlist(void);
void		*PHalloc(unsigned long, long);
void		fatal(void);
unsigned	long obj_nbytes(register void *, unsigned long, unsigned long *);
unsigned long	_cnvt_objlst(void *, unsigned long *);
void		restoreJlist(void);
