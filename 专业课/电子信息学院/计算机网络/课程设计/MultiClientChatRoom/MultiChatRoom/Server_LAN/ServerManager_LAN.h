/*
Coded by Robel Sharma
Date: 20-08-2013
If you use in any product please
make sure to write my credits

*/
#pragma once

#include<winsock2.h>

class CServerDlg;
 
#pragma comment(lib,"ws2_32.lib")

class ServerManager
{
public:
	ServerManager(CServerDlg* dialog);
	~ServerManager(void);

	WSADATA wsa;
    SOCKET s , new_socket;

	//static SOCKET sArray[100];
    struct sockaddr_in server , client;
    int c;

    //static int iCount;
	int iTempCount;
	CServerDlg* m_pDialog;
	HANDLE m_Thread_handle[100];
	CWinThread *cpTh[100];

	static void SetStaticVariable(int iC, SOCKET cS);
	void StartListening(int iPort);
	static UINT __cdecl DataThreadFunc(LPVOID pParam);
	UINT SendReceiveData(SOCKET cSocket);
	void ClearServer();
};

