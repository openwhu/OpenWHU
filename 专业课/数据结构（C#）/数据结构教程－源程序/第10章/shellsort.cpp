#include <stdio.h>
#define MaxSize 20
typedef int KeyType;  	//定义关键字类型
typedef char InfoType[10];
typedef struct       	//记录类型
{
	KeyType key;   		//关键字项
	InfoType data; 		//其他数据项,类型为InfoType
} RecType;				//排序的记录类型定义

void ShellSort(RecType R[],int n)	//希尔排序算法
{
	int i,j,gap,k;
	RecType tmp;
	gap=n/2;				//增量置初值
	while (gap>0)
	{	for (i=gap;i<n;i++) //对所有相隔gap位置的所有元素组进行排序
		{	tmp=R[i];
			j=i-gap;
			while (j>=0 && tmp.key<R[j].key)//对相隔gap位置的元素组进行排序
			{	R[j+gap]=R[j];
				j=j-gap;
			}
			R[j+gap]=tmp;
			j=j-gap;
		}
		printf("gap=%d:",gap);
		for (k=0;k<n;k++)
			printf("%d ",R[k].key);
		printf("\n");
		gap=gap/2;	//减小增量
	}
}

void main()
{
	int i,n=10;
	RecType R[MaxSize];
	KeyType a[]={9,8,7,6,5,4,3,2,1,0};
	for (i=0;i<n;i++)
		R[i].key=a[i];
	printf("排序前:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
	ShellSort(R,n);
	printf("排序后:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
}


