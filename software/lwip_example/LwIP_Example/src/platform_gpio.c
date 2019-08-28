/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#include "platform_gpio.h"
#include "xparameters.h"
#include "xil_printf.h"

#if defined(XPAR_LEDS_8BITS_BASEADDR)
#define LED_BASE XPAR_LEDS_8BITS_BASEADDR
#elif defined(XPAR_LEDS_4BITS_BASEADDR)
#define LED_BASE XPAR_LEDS_4BITS_BASEADDR
#elif defined(XPAR_LEDS_6BIT_BASEADDR)
#define LED_BASE XPAR_LEDS_6BIT_BASEADDR
#elif defined(XPAR_LEDS_BASEADDR)
#define LED_BASE XPAR_LEDS_BASEADDR
#elif defined(XPAR_GPIO_0_BASEADDR)
#define LED_BASE XPAR_GPIO_0_BASEADDR
#else
#define NO_LEDS
#endif

#if defined(XPAR_DIP_SWITCHES_8BITS_BASEADDR)
#define DIP_BASE XPAR_DIP_SWITCHES_8BITS_BASEADDR
#elif defined(XPAR_DIPS_4BIT_BASEADDR)
#define DIP_BASE XPAR_DIPS_4BIT_BASEADDR
#elif defined(XPAR_PUSH_BUTTONS_POSITION_BASEADDR)
#define DIP_BASE XPAR_PUSH_BUTTONS_POSITION_BASEADDR 
#elif defined(XPAR_DIP_SWITCHES_4BITS_BASEADDR)
#define DIP_BASE XPAR_DIP_SWITCHES_4BITS_BASEADDR
#elif defined(XPAR_BUTTONS_BASEADDR)
#define DIP_BASE XPAR_BUTTONS_BASEADDR
#else
#define NO_DIP
#endif

void
platform_init_gpios()
{
#ifndef NO_LEDS
    /* set led gpio data direction to output */
    *(volatile unsigned int*)(LED_BASE + 4) = 0;
    /* initialize leds to OFF */
    *(volatile int *)(LED_BASE) = 0;
#endif

#ifndef NO_DIP
    /* set dip switch gpio data direction to in */
    *(volatile unsigned int*)(DIP_BASE + 4) = ~0;
#endif
}

int 
toggle_leds()
{
    static int state = 0;
    //xil_printf("Toggle these LEDs\r\n");
    state = ~state;
#ifndef NO_LEDS
    if (state == 0)
    	*(volatile int *)(LED_BASE) = 0x3;
    else
    	*(volatile int *)(LED_BASE) = 0x0;
#endif
	return state;

}

unsigned int 
get_switch_state()
{
#ifdef NO_DIP
    return 0x0;
#else
    return *(volatile unsigned int *)(DIP_BASE);
#endif
}
