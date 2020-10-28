
// Multi_core_hw1Dlg.h : 头文件
//

#pragma once
#include "afxwin.h"


// CMulti_core_hw1Dlg 对话框
class CMulti_core_hw1Dlg : public CDialogEx
{
// 构造
public:
	CMulti_core_hw1Dlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_MULTI_CORE_HW1_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedInput();
	afx_msg void OnBnClickedQuery();
	// 录入学生信息
	CString st_name1;
	CString st_name2;
	CString st_name3;
	CString st_num1;
	CString st_num2;
	CString st_num3;
	CString num_query;
	BOOL register_1;
	BOOL register_2;
	BOOL register_3;
};
