/*****************************************************************************
* Filename:          C:\Users\Rahul\Xilinx\MajorProj\drivers/present_hw_3_v1_00_a/src/present_hw_3.c
* Version:           1.00.a
* Description:       present_hw_3 (PRESENT HW 3) Driver Source File
* Date:              Tue Apr 03 15:04:46 2012 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#include "present_hw_3.h"
#define input_slot_id   XPAR_FSL_PRESENT_HW_3_0_INPUT_SLOT_ID
#define output_slot_id  XPAR_FSL_PRESENT_HW_3_0_OUTPUT_SLOT_ID

void hw3_u32_to_u8(unsigned int i32, unsigned char i8[4]){
	i8[0] = (unsigned char)((i32 >> 24) & 0xFF);
	i8[1] = (unsigned char)((i32 >> 16) & 0xFF);
	i8[2] = (unsigned char)((i32 >> 8) & 0xFF);
	i8[3] = (unsigned char)(i32 & 0xFF);
}

unsigned int hw3_u8_to_u32(unsigned char i8[4]) {
	unsigned int out;
	out = (unsigned int)i8[0] << 24;
	out |= (unsigned int)i8[1] << 16;
	out |= (unsigned int)i8[2] << 8;
	out |= (unsigned int)i8[3];
	return out;
}

unsigned int present_hw3_enc(unsigned char key[10], unsigned char plaintext[8], unsigned char cipher[8], XTmrCtr *timer) {
	unsigned int to_fsl[5];
	unsigned int from_fsl[2];
	unsigned char key_pad[4];

	key_pad[0] = 0x80;
	key_pad[1] = 0x00;
	key_pad[2] = key[0];
	key_pad[3] = key[1];
	to_fsl[0] = hw3_u8_to_u32(key_pad);
	to_fsl[1] = hw3_u8_to_u32(&key[2]);
	to_fsl[2] = hw3_u8_to_u32(&key[6]);
	to_fsl[3] = hw3_u8_to_u32(&plaintext[0]);
	to_fsl[4] = hw3_u8_to_u32(&plaintext[4]);

	XTmrCtr_Start(timer, 1);

	present_hw_3(input_slot_id, output_slot_id, to_fsl, from_fsl);

	XTmrCtr_Stop(timer, 1);

	hw3_u32_to_u8(from_fsl[0], &cipher[0]);
	hw3_u32_to_u8(from_fsl[1], &cipher[4]);

	return XTmrCtr_GetValue(timer, 1);
}

unsigned int present_hw3_dec(unsigned char key[10], unsigned char cipher[8], unsigned char plaintext[8], XTmrCtr *timer) {
	unsigned int to_fsl[5];
	unsigned int from_fsl[2];
	unsigned char key_pad[4];

	key_pad[0] = 0x00;
	key_pad[1] = 0x00;
	key_pad[2] = key[0];
	key_pad[3] = key[1];
	to_fsl[0] = hw3_u8_to_u32(key_pad);
	to_fsl[1] = hw3_u8_to_u32(&key[2]);
	to_fsl[2] = hw3_u8_to_u32(&key[6]);
	to_fsl[3] = hw3_u8_to_u32(&cipher[0]);
	to_fsl[4] = hw3_u8_to_u32(&cipher[4]);

	XTmrCtr_Start(timer, 1);

	present_hw_3(input_slot_id, output_slot_id, to_fsl, from_fsl);

	XTmrCtr_Stop(timer, 1);

	hw3_u32_to_u8(from_fsl[0], &plaintext[0]);
	hw3_u32_to_u8(from_fsl[1], &plaintext[4]);

	return XTmrCtr_GetValue(timer, 1);
}
