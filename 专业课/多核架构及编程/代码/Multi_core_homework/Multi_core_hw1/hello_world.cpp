#include <time.h>
#include <iostream>
#include <Windows.h>
using namespace std;

DWORD WINAPI Thread1(LPVOID lpParameter);   // thread data  
DWORD WINAPI Thread2(LPVOID lpParameter);   // thread data  

HANDLE handle1, handle2;
int cnt_hello = 0, cnt_world = 0;

int main()
{
	int input = 0;
	handle1 = CreateThread(NULL, 0, Thread1, (void*)&input, CREATE_SUSPENDED, NULL);
	//使用CREATE_SUSPENDED参数，该线程创建后不会立即运行，需要ResumeThread函数
	handle2 = CreateThread(NULL, 0, Thread2, (void*)&input, CREATE_SUSPENDED, NULL);
	cout << "1 for Hello;" << endl;
	cout << "2 for World;" << endl;
	cout << "3 for Hello World;" << endl;
	cout << "4 for World Hello;" << endl;
	cout << "5 for Hello Hello World;" << endl;
	cout << "other for exit;" << endl;
	cout << "Please input your choise:" << endl << endl;
	while (true) {
		cin >> input;
		input %= 10;
		if (input == 1)
		{
			cnt_hello = 1;
			cnt_world = 0;
			ResumeThread(handle1);
			//ResumeThread(handle2);
		}
		else if (input == 2)
		{
			cnt_hello = 0;
			cnt_world = 1;
			//ResumeThread(handle1);
			ResumeThread(handle2);
		}
		else if (input == 3)
		{
			cnt_hello = 1;
			cnt_world = 1;
			ResumeThread(handle1);
			//ResumeThread(handle2);
		}
		else if (input == 4)
		{
			cnt_hello = 1;
			cnt_world = 1;
			//ResumeThread(handle1);
			ResumeThread(handle2);
		}
		else if (input == 5)
		{
			cnt_hello = 2;
			cnt_world = 1;
			ResumeThread(handle1);
			//ResumeThread(handle2);
		}
		else
		{
			TerminateThread(handle1, 1);
			TerminateThread(handle2, 1);
			break;
		}
	};
	return 0;
}

DWORD WINAPI Thread1(LPVOID param)
{
	int i = 0;
	while (true)
	{
		if (i == cnt_hello)
		{
			cnt_hello = 0;
			i = 0;
			SuspendThread(handle1);
			ResumeThread(handle2);
		}
		else
		{
			cout << "hello! ";
			i++;
		}
	}
	return 0;
}

DWORD WINAPI Thread2(LPVOID param)
{
	int j = 0;
	while (true)
	{
		if (j == cnt_world)
		{
			cnt_world = 0;
			j = 0;
			SuspendThread(handle2);
			ResumeThread(handle1);
		}
		else
		{
			cout << "world! ";
			j++;
		}
	}
	return 0;
}
