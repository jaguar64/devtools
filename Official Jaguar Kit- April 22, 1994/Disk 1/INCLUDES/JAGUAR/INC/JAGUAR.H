/***********************************************************************
  Jaguar.h
***********************************************************************/



/*	TOM REGISTERS*/

#define MEMCON1	0xf00000	/* Memory Configuration Register One*/
#define MEMCON2	0xf00002	/* Memory Configuration Register Two*/
#define HC		0xf00004	/* Horizontal Count*/
#define VC		0xf00006	/* Vertical Count*/
#define LPH		0xf00008	/* Horizontal Lightpen*/
#define LPV		0xf0000a	/* Vertical Lightpen    */
#define OB0		0xf00010	/* Current Object Phrase*/
#define OB1		0xf00012
#define OB2		0xf00014
#define OB3		0xf00016
#define OLP		0xf00020	/* Object List Pointer */
#define OLPLO		0xf00020
#define OLPHI		0xf00022
#define ODP		0xf00024	/* Object Data Pointer */
#define OBF		0xf00026	/* Object Processor Flag */
#define VMODE		0xf00028	/* Video Mode          */
#define BORD1		0xf0002a	/* Border Color (Red & Green)*/
#define BORD2		0xf0002c	/* Border Color (Blue)       */
#define HP		0xf0002e	/* Horizontal Period         */
#define HBB		0xf00030	/* Horizontal Blanking Begin */
#define HBE		0xf00032	/* Horizontal Blanking End   */
#define HS		0xf00034	/* Horizontal Sync           */
#define HVS		0xf00036	/* Horizontal Vertical Sync  */
#define HDB1		0xf00038	/* Horizontal Display Begin One*/
#define HDB2		0xf0003a	/* Horizontal Display Begin Two  */
#define HDE		0xf0003c	/* Horizontal Display End        */
#define VP		0xf0003e	/* Vertical Period             */
#define VBB		0xf00040	/* Vertical Blanking Begin    */
#define VBE		0xf00042	/* Vertical Blanking End     */
#define VS		0xf00044	/* Vertical Sync             */
#define VDB		0xf00046	/* Vertical Display Begin    */
#define VDE		0xf00048	/* Vertical Display End      */
#define VEB		0xf0004a	/* Vertical alization Begin  */
#define VEE		0xf0004c	/* Vertical alization End    */
#define VI		0xf0004e	/* Vertical Interrupt        */
#define PIT0		0xf00050	/* Programmable Interrupt Timer (Lo)*/
#define PIT1		0xf00052	/* Programmable Interrupt Timer (Hi)*/
#define HEQ		0xf00054	/* Horizontal alization End     */
#define BG		0xf00058	/* Background Color*/

#define INT1		0xf000e0	/* CPU Interrupt Control Register*/
#define INT2		0xf000e2	/* CPU Interrupt Resume Register */

#define CLUT		0xf00400	/* Color Lookup Table*/

#define LBUFA		0xf00800	/* Line Buffer A*/
#define LBUFB		0xf01000	/* Line Buffer B  */
#define LBUFC		0xf01800	/* Line Buffer Current*/

/*
*	GPU REGISTERS
*/

#define G_FLAGS	0xf02100	/* GPU Flags*/
#define G_MTXC		0xf02104	/* GPU Matrix Control*/
#define G_MTXA		0xf02108	/* GPU Matrix Address  */
#define G_END		0xf0210c	/* GPU Data Organization */
#define G_PC		0xf02110	/* GPU Program Counter     */
#define G_CTRL		0xf02114	/* GPU Operation Control/Status */
#define G_HIDATA 	0xf02118	/* GPU Bus Interface high data  */
#define G_REMAIN 	0xf0211c	/* GPU Division Remainder    */
#define G_DIVCTRL 	0xf0211c	/* GPU Divider control*/
#define G_RAM		0xf03000	/* GPU Internal RAM */
#define G_ENDRAM	0xf04000	/* 4K bytes  */

/*
*	BLITTER REGISTERS  blit.h is for bit flags, commands, etc
*/

#define A1_0xf00000		0xf02200	/* A1 0xf00000Address*/
#define A1_FLAGS		0xf02204	/* A1 Control Flags*/
#define A1_CLIP		0xf02208	/* A1 Clipping Size*/
#define A1_PIXEL		0xf0220C	/* A1 Pixel Pointer*/
#define A1_STEP		0xf02210	/* A1 Step (Integer Part)*/
#define A1_FSTEP		0xf02214	/* A1 Step (Fractional Part)*/
#define A1_FPIXEL		0xf02218	/* A1 Pixel Pointer (Fractional)*/
#define A1_INC			0xf0221C	/* A1 Increment (Integer Part)*/
#define A1_FINC		0xf02220	/* A1 Increment (Fractional Part)*/
#define A2_BASE		0xf02224	/* A2 0xf00000Address*/
#define A2_FLAGS		0xf02228	/* A2 Control Flags*/
#define A2_MASK		0xf0222C	/* A2 Address Mask*/
#define A2_PIXEL		0xf02230	/* A2 PIXEL*/
#define A2_STEP		0xf02234	/* A2 Step (Integer)*/

#define B_CMD			0xf02238	/* Command*/
#define B_COUNT		0xf0223C	/* Counters*/
#define B_SRCD			0xf02240	/* Source Data*/
#define B_DSTD			0xf02248	/* Destination Data*/
#define B_DSTZ			0xf02250	/* Destination Z*/
#define B_SRCZ1		0xf02258	/* Source Z (Integer)*/
#define B_SRCZ2		0xf02260	/* Source Z (Fractional)*/
#define B_PATD			0xf02268	/* Pattern Data*/
#define B_IINC			0xf02270	/* Intensity Increment*/
#define B_ZINC			0xf02274	/* Z Increment*/
#define B_STOP			0xf02278	/* Collision stop control*/

#define B_I3			0xf0227C	/* Blitter Intensity 3*/
#define B_I2			0xf02280	/* Blitter Intensity 2*/
#define B_I1			0xf02284	/* Blitter Intensity 1*/
#define B_I0			0xf02288	/* Blitter Intensity 0*/

#define B_Z3			0xf0228C	/* Blitter Z 3*/
#define B_Z2			0xf02290	/* Blitter Z 2*/
#define B_Z1			0xf02294	/* Blitter Z 1*/
#define B_Z0			0xf02298	/* Blitter Z 0*/

/*	JERRY REGISTERS*/

#define JPIT1			0xf10000
#define CLK1			0xf10010	/* Processor Clock Frency*/
#define CLK2			0xf10012	/* Video Clock Frency*/
#define CHRO_CLK		0xf10014	/* Chroma clock control*/

#define JOYSTICK		0xf14000	/* Joystick register*/
#define JOYBUTS		0xf14002	/* Joystick register*/
#define CONFIG			0xf14002	/* Also has NTSC/PAL*/

#define MOD_MASK		0xf1a118	/* Mask for ADDQ(SUBQ)MOD*/

#define SCLK			0xf1A150	/* SSI Clock Frency*/
#define SMODE			0xf1A154	/* SSI Control*/

#define R_DAC			0xf1a148
#define L_DAC			0xf1a14c  /* the REAL dac's are here */

#define L_I2S			0xf1a148
#define R_I2S			0xf1a14c

/*	ROM Tables built into Jerry 128 samples*/
/*	16 bit samples sign extended to 32*/

#define ROM_TABLE 		0xf1D000	/* 0xf00000of tables*/

#define ROM_TRI     	0xf1D000	/* A triangle wave*/
#define ROM_SINE    	0xf1D200	/* Full amplitude SINE*/
#define ROM_AMSINE  	0xf1D400	/* Linear (?) ramp SINE*/

/* This was once ROM_SINE12W which is just like ROM_SINE*/
#define ROM_12W 		0xf1D600	/* SINE(X)+SINE(2*X)*/

#define ROM_CHIRP16 		0xf1D800	/* SHORT SWEEP*/
#define ROM_NTRI    		0xf1DA00	/* Triangle w/NOISE*/
#define ROM_DELTA   		0xf1DC00	/* Positive spike*/
#define ROM_NOISE   		0xf1DE00	/* Guess*/

/*	JERRY Registers (DSP)*/

#define D_FLAGS		0xf1A100	/* DSP Flags*/
#define D_MTXC			0xf1A104	/* DSP Matrix Control*/
#define D_MTXA			0xf1A108	/* DSP Matrix Address*/
#define D_END			0xf1A10c	/* DSP Data Organization*/
#define D_PC			0xf1A110	/* DSP Program Counter*/
#define D_CTRL			0xf1A114	/* DSP Operation Control/Status*/
#define D_HIDATA 		0xf1A118	/* DSP Bus Interface high data*/
#define D_REMAIN 		0xf1A11c	/* DSP Division Remainder*/
#define D_DIVCTRL 		0xf1A11c	/* DSP Divider control*/
#define D_RAM			0xf1B000	/* DSP Internal RAM*/
#define D_ENDRAM		0xf1D000	/* 8K bytes*/
