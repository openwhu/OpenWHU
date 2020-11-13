/*
 * menu.c
 *
 *  Created on: 2016-8-15
 *      Author: Administrator
 */
#include "menu.h"
#include "lcd.h"

void DispModeMenu(unsigned char item){
	DispString67At(0,36,"MODESelect",0);
	DispString67At(1,0,"0.FM_AUTO_SEEK",(item==0));
//	DispString67At(2,0,"1.FM_HAND_SEEK",(item==1));
}

void DispFMAutoSeekMenu(unsigned char item ){
	DispString67At(0,36,"FM_AUTO_SEEK",0);
	DispString67At(1,0,"Freq(Hz):",0);
//	DispDec67At(2,60,SIGNAL.sine.freq,6,(item==0));
}

void DispFMHangSeekMenu(unsigned char item ){
	DispString67At(0,36,"FM_Hand_SEEK",0);
	DispString67At(1,0,"Freq(Hz):",0);
//	DispDec67At(2,60,SIGNAL.sine.freq,6,(item==0));
}
