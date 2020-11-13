#include <stdio.h>
#define MAXL 100	//数据表的最大长度
#define MAXI 20		//索引表的最大长度
typedef int KeyType;
typedef char InfoType[10];
typedef struct 
{	
	KeyType key;                //KeyType为关键字的数据类型
	InfoType data;              //其他数据
} NodeType;
typedef NodeType SeqList[MAXL];	//顺序表类型

typedef struct 
{	
	KeyType key;			//KeyType为关键字的类型
	int link;				//指向对应块的起始下标
} IdxType;
typedef IdxType IDX[MAXI];	//索引表类型

int IdxSearch(IDX I,int m,SeqList R,int n,KeyType k)
{
	int low=0,high=m-1,mid,i;
	int b=n/m;            	//b为每块的记录个数
	while (low<=high)    	//在索引表中进行二分查找,找到的位置存放在low中
	{
		mid=(low+high)/2;
		if (I[mid].key>=k)	
			high=mid-1;
		else 
			low=mid+1;
	}
	//应在索引表的high+1块中,再在线性表中进行顺序查找
	i=I[high+1].link;
	while (i<=I[high+1].link+b-1 && R[i].key!=k) i++;
	if (i<=I[high+1].link+b-1) 
		return i;
	else 
		return -1;
}

void main()
{
	int i,n=25,m=5,j;
	SeqList R;
	IDX I={{14,0},{34,5},{66,10},{85,15},{100,20}};
	KeyType a[]={8,14,6,9,10,22,34,18,19,31,40,38,54,66,46,71,78,68,80,85,100,94,88,96,87};
	KeyType x=85;
	for (i=0;i<n;i++)
		R[i].key=a[i];
	j=IdxSearch(I,m,R,n,x);
	if (j!=-1)
		printf("R[%d]=%d\n",j,x);
	else
		printf("未找到%d\n",x);
}
