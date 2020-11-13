#include "cdlinklist.cpp"
bool delelem(DLinkList *&L,ElemType x)
{
	DLinkList *p=L->next; 
	while (p!=L && p->data!=x)
		p=p->next;
	if (p!=L)						//找到第一个元素值为x的节点
	{
		p->next->prior=p->prior;	//删除节点*p
		p->prior->next=p->next;
		free(p);
		return true;
	}
	else 
		return false;
}
void main()
{
	ElemType a[]={1,2,2,4,2,3,5,2,1,4};
	ElemType x=1;
	DLinkList *L;
	CreateListR(L,a,10);
	printf("L:");DispList(L);
	printf("删除第一个节点值为%d的节点\n",x);
	if (delelem(L,x))
	{
		printf("L:");DispList(L);
	}
	else
		printf("循环双链表L中不存在元素值为%d的节点\n",x);
	DestroyList(L);
}
