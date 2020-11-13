#include <stdio.h>
#include <malloc.h>
#define MaxSize 20
typedef int KeyType;  	//定义关键字类型
typedef char InfoType[10];
typedef struct       	//记录类型
{
	KeyType key;   		//关键字项
	InfoType data; 		//其他数据项,类型为InfoType
} RecType;				//排序的记录类型定义

void Merge(RecType R[],int low,int mid,int high) 
{
	RecType *R1;
	int i=low,j=mid+1,k=0; //k是R1的下标,i、j分别为第1、2段的下标
	R1=(RecType *)malloc((high-low+1)*sizeof(RecType));  //动态分配空间
	while (i<=mid && j<=high)     	//在第1段和第2段均未扫描完时循环
		if (R[i].key<=R[j].key)    	//将第1段中的记录放入R1中
		{
			R1[k]=R[i];
			i++;k++; 
		}
		else                       		//将第2段中的记录放入R1中
		{
			R1[k]=R[j];
			j++;k++; 
		}
	while (i<=mid)          	       	//将第1段余下部分复制到R1
	{ 
		R1[k]=R[i];
		i++;k++; 
	}
    while (j<=high)                	//将第2段余下部分复制到R1
	{
		R1[k]=R[j];
		j++;k++;  
	}
    for (k=0,i=low;i<=high;k++,i++) //将R1复制回R中
	    R[i]=R1[k];
} 
void MergeSortDC(RecType R[],int low,int high)
//对R[low..high]进行二路归并排序
{
	int mid;
	if (low<high)
	{	mid=(low+high)/2;
		MergeSortDC(R,low,mid);
		MergeSortDC(R,mid+1,high);
		Merge(R,low,mid,high);
	}
}
void MergeSort1(RecType R[],int n)	//自顶向下的二路归并算法
{
	MergeSortDC(R,0,n-1);
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
	MergeSort1(R,n);
	printf("排序后:");
	for (i=0;i<n;i++)
		printf("%d ",R[i].key);
	printf("\n");
}


