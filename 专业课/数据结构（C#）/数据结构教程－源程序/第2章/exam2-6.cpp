#include "linklist.cpp"
void delmaxnode(LinkList *&L)
{
	LinkList *p=L->next,*pre=L,*maxp=p,*maxpre=pre;
	while (p!=NULL)					//用p扫描整个单链表,pre始终指向其前驱节点
	{
		if (maxp->data<p->data)		//若找到一个更大的节点
		{	maxp=p;					//更改maxp
			maxpre=pre;				//更改maxpre
		}
		pre=p;						//p、pre同步后移一个节点
		p=p->next;
	}
	maxpre->next=maxp->next;		//删除*maxp节点
	free(maxp);						//释放*maxp节点
}
void main()
{
	LinkList *L;
	int n=10;
	ElemType a[]={1,3,2,9,0,4,7,6,5,8};
	CreateListR(L,a,n);
	printf("L:");DispList(L);
	printf("删除最大值节点\n");
	delmaxnode(L);
	printf("L:");DispList(L);
	DestroyList(L);
}