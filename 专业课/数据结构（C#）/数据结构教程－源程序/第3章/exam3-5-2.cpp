#include "listack.cpp"
#include <string.h>
bool Match(char exp[],int n)
{
	int i=0; char e;
	bool match=true;
	LiStack *st;
	InitStack(st);						//初始化栈
	while (i<n && match)				//扫描exp中所有字符
	{
		if (exp[i]=='(')				//当前字符为左括号,将其进栈
			Push(st,exp[i]);
		else if (exp[i]==')')			//当前字符为右括号
		{
			if (GetTop(st,e)==true)
			{	
				if (e!='(')				//栈顶元素不为'('时表示不匹配
					match=false;
				else
					Pop(st,e);			//将栈顶元素出栈
			}
			else  match=false;			//无法取栈顶元素时表示不匹配
		}
		i++;							//继续处理其他字符
	}
	if (!StackEmpty(st))				//栈不空时表示不匹配
		match=false;
	DestroyStack(st);					//销毁栈
	return match;
}

void main()
{
	char exp[]="(1+2*(5+3)/2)";
	if (Match(exp,strlen(exp))==1)
		printf("表达式%s括号配对\n",exp);
	else
		printf("表达式%s括号不配对\n",exp);
}