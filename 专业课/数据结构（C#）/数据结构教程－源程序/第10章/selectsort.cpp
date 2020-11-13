#include <stdio.h>
#define MaxSize 20
typedef int KeyType;  	//定义关键字类型
typedef char InfoType[10];
typedef struct       	//记录类型
{
	KeyType key;   		//关键字项
	InfoType data; 		//其他数据项,类型为InfoType
} RecType;				//排序的记录类型定义
void SelectSort(RecType R[],int n)
{
	int i,j,k,l;
	RecType temp;
	for (i=0;i<n-1;i++)    	 	//做第i趟排序
	{
		k=i;
		for (j=i+1;j<n;j++)  	//在当前无序区R[i..n-1]中选key最小的R[k]
			if (R[j].key<R[k].key)
				k=j;           	//k记下目前找到的最小关键字所在的位置
			if (k!=i)          		//交换R[i]和R[k]
			{
				temp=R[i];
				R[i]=R[k];
				R[k]=temp;  
			}
		printf("i=%d: ",i);
		for (l=0;l<n;l++)
			printf("%d ",R[l].key);
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
	SelectSort(R,n);
	printf("排序后:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
}


