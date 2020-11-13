#include "StdAfx.h"
#include "ServeManager.h"
#include <Windows.h>
#include <winsock2.h>
#include <WS2tcpip.h>
#include <iostream>
using namespace std;

static SOCKET sArray[100];
static int iCount;

ServeManager::ServeManager()
{
}

ServeManager::~ServeManager()
{
	char *message;
	message = "serve is closed";
	for (int i = 1; i <= iCount; i++)
	{
		if (send(sArray[i], message, strlen(message), 0) == SOCKET_ERROR)
		{
			printf("Send failed");
		}
	}
	closesocket(s);
	WSACleanup();
}

void ServeManager::ClearServer()
{
	char *message;
	message = "serve is closed";
	for (int i = 1; i <= iCount; i++)
	{
		if (send(sArray[i], message, strlen(message), 0) == SOCKET_ERROR)
		{
			printf("Send failed");
		}
	}
	closesocket(s);
	WSACleanup();//terminates use of the Ws2_32.dll
}

void ServeManager::StartListening(int iPort)
{
	iCount = 0;
	printf("Initialising Winsock...\n");
	//WASStartup: initiates use of Ws2_32.dll by a process
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
	{
		printf("Failed. Error Code : %d\n", WSAGetLastError());
		return;
	}

	printf("Initialised.\n");

	//Create a socket(AF_INET: internet work, SOCK_STREAM: Use TCP protocol)
	if ((s = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET)
	{
		printf("Could not create socket : %d\n", WSAGetLastError());
	}

	printf("Socket created.\n");

	//Prepare the sockaddr_in structure
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(iPort);

	//Bind
	if (bind(s, (struct sockaddr *)&server, sizeof(server)) == SOCKET_ERROR)
	{
		printf("Bind failed with error code : %d\n", WSAGetLastError());
		exit(EXIT_FAILURE);
	}

	printf("Bind done\n");

	//Listen to incoming connections, maximum connection 100
	listen(s, 100);
	char *message;
	printf("Waiting for incoming connections...\n");
	c = sizeof(struct sockaddr_in);

	while ((new_socket = accept(s, (struct sockaddr *)&client, &c)) != INVALID_SOCKET)
	{
		printf("Connection accepted\n");
		// m_pDialog->ShowServerInfo("Connection accepted\n");
		//Reply to the client
		socklen_t len;
		struct sockaddr_storage addr;
		char ipstr[INET6_ADDRSTRLEN];
		int port;

		len = sizeof addr;
		//retrieves the name of the peer to which a socket is connected
		getpeername(new_socket, (struct sockaddr*)&addr, &len);

		// deal with IPv4:
		if (addr.ss_family == AF_INET) {
			struct sockaddr_in *s = (struct sockaddr_in *)&addr;
			port = ntohs(s->sin_port);
			//converts an (Ipv4) Internet network address into a string in Internet standard dotted format
			inet_ntop(AF_INET, &s->sin_addr, ipstr, sizeof ipstr);
		}

		printf("Peer IP address: %s\n", ipstr);
		HANDLE handle1 = CreateThread(NULL, 0, DataThreadFunc, (LPVOID)new_socket, 0, NULL);
		++iCount;
		//m_Thread_handle[++iCount] = cTh->m_hThread;
		//cpTh[iCount] = cTh;
		sArray[iCount] = new_socket;//store the new connection
									//message = "Hello Client , I have received your connection.\n";
									//send(new_socket , message , strlen(message) , 0);

									//SetStaticVariable(iTempCount, new_socket);
	}

	if (new_socket == INVALID_SOCKET)
	{
		printf("accept failed with error code : %d\n", WSAGetLastError());
		return;
	}
}

DWORD WINAPI ServeManager::DataThreadFunc(LPVOID pParam)
{
	SOCKET pYourSocket = reinterpret_cast<SOCKET>(pParam);
	//UINT retCode = pYourClass->ThreadFunc();
	//SendReceiveData(pYourClass);


	char *message;
	message = "Welcome to Magic TCP chat room.\n";
	send(pYourSocket, message, strlen(message), 0);//send the message to a specific connected socket
	const int REC_BUFFERSIZE = 1024;
	char server_reply[REC_BUFFERSIZE + 1];
	int recv_size;

	while ((recv_size = recv(pYourSocket, server_reply, REC_BUFFERSIZE, 0)) != SOCKET_ERROR)
	{
		server_reply[recv_size] = '\0';//the end of a string
									   //m_pDialog->ShowServerInfo("Message Received: "+ string(server_reply));
		for (int i = 1;i <= iCount; i++)
		{
			//将收到的消息转发给每一个连接的客户端
			if (sArray[i] != pYourSocket)//没必要转发给发消息的人
			{
				if (send(sArray[i], server_reply, recv_size, 0) == SOCKET_ERROR)
				{
					printf("Send failed");
				}
			}
		}
		send(pYourSocket, "READY!", 6, 0);//发送确认回信
	}
	return 0;
}