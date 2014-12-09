/* DeJag binding */
/* dejag.h */
/* Make sure all data is phrase aligned! */

#define DQ_Adr	0xF03E00	/* The start of DQ??.ABS (Dequantize table)*/
#define In_Adr	0xF03F40	/* Points to start of JAG data   */
#define Out_Adr	0xF03F44	/* Points to start of output area*/
#define Dehuff_Adr	0xF03F48	/* Points to start of DEHUFF.ABS*/
#define Out_Width	0xF03F4C	/* Width of the output space in blocks*/
#define Out_E_Width	0xF03F50	/* Encloded pixel width (#WID320 for example)*/
#define All_Done	0xF03F54	/* Contains: 1-In progress 0-Done*/
