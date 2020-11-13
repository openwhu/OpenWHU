
// Multi_core_hw1Dlg.cpp : 实现文件
//

#include "stdafx.h"
#include "Multi_core_hw1.h"
#include "Multi_core_hw1Dlg.h"
#include "afxdialogex.h"
#include "Student.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CMulti_core_hw1Dlg 对话框



CMulti_core_hw1Dlg::CMulti_core_hw1Dlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(IDD_MULTI_CORE_HW1_DIALOG, pParent)
	, st_name1(_T(""))
	, st_name2(_T(""))
	, st_name3(_T(""))
	, st_num1(_T(""))
	, st_num2(_T(""))
	, st_num3(_T(""))
	, num_query(_T(""))
	, register_1(FALSE)
	, register_2(FALSE)
	, register_3(FALSE)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMulti_core_hw1Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT1, st_name1);
	DDX_Text(pDX, IDC_EDIT2, st_name2);
	DDX_Text(pDX, IDC_EDIT3, st_name3);
	DDX_Text(pDX, IDC_EDIT5, st_num1);
	DDX_Text(pDX, IDC_EDIT6, st_num2);
	DDX_Text(pDX, IDC_EDIT7, st_num3);
	DDX_Text(pDX, IDC_EDIT4, num_query);
	DDX_Check(pDX, IDC_CHECK1, register_1);
	DDX_Check(pDX, IDC_CHECK2, register_2);
	DDX_Check(pDX, IDC_CHECK3, register_3);
}

BEGIN_MESSAGE_MAP(CMulti_core_hw1Dlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(BT_Input, &CMulti_core_hw1Dlg::OnBnClickedInput)
	ON_BN_CLICKED(BT_Query, &CMulti_core_hw1Dlg::OnBnClickedQuery)
END_MESSAGE_MAP()


// CMulti_core_hw1Dlg 消息处理程序

BOOL CMulti_core_hw1Dlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
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

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CMulti_core_hw1Dlg::OnSysCommand(UINT nID, LPARAM lParam)
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

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CMulti_core_hw1Dlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CMulti_core_hw1Dlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CMulti_core_hw1Dlg::OnBnClickedInput()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdateData(TRUE);//把控件的值传给控件变量
	CFile file(_T("student.dat"), CFile::modeCreate | CFile::modeWrite);
	CArchive ar(&file, CArchive::store);
	CStudent stu(true);

	stu.setName(st_name1);
	stu.setNum(st_num1);
	stu.setState(register_1);
	stu.Serialize(ar);

	stu.setName(st_name2);
	stu.setNum(st_num2);
	stu.setState(register_2);
	stu.Serialize(ar);

	stu.setName(st_name3);
	stu.setNum(st_num3);
	stu.setState(register_3);
	stu.Serialize(ar);

	ar.Close();
	file.Close();
}


void CMulti_core_hw1Dlg::OnBnClickedQuery()
{
	// TODO: 在此添加控件通知处理程序代码
	//从文件读取已注册的学生信息
	CTypedPtrArray<CObArray, CStudent *> m_Students;

	CFile file(_T("student.dat"), CFile::modeRead);
	CArchive ar(&file, CArchive::load);
	
	//从文件读取信息
	CStudent *stu0 = new CStudent();
	stu0->Serialize(ar);
	m_Students.Add(stu0);
	CStudent *stu1 = new CStudent();
	stu1->Serialize(ar);
	m_Students.Add(stu1);
	CStudent *stu2 = new CStudent();
	stu2->Serialize(ar);
	m_Students.Add(stu2);

	ar.Close();
	file.Close();

	UpdateData(TRUE);//把控件的值传给控件变量
	CString student;
	int i;
	for (i = 0;i < m_Students.GetSize();i++)
	{
		CStudent *stu = m_Students.GetAt(i);
		if (stu->getNum() == num_query)
		{
			student += "姓名：";
			student += stu->getName();
			student += "\r\n";
			student += "学号：";
			student += stu->getNum();
			student += "\r\n";
			student += "注册状态：";
			if (stu->getState())
			{
				student += "已注册";
			}
			else
			{
				student += "未注册";
			}
			break;
		}
	}
	if (i >= m_Students.GetSize())
	{
		student = "未查询到该学生！！！";
	}
	MessageBoxA(student);
}
