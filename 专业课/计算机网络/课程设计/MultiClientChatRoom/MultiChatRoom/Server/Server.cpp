// Serve_win32.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "ServeManager.h"
#include <Windows.h>
#include <iostream>
using namespace std;

DWORD WINAPI ThreadFunc(LPVOID lpParameter);

ServeManager *m_pServer;
BOOL CtrlHandler(DWORD fdwCtrlType);

int main()
{
	if (SetConsoleCtrlHandler((PHANDLER_ROUTINE)CtrlHandler, TRUE))
	{
		//printf("调用WINDOWS API函数-->SetConsoleCtrlHandler函数.\n");
		int iPort = 1680;
		m_pServer = new ServeManager();
		m_pServer->StartListening(iPort);
	}
	else
	{
		printf("ERROR: could not set control handler.\n");
	}
		
    return 0;
}

BOOL CtrlHandler(DWORD fdwCtrlType)
{
	switch (fdwCtrlType)
	{
	/* handle the CTRL-CLOSE signal */
	case CTRL_CLOSE_EVENT:
		m_pServer->ClearServer();
		return TRUE;

	default:
		return FALSE;
	}
}