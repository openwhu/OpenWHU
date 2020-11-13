#include "sqlist.cpp"
void delnode1(SqList *&L,ElemType x)
{
	int k=0,i;  //k记录值不等于x的元素个数
	for  (i=0;i<L->length;i++) 
		if (L->data[i]!=x)
		{
			L->data[k]=L->data[i];
			k++;    //不等于x的元素增1
		}
	L->length=k;  //顺序表L的长度等于k
}
void delnode2(SqList *&L,ElemType x)
{ 
	int k=0,i=0; //k记录值等于x的元素个数
	while (i<L->length) 
	{
		if (L->data[i]==x) 
			k++;
		else 
			L->data[i-k]=L->data[i]; //当前元素前移k个位置
		i++;
	}
	L->length-=k;	//顺序表L的长度递减k
}

void main()
{
	ElemType a[]={1,2,2,1,0,2,4,2,3,1};
	ElemType x=2;
	SqList *L;
	CreateList(L,a,10);
	printf("L:");DispList(L);
	printf("删除值为%d的元素\n",x);
	delnode2(L,x);
	printf("L:");DispList(L);
	DestroyList(L);
}