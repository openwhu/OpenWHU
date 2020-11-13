#include <stdio.h>
#define MaxSize 50
typedef int ElemType; 
typedef struct 
{	
	ElemType data[MaxSize];		//存放顺序表元素
   	int length;					//存放顺序表的长度
} SqList;						//顺序表的类型定义
ElemType Max(SqList L,int i,int j)  //求顺序表L中最大元素
{
	int mid;
	ElemType max,max1,max2;
	if (i==j) 
		max=L.data[i];				//递归出口
	else
	{	
		mid=(i+j)/2;
		max1=Max(L,i,mid);			//递归调用1
		max2=Max(L,mid+1,j); 		//递归调用2
		max=(max1>max2)?max1:max2;
	}
	return(max);
}
void main()
{
	int i;
	SqList L;
	ElemType a[]={3,1,5,8,0,2,4,7,9,6};
	for (i=0;i<10;i++)		//构造顺序表
		L.data[i]=a[i];
	L.length=10;
	printf("Max=%d\n",Max(L,0,9));
}