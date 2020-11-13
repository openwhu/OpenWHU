#include "dlinklist.cpp"
void reverse(DLinkList *&L)		//双链表节点逆置
{
	DLinkList *p=L->next,*q;	//p指向开好节点
	L->next=NULL;				//构造只有头节点的双链表L
	while (p!=NULL)				//扫描L的数据节点
	{	q=p->next;				//因头插法会修改*p的next域,用q保存其后继节点
		p->next=L->next;		//采用头插法将*p节点插入到双链表中
		if (L->next!=NULL)		//若L中存在数据节点,修改其前驱指针
			L->next->prior=p;
		L->next=p;
		p->prior=L;
		p=q;					//让p重新指向其后继节点
	}
}
void main()
{
	ElemType a[]={1,8,0,4,9,7,5,2,3,6};
	DLinkList *L;
	CreateListR(L,a,10);
	printf("L:");DispList(L);
	printf("逆置\n");
	reverse(L);
	printf("L:");DispList(L);
	DestroyList(L);
}
