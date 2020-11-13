// Multi_core_Ball.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

void playGame();
void initGame();
void reDraw();
int getDirection();
DWORD WINAPI Thread_player1(LPVOID lpParameter);
DWORD WINAPI Thread_player2(LPVOID lpParameter);

HANDLE handle1, handle2;
HANDLE hEvent[2];

Ball *player1, *player2;
Dot *dot;
TCHAR s[10];//the score
TCHAR s1[20] = _T("Player1:");//the score
TCHAR s2[20] = _T("Player2:");//the score
bool dir1, dir2;
bool isFinish;//用于同步两个线程的全局变量
int direction;

void main()
{
	initGame();
	playGame();
	CloseHandle(handle1);
	CloseHandle(handle2);
	closegraph();
	printf("游戏结束!!!\n");
	printf("玩家1得分：%d\n", player1->getScore());
	printf("玩家2得分：%d\n", player2->getScore());
	if (player1->getScore() > player2->getScore())
	{
		printf("玩家1获胜！！！\n");
	}
	else
	{
		printf("玩家2获胜！！！\n");
	}
}

void initGame()
{
	initgraph(GRAPH_WIDE, GRAPH_HIGH);//绘制游戏背景
	setbkcolor(LIGHTGRAY);//设置背景色
	setfillcolor(CYAN);//设置填充色
	setlinecolor(CYAN);//设置线条色

	dot = new Dot();
	//新建玩家
	player1 = new Ball(PLAYER_STARTX, PLAYER1_STARTY);
	player2 = new Ball(PLAYER_STARTX, PLAYER2_STARTY);

	//用于和主线程同步的事件
	hEvent[0] = CreateEvent(NULL, FALSE, FALSE, _T("Player1"));
	hEvent[1] = CreateEvent(NULL, FALSE, FALSE, _T("Player2"));
	//开启两个玩家的线程
	handle1 = CreateThread(NULL, 0, Thread_player1, NULL, 0, NULL);
	handle2 = CreateThread(NULL, 0, Thread_player2, NULL, 0, NULL);
	Sleep(50);//延迟一段时间，保证两个玩家都创建完毕

	dir1 = false;
	dir2 = false;
	isFinish = false;
	direction = LEFT;
}

void playGame()
{
	char key;
	while (!isFinish)
	{
		WaitForMultipleObjects(2, hEvent, TRUE, INFINITE);//所有事件有信号时就返回值
		reDraw();
		if (_kbhit())//如果有输入的话，改变方向.没有就方向不变
		{
			key = _getch();
			if (key == -32)
			{
				key = _getch();
				if (key == 72)//上
				{
					direction = UP;
					dir2 = true;
				}
				else if (key == 80)//下
				{
					direction = DOWN;
					dir2 = true;
				}
				else if (key == 75)//左
				{
					direction = LEFT;
					dir2 = true;
				}
				else if (key == 77)//右
				{
					direction = RIGHT;
					dir2 = true;
				}
			}
			else if (key == 'w')
			{
				direction = UP;
				dir1 = true;
			}
			else if (key == 'a')
			{
				direction = LEFT;
				dir1 = true;
			}
			else if (key == 's')
			{
				direction = DOWN;
				dir1 = true;
			}
			else if (key == 'd')
			{
				direction = RIGHT;
				dir1 = true;
			}
		}
	}
}

void reDraw()
{
	Sleep(SLEEP_TIME);
	//清屏
	cleardevice();
	//重绘图像
	player1->draw();
	player2->draw();
	dot->draw();
	//显示成绩
	outtextxy(GRAPH_WIDE - 100, 50, s1);
	_stprintf(s, _T("%d"), player1->getScore());//将字符串转换为数字
	outtextxy(GRAPH_WIDE - 30, 50, s);
	outtextxy(GRAPH_WIDE - 100, 70, s2);
	_stprintf(s, _T("%d"), player2->getScore());//将字符串转换为数字
	outtextxy(GRAPH_WIDE - 30, 70, s);
}

DWORD WINAPI Thread_player1(LPVOID lpParameter)
{
	int state1;
	while (true)
	{
		//判断是否有按键需要改变方向
		if (dir1)
		{
			player1->changeDirection(direction);
			dir1 = false;
		}
		state1 = player1->checkState(player2, dot);
		if (state1 == HIT_WALL)
		{
			player1->init(PLAYER_STARTX, PLAYER1_STARTY);//撞墙死亡，重新开始
		}
		else if(state1 == HIT_BALL)
		{
			if (player1->getR() <= player2->getR())//比别人小
			{
				player1->init(PLAYER_STARTX, PLAYER1_STARTY);//被别人吃掉
				player2->eat(3);//玩家2分数增加
			}
			else
			{
				player2->init(PLAYER_STARTX, PLAYER2_STARTY);//吃掉别人
				player1->eat(3);//玩家1分数增加
			}
		}
		else if (state1 == EAT)
		{
			player1->eat(dot->getR() - 5);//吃到果子，分数增加
			dot->change();//重绘果子
		}
		else if(state1 == KEEP)
		{
			player1->move();
		}
		if (player1->getScore() == GAME_OVER)
		{
			break;
		}
		Sleep(SLEEP_TIME);
		SetEvent(hEvent[0]);
	}
	isFinish = true;
	return 0;
}

DWORD WINAPI Thread_player2(LPVOID lpParameter)
{
	int state2;
	while (true)
	{
		//判断是否有按键需要改变方向
		if (dir2)
		{
			player2->changeDirection(direction);
			dir2 = false;
		}
		state2 = player2->checkState(player1, dot);
		if (state2 == HIT_WALL)
		{
			player2->init(PLAYER_STARTX, PLAYER2_STARTY);//撞墙死亡，重新开始
		}
		else if (state2 == HIT_BALL)
		{
			if (player2->getR() <= player1->getR())//比别人小
			{
				player2->init(PLAYER_STARTX, PLAYER1_STARTY);//被别人吃掉
				player1->eat(3);//玩家2分数增加
			}
			else
			{
				player1->init(PLAYER_STARTX, PLAYER2_STARTY);//吃掉别人
				player2->eat(3);//玩家1分数增加
			}
		}
		else if (state2 == EAT)
		{
			player2->eat(dot->getR() - 5);//吃到果子，分数增加
			dot->change();//重绘果子
		}
		else if (state2 == KEEP)
		{
			player2->move();
		}
		if (player2->getScore() == GAME_OVER)
		{
			break;
		}
		Sleep(SLEEP_TIME);
		SetEvent(hEvent[1]);
	}
	isFinish = true;
	return 0;
}