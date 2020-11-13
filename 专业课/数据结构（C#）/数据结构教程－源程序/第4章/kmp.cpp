#include "sqstring.cpp"
void GetNext(SqString t,int next[])  /*由模式串t求出next值*/
{
	int j,k;
	j=0;k=-1;next[0]=-1;
	while (j<t.length-1) 
	{	
		if (k==-1 || t.data[j]==t.data[k]) 	/*k为-1或比较的字符相等时*/
		{	
			j++;k++;
			next[j]=k;
       	}
       	else  k=next[k];
	}
}
int KMPIndex(SqString s,SqString t)  /*KMP算法*/
{
	int next[MaxSize],i=0,j=0;
	GetNext(t,next);
	while (i<s.length && j<t.length) 
	{
		if (j==-1 || s.data[i]==t.data[j]) 
		{
			i++;j++;  			/*i,j各增1*/
		}
		else j=next[j]; 		/*i不变,j后退*/
    }
    if (j>=t.length)
		return(i-t.length);  		/*返回匹配模式串的首字符下标*/
    else  
		return(-1);        		/*返回不匹配标志*/
}
void main()
{
	SqString s,t;
	StrAssign(s,"ababcabcacbab");
	StrAssign(t,"abcac");
	printf("s:");DispStr(s);
	printf("t:");DispStr(t);
	printf("位置:%d\n",KMPIndex(s,t));
}
