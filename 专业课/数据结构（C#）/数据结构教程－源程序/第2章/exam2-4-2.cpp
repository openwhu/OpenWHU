#include "sqlist.cpp" 
void move2(SqList *&L)
{
	int i=0,j=L->length-1;
	ElemType pivot=L->data[0];	//以data[0]为基准
	while (i<j)  				//从顺序表两端交替向中间扫描,直至i=j为止
	{	
		while (j>i && L->data[j]>pivot) 
			j--;  				//从右向左扫描,找一个小于等于pivot的data[j]
		L->data[i]=L->data[j];	//找到这样的data[j],放入data[i]处
		i++;
		while (i<j && L->data[i]<=pivot) 
			i++;				//从左向右扫描,找一个大于pivot的记录data[i]
		L->data[j]=L->data[i];	//找到这样的data[i],放入data[j]处
		j--;

		//以下显示每一趟的结果
		for (int a=0;a<L->length;a++)
			printf("%d ",L->data[a]);
		printf("\n");

	}
	L->data[i]=pivot;
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
	move2(L);
	printf("L:");DispList(L);
	DestroyList(L);
}
