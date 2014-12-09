/* BLIT.H */
/* Gnu C defines, simply #include this file */


/*==========================================================*
;* BLITTER Command Register equates					*
;*==========================================================*
*/

#define SRCEN	0x01	/* d00:     source data read (inner loop) */
#define SRCENZ	0x02	/* d01:     source Z read (inner loop)    */
#define SRCENX	0x04 /* d02:     source data read (realign)    */
#define DSTEN	0x08	/* d03:     destination data read (inner loop)*/
#define DSTENZ	0x10	/* d04:     destination Z read (inner loop)  */
#define DSTWRZ	0x20	/* d05:     destination Z write (inner loop) */
#define CLIP_A1	0x040	/* d06:     A1 clipping enable   */
#define NOGO	0x80	/* d07:     diagnostic               */
#define UPDA1F	0x100	/*; d08:     A1 update step fraction*/
#define UPDA1  0x200	/*; d09:     A1 update step           */
#define UPDA2	0x400	/*; d10:     A2 update step           */
#define DSTA2	0x800	/*; d11:     reverse usage of A1 and A2 */
#define GOURD	0x1000	/*; d12:     enable Gouraud shading    */
#define ZBUFF	0x2000	/*; d13:     polygon Z data updates   */
#define TOPBEN 0x4000	/*; d14:     intensity carry into byte  */
#define TOPNEN	0x8000	/*; d15:     intensity carry into nibble */
#define PATDSEL 0x10000	/*; d16:     Select pattern data */
#define ADDDSEL 0x20000	/*; d17:     diagnostic */
					/*; d18-d20: Z comparator inhibit*/
#define ZMODELT 0x40000	/*; 	     source < destination*/
#define ZMODEEQ 0x80000	/*;	     source = destination*/
#define ZMODEGT 0x100000	/*;	     source > destination*/
					/*; d21-d24: Logic function control*/
#define LFU_NAN 0x200000	/*; 	     !source & !destination*/
#define LFU_NA	0x400000	/*; 	     !source &  destination*/
#define LFU_AN	0x800000	/*; 	      source & !destination*/
#define LFU_A	0x1000000	/*; 	      source &  destination*/

/* The following are ALL 16 possible logical operations of the LFUs*/

#define LFU_ZERO	0x00000000	/* All Zeros*/
#define LFU_NSAND	0x200000	/* NOT Source AND NOT Destination*/
#define LFU_NSAD    0x400000	/* NOT Source AND Destination     */
#define LFU_NOTS	0x600000	/*; NOT Source           */
#define LFU_SAND	0x800000	/*; Source AND NOT Destination*/
#define LFU_NOTD	0xA00000	/*; NOT Destination          */
#define LFU_N_SXORD	0xC00000	/*; NOT (Source XOR Destination)*/
#define LFU_NSORND	0xE00000	/*; NOT Source OR NOT Destination */
#define LFU_SAD	0x1000000 /* Source AND Destination */
#define LFU_SXORD	0x1200000	/*; Source XOR Destination */
#define LFU_D		0x1400000	/* Destination*/
#define LFU_NSORD	0x1600000	/*; NOT Source OR Destination*/
#define LFU_S		0x1800000	/*; Source*/
#define LFU_SORND	0x1A00000	/*; Source OR NOT Destination*/
#define LFU_SORD	0x1C00000	/*; Source OR Destination*/
#define LFU_ONE  	0x1E00000	/*; All Ones*/

/*; These are some common combinations with less boolean names*/

#define LFU_REPLACE	0x1800000	/*; Source REPLACEs destination*/
#define LFU_XOR	0x1200000	/*; Source XOR with destination  */
#define LFU_CLEAR	0x0000000	/*; CLEAR destination         */

#defne CMPDST		0x2000000	/*; d25: pixel compare pattern & dest*/
#define BCOMPEN     0x4000000	/*; d26: bit compare write inhibit  */
#define DCOMPEN  	0x8000000	/*; d27: data compare write inhibit */
#define BKGWREN	0x10000000 /*	; d28:     data write back    */

/*=================================================*
;* BLITTER Flags (A1 or A2) register equates
*=================================================*/

/*; Pitch d00-d01:
;	distance between pixel phrases*/

#define PITCH1		0x00000000	/* 0 phrase gap*/
#define PITCH2		0x01	/* 1 phrase gap*/
#define PITCH4		0x02	/* 3 phrase gap*/
/*; This definition is for old chip versions*/
#define PITCH8		0x03	/* 7 phrase gap*/
#define PITCH3		0x03	/* 2 phrase gap*/

/*; Pixel d03-d05
;	bit depth (2^n)*/

#define PIXEL1		0x00000000	/*; n = 0	0 color*/
#define PIXEL2		0x08	/*; n = 1	2 colors           */
#define PIXEL4		0x10	/*; n = 2	4 colors         */
#define PIXEL8		0x18	/*; n = 3	8 colors         */
#define PIXEL16	0x20	/*; n = 4	16 colors        */
#define PIXEL32	0x28	/*; n = 5	32 colors        */

/*; Z offset d06-d08
;	offset from phrase of pixel data from its corresponding
;	Z data phrases*/

#define ZOFFS0	0x00000000 /*	; offset = 0	UNUSED*/
#define ZOFFS1	0x40	      /*; offset = 1      */
#define ZOFFS2	0x80	      /* ; offset = 2     */
#define ZOFFS3	0xC0	     /*; offset = 3       */
#define ZOFFS4	0x100	/*; offset = 4       */
#define ZOFFS5	0x140	/*; offset = 5       */
#define ZOFFS6	0x180	/*; offset = 6       */
#define ZOFFS7	0x1C0	/*; offset = 7	UNUSED*/

/*; Width d09-d14
;	width used for address generation
;	This is a 6-bit floating point value in pixels
;	4-bit unsigned exponent
;	2-bit mantissa with implied 3rd bit of 1*/

#define WID2		0x800	/*; 1.00 X 2^1  ( 4<<9)*/
#define WID4 		0x1000	/*; 1.00 X 2^2  ( 8<<9)*/
#define WID6		0x1400	/*; 1.10 X 2^2  (10<<9)*/
#define WID8		0x1800	/*; 1.00 x 2^3  (12<<9)*/
#define WID10		0x1A00	/*; 1.01 X 2^3  (13<<9)*/
#define WID12		0x1C00	/*; 1.10 X 2^3  (14<<9)*/
#define WID14		0x1E00	/*; 1.11 X 2^3  (15<<9)*/
#define WID16		0x2000	/*; 1.00 X 2^4  (16<<9)*/
#define WID20		0x2200	/*; 1.01 X 2^4  (17<<9)*/
#define WID24		0x2400	/*; 1.10 X 2^4  (18<<9)*/
#define WID28		0x2600	/*; 1.11 X 2^4  (19<<9)*/
#define WID32		0x2800	/*; 1.00 X 2^5  (20<<9)*/
#define WID40		0x2A00	/*; 1.01 X 2^5  (21<<9)*/
#define WID48		0x2C00	/*; 1.10 X 2^5  (22<<9)*/
#define WID56		0x2E00	/*; 1.11 X 2^5  (23<<9)*/
#define WID64		0x3000	/*; 1.00 X 2^6  (24<<9)*/
#define WID80		0x3200	/*; 1.01 X 2^6  (25<<9)*/
#define WID96		0x3400	/*; 1.10 X 2^6  (26<<9)*/
#define WID112		0x3600	/*; 1.11 X 2^6  (27<<9)*/
#define WID128		0x3800	/*; 1.00 X 2^7  (28<<9)  */
#define WID160		0x3A00	/*; 1.01 X 2^7  (29<<9)  */
#define WID192		0x3C00	/*; 1.10 X 2^7  (30<<9)  */
#define WID224		0x3E00	/*; 1.11 X 2^7  (31<<9)  */
#define WID256		0x4000	/*; 1.00 X 2^8  (32<<9)  */
#define WID320		0x4200	/*; 1.01 X 2^8  (33<<9)  */
#define WID384		0x4400	/*; 1.10 X 2^8  (34<<9)  */
#define WID448		0x4600	/* 1.11 X 2^8  (35<<9)*/
#define WID512		0x4800	/*; 1.00 X 2^9  (36<<9)*/
#define WID640		0x4A00	/*; 1.01 X 2^9  (37<<9)*/
#define WID768		0x4C00	/*; 1.10 X 2^9  (38<<9)*/
#define WID896		0x4E00	/*; 1.11 X 2^9  (39<<9)*/
#define WID1024	0x5000	/*; 1.00 X 2^10 (40<<9)*/
#define WID1280	0x5200	/*; 1.01 X 2^10 (41<<9)  */
#define WID1536	0x5400	/*; 1.10 X 2^10 (42<<9)  */
#define WID1792	0x5600	/*; 1.11 X 2^10 (43<<9)  */
#define WID2048	0x5800	/*; 1.00 X 2^11 (44<<9)  */
#define WID2560	0x5A00	/*; 1.01 X 2^11 (45<<9)  */
#define WID3072	0x5C00	/*; 1.10 X 2^11 (46<<9)  */
#define WID3584	0x5E00	/*; 1.11 X 2^11 (47<<9)  */

; X add control d16-d17
;	controls the update of the X pointer on each pass
;	round the inner loop
#define XADDPHR	0x00000000 /*; 00-add phrase width and truncate*/
#define XADDPIX	0x10000	/* 01 - add pixel size (add 1)	  */
#define XADD0		0x20000	/* 10 - add zero                 */
#define XADDINC	0x30000	/* 11 - add the increment        */

/*; Y add control	d18
;	controls the update of the Y pointer within the inner loop.
;it is overridden by the X add control if they are in add increment*/
#define YADD0		0x00000000	/*; 00 - add zero*/
#define YADD1		0x40000	/*; 01 - add 1        */

/*; X sign d19
;	add or subtract pixel size if X add control = 01 (XADDPIX)*/
#define XSIGNADD	0x00000000	/*; 0 - add pixel size*/
#define XSIGNSUB	0x80000	/*; 1 - subtract pixel size */

/*; X sign d20
;	add or subtract pixel size if X add control = 01 (YADD1)*/
#define YSIGNADD	0x00000000 /*	; 0 - add 1*/
#define YSIGNSUB	0x100000	/*; 1 - sub 1*/
