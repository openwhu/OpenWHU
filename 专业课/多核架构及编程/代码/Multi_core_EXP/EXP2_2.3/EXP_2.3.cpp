// EXP_2.3.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <windows.h>  
#include <iostream>  
using namespace std;

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  

int globalvar;
int cnt = 10;

int main()
{
	globalvar = 99;
	HANDLE handle1 = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);//creat a new thread and run immediately
	HANDLE handle2 = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);//creat a new thread and run immediately
	if (!handle1 || !handle2)//error creat the thread
	{
		cout << "Thread Create Error ! " << endl;
		CloseHandle(handle1);
		CloseHandle(handle2);
	}
	Sleep(10);
	globalvar = TRUE;
	CloseHandle(handle1);
	CloseHandle(handle2);
    return 0;
}

DWORD WINAPI Thread1(LPVOID lpParameter)
{
	while (globalvar) {
		if (cnt > 0)
		{
			cout << "This is Thread1!" << endl;
			cnt--;
		}
	}
	return 0;
}


DWORD WINAPI Thread2(LPVOID lpParameter)
{
	while (globalvar) {
		if (cnt > 0)
		{
			cout << "This is Thread2!" << endl;
			cnt--;
		}
	}
	return 0;
}

