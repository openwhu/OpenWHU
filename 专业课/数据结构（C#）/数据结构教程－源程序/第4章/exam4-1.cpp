#include "sqstring.cpp"
int Strcmp(SqString s,SqString t)
{
	int i,comlen;
	if (s.length<t.length) comlen=s.length;	//求s和t的共同长度
	else comlen=t.length;
	for (i=0;i<comlen;i++)			//在共同长度内逐个字符比较
		if (s.data[i]>t.data[i])
			return 1;
		else if (s.data[i]<t.data[i])
			return -1;
	if (s.length==t.length)			//s==t
		return 0;
	else if (s.length>t.length)		//s>t
		return 1;
	else  return -1;				//s<t
}
void main()
{
	SqString s,t;
	StrAssign(s,"abcdefg");
	StrAssign(t,"ab");
	printf("s:");DispStr(s);
	printf("t:");DispStr(t);
	printf("Strcmp(s,t)=%d\n",Strcmp(s,t));

	StrAssign(s,"abcd");
	StrAssign(t,"abcd");
	printf("s:");DispStr(s);
	printf("t:");DispStr(t);
	printf("Strcmp(s,t)=%d\n",Strcmp(s,t));
}

