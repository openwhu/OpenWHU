// Test3.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <string>
#include <process.h>
#include <Windows.h>
using namespace std;

int globalvar = false;
DWORD WINAPI ThreadFunc(LPVOID pParam)
{
	cout << "ThreadFunc" << endl;
	/*Beep(
  DWORD dwFreq,      // sound frequency
  DWORD dwDuration   // sound duration
);*/
	Beep(5000, 2000); 
	globalvar = true;
	return 0;
}
int main()
{
	HANDLE hthread = CreateThread(NULL, 0, ThreadFunc, NULL, 0, NULL);//creat a new thread and run immediately
	if (!hthread)//error creat the thread
	{
		cout << "Thread Create Error ! " << endl;
		CloseHandle(hthread);
	}
	//try to modify the sleep time to see what happen?
	Sleep(1000);
	while (!globalvar)
	{
		cout << "Thread while" << endl;
	}
	cout << "Thread exit" << endl;
	return 0;
}

