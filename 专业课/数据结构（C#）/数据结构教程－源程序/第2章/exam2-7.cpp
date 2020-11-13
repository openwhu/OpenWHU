#include "linklist.cpp"
void sort(LinkList *&L)
{	LinkList *p,*pre,*q;
	p=L->next->next;		//p指向L的第2个数据节点
	L->next->next=NULL;		//构造只含一个数据节点的有序表
	while (p!=NULL)
	{	q=p->next;			//q保存*p节点后继节点的指针
		pre=L;				//从有序表开头进行比较,pre指向插入*p的前驱节点
		while (pre->next!=NULL && pre->next->data<p->data)
			pre=pre->next;	//在有序表中找插入*p的前驱节点*pre
		p->next=pre->next;	//将*pre之后插入*p
		pre->next=p;
		p=q;				//扫描原单链表余下的节点
	}
}
void main()
{
	LinkList *L;
	int n=10;
	ElemType a[]={1,3,2,9,0,4,7,6,5,8};
	CreateListR(L,a,n);
	printf("L:");DispList(L);
	printf("排序\n");
	sort(L);
	printf("L:");DispList(L);
	DestroyList(L);
}

