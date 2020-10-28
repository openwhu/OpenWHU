#pragma once

#include<winsock2.h>
#pragma comment(lib,"ws2_32.lib")
class ServeManager
{
public:
	ServeManager();
	~ServeManager();
	WSADATA wsa;
	SOCKET s, new_socket;

	//static SOCKET sArray[100];
	struct sockaddr_in server, client;
	int c;

	//static int iCount;
	int iTempCount;
	HANDLE m_Thread_handle[100];

	void StartListening(int iPort);
	static DWORD WINAPI DataThreadFunc(LPVOID pParam);
	void ClearServer();
};

