// Test2.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <process.h>
#include <Windows.h>
using namespace std;


DWORD WINAPI FunOne(LPVOID param)
{
	while (true)
	{
		Sleep(1000);
		cout << "hello! ";
	}
	return 0;
}
DWORD WINAPI FunTwo(LPVOID param)
{
	while (true)
	{
		Sleep(1000);
		cout << "world! ";
	}
	return 0;
}
int main(int argc, char* argv[])
{
	int input = 0;
	HANDLE handle1 =
		CreateThread(NULL, 0, FunOne, (void*)&input, CREATE_SUSPENDED, NULL);
	//使用CREATE_SUSPENDED参数，该线程创建后不会立即运行，需要ResumeThread函数
	HANDLE handle2 =
		CreateThread(NULL, 0, FunTwo, (void*)&input, CREATE_SUSPENDED, NULL);
	cout << "0 for suspend thread;" << endl;
	cout << "1 for resume thread;" << endl;
	cout << "2 for terminate thread;" << endl;
	cout << "Please input your choise:" << endl;
	while (true) {
		cin >> input;
		if (input == 1) 
		{ 
			ResumeThread(handle1); 
			ResumeThread(handle2); 
		}
		else if (input == 0)
		{ 
			SuspendThread(handle1); 
			SuspendThread(handle2); 
		}
		if (input == 2) 
		{ 
			return 0; 
		}
	};
	TerminateThread(handle1, 1);
	TerminateThread(handle2, 1);
	return 0;
}
