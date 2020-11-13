#include <stdio.h>
#define MaxSize 20
typedef int KeyType;  	//定义关键字类型
typedef char InfoType[10];
typedef struct       	//记录类型
{
	KeyType key;   		//关键字项
	InfoType data; 		//其他数据项,类型为InfoType
} RecType;				//排序的记录类型定义
void BubbleSort1(RecType R[],int n)
{
	int i,j,k,exchange;
	RecType tmp;
	for (i=0;i<n-1;i++) 
	{
		exchange=0;
		for (j=n-1;j>i;j--)	//比较,找出最小关键字的记录
			if (R[j].key<R[j-1].key)
			{
				tmp=R[j];  //R[j]与R[j-1]进行交换,将最小关键字记录前移
				R[j]=R[j-1];
				R[j-1]=tmp;
				exchange=1;
			}

		printf("i=%d: ",i);
		for (k=0;k<n;k++)
			printf("%d ",R[k].key);
		printf("\n");

		if (exchange==0) 	//中途结束算法
			return;
	}
}
void main()
{
	int i,n=10;
	RecType R[MaxSize];
	KeyType a[]={0,1,7,2,5,4,3,6,8,9};
	for (i=0;i<n;i++)
		R[i].key=a[i];
	printf("排序前:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
	BubbleSort1(R,n);
	printf("排序后:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
}


