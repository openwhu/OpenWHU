// EXP2_4.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <windows.h>  
#include <iostream>  
#include <time.h>
using namespace std;

#define eps 0.00000001

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  

int isfinish = 0;
double PI1 = 0.0, PI2 = 0.0;

int main() {
	HANDLE handle1, handle2;
	clock_t start, finish;
	
	start = clock();
	handle1 = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);
	handle2 = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);

	while (isfinish != 2);
	cout.precision(10);
	cout << "PI = " << PI1 + PI2 << endl;
	finish = clock();
	cout << "It takes " << (((double)(finish - start) / CLOCKS_PER_SEC)) << " seconds to calculate PI." << endl;
	CloseHandle(handle1);
	CloseHandle(handle2);
	return 0;
}

DWORD WINAPI Thread1(LPVOID lpParameter)
{
	for (double i = 0; i < 0.5; i += eps)
	{
		PI1 += ((4.0 / (1.0 + i * i)) * eps);
	}
	isfinish++;
	return 0;
}

DWORD WINAPI Thread2(LPVOID lpParameter)
{
	for (double i = 0.5; i <= 1; i += eps)
	{
		PI2 += ((4.0 / (1.0 + i * i)) * eps);
	}
	isfinish++;
	return 0;
}