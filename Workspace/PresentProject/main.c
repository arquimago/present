/*
 * main.c
 *
 *  Created on: Mar 28, 2012
 *      Author: Rahul
 */

#include "types.h"

#include <stdio.h>
#include "xparameters.h"
#include "xutil.h"
#include "xio.h"
#include "xtft.h"
#include "xuartlite_l.h"
#include "xuartlite.h"
#include "mb_interface.h"
#include "xtmrctr.h"

#include "present.h"
#include "present_hw_1.h"
#include "present_hw_2.h"
#include "present_hw_3.h"


#define IMG_HOR 320
#define IMG_VER 240
#define SCR_HOR 640
#define SCR_VER 480

#define TFT_DEVICE_ID XPAR_XPS_TFT_0_DEVICE_ID
#define TIMER_DEVICE_ID XPAR_XPS_TIMER_0_DEVICE_ID

static XTft TftInstance;
static XTmrCtr timer;

static uint8_t image[30720];
static uint8_t processed_image[30720];

void tft_string(char* string) {
	while (*string != 0) {
		XTft_Write(&TftInstance, *string++);
	}
}

static char header_4218[7] = "EE4218";
static char header_mp[14] = "Major Project";
static char header_rahul[9] = "Rahul AG";
static char header_zibin[10] = "Ong Zibin";

void tft_header() {
	XTft_SetPosChar(&TftInstance, 460, 20);
	XTft_SetColor(&TftInstance, 0x00ff00ff,0x000000);
	tft_string(header_4218);
	XTft_SetPosChar(&TftInstance, 435, 40);
	tft_string(header_mp);
	XTft_SetPosChar(&TftInstance, 455, 80);
	tft_string(header_rahul);
	XTft_SetPosChar(&TftInstance, 450, 100);
	tft_string(header_zibin);
	XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
}

static char conf_mode[7] = "Mode: ";
static char conf_module[9] = "Module: ";
static char conf_dcache[10] = "D-Cache: ";
static char conf_icache[10] = "I-Cache: ";

void tft_config(uint8_t mode, uint8_t module, uint8_t dcache, uint8_t icache) {
	char conf_xxcrypt[8] = "xxcrypt";

	XTft_SetPosChar(&TftInstance, 20, 280);
	XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	tft_string(conf_mode);

	if (mode == 'd' || mode == 'D') {
		conf_xxcrypt[0] = 'd';
		conf_xxcrypt[1] = 'e';
	} else {
		conf_xxcrypt[0] = 'e';
		conf_xxcrypt[1] = 'n';
	}
	XTft_SetColor(&TftInstance, 0x00ffff00,0x000000);
	tft_string(conf_xxcrypt);
	XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);

	XTft_SetPosChar(&TftInstance, 20, 300);
	tft_string(conf_module);

	if (module == 's' || module == 'S') {
		XTft_SetColor(&TftInstance, 0x00ffff00,0x000000);
		tft_string("sw");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else if (module == '1') {
		XTft_SetColor(&TftInstance, 0x00ffff00,0x000000);
		tft_string("hw 1");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else if (module == '2') {
		XTft_SetColor(&TftInstance, 0x00ffff00,0x000000);
		tft_string("hw 2");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else if (module == '3') {
		XTft_SetColor(&TftInstance, 0x00ffff00,0x000000);
		tft_string("hw 3");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	}

	XTft_SetPosChar(&TftInstance, 20, 320);
	tft_string(conf_dcache);

	if (dcache == 'd' || dcache == 'D') {
		XTft_SetColor(&TftInstance, 0x0000ff00,0x000000);
		tft_string("on");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else if (dcache == 'L') {
		XTft_SetColor(&TftInstance, 0x000000ff,0x000000);
		tft_string("locked");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else {
		XTft_SetColor(&TftInstance, 0x00ff0000,0x000000);
		tft_string("off");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	}

	XTft_SetPosChar(&TftInstance, 20, 340);
	tft_string(conf_icache);

	if (icache == 'i' || icache == 'I') {
		XTft_SetColor(&TftInstance, 0x0000ff00,0x000000);
		tft_string("on");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else if (icache == 'L') {
		XTft_SetColor(&TftInstance, 0x000000ff,0x000000);
		tft_string("locked");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	} else {
		XTft_SetColor(&TftInstance, 0x00ff0000,0x000000);
		tft_string("off");
		XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	}
}

static char timer_hdr_loop[18] = "Loop time: ";
static char timer_hdr_proc[18] = "Processing time: ";
static char timer_unit[4] = " ms";

void tft_timer_disp(unsigned int loop_value, unsigned int proc_value) {
	unsigned int radix = 1000000000;
	XTft_SetPosChar(&TftInstance, 20, 380);
	XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	tft_string(timer_hdr_loop);
	XTft_SetPosChar(&TftInstance, 20, 400);
	while (radix > 100) {
		if (loop_value / radix != 0) {
			XTft_Write(&TftInstance, ((loop_value/radix)%10) + 0x30);
		}
		radix /= 10;
	}
	XTft_Write(&TftInstance, '.');
	while (radix > 0) {
		if (loop_value / radix != 0) {
			XTft_Write(&TftInstance, ((loop_value/radix)%10) + 0x30);
		}
		radix /= 10;
	}
	tft_string(timer_unit);

	radix = 1000000000;
	XTft_SetPosChar(&TftInstance, 20, 420);
	XTft_SetColor(&TftInstance, 0x00ffffff,0x000000);
	tft_string(timer_hdr_proc);
	XTft_SetPosChar(&TftInstance, 20, 440);
	while (radix > 100) {
		if (proc_value / radix != 0) {
			XTft_Write(&TftInstance, ((proc_value/radix)%10) + 0x30);
		}
		radix /= 10;
	}
	XTft_Write(&TftInstance, '.');
	while (radix > 0) {
		if (proc_value / radix != 0) {
			XTft_Write(&TftInstance, ((proc_value/radix)%10) + 0x30);
		}
		radix /= 10;
	}
	tft_string(timer_unit);
}

void tft_display_img(uint8_t img[30720], int min_x, int min_y, int max_x, int max_y) {
	uint32_t colour[5];
	int i, j, x, y;
	x = min_x;
	y = min_y;

	for (i = 0; i < 15360; ++i) {

		colour[0] = ((img[i*2] & 0x80) >> 7) * 0x00FF0000;
		colour[0] |= ((img[i*2] & 0x40) >> 6) * 0x0000FF00;
		colour[0] |= ((img[i*2] & 0x20) >> 5) * 0x000000FF;

		colour[1] = ((img[i*2] & 0x10) >> 4) * 0x00FF0000;
		colour[1] |= ((img[i*2] & 0x08) >> 3) * 0x0000FF00;
		colour[1] |= ((img[i*2] & 0x04) >> 2) * 0x000000FF;

		colour[2] = ((img[i*2] & 0x02) >> 1) * 0x00FF0000;
		colour[2] |= (img[i*2] & 0x01) * 0x0000FF00;
		colour[2] |= ((img[i*2+1] & 0x80) >> 7) * 0x000000FF;

		colour[3] = ((img[i*2+1] & 0x40) >> 6) * 0x00FF0000;
		colour[3] |= ((img[i*2+1] & 0x20) >> 5) * 0x0000FF00;
		colour[3] |= ((img[i*2+1] & 0x10) >> 4) * 0x000000FF;

		colour[4] = ((img[i*2+1] & 0x08) >> 3) * 0x00FF0000;
		colour[4] |= ((img[i*2+1] & 0x04) >> 2) * 0x0000FF00;
		colour[4] |= ((img[i*2+1] & 0x02) >> 1) * 0x000000FF;

		for (j = 0; j < 5; ++j) {
			XTft_SetPixel(&TftInstance, x, y, colour[j]);
			++x;
			if (x >= max_x) {
				x = min_x;
				++y;
				if (y >= max_y) {
					y = min_y;
				}
			}
		}
	}
}


int main(void) {

	uint8_t key[10];
	uint8_t input[8];
	uint8_t processed[8];
	uint8_t mode = 0, dataCache, instrCache, algo;
	unsigned int legit;
	int Status;
	unsigned int i, j;
	uint32_t timer_loop, timer_proc;
	XTft_Config *TftConfigPtr;

	microblaze_disable_icache();
	microblaze_invalidate_icache();
	microblaze_enable_icache();
	microblaze_disable_dcache();
	microblaze_invalidate_dcache();
	microblaze_enable_dcache();

	xil_printf("  Setting up Timer...");

	Status = XTmrCtr_Initialize(&timer, TIMER_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	xil_printf("done!\r\n");

	xil_printf("  Setting up TFT...");
	TftConfigPtr = XTft_LookupConfig(XPAR_XPS_TFT_0_DEVICE_ID);
	if (TftConfigPtr == (XTft_Config *)NULL) {
		return XST_FAILURE;
	}

	Status = XTft_CfgInitialize(&TftInstance, TftConfigPtr, TftConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	xil_printf("done!\r\n");

	XTft_SetColor(&TftInstance, 0, 0);
	XTft_ClearScreen(&TftInstance);
	tft_header();

	while (1) {
		legit = 1;
		xil_printf("Config: [E/D][S/1/2][I/X][D/X]");
		mode = XUartLite_RecvByte(STDIN_BASEADDRESS);
		if (mode != 'E' && mode != 'D') {
			legit = 0;
		}

		algo = XUartLite_RecvByte(STDIN_BASEADDRESS);
		if (algo != 'S' && algo != '1' && algo != '2' && algo != '3') {
			legit = 0;
		}

		microblaze_disable_icache();
		microblaze_invalidate_icache();
		microblaze_disable_dcache();
		microblaze_invalidate_dcache();

		if (algo == 'S') {
			instrCache = XUartLite_RecvByte(STDIN_BASEADDRESS);
			if (instrCache =='I' || instrCache == 'i') {
				instrCache = 'I';
				microblaze_enable_icache();
			}

			dataCache = XUartLite_RecvByte(STDIN_BASEADDRESS);
			if (dataCache == 'D' || dataCache == 'd') {
				dataCache = 'D';
				microblaze_enable_dcache();
			}
		} else {
			instrCache = 'L';
			microblaze_enable_icache();
			dataCache = 'L';
			microblaze_enable_dcache();
		}


		if (!legit) {
			continue;
		}

		xil_printf("\r\n  Clearing screen...");
		XTft_SetColor(&TftInstance, 0, 0);
		XTft_ClearScreen(&TftInstance);
		xil_printf("done!\r\n");

		tft_header();
		tft_config(mode, algo, dataCache, instrCache);

		xil_printf("  Waiting for key...");
		for (i = 0; i < 10; ++i) {
			key[i] = XUartLite_RecvByte(STDIN_BASEADDRESS);
		}
		xil_printf("Received!\r\n");

		xil_printf("  Key: ");
		for (i = 0; i < 10; ++i) {
			xil_printf("%02X", key[i]);
		}
		xil_printf("\r\n");

		xil_printf("  Waiting for image...");
		for (i = 0; i < 30720; ++i) {
			image[i] = XUartLite_RecvByte(STDIN_BASEADDRESS);
		}
		xil_printf(" Received!\r\n");

		xil_printf("  Displaying unprocessed image...");
		tft_display_img(image, 0, 0, IMG_HOR, IMG_VER);
		xil_printf("done!\r\n");

		xil_printf("  Processing...");
		timer_proc = 0;
		XTmrCtr_Start(&timer, 0);
		if (algo == 'S') {
			generateRoundKeys(key);
		}
		for (i = 0; i < 3840; ++i) {
			for (j = 0; j < 8; ++j) {
				input[j] = image[i*8+j];
			}
			if (algo == 'S') {
				if (mode == 'D') {
					//present_dec(cipher, plaintext);
					timer_proc += present_dec(input, processed, &timer) / 50;
				} else {
					//present_enc(plaintext, cipher);
					timer_proc += present_enc(input, processed, &timer) / 50;
				}
			} else if (algo == '1') {
				if (mode == 'D') {
					//present_dec(cipher, plaintext);
					timer_proc += present_hw1_dec(key, input, processed, &timer) / 50;
				} else {
					//present_enc(plaintext, cipher);
					timer_proc += present_hw1_enc(key, input, processed, &timer) / 50;
				}
			} else if (algo == '2') {
				if (mode == 'D') {
					//present_dec(cipher, plaintext);
					timer_proc += present_hw2_dec(key, input, processed, &timer) / 50;
				} else {
					//present_enc(plaintext, cipher);
					timer_proc += present_hw2_enc(key, input, processed, &timer) / 50;
				}
			} else if (algo == '3') {
				if (mode == 'D') {
					//present_dec(cipher, plaintext);
					timer_proc += present_hw3_dec(key, input, processed, &timer) / 50;
				} else {
					//present_enc(plaintext, cipher);
					timer_proc += present_hw3_enc(key, input, processed, &timer) / 50;
				}
			}
			for (j = 0; j < 8; ++j) {
				processed_image[i*8+j] = processed[j];
			}
		}
		XTmrCtr_Stop(&timer, 0);
		xil_printf(" Done!\r\n");

		timer_loop = XTmrCtr_GetValue(&timer, 0) / 50;
		xil_printf("  Loop took %d.%03d ms\r\n", timer_loop/1000, timer_loop%1000);
		xil_printf("  Processing took %d.%03d ms\r\n", timer_proc/1000, timer_proc%1000);
		tft_timer_disp(timer_loop, timer_proc);

		tft_display_img(processed_image, IMG_HOR, IMG_VER, SCR_HOR, SCR_VER);
		xil_printf("done!\r\n");
	}


	return 0;

}
/*
int main(void) {

	uint8_t key[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	uint8_t input[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	uint8_t processed[8];
	uint8_t mode = 0, dataCache, instrCache, algo;
	unsigned int legit;
	int Status;
	unsigned int i, j;
	uint32_t timer_loop, timer_proc;
	XTft_Config *TftConfigPtr;

	microblaze_disable_icache();
	microblaze_invalidate_icache();
	microblaze_enable_icache();
	microblaze_disable_dcache();
	microblaze_invalidate_dcache();
	microblaze_enable_dcache();

	xil_printf("  Setting up Timer...");

	Status = XTmrCtr_Initialize(&timer, TIMER_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	xil_printf("done!\r\n");

	generateRoundKeys(key);
	present_enc(input, processed, &timer);


	return 0;

}
*/
