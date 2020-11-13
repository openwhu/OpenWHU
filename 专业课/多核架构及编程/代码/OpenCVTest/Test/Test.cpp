#include "stdafx.h"
#include <windows.h>  
#include <iostream>  
#include <time.h>
#include<cv.h>
#include<highgui.h>
using namespace std;

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread3(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread4(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread5(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread6(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread7(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread8(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread9(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread10(LPVOID lpParameter);   // thread data  

HANDLE hEvent[10];

int main() {
	HANDLE handle[10];
	clock_t start, finish;
	int i;
	start = clock();
	handle[0] = CreateThread(NULL, 0, Thread1, NULL, 0, NULL);
	handle[1] = CreateThread(NULL, 0, Thread2, NULL, 0, NULL);
	handle[2] = CreateThread(NULL, 0, Thread3, NULL, 0, NULL);
	handle[3] = CreateThread(NULL, 0, Thread4, NULL, 0, NULL);
	handle[4] = CreateThread(NULL, 0, Thread5, NULL, 0, NULL);
	handle[5] = CreateThread(NULL, 0, Thread6, NULL, 0, NULL);
	handle[6] = CreateThread(NULL, 0, Thread7, NULL, 0, NULL);
	handle[7] = CreateThread(NULL, 0, Thread8, NULL, 0, NULL);
	handle[8] = CreateThread(NULL, 0, Thread9, NULL, 0, NULL);
	handle[9] = CreateThread(NULL, 0, Thread10, NULL, 0, NULL);
	for (i = 0; i < 10; i++)
	{
		hEvent[i] = CreateEvent(NULL, FALSE, FALSE, TEXT("cnt"));
	}
	WaitForMultipleObjects(10, hEvent, FALSE, INFINITE);
	finish = clock();
	cout << "It takes " << (((double)(finish - start) / CLOCKS_PER_SEC)) << " seconds to show." << endl;
	for (i = 0; i < 10; i++)
	{
		CloseHandle(handle[i]);
		CloseHandle(hEvent[i]);
	}
	return 0;
}

DWORD WINAPI Thread1(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("1.jpg");
	if (!image) return -1;
	cvNamedWindow("1", 1);
	cvShowImage("1", image);
	cvWaitKey(0);
	cvDestroyWindow("1");
	cvReleaseImage(&image);
	SetEvent(hEvent[0]);
	return 0;
}

DWORD WINAPI Thread2(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("2.jpg");
	if (!image) return -1;
	cvNamedWindow("2", 1);
	cvShowImage("2", image);
	cvWaitKey(0);
	cvDestroyWindow("2");
	cvReleaseImage(&image);
	SetEvent(hEvent[1]);
	return 0;
}

DWORD WINAPI Thread3(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("3.jpg");
	if (!image) return -1;
	cvNamedWindow("3", 1);
	cvShowImage("3", image);
	cvWaitKey(0);
	cvDestroyWindow("3");
	cvReleaseImage(&image);
	SetEvent(hEvent[2]);
	return 0;
}

DWORD WINAPI Thread4(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("4.jpg");
	if (!image) return -1;
	cvNamedWindow("4", 1);
	cvShowImage("4", image);
	cvWaitKey(0);
	cvDestroyWindow("4");
	cvReleaseImage(&image);
	SetEvent(hEvent[3]);
	return 0;
}

DWORD WINAPI Thread5(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("5.jpg");
	if (!image) return -1;
	cvNamedWindow("5", 1);
	cvShowImage("5", image);
	cvWaitKey(0);
	cvDestroyWindow("5");
	cvReleaseImage(&image);
	SetEvent(hEvent[4]);
	return 0;
}

DWORD WINAPI Thread6(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("6.jpg");
	if (!image) return -1;
	cvNamedWindow("6", 1);
	cvShowImage("6", image);
	cvWaitKey(0);
	cvDestroyWindow("6");
	cvReleaseImage(&image);
	SetEvent(hEvent[5]);
	return 0;
}

DWORD WINAPI Thread7(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("7.jpg");
	if (!image) return -1;
	cvNamedWindow("7", 1);
	cvShowImage("7", image);
	cvWaitKey(0);
	cvDestroyWindow("7");
	cvReleaseImage(&image);
	SetEvent(hEvent[6]);
	return 0;
}

DWORD WINAPI Thread8(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("8.jpg");
	if (!image) return -1;
	cvNamedWindow("8", 1);
	cvShowImage("8", image);
	cvWaitKey(0);
	cvDestroyWindow("8");
	cvReleaseImage(&image);
	SetEvent(hEvent[7]);
	return 0;
}

DWORD WINAPI Thread9(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("9.jpg");
	if (!image) return -1;
	cvNamedWindow("9", 1);
	cvShowImage("9", image);
	cvWaitKey(0);
	cvDestroyWindow("9");
	cvReleaseImage(&image);
	SetEvent(hEvent[8]);
	return 0;
}

DWORD WINAPI Thread10(LPVOID lpParameter)
{
	IplImage* image;
	image = cvLoadImage("10.jpg");
	if (!image) return -1;
	cvNamedWindow("10", 1);
	cvShowImage("10", image);
	cvWaitKey(0);
	cvDestroyWindow("10");
	cvReleaseImage(&image);
	SetEvent(hEvent[9]);
	return 0;
}