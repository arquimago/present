/*****************************************************************************
* Filename:          C:\Users\Rahul\Xilinx\MajorProj\drivers/present_hw_1_v1_00_a/src/present_hw_1.h
* Version:           1.00.a
* Description:       present_hw_1 (PRESENT HW Crypto) Driver Header File
* Date:              Sat Mar 31 19:23:08 2012 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#ifndef PRESENT_HW_1_H
#define PRESENT_HW_1_H

#include "types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xutil.h"
#include "xtmrctr.h"

#include "fsl.h" 
#define write_into_fsl(val, id)  putfsl(val, id)
#define read_from_fsl(val, id)  getfsl(val, id)

/*
* A macro for accessing FSL peripheral.
*
* This example driver writes all the data in the input arguments
* into the input FSL bus through blocking writes. FSL peripheral will
* automatically read from the FSL bus. Once all the inputs
* have been written, the output from the FSL peripheral is read
* into output arguments through blocking reads.
*
* Arguments:
*	 input_slot_id
*		 Compile time constant indicating FSL slot from
*		 which coprocessor read the input data. Defined in
*		 xparameters.h .
*	 output_slot_id
*		 Compile time constant indicating FSL slot into
*		 which the coprocessor write output data. Defined in
*		 xparameters.h .
*	 input_0    An array of unsigned integers. Array size is 5
*	 output_0   An array of unsigned integers. Array size is 2
*
* Caveats:
*    The output_slot_id and input_slot_id arguments must be
*    constants available at compile time. Do not pass
*    variables for these arguments.
*
*    Since this is a macro, using it too many times will
*    increase the size of your application. In such cases,
*    or when this macro is too simplistic for your
*    application you may want to create your own instance
*    specific driver function (not a macro) using the 
*    macros defined in this file and the slot
*    identifiers defined in xparameters.h .  Please see the
*    example code (present_hw_1_app.c) for details.
*/

#define  present_hw_1(\
		 input_slot_id,\
		 output_slot_id,\
		 input_0,      \
		 output_0       \
		 )\
{\
   int i;\
\
   for (i=0; i<5; i++)\
   {\
      write_into_fsl(input_0[i], input_slot_id);\
   }\
\
   for (i=0; i<2; i++)\
   {\
      read_from_fsl(output_0[i], output_slot_id);\
   }\
}

XStatus PRESENT_HW_1_SelfTest();
void u32_to_u8(uint32_t i32, uint8_t i8[4]);
uint32_t u8_to_u32(uint8_t i8[4]);
uint32_t present_hw1_enc(uint8_t key[10], uint8_t plaintext[8], uint8_t cipher[8], XTmrCtr *timer);
uint32_t present_hw1_dec(uint8_t key[10], uint8_t cipher[8], uint8_t plaintext[8], XTmrCtr *timer);


#endif 
