/*****************************************************************************
* Filename:          C:\Users\Rahul\Xilinx\MajorProj\drivers/present_hw_3_v1_00_a/src/present_hw_3_selftest.c
* Version:           1.00.a
* Description:       
* Date:              Tue Apr 03 15:04:46 2012 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#include "xparameters.h"
#include "present_hw_3.h"

/* IMPORTANT:
*  In order to run this self test, you need to modify the value of following
*  micros according to the slot ID defined in xparameters.h file. 
*/
#define input_slot_id   XPAR_FSL_PRESENT_HW_3_0_INPUT_SLOT_ID
#define output_slot_id  XPAR_FSL_PRESENT_HW_3_0_OUTPUT_SLOT_ID

XStatus PRESENT_HW_3_SelfTest()
{
	 unsigned int input_0[5];     
	 unsigned int output_0[2];     

	 //Initialize your input data over here: 
	 input_0[0] = 12345;     
	 input_0[1] = 24690;     
	 input_0[2] = 37035;     
	 input_0[3] = 49380;     
	 input_0[4] = 61725;     

	 //Call the macro with instance specific slot IDs
	 present_hw_3(
		 input_slot_id,
		 output_slot_id,
		 input_0,      
		 output_0       
		 );

	 if (output_0[0] != 185175)
		 return XST_FAILURE;
	 if (output_0[1] != 185175)
		 return XST_FAILURE;

	 return XST_SUCCESS;
}
