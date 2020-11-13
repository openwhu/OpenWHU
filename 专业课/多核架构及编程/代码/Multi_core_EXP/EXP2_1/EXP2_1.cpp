// EXP2_1.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <string>
#include <process.h>
#include <Windows.h>
using namespace std;

void ThreadFun1(PVOID param) 
{
	while (1)
	{
		Sleep(100);
		cout << "This is Thread1!" << endl;
	}
}

void ThreadFun2(PVOID param)
{
	while (1)
	{
		Sleep(100);
		cout << "This is Thread2!" << endl;
	}
}

int main()
{
	_beginthread(ThreadFun1, 0, NULL);
	_beginthread(ThreadFun2, 0, NULL);
	Sleep(550);
	cout << "Each Thread has print its number 5 times." << endl;
    return 0;
}

