#pragma once
class Dot
{
private:
	int x;
	int y;
	int r;
public:
	Dot(int radius = 5);
	~Dot();
	void draw();
	void change();
	int getX();
	int getY();
	int getR();
};

