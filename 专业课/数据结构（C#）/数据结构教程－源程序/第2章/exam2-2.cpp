#include "sqlist.cpp"   //假设线性表以顺序表表示
void unionList(SqList *LA,SqList *LB,SqList *&LC) 
{
	int lena,i;
	ElemType e;
	InitList(LC);
	for (i=1;i<=ListLength(LA);i++)	//将LA的所有元素插入到Lc中
	{	
		GetElem(LA,i,e);
		ListInsert(LC,i,e);
	}
	lena=ListLength(LA);    			//求线性表LA的长度
	for (i=1;i<=ListLength(LB);i++) 
	{	
		GetElem(LB,i,e); 				//取LB中第i个数据元素赋给e
		if (!LocateElem(LA,e)) 
			ListInsert(LC,++lena,e); 	//LA中不存在和e相同者,则插入到LC中
	}
}

void main()
{
	SqList *LA,*LB,*LC;
	InitList(LA);
	InitList(LB);
	//构造LA={1,3,2}
	ListInsert(LA,1,1);
	ListInsert(LA,2,3);
	ListInsert(LA,3,2);
	printf("LA:");DispList(LA);
	//构造LB={1,4,2}
	ListInsert(LB,1,1);
	ListInsert(LB,2,4);
	ListInsert(LB,3,2);
	printf("LB:");DispList(LB);
	unionList(LA,LB,LC);
	printf("LC=LA∪LB\n");
	printf("LC:");DispList(LC);
	DestroyList(LA);
	DestroyList(LB);
	DestroyList(LC);
}