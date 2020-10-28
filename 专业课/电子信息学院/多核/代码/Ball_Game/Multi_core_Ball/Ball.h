#pragma once
#include "Dot.h"

class Ball
{
private:
	int x;
	int y;
	int r;
	int step;
	int score;
	int olddirection;
public:
	Ball(int x1, int y1);
	~Ball();
	void init(int x1, int y1);
	void draw(); 
	void move();
	void changeDirection(int newdirection);
	int checkState(Ball *ball,Dot *dot);
	int getX();
	int getY();
	int getR();
	int getScore();
	void eat(int r);
};

