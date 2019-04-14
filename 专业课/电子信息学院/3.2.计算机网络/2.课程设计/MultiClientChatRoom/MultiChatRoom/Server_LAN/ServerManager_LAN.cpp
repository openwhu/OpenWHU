/*
Coded by Robel Sharma
Date: 20-08-2013
If you use in any product please
make sure to write my credits

*/

#include "StdAfx.h"
#include "ServerManager_LAN.h"
#include "Server_LAN.h"
#include "ServerDlg_LAN.h"
#include <Windows.h>
#include <winsock2.h>
#include <WS2tcpip.h>

static SOCKET sArray[100];
static int iCount;
ServerManager::ServerManager(CServerDlg* dialog)
{
	m_pDialog = dialog;
}

ServerManager::~ServerManager()
{
	
	closesocket(s);
    WSACleanup();
}

void ServerManager::ClearServer()
{
	closesocket(s);
    WSACleanup();//terminates use of the Ws2_32.dll

	/*
	for(int i=1;i<=iCount;++i)
	{
		DWORD dwCode;  
        GetExitCodeThread(cpTh[i]->m_hThread, &dwCode);  
        delete cpTh[i];
		//CloseHandle(m_Thread_handle[i]);
	}*/
}

void ServerManager::StartListening(int iPort)
{
	iCount=0;
	printf("\nInitialising Winsock...");
	//WASStartup: initiates use of Ws2_32.dll by a process
    if (WSAStartup(MAKEWORD(2,2),&wsa) != 0)
    {
        printf("Failed. Error Code : %d", WSAGetLastError());
        return;
    }
    
    printf("Initialised.\n");
    
    //Create a socket(AF_INET: internet work, SOCK_STREAM: Use TCP protocol)
    if((s = socket(AF_INET , SOCK_STREAM , 0 )) == INVALID_SOCKET)
    {
        printf("Could not create socket : %d" , WSAGetLastError());
		m_pDialog->ShowServerInfo("Could not create socket");
    }
 
    printf("Socket created.\n");
     
    //Prepare the sockaddr_in structure
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons( iPort );
     
    //Bind
    if( bind(s ,(struct sockaddr *)&server , sizeof(server)) == SOCKET_ERROR)
    {
        printf("Bind failed with error code : %d" , WSAGetLastError());
		m_pDialog->ShowServerInfo("Bind failed with error code");
        exit(EXIT_FAILURE);
    }
     
    puts("Bind done");
 
    //Listen to incoming connections, maximum connection 100
    listen(s , 100);
	 char *message;
	 puts("Waiting for incoming connections...");
     m_pDialog->ShowServerInfo("Waiting for incoming connections...\n");
     c = sizeof(struct sockaddr_in);
     
    while( (new_socket = accept(s , (struct sockaddr *)&client, &c)) != INVALID_SOCKET )
    {
        puts("Connection accepted");
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
		m_pDialog->ShowServerInfo("Connected Peer IP address: " + string(ipstr) + "\n");
		CWinThread *cTh = AfxBeginThread(DataThreadFunc, (LPVOID)new_socket);
		++iCount;
		sArray[iCount] = new_socket;//store the new connection
    }
     
    if (new_socket == INVALID_SOCKET)
    {
        printf("accept failed with error code : %d" , WSAGetLastError());
        return;
    }
}

UINT __cdecl ServerManager::DataThreadFunc(LPVOID pParam)
{
	SOCKET pYourSocket = reinterpret_cast<SOCKET>(pParam);

	char *message;
	message = "Welcome to Magic TCP chat room.\n";
    send(pYourSocket , message , strlen(message) , 0);//send the message to a specific connected socket
	const int REC_BUFFERSIZE = 1024;
	char server_reply[REC_BUFFERSIZE + 1];
    int recv_size;

	while((recv_size = recv(pYourSocket , server_reply , REC_BUFFERSIZE , 0)) != SOCKET_ERROR)
	{
		server_reply[recv_size] = '\0';//the end of a string
		//m_pDialog->ShowServerInfo("Message Received: "+ string(server_reply));
		for(int i = 1;i <= iCount; i++)
		{
			//将收到的消息转发给每一个连接的客户端
			if(sArray[i] != pYourSocket)//没必要转发给发消息的人
			{
				if (send(sArray[i], server_reply, recv_size, 0) == SOCKET_ERROR)
				{
					puts("Send failed");
				}
			}
		}
		send(pYourSocket, "READY!", 6, 0);//发送确认回信
	}
    return 0;
}

UINT ServerManager::SendReceiveData(SOCKET cSocket)
{
	return 0;
}

void ServerManager::SetStaticVariable(int iC, SOCKET cS)
{
	iCount = iC;
	sArray[iCount] = cS;
}