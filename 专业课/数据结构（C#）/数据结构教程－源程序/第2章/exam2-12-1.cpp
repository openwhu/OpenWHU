#include "sqlist.cpp"
void UnionList(SqList *LA,SqList *LB,SqList *&LC)
{
	int i=0,j=0,k=0;	//i、j、k分别作为LA、LB、LC的下标
	LC=(SqList *)malloc(sizeof(SqList));
	LC->length=0;
	while (i<LA->length && j<LB->length)
	{	
		if (LA->data[i]<LB->data[j])
		{	
			LC->data[k]=LA->data[i];
			i++;k++;
		}
		else				//LA->data[i]>LB->data[j]
		{	
			LC->data[k]=LB->data[j];
			j++;k++;
		}
	}
	while (i<LA->length)	//LA尚未扫描完,将其余元素插入LC中
	{	
		LC->data[k]=LA->data[i];
		i++;k++;
	}
	while (j<LB->length)  //LB尚未扫描完,将其余元素插入LC中
	{	
		LC->data[k]=LB->data[j];
		j++;k++;
	} 
	LC->length=k;
}
void main()
{
	SqList *L1,*L2,*L3;
	ElemType a[]={1,3,5};
	ElemType b[]={2,4,8,10};
	CreateList(L1,a,3);
	printf("L1:");DispList(L1);
	CreateList(L2,b,4);
	printf("L2:");DispList(L2);
	printf("归并\n");
	UnionList(L1,L2,L3);
	printf("L3:");DispList(L3);
	DestroyList(L1);
	DestroyList(L2);
	DestroyList(L3);
}

