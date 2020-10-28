#pragma once

#include "string"
#include <winsock2.h>
#include <stdio.h>
#include "FileUtil.h"
using namespace std;
class CClientDlg;

class ClientCon
{
public:
	ClientCon(CClientDlg *dlg);
	~ClientCon(void);
	void StartConnect(string sAddress, int iPort, string sUsername);
	void SendData(string sMessage, bool showName = false);
	void SendFile(FILE* file, CString filename);

	WSADATA wsa;
    SOCKET sClient;
	CClientDlg *m_pClient;
	string m_pUser;
	bool isFile;//接收方用于控制是否接受文件
	bool isReady;//发送方用于控制是否继续发送文件
	FileUtil fu;
	FILE * file;
};

