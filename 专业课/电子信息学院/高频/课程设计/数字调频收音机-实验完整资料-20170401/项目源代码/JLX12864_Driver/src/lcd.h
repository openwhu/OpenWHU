/*
 * lcd.h
 *
 *  Created on: 2016-5-5
 *      Author: DanyangHong
 */

#ifndef LCD_H_
#define LCD_H_

#include <msp430g2553.h>


#define SET_LCDRST	P1OUT|=BIT4
#define CLR_LCDRST	P1OUT&=~BIT4
#define SET_LCDRS	P1OUT|=BIT3
#define CLR_LCDRS	P1OUT&=~BIT3
#define SET_SDA	    P1OUT|=BIT2
#define CLR_SDA	    P1OUT&=~BIT2
#define SET_SCK	    P1OUT|=BIT1
#define CLR_SCK	    P1OUT&=~BIT1
#define SET_LEDA	P1OUT|=BIT0
#define CLR_LEDA	P1OUT&=~BIT0

extern void lcd_clear(void);
extern void lcd_clear_page(unsigned char page_num);
extern void Lcd_Init();
extern void lcd_addr(unsigned char page,unsigned char column);
extern void disp_graph_8x16(unsigned char page,unsigned char column,const unsigned char *dp,unsigned char sytle);
extern void disp_graph_16x16(unsigned char page,unsigned char column,const unsigned char *dp,unsigned char style);
extern void disp_graph_6x7(unsigned char page,unsigned char column,const unsigned char *dp,unsigned char style);

/*=======5*7========*/
extern void DispString67At(unsigned char x,unsigned char y,char *str,unsigned char style);
extern void DispDec67At(unsigned char x,unsigned char y,long dat,unsigned char len,unsigned char style);
extern void DispHex67At(unsigned char x,unsigned char y,long dat,unsigned char len,unsigned char style);
extern void DispFloat67At(unsigned char x,unsigned char y,float dat,unsigned char len1,unsigned char len2,unsigned char style );

#endif /* LCD_H_ */
