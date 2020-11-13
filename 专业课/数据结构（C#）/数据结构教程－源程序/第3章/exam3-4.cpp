#include "sqstack.cpp"
bool symmetry(ElemType str[])
{
	int i;  ElemType e;
	SqStack *st;
	InitStack(st);				//初始化栈
	for (i=0;str[i]!='\0';i++)	//将串所有元素进栈
		Push(st,str[i]);		//元素进栈
	for (i=0;str[i]!='\0';i++)
	{
		Pop(st,e);				//退栈元素e
		if (str[i]!=e)			//若e与当前串元素不同则不是对称串
		{
			DestroyStack(st);	//销毁栈
			return false;
		}
	}
	DestroyStack(st);			//销毁栈
	return true;
}

void main()
{
	ElemType str[]="1234321";
	if (symmetry(str))
		printf("%s是对称串\n",str);
	else
		printf("%s不是对称串\n",str);
}