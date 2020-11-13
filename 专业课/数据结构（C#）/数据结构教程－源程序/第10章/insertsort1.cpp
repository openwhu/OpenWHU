#include <stdio.h>
#define MaxSize 20
typedef int KeyType;  	//定义关键字类型
typedef char InfoType[10];
typedef struct       	//记录类型
{
	KeyType key;   		//关键字项
	InfoType data; 		//其他数据项,类型为InfoType
} RecType;				//排序的记录类型定义

void InsertSort1(RecType R[],int n) //对R[0..n-1]按递增有序进行直接插入排序
{
	int i,j,low,high,mid;
	RecType tmp;
	for (i=1;i<n;i++) 
	{
		tmp=R[i];
		low=0;high=i-1;
		while (low<=high)
		{
			mid=(low+high)/2;
			if (tmp.key<R[mid].key)
				high=mid-1;
			else
				low=mid+1;
		}
		for (j=i-1;j>=high+1;j--)
			R[j+1]=R[j];
		R[high+1]=tmp;
		printf("i=%d: ",i);
		for (j=0;j<n;j++)
			printf("%d ",R[j].key);
		printf("\n");
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
	InsertSort1(R,n);
	printf("排序后:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
}


