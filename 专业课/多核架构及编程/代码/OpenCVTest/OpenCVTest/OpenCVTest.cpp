// OpenCVTest.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <windows.h>  
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <omp.h>
#include <time.h>

using namespace cv;
using namespace std;

HANDLE hEvent;

DWORD WINAPI Fun1(LPVOID param)
{
	IplImage* img1;
	char* filename;
	filename = "../cat1.jpg";
	img1 = cvLoadImage(filename);
	cvShowImage("jpg", img1);
	SetEvent(hEvent);
	cvWaitKey(0);
	SetEvent(hEvent);
	return 0;
}

int main()
{
	time_t start1, end1;
	hEvent = CreateEvent(NULL, FALSE, FALSE, TEXT("cnt"));
	start1 = clock();
	CreateThread(NULL, 0, Fun1, NULL, 0, NULL);
	WaitForSingleObject(hEvent, INFINITE);
	ResetEvent(hEvent);
	end1 = clock();
	WaitForSingleObject(hEvent, INFINITE);
	double cha = (end1 - start1)*1.0 / CLK_TCK;
	printf("time of caculation is: %lf \n", cha);
    return 0;
}

