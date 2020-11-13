
// ClientDlg.h : header file
//

#pragma once
#include "stdafx.h"
#include "resource.h"
#include <string>
#include "ClientCon_LAN.h"

// CClientDlg dialog
class CClientDlg : public CDialogEx
{
// Construction
public:
	CClientDlg(CWnd* pParent = NULL);	// standard constructor
	void ShowServerInfo(string sValue);

// Dialog Data
enum { IDD = IDD_CLIENT_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP();
public:
	ClientCon *m_pClient;
	static UINT __cdecl StaticThreadFunc(LPVOID pParam);
    UINT ThreadFunc();
	void AppendTextToEditCtrl(CEdit& edit, LPCTSTR pszText);
	CEdit m_Portbox;

private:
	HANDLE m_Thread_handle;
	CWinThread *cTh;

public:
	CEdit m_Textbox;
	afx_msg void OnBnClickedOk();
	afx_msg void OnClickedBtLogin();
	afx_msg void OnClickedBtLogout();
	afx_msg void OnClickedBtSend();
	afx_msg void OnClickedBtClear();
	afx_msg void OnClickedBtFile();
	//在系统之前截获按键信息
	virtual BOOL PreTranslateMessage(MSG* pMsg);
};
