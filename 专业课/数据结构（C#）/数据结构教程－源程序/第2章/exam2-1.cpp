#include "sqlist.cpp"   //假设线性表以顺序表表示
void main()
{
	SqList *L;
	ElemType e;
	InitList(L);
	ListInsert(L,1,1);
	ListInsert(L,2,3);
	ListInsert(L,3,1);
	ListInsert(L,4,4);
	ListInsert(L,5,2);
	printf("ListLength(L)=%d\n",ListLength(L));
	printf("ListEmpty(L)=%d\n",ListEmpty(L));
	GetElem(L,3,e);
	printf("e=%d\n",e);
	printf("LocateElem(L,1)=%d\n",LocateElem(L,1));
	ListInsert(L,4,5);
	DispList(L);
	ListDelete(L,3,e);
	DispList(L);
	DestroyList(L);
}