#include "stdafx.h"

Dot::Dot(int radius)
{
	r = radius;
	x = GRAPH_WIDE - r;//取x的取值范围，防止出现在墙外
	y = GRAPH_HIGH - r;
	x = rand() % x;
	y = rand() % y;
}

Dot::~Dot()
{
}

void Dot::draw() 
{
	setfillcolor(LIGHTRED);//画出不同颜色苹果
	setlinecolor(LIGHTRED);
	fillcircle(x, y, r);
	setfillcolor(CYAN);//画完apple后要把颜色恢复成原始设置
	setlinecolor(CYAN);
}

void Dot::change()
{
	x = GRAPH_WIDE - 3 * r;//限制x的取值范围，防止离墙太近，反应不过来
	y = GRAPH_HIGH - 3 * r;
	x = rand() % x;
	y = rand() % y;
	r = (rand() % 3) + 5;//每一次果子的大小随机
}

int Dot::getX()
{
	return x;
}

int Dot::getY()
{
	return y;
}

int Dot::getR()
{
	return r;
}