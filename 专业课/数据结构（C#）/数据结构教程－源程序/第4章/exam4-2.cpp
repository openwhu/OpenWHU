#include "sqstring.cpp"
void LongestString(SqString s,int &index,int &max)
{
	int length=1,i=0,start=0;	//length保存平台的长度
	index=0,max=0;				//index保存最长平台在s中的开始位置,max保存其长度
	while (i<s.length-1)
		if (s.data[i]==s.data[i+1])
		{	
			i++;
			length++;
		}
		else				//上一个平台结束
		{	
			if (max<length)	//当前平台长度大,则更新max
			{	
				max=length;
				index=start;
			}
			i++;start=i;	//初始化下一个平台的起始位置和长度
			length=1;
		}
}
void main()
{
	SqString s;
	int i,j,k;
	StrAssign(s,"aabcsaaaabcdeab");
	printf("s:");DispStr(s);
	LongestString(s,i,j);
	printf("最长平台:");
	for (k=i;k<i+j;k++)
		printf("%c",s.data[k]);
	printf("\n");
}