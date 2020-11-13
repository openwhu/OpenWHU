#include "sqstring.cpp"
int index(SqString s,SqString t)
{
	int i=0,j=0;
	while (i<s.length && j<t.length) 
	{
		if (s.data[i]==t.data[j])  	//继续匹配下一个字符
		{	
			i++;				//主串和子串依次匹配下一个字符
			j++;  
		}
		else          			//主串、子串指针回溯重新开始下一次匹配
		{	
			i=i-j+1;			//主串从下一个位置开始匹配
			j=0; 				//子串从头开始匹配
		}
	}
	if (j>=t.length)   
		return(i-t.length);  		//返回匹配的第一个字符的下标
	else  
		return(-1);        		//模式匹配不成功
}
void main()
{
	SqString s,t;
	StrAssign(s,"ababcabcacbab");
	StrAssign(t,"abcac");
	printf("s:");DispStr(s);
	printf("t:");DispStr(t);
	printf("位置:%d\n",index(s,t));
}
