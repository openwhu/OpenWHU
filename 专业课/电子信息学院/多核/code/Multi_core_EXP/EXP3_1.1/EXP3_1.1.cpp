// Multi_core_EXP3.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <math.h>
#include <time.h>
#include <Windows.h>
using namespace std;

//采用和OpenMP同样的方式，便于比较
#define N 100000000
//标准结果：2

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  

int isfinish = 0;
double Result1 = 0.0, Result2 = 0.0;
double eps = 3.1415 / N;

int main() {
	HANDLE handle1, handle2;
	clock_t start, finish;

	start = clock();
	handle1 = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);
	handle2 = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);

	while (isfinish != 2);
	cout.precision(10);
	cout << "Result = " << Result1 + Result2 << endl;
	finish = clock();
	cout << "It takes " << ((double)(finish - start) / CLOCKS_PER_SEC) << " seconds to calculate." << endl;
	CloseHandle(handle1);
	CloseHandle(handle2);
	return 0;
}

DWORD WINAPI Thread1(LPVOID lpParameter)
{
	/*for (double i = 0; i < 1.57; i += eps)
	{
		Result1 += (sin(i) * eps);
	}*/
	double x = 0.0;
	for (int i = 0; i < (N / 2); i++)
	{
		Result1 += (sin(x) * eps);
		x += eps;
	}
	isfinish++;
	return 0;
}

DWORD WINAPI Thread2(LPVOID lpParameter)
{
	/*for (double i = 1.57; i <= 3.14; i += eps)
	{
		Result2 += (sin(i) * eps);
	}*/
	double x = (N / 2) * eps;
	for (int i = (N / 2); i < N; i++)
	{
		Result2 += (sin(x) * eps);
		x += eps;
	}
	isfinish++;
	return 0;
}

