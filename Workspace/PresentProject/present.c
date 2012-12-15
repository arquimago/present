/*
 * present.c
 *
 *  Created on: Mar 28, 2012
 *      Author: Rahul
 */

#include "present.h"
#include "xio.h"
#include "stdio.h"

uint32_t present_enc(uint8_t plaintext[8], uint8_t cipher[8], XTmrCtr *timer) {
	int i;
	uint8_t state[8];

	for (i = 0; i < 8; ++i)
	{
		state[i] = plaintext[i];
	}

	XTmrCtr_Start(timer, 1);

	for (i = 1; i <= 31; ++i)
	{
		addRoundKey(state, roundkeys[i-1]);
		sboxLayer(state, sboxEnc);
		permutLayer(state, permutMap);
		}
	addRoundKey(state, roundkeys[31]);

	XTmrCtr_Stop(timer, 1);

	for (i = 0; i < 8; ++i)
	{
		cipher[i] = state[i];
	}

	return XTmrCtr_GetValue(timer, 1);
}

uint32_t present_dec(uint8_t cipher[8], uint8_t plaintext[8], XTmrCtr *timer) {
	int i;
	uint8_t state[8];

	for (i = 0; i < 8; ++i)
	{
		state[i] = cipher[i];
	}

	XTmrCtr_Start(timer, 1);

	addRoundKey(state, roundkeys[31]);
	for (i = 1; i <= 31; ++i)
	{
		permutLayer(state, invPermutMap);
		sboxLayer(state, sboxDec);
		addRoundKey(state, roundkeys[31-i]);
	}

	XTmrCtr_Stop(timer, 1);

	for (i = 0; i < 8; ++i)
	{
		plaintext[i] = state[i];
	}

	return XTmrCtr_GetValue(timer, 1);
}

void generateRoundKeys(uint8_t cipherKey[10]) {
	int i;
	uint8_t tempKey[10];

	for (i = 0; i < 10; ++i)
	{
		tempKey[i] = cipherKey[i];
	}

	for (i = 1; i <= 32; ++i)
	{
		updateRoundKeys(tempKey, roundkeys[i-1], i);
	}
}

void updateRoundKeys(uint8_t cipherKey[10], uint8_t roundKey[8], int round) {
	int i;
	uint8_t tempKey[10];

	for (i = 0; i < 8; ++i)
	{
		roundKey[i] = cipherKey[i];
	}

	for (i = 0; i < 10; ++i)
	{
		tempKey[i] = cipherKey[i];
	}

	cipherKey[9] = tempKey[6] << 5 | tempKey[7] >> 3;
	cipherKey[8] = tempKey[5] << 5 | tempKey[6] >> 3;
	cipherKey[7] = tempKey[4] << 5 | tempKey[5] >> 3;
	cipherKey[6] = tempKey[3] << 5 | tempKey[4] >> 3;
	cipherKey[5] = tempKey[2] << 5 | tempKey[3] >> 3;
	cipherKey[4] = tempKey[1] << 5 | tempKey[2] >> 3;
	cipherKey[3] = tempKey[0] << 5 | tempKey[1] >> 3;
	cipherKey[2] = tempKey[9] << 5 | tempKey[0] >> 3;
	cipherKey[1] = tempKey[8] << 5 | tempKey[9] >> 3;
	cipherKey[0] = tempKey[7] << 5 | tempKey[8] >> 3;

	cipherKey[0] = (cipherKey[0] & 0x0F) | (sboxEnc[cipherKey[0] >> 4] << 4);

	cipherKey[7] ^= (uint8_t)round >> 1;
	cipherKey[8] ^= (uint8_t)round << 7;
}

void addRoundKey(uint8_t state[8], uint8_t roundKey[8]) {
	int i;
	for (i = 0; i < 8; ++i)
	{
		state[i] ^= roundKey[i];
	}

}

void sboxLayer(uint8_t state[8], const uint8_t sbox[16]) {
	int i;
	uint8_t temp;

	for (i = 0; i < 8; ++i)
	{
		temp = state[i];
		state[i] = sbox[(temp >> 4)] << 4;
		state[i] |= sbox[(temp & 0x0F)];
	}

}

uint64_t byteArrToInt64(uint8_t input[8]) {
	int i;
	uint64_t output = 0;
	for (i = 0; i < 8; ++i)
	{
		output += (uint64_t)input[i] << ((7-i)*8);
	}
	return output;
}

void int64ToByteArr(uint64_t integer, uint8_t array[8]) {
	int i;
	for (i = 0; i < 8; ++i)
	{
		array[i] = (uint8_t)((integer >> ((7-i)*8)) & 0xFF);
	}
}

void permutLayer(uint8_t state[8], const uint8_t permutationMap[64]) {
	int i;
	uint64_t temp = 0, output = 0;

	temp = byteArrToInt64(state);

	for (i = 0; i < 64; ++i)
	{
		output += ((temp >> i) & 0x01) << permutationMap[i];
	}

	int64ToByteArr(output, state);
}
