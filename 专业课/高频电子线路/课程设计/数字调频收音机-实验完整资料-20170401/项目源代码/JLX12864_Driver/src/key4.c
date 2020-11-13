/*
 * key4.c
 *
 *  Created on: 2016-8-9
 *      Author: DanyangHong
 */
#include<msp430g2553.h>
#include "key4.h"

void Key4_init()
{
	  P1OUT |=  BIT5;                            // P1.4 set, else reset
	  P1REN |= BIT5;                            // P1.4 pullup
	  P1IE |= BIT5;                             // P1.4 interrupt enabled
	  P1IES |= BIT5;                            // P1.4 Hi/lo edge
	  P1IFG &= (~BIT5);                           // P1.4 IFG cleared

	  P2OUT |=  BIT2 + BIT1 + BIT0;                            // P1.4 set, else reset
	  P2REN |= BIT2 + BIT1 + BIT0;                            // P1.4 pullup
	  P2IE |= BIT2 + BIT1 + BIT0;                             // P1.4 interrupt enabled
	  P2IES |= BIT2 + BIT1 + BIT0;                            // P1.4 Hi/lo edge
	  P2IFG &= (~BIT2) + (~BIT1) + (~BIT0);                           // P1.4 IFG cleared
}
