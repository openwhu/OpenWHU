// EXP3_2.1.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <math.h>
#include <time.h>
#include <Windows.h>
using namespace std;

#define dimension 8000

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  

int array1[dimension][dimension];
int max = 0, min = 0, isfinish = 0;

int main()
{
	clock_t start, finish;
	HANDLE handle1, handle2;

	//初始化矩阵
	start = clock();
	handle1 = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);
	handle2 = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);

	while (isfinish != 2);
	finish = clock();

	cout << "Max value: " << max << endl;
	cout << "Min value: " << min << endl;
	cout << "Total time: " << ((double)(finish - start) / CLOCKS_PER_SEC) << endl;
    return 0;
}

DWORD WINAPI Thread1(LPVOID lpParameter)
{
	srand((unsigned)time(NULL));
	for (int i = 0; i < (dimension / 2); i++)
	{
		for (int j = 0; j < dimension; j++)
		{
			array1[i][j] = (rand() % 1000);
			if (array1[i][j] > max)
			{
				max = array1[i][j];
			}
			if (array1[i][j] < min)
			{
				min = array1[i][j];
			}
		}
	}
	isfinish++;
	return 0;
}

DWORD WINAPI Thread2(LPVOID lpParameter)
{
	srand((unsigned)time(NULL));
	for (int i = (dimension / 2); i < dimension; i++)
	{
		for (int j = 0; j < dimension; j++)
		{
			array1[i][j] = (rand() % 1000);
			if (array1[i][j] > max)
			{
				max = array1[i][j];
			}
			if (array1[i][j] < min)
			{
				min = array1[i][j];
			}
		}
	}
	isfinish++;
	return 0;
}