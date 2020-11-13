#include "dlinklist.cpp"
void sort(DLinkList *&L)	//双链表节点排序
{	
	DLinkList *p,*pre,*q;
	p=L->next->next;		//p指向L的第2个数据节点
	L->next->next=NULL;		//构造只含一个数据节点的有序表
	while (p!=NULL)
	{	q=p->next;			//q保存*p节点后继节点的指针
		pre=L;				//从有序表开头进行比较,pre指向插入*p的前驱节点
		while (pre->next!=NULL && pre->next->data<p->data)
			pre=pre->next;	//在有序表中找插入*p的前驱节点*pre
		p->next=pre->next;	//在*pre之后插入到*p节点
		if (pre->next!=NULL)
			pre->next->prior=p;
		pre->next=p;
		p->prior=pre;
		p=q;				//扫描原双链表余下的节点
	}
}

void main()
{
	ElemType a[]={1,8,0,4,9,7,5,2,3,6};
	DLinkList *L;
	CreateListR(L,a,10);
	printf("L:");DispList(L);
	printf("排序\n");
	sort(L);
	printf("L:");DispList(L);
	DestroyList(L);
}
