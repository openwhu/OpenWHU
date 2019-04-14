// Test_press.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <windows.h>  
#include <iostream>  
#include <time.h>
#include <conio.h>
#include <WinUser.h>
using namespace std;

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data 

bool player1 = false;
bool player2 = false;

int main()
{
	HANDLE handle1, handle2;

	handle1 = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);
	handle2 = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);

	char key;
	while (true)
	{
		if (_kbhit()) 
		{
			key = _getch();
			if (key == -32)
			{
				key = _getch();
				if ((key == 72) || (key == 80) || (key == 75) || (key == 77))
				{
					player2 = true;
				}
			}
			else if ((key == 'w') || (key == 'a') || (key == 's') || (key == 'd'))
			{
				player1 = true;
			}
		}
	}
	CloseHandle(handle1);
	CloseHandle(handle2);
    return 0;
}

DWORD WINAPI Thread1(LPVOID lpParameter)
{
	while (true)
	{
		if (player1)
		{
			cout << "This is palyer1! " << endl;
			player1 = false;
		}
	}
}

DWORD WINAPI Thread2(LPVOID lpParameter)
{
	while (true)
	{
		if (player2)
		{
			cout << "This is player2! " << endl;
			player2 = false;
		}
	}
}