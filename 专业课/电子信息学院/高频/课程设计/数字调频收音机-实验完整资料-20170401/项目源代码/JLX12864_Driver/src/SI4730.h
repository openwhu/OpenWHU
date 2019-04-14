/*
 * SI4730.h
 *
 *  Created on: 2016-8-9
 *      Author: DanyangHong
 */

#ifndef SI4730_H_
#define SI4730_H_

typedef unsigned char uchar;
typedef unsigned int uint;
#define HIGH 1
#define LOW 0
#define SI4730_HIGH    //4730选择地址定义
//#define SI4730_LOW
#define Max_freq_FM 10800      //108MHz
#define Min_freq_FM 8750   //87.5MHz
#define max_freq_AM 1701 //1701KHz
#define min_freq_AM 531
#define    FM_RECEIVER 0x20 //FM调谐频率 page.52
#define    FM_TRNSMITTER 0x30
#define    AM_RECEIVER 0x40 //AM调谐频率
#define    TX_TUNE_MEASURE 0x32

extern uint Frequency_fm;
extern uint Frequency_am;
extern uint read_buff;
extern uchar Mode;
extern uchar FM_AM_;
extern uchar pass_one;

#define KEY_UP  P1IN&BIT5   //向上搜台
#define KEY_DW  P2IN&BIT0   //向下搜台
#define FM_AM_Choose  P2IN&BIT1 //FM与AM选择

#define Si4730_RESET_HIGH P1OUT |= BIT7
#define Si4730_RESET_LOW  P1OUT &= (~BIT7)
#define Si4730_SCLK_HIGH  P1OUT |= BIT6
#define Si4730_SCLK_LOW   P1OUT &= (~BIT6)
#define Si4730_SDIO_HIGH  P2OUT |= BIT5
#define Si4730_SDIO_LOW   P2OUT &= (~BIT5)
#define Si4730_SDIO_OUT   P2DIR |= BIT5  //数据输出
#define Si4730_SDIO_IN    P2DIR &= ~BIT5  //数据输入
#define READ_SDIO         P2IN&BIT5

#define CPU_F                               ((double)8000000)
#define delay_us(x)                       __delay_cycles((long)(CPU_F*(double)x/1000000.0))
#define delay_ms(x)                      __delay_cycles((long)(CPU_F*(double)x/1000.0))

//#if 0 //address switch
#ifdef SI4730_LOW
#define READ_ADDR   0x23
#define WRITE_ADDR 0x22
#endif

#ifdef SI4730_HIGH
#define READ_ADDR   0xc7
#define WRITE_ADDR 0xc6
#endif

extern void Si4730_Delay(unsigned int k);
extern void ResetSi47XX_2w();
extern void Si4730_start();
extern void Si4730_ack();
extern void Si4730_stop();
extern void Si4730_writebyte(uchar write_data);
extern void Operation_Si4730_Write(uchar *data1,uchar numByte);
extern void Si4730_Power_Up_FM_AM_Choose(unsigned char mod);
extern void Si4730_Tune(char mod,unsigned short Channel_Freq);
extern void Search_FM();
extern void Si4730_Tune_AM(char mod,unsigned short Channel_Freq);
extern void Search_AM();
extern void SI4730_GPIO_INIT();
extern void Si4730_auto_seek();

#define I2C_CLK_Delay() delay_us(100)

extern uchar uiReceiveDataBuffer[8];
extern unsigned char Si4730_readbyte(void);
extern void I2CAcknowledge(void);
extern void Operation_Si4730_Read(uchar *data1,uchar numByte);
extern void OperationSi47XX_2w(unsigned char operation, unsigned char *data1, unsigned char numBytes);
extern void SI4730_GET_FRE();

#endif /* SI4730_H_ */
