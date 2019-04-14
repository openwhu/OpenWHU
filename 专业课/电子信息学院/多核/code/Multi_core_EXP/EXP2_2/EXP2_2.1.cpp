//1、使用 事件法 实现线程同步

#include "stdafx.h"
#include <windows.h>  
#include <iostream>  
using namespace std;

DWORD WIN2API Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  

int cnt = 10;
HANDLE hEvent;

void main() {

	HANDLE handle1, handle2;

	handle1 = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);
	handle2 = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);

	hEvent = CreateEvent(NULL, FALSE, FALSE, TEXT("cnt"));
	if (hEvent)
	{


		if (ERROR_ALREADY_EXISTS == GetLastError())
		{
			cout << "only instance can run!" << endl;
			return;
		}
	}
	SetEvent(hEvent);
	Sleep(1000);
	CloseHandle(hEvent);
	CloseHandle(handle1);
	CloseHandle(handle2);
}


DWORD WINAPI Thread1(LPVOID lpParameter)
{
	while (TRUE) {
		WaitForSingleObject(hEvent, INFINITE);
		if (cnt > 0)
		{
			cout << "This is Thread1!" << endl;
			cnt--;
		}
		SetEvent(hEvent);
	}
	return 0;
}


DWORD WINAPI Thread2(LPVOID lpParameter)
{
	while (TRUE) {
		WaitForSingleObject(hEvent, INFINITE);
		if (cnt > 0)
		{
			cout << "This is Thread2!" << endl;
			cnt--;
		}
		SetEvent(hEvent);
	}
	return 0;
}

