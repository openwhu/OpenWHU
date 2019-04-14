#include "stdafx.h"
#include "Student.h"

IMPLEMENT_SERIAL(CStudent, CObject, 1)//最后一个数字为版本号

CStudent::CStudent(void)
{

}

CStudent::CStudent(bool none)
{
	mName = "";
	mNum = "";
	ifregister = false;
}


CStudent::~CStudent()
{
}

CString CStudent::getName()
{
	return mName;
}

CString CStudent::getNum()
{
	return mNum;
}

bool CStudent::getState()
{
	return ifregister;
}

void CStudent::setName(CString name)
{
	mName = name;
}

void CStudent::setNum(CString num)
{
	mNum = num;
}

void CStudent::setState(bool state)
{
	ifregister = state;
}

void CStudent::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{	// storing code
		ar << mName << mNum << ifregister;
	}
	else
	{	// loading code
		ar >> mName >> mNum >> ifregister;
	}
}
