/**====================================================*
;* GPUFLAGS Flags register equates					*
;*=====================================================*/

#define G_ZERO		0x01	/* ALU zero flag*/
#define G_CARRY	0x02	/* ALU carry flag */
#define G_NEGATIVE	0x04	/* ALU negative flag*/
#define G_IMASK	0x08	/* Interrupt mask*/
#define G_INTEN0	0x10	/* Interrupt enable bits*/
#define G_INTEN1	0x20	/* Interrupt enable bits*/
#define G_INTEN2	0x40	/* Interrupt enable bits*/
#define G_INTEN3	0x80	/* Interrupt enable bits*/
#define G_INTEN4	0x100	/* Interrupt enable bits*/
#define G_INTCLR0	0x200	/* Interrupt disable bits*/
#define G_INTCLR1	0x400	/* Interrupt disable bits*/
#define G_INTCLR2	0x800	/*Interrupt disable bits*/
#define G_INTCLR3	0x1000	/* Interrupt disable bits*/
#define G_INTCLR4	0x2000	/* Interrupt disable bits*/
#define G_REGPAGE	0x4000	/* Register Bank*/
#define G_DMAEN	0x8000	/* GPU Load and Store at DMA priority*/

/*============================================================*
;* GPUCTRL Matrix Control register
;*============================================================*/

#define GPUM3x1	0x03	/* [ 3x1] matrix*/
#define GPUM4x1	0x04	/* [ 4x1] matrix*/
#define GPUM5x1	0x05	/* [ 5x1] matrix*/
#define GPUM6x1	0x06	/* [ 6x1] matrix*/
#define GPUM7x1	0x07	/* [ 7x1] matrix*/
#define GPUM8x1	0x08	/* [ 8x1] matrix*/
#define GPUM9x1	0x09	/* [ 9x1] matrix*/
#define GPUM10x1	0x0A	/* [10x1] matrix*/
#define GPUM11x1	0x0B	/* [11x1] matrix*/
#define GPUM12x1	0x0C	/* [12x1] matrix*/
#define GPUM13x1	0x0D	/* [13x1] matrix*/
#define GPUM14x1	0x0E	/* [14x1] matrix*/
#define GPUM15x1	0x0F	/* [15x1] matrix*/

#define GPUMROW	0x0000000	/* Row Major matrix*/
#define GPUMCOL	0x0000010	/* Column Major matrix*/

/**=============================================================*
/** GPUCTRL Control and Status register
/**=============================================================*/

#define GPUGO		0x00000001	/* Start and Stop the GPU  */
#define CPUINT		0x00000002	/* Allow GPU to interrupt CPU*/
#define GPU_CPUINT	0x00000002	/* Allow GPU to interrupt CPU */
#define GPUINT0	0x00000004	/* generate a GPU type 0 interrupt*/
#define SINGLE_STEP	0x00000008	/* enable single stepping GPU       */
#define SINGLE_GO	0x00000010	/* if SINGLE_STEP execute 1 GPU instruction*/
#define DMA_ACK	0x00000020	/* set external DMA acknowledge    */
#define INT_LAT0	0x00000040	/* Interrupt latch 0     */
#define INT_LAT1	0x00000080	/* Interrupt latch 1     */
#define INT_LAT2	0x00000100	/* Interrupt latch 2 */
#define INT_LAT3	0x00000200	/* Interrupt latch 3 */
#define INT_LAT4	0x00000400	/* Interrupt latch 4 */
#define BUS_HOG	0x00000800	/* Allow GPU to hog BUS */

/**==========================================================*
/** General GPU defines
/**=========================================================*/
#define ARGSIZE	0x384
