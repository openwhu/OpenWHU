#include "linklist.cpp"
void Commnode(LinkList *&LA,LinkList *LB,LinkList *LC)
{
	LinkList *pa=LA->next,*pb=LB->next,*pc=LC->next,*q,*r;
	LA->next=NULL;  		//此时LA作为新建单链表的头结点
	r=LA;					//r始终指向新单链表最后一个结点
	while (pa!=NULL)		//查找均包含的公共结点并建立新链表
	{	
		while (pb!=NULL && pa->data>pb->data) //pa所指结点与LB中结点进行比较
			pb=pb->next;
		while (pc!=NULL && pa->data>pc->data) //pa所指结点与LC中结点进行比较
			pc=pc->next;
		if (pb!=NULL && pc!=NULL && pa->data==pb->data && pa->data==pc->data) //pa所指结点是公共结点
		{	
			r->next=pa;			//将*pa结点插入到LA中
			r=pa;		
			pa=pa->next;		//pa移到下一个结点
		}
		else               		//pa所指结点不是公共结点,则删除之
		{	
			q=pa;
			pa=pa->next;		//pa移到下一个结点
			free(q);			//释放非公共结点
		}
	}
	r->next=NULL;			//将新建单链表尾结点的next域置空
}
void main()
{
	LinkList *L1,*L2,*L3;
	ElemType a[]={1,3,5,8};
	ElemType b[]={2,3,6,7};
	ElemType c[]={1,3,8,9};
	CreateListR(L1,a,4);
	printf("L1:");DispList(L1);
	CreateListR(L2,b,4);
	printf("L2:");DispList(L2);
	CreateListR(L3,c,4);
	printf("L3:");DispList(L3);
	printf("提取公共元素\n");
	Commnode(L1,L2,L3);
	printf("L1:");DispList(L1);
	DestroyList(L1);
	DestroyList(L2);
	DestroyList(L3);
}

