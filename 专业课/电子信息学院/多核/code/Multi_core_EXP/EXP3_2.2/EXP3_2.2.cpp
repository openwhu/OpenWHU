// EXP3_2.2.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <math.h>
#include <time.h>
#include <Windows.h>
#include <omp.h>
using namespace std;

#define dimension 8000

int array2[dimension][dimension];

int main()
{
clock_t start, finish;

int max = 0, min = 0;
srand((unsigned)time(NULL));
start = clock();
#pragma omp parallel for
for (int i = 0; i < dimension; i++)
{
for (int j = 0; j < dimension; j++)
{
array2[i][j] = (rand() % 1000);
#pragma omp critical
if (array2[i][j] > max)
{
max = array2[i][j];
}
#pragma omp critical
if (array2[i][j] < min)
{
min = array2[i][j];
}
//可以把线程号打印出来证明多线程成功开启
//cout << "This is Thread " << omp_get_thread_num() << endl;
}
}
finish = clock();
cout << "Max value: " << max << endl;
cout << "Min value: " << min << endl;
cout << "Total time: " << ((double)(finish - start) / CLOCKS_PER_SEC) << endl;
return 0;
}

/*
int main()
{
int S = 10;
#pragma omp parallel for firstprivate(S)
for (int i = 0; i < 6; i++)
{
#pragma omp atomic
S++;
printf("Thread %d uses S = %d\n", omp_get_thread_num(), S);
}

printf("S = %d", S);
return 0;
}
*/