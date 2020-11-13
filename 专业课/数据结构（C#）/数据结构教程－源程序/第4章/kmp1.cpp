#include "sqstring.cpp"
void GetNextval(SqString t,int nextval[])  //由模式串t求出nextval值
{
	int j=0,k=-1;
	nextval[0]=-1;
   	while (j<t.length) 
	{
       	if (k==-1 || t.data[j]==t.data[k]) 
		{	
			j++;k++;
			if (t.data[j]!=t.data[k]) 
				nextval[j]=k;
           	else  
				nextval[j]=nextval[k];
       	}
       	else  k=nextval[k];    	
	}

}
int KMPIndex1(SqString s,SqString t)    //修正的KMP算法
{
	int nextval[MaxSize],i=0,j=0;
	GetNextval(t,nextval);
	while (i<s.length && j<t.length) 
	{
		if (j==-1 || s.data[i]==t.data[j]) 
		{	
			i++;j++;	
		}
		else j=nextval[j];
	}
	if (j>=t.length)  
		return(i-t.length);
	else
		return(-1);
}
void main()
{
	SqString s,t;
	StrAssign(s,"ababcabcacbab");
	StrAssign(t,"abcac");
	printf("s:");DispStr(s);
	printf("t:");DispStr(t);
	printf("位置:%d\n",KMPIndex1(s,t));
}
