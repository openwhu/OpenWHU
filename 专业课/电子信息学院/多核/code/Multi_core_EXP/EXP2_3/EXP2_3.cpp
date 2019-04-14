// EXP2_3.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <Windows.h>
#include <iostream>
using namespace std;

DWORD WINAPI Thread1(LPVOID param);
DWORD WINAPI Thread2(LPVOID param);

HANDLE handle1, handle2;

int main()
{
	int input = 0;
	handle1 = CreateThread(NULL, 0, Thread1, (void*)&input, CREATE_SUSPENDED, NULL);
	//使用CREATE_SUSPENDED参数，该线程创建后不会立即运行，需要ResumeThread函数
	handle2 = CreateThread(NULL, 0, Thread2, (void*)&input, CREATE_SUSPENDED, NULL);
	cout << "0 for exit;" << endl;
	cout << "1 for Hello;" << endl;
	cout << "2 for World;" << endl;
	cout << "Please input your choise:" << endl;
	while (true) {
		cin >> input;
		if (input == 1)
		{
			ResumeThread(handle1);
		}
		else if (input == 2)
		{
			ResumeThread(handle2);
		}
		else if (input == 0)
		{
			TerminateThread(handle1, 1);
			TerminateThread(handle2, 1);
			return 0;
		}
		else
		{
			cout << "Invalidate input, please choose again!" << endl;
		}
	};
}

DWORD WINAPI Thread1(LPVOID param)
{
	while (true)
	{
		cout << "hello! ";
		SuspendThread(handle1);
	}
	return 0;
}

DWORD WINAPI Thread2(LPVOID param)
{
	while (true)
	{
		cout << "world! ";
		SuspendThread(handle2);
	}
	return 0;
}