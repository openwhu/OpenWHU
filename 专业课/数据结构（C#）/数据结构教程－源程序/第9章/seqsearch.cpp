#include <stdio.h>
#define MAXL 100
typedef int KeyType;
typedef char InfoType[10];
typedef struct 
{	
	KeyType key;                //KeyType为关键字的数据类型
	InfoType data;              //其他数据
} NodeType;
typedef NodeType SeqList[MAXL];		//顺序表类型
int SeqSearch(SeqList R,int n,KeyType k)
{
    int i=0;
    while (i<n && R[i].key!=k)	//从表头往后找
		i++;
    if (i>=n) 
		return -1;
    else 
		return i;
}
void main()
{
	int i,n=10;
	SeqList R;
	KeyType a[]={2,3,1,8,5,4,9,0,7,6},x=9;
	for (i=0;i<n;i++)
		R[i].key=a[i];
	printf("R[%d]=%d\n",SeqSearch(R,n,x),x);
}
