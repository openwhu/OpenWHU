// EXP3_1.2.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>
#include <math.h>
#include <omp.h>
#include <time.h>
using namespace std;

#define N 100000000

int main()
{
	clock_t start, finish;
	double eps = 3.1415 / N;
	double result = 0.0, x = 0.0;
	start = clock();
	omp_set_num_threads(4);//强制设置开的线程数（并不是越多越好）
#pragma omp parallel for
	for (int i = 0; i < N; i++)
	{
#pragma omp critical
		//共同访问对象一定要保护起来
		result += (sin(x) * eps);
#pragma omp critical
		x += eps;
		//可以把线程号打印出来证明多线程成功开启
		//cout << "This is Thread " << omp_get_thread_num() << endl;
	}
	finish = clock();
	cout.precision(15);
	cout << "Result = " << result << endl;
	cout << "It takes " << ((double)(finish - start) / CLOCKS_PER_SEC) << " seconds to calculate." << endl;
    return 0;
}

