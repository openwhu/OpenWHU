#pragma once
class CStudent : public CObject
{
private:
	CString mName;
	CString mNum;
	bool ifregister;
public:
	CStudent(void);
	CStudent(bool none);
	~CStudent();
	CString getName();
	CString getNum();
	bool getState();
	void setName(CString name);
	void setNum(CString num);
	void setState(bool state);
	virtual void Serialize(CArchive& ar);
	DECLARE_SERIAL(CStudent);
};

