
// ClientDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ClientDlg.h"
#include "ClientCon.h"
#include "FileUtil.h"
#include <string>
using namespace std;

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CClientDlg dialog
CClientDlg::CClientDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CClientDlg::IDD, pParent),
	m_pClient(NULL)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CClientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_Message, m_Textbox);
}

BEGIN_MESSAGE_MAP(CClientDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDOK, &CClientDlg::OnBnClickedOk)
	ON_BN_CLICKED(IDC_BT_LogIn, &CClientDlg::OnClickedBtLogin)
	ON_BN_CLICKED(IDC_BT_LogOut, &CClientDlg::OnClickedBtLogout)
	ON_BN_CLICKED(IDC_BT_Send, &CClientDlg::OnClickedBtSend)
	ON_BN_CLICKED(IDC_BT_CLEAR, &CClientDlg::OnClickedBtClear)
	ON_BN_CLICKED(IDC_BT_FILE, &CClientDlg::OnClickedBtFile)
END_MESSAGE_MAP()


// CClientDlg message handlers

BOOL CClientDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CClientDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CClientDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CClientDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CClientDlg::ShowServerInfo(string sValue)
{
	CString strLine(sValue.c_str());
	// add CR/LF to text
	//MessageBox(sValue.c_str());
	AppendTextToEditCtrl(m_Textbox, strLine);
	//DoModal();
	//UpdateData(TRUE);
}

void CClientDlg::AppendTextToEditCtrl(CEdit& edit, LPCTSTR pszText)
{
   // get the initial text length
   int nLength = edit.GetWindowTextLength();
   // put the selection at the end of text
   edit.SetSel(nLength, nLength);
   // replace the selection
   edit.ReplaceSel(pszText);
}

UINT __cdecl CClientDlg::StaticThreadFunc(LPVOID pParam)
{
	CClientDlg *pYourClass = reinterpret_cast<CClientDlg*>(pParam);
    UINT retCode = pYourClass->ThreadFunc();

    return retCode;
}

UINT CClientDlg::ThreadFunc()
{ 
	CString username;
	GetDlgItemText(IDC_EDIT_Name, username);

	m_pClient = new ClientCon(this);

	string IPAddress = "203.195.199.250";
	int iPort = 1680;
	CT2CA CStringToAscii2(username);

	std::string UserName (CStringToAscii2);
	//StartConnect()死循环等待数据，所以只能放在子线程
	m_pClient->StartConnect(IPAddress, iPort, UserName);
	return 0;
}

void CClientDlg::OnBnClickedOk()
{
	OnClickedBtLogin();
}

void CClientDlg::OnClickedBtLogin()
{
	//一个客户端可能同时连接不止一个服务器，所以开新的线程处理连接
	if (m_pClient == NULL)
	{
		cTh = AfxBeginThread(StaticThreadFunc, this);
		m_Thread_handle = cTh->m_hThread;
	}
}

void CClientDlg::OnClickedBtLogout()
{
	// TODO: 在此添加控件通知处理程序代码
	if (m_pClient != NULL)
	{
		std::string sResultedString(m_pClient->m_pUser + " is logged out\n");
		m_pClient->SendData(sResultedString);
		delete m_pClient;
		m_pClient = NULL;
	}
	else
	{
		ShowServerInfo("You haven't log in yet.\n");
	}
}


void CClientDlg::OnClickedBtSend()
{
	// TODO: 在此添加控件通知处理程序代码
	CString sTextData;
	GetDlgItemText(IDC_EDIT_SendText, sTextData);

	CT2CA CStringToAscii(sTextData);

	// construct a std::string using the LPCSTR input
	std::string sResultedString(CStringToAscii);
	if (m_pClient != NULL) 
	{
		m_pClient->SendData(sResultedString);
	}
	else
	{
		ShowServerInfo("Please log in first.\n");
	}
	CWnd* pWnd = GetDlgItem(IDC_EDIT_SendText);
	pWnd->SetWindowText(_T(""));//清空发送区
}


void CClientDlg::OnClickedBtClear()
{
	// TODO: 在此添加控件通知处理程序代码
	CWnd* pWnd = GetDlgItem(IDC_EDIT_Message);
	pWnd->SetWindowText(_T("Welcome to Magic TCP chat room!!!"));//清空接收区
}


void CClientDlg::OnClickedBtFile()
{
	// TODO: 在此添加控件通知处理程序代码
	// 设置过滤器     
	TCHAR szFilter[] = _T("记事本文件(*.txt*)|*.txt*|所有文件(*.*)|*.*||");
	// 构造打开文件对话框     
	CFileDialog fileDlg(TRUE, _T("."), NULL, 0, szFilter, this);
	CString strFilePath;
	CString strFileName;

	// 显示打开文件对话框     
	if (IDOK == fileDlg.DoModal())
	{
		// 如果点击了文件对话框上的“打开”按钮，则将选择的文件路径显示到编辑框里     
		strFilePath = fileDlg.GetPathName();
		strFileName = fileDlg.GetFileTitle();
		FileUtil fu;
		FILE *f = fu.openFile(strFilePath);
		if ((f != NULL) && (m_pClient != NULL))
		{
			m_pClient->SendData("群发了文件" + std::string(CW2A(strFileName.GetString())));
			m_pClient->SendFile(f, strFileName);
		}
		else
		{
			ShowServerInfo("Please log in first.\n");
		}
	}
}


BOOL CClientDlg::PreTranslateMessage(MSG* pMsg)
{
	// TODO: 在此添加专用代码和/或调用基类
	if ((pMsg->message == WM_KEYDOWN) && (pMsg->wParam == VK_RETURN))
	{
		if (GetDlgItem(IDC_EDIT_SendText) == GetFocus())
		{
			OnClickedBtSend();
			return false;
		}
	}
	return CDialogEx::PreTranslateMessage(pMsg);
}
