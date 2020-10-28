#pragma once
#include <stdio.h>
#include <WINSOCK2.H>
#include <io.h> 
#include <string>
#pragma  comment(lib,"ws2_32.lib")
using namespace std;

class FileUtil
{
private:
	FILE *f;
public:
	FILE * openFile(CString filename)
	{
		char* name = CString2Char(filename);
		if (f = fopen(name, "r"))
		{
			printf("文件打开成功\n");
			return f;
		}
		else
		{
			printf("文件不存在\n");
			return NULL;
		}
	}

	FILE * createFile(char *name)
	{
		//创建一个空的文件，若有同名文件存在则将内容删除
		if (f = fopen(name, "w"))
		{
			printf("文件创建成功\n");
		}
		else
		{
			printf("文件创建失败\n");
		}
		return f;
	}

	bool createDir(char *dir)
	{
		char head[MAX_PATH] = "md ";
		return system(strcat(head, dir));
	}

	char* CString2Char(CString string) 
	{
		int n = string.GetLength(); //获取str的字符数  
		char *pChar = new char[n + 1]; //以字节为单位  
		WideCharToMultiByte(CP_ACP, 0, string, n, pChar, n + 1, NULL, NULL); //宽字节编码转换成多字节编码  
		pChar[n] = '\0'; //多字节字符以'\0'结束
		return pChar;
	}

	char* string2Char(string string)
	{
		return (char *)string.data();
	}
};