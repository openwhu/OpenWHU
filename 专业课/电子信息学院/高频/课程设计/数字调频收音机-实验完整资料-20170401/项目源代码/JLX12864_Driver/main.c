#include <msp430.h> 
#include "lcd.h"
#include "key4.h"
#include "SI4730.h"

/*
 * main.c
 */
uchar upflag=2;
uchar dwflag=2;
uchar autoflag=2;
int main(void) {

    WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer

	  if (CALBC1_8MHZ==0xFF)					// If calibration constant erased
	  {
	    while(1);                               // do not load, trap CPU!!
	  }
	  DCOCTL = 0;                               // Select lowest DCOx and MODx settings
	  BCSCTL1 = CALBC1_8MHZ;                   // Set range
	  DCOCTL = CALDCO_8MHZ;                    // Set DCO step + modulation*/

    Lcd_Init();    //LCD初始化
    Key4_init();   //按键初始化
    SI4730_GPIO_INIT();
    ResetSi47XX_2w();//I2C总线初始化

    _EINT();       //开总中断

    DispString67At(0,0,"ccarie",0);

    while(1)
    {
    	if(!FM_AM_)
    	{
    		Si4730_Power_Up_FM_AM_Choose(FM_RECEIVER); //fm选择
//    		Si4730_auto_seek();
    		if(upflag==1)
    		{
    			upflag=0;
    			Mode = HIGH; //向上搜台
    			Search_FM();
    		}
    		if(dwflag==1)
    		{
    			dwflag=0;
    			Mode = LOW; //向下搜台
    			Search_FM();
    		}
    	}
    	if(FM_AM_)   //am选择
    	{
    		Si4730_Power_Up_FM_AM_Choose(AM_RECEIVER);
    		if(upflag==1)
    		{
    			upflag=0;
    			Mode = HIGH; //向上搜台
    			Search_AM();
    		}
    		if(dwflag==1)
    		{
    			dwflag=0;
    			Mode = LOW; //向下搜台
    			Search_AM();
    		}
    	}
    	if(autoflag==1)
    	{
    		autoflag=0;
    		Si4730_Power_Up_FM_AM_Choose(FM_RECEIVER); //fm选择
    		Si4730_auto_seek();
    	}
    	DispDec67At(1,0,Frequency_fm,5,0);
    	SI4730_GET_FRE();
    }
	return 0;
}

/*
 * 按键1的中断函数
 */
#if defined(__TI_COMPILER_VERSION__) || defined(__IAR_SYSTEMS_ICC__)
#pragma vector=PORT1_VECTOR
__interrupt void Port_1(void)
#elif defined(__GNUC__)
void __attribute__ ((interrupt(PORT1_VECTOR))) Port_1 (void)
#else
#error Compiler not supported!
#endif
{
	volatile int m = 1000;
	while(m--);
	if(!(KEY_UP))      //key1按下,向上搜台
	{
		upflag=1;
		DispString67At(1,0,"ccarie",0);
	}
	P1IFG &= (~BIT5);                           // P1.3 IFG cleared
}

/*
 * 按键2~4的中断函数
 */
#if defined(__TI_COMPILER_VERSION__) || defined(__IAR_SYSTEMS_ICC__)
#pragma vector=PORT2_VECTOR
__interrupt void Port_2(void)
#elif defined(__GNUC__)
void __attribute__ ((interrupt(PORT2_VECTOR))) Port_2 (void)
#else
#error Compiler not supported!
#endif
{
	volatile int m = 1000;
	while(m--);
	if(!(KEY_DW))  //key2按下，向下搜台
	{
		dwflag=1;
		DispString67At(2,0,"ccarie",0);
	}
	if(!(FM_AM_Choose))  //key3按下，FM与AM选择
	{
		FM_AM_ = ~FM_AM_;  //FM_AM_=0选择fm，FM_AM_=1选择am
		DispString67At(3,0,"ccarie",0);
	}
	if(!(P2IN & BIT2))  //key4按下
	{
		autoflag=1;
		DispString67At(4,0,"ccarie",0);
	}
	P2IFG &=(~BIT0);
	P2IFG &=(~BIT1);
	P2IFG &=(~BIT2);
}

