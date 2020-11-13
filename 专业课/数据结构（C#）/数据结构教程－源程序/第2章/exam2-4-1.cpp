#include "sqlist.cpp"  
void move1(SqList *&L)
{
	int i=0,j=L->length-1;
	ElemType pivot=L->data[0];	//以data[0]为基准
	ElemType tmp;
	while (i<j)  			//从区间两端交替向中间扫描,直至i=j为止
	{	
		while (i<j && L->data[j]>pivot) 
			j--;  			//从右向左扫描,找第1个小于等于pivot的元素
		while (i<j && L->data[i]<=pivot) 
			i++;			//从左向右扫描,找第1个大于pivot的元素
		if (i<j)
		{
			tmp=L->data[i];	//L->data[i]和L->data[j]进行交换
			L->data[i]=L->data[j];
			L->data[j]=tmp;
		}
		//以下输出每一趟的结果
		for (int a=0;a<L->length;a++)
			printf("%d ",L->data[a]);
		printf("\n");
	}
	tmp=L->data[0];			//L->data[0]和L->data[j]进行交换
	L->data[0]=L->data[j];
	L->data[j]=tmp;
	printf("基准位置i=%d\n",i);
}

void main()
{
	SqList *L;
	//ElemType a[]={3,8,2,7,1,5,3,4,6,0};
	ElemType a[]={3,8,2,7,3,5,3,4,6,0};
	CreateList(L,a,10);
	printf("L:");DispList(L);
	printf("执行移动运算\n");
	move1(L);
	printf("L:");DispList(L);
	DestroyList(L);
}
