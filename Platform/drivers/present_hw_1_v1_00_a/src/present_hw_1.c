/*****************************************************************************
* Filename:          C:\Users\Rahul\Xilinx\MajorProj\drivers/present_hw_1_v1_00_a/src/present_hw_1.c
* Version:           1.00.a
* Description:       present_hw_1 (PRESENT HW Crypto) Driver Source File
* Date:              Sat Mar 31 19:23:08 2012 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#include "present_hw_1.h"

#define input_slot_id   XPAR_FSL_PRESENT_HW_1_0_INPUT_SLOT_ID
#define output_slot_id  XPAR_FSL_PRESENT_HW_1_0_OUTPUT_SLOT_ID

void u32_to_u8(uint32_t i32, uint8_t i8[4]){
	i8[0] = (uint8_t)((i32 >> 24) & 0xFF);
	i8[1] = (uint8_t)((i32 >> 16) & 0xFF);
	i8[2] = (uint8_t)((i32 >> 8) & 0xFF);
	i8[3] = (uint8_t)(i32 & 0xFF);
}

uint32_t u8_to_u32(uint8_t i8[4]) {
	uint32_t out;
	out = (uint32_t)i8[0] << 24;
	out |= (uint32_t)i8[1] << 16;
	out |= (uint32_t)i8[2] << 8;
	out |= (uint32_t)i8[3];
	return out;
}

uint32_t present_hw1_enc(uint8_t key[10], uint8_t plaintext[8], uint8_t cipher[8], XTmrCtr *timer) {
	uint32_t to_fsl[5];
	uint32_t from_fsl[2];
	uint8_t key_pad[4];

	key_pad[0] = 0x80;
	key_pad[1] = 0x00;
	key_pad[2] = key[0];
	key_pad[3] = key[1];
	to_fsl[0] = u8_to_u32(key_pad);
	to_fsl[1] = u8_to_u32(&key[2]);
	to_fsl[2] = u8_to_u32(&key[6]);
	to_fsl[3] = u8_to_u32(&plaintext[0]);
	to_fsl[4] = u8_to_u32(&plaintext[4]);

	XTmrCtr_Start(timer, 1);

	present_hw_1(input_slot_id, output_slot_id, to_fsl, from_fsl);

	XTmrCtr_Stop(timer, 1);

	u32_to_u8(from_fsl[0], &cipher[0]);
	u32_to_u8(from_fsl[1], &cipher[4]);

	return XTmrCtr_GetValue(timer, 1);
}

uint32_t present_hw1_dec(uint8_t key[10], uint8_t cipher[8], uint8_t plaintext[8], XTmrCtr *timer) {
	uint32_t to_fsl[5];
	uint32_t from_fsl[2];
	uint8_t key_pad[4];

	key_pad[0] = 0x00;
	key_pad[1] = 0x00;
	key_pad[2] = key[0];
	key_pad[3] = key[1];
	to_fsl[0] = u8_to_u32(key_pad);
	to_fsl[1] = u8_to_u32(&key[2]);
	to_fsl[2] = u8_to_u32(&key[6]);
	to_fsl[3] = u8_to_u32(&cipher[0]);
	to_fsl[4] = u8_to_u32(&cipher[4]);

	XTmrCtr_Start(timer, 1);

	present_hw_1(input_slot_id, output_slot_id, to_fsl, from_fsl);

	XTmrCtr_Stop(timer, 1);

	u32_to_u8(from_fsl[0], &plaintext[0]);
	u32_to_u8(from_fsl[1], &plaintext[4]);

	return XTmrCtr_GetValue(timer, 1);
}
