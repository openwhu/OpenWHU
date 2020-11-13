#include "linklist.cpp"
void dels(LinkList *&L)
{
	LinkList *p=L->next,*q;
	while (p->next!=NULL) 
	{
		if (p->data==p->next->data)		//找到重复值的节点
		{
			q=p->next;					//q指向这个重复值的节点
			p->next=q->next;			//删除*q节点
			free(q);
		}
		else							//不是重复节点,p指针下移
			p=p->next;
	}
}
void main()
{
	LinkList *L;
	ElemType a[]={1,2,2,2,3,3,3,3,3};
	CreateListR(L,a,9);
	printf("L:"); DispList(L);
	dels(L);
	printf("L:"); DispList(L);
	DestroyList(L);
}
