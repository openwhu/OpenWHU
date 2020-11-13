#include <stdio.h>
#include <malloc.h>
typedef int ElemType;
typedef struct DNode		//定义双链表结点类型
{
	ElemType data;
	struct DNode *prior;	//指向前驱结点
	struct DNode *next;		//指向后继结点
} DLinkList;
void CreateListF(DLinkList *&L,ElemType a[],int n)
//头插法建双链表
{
	DLinkList *s;int i;
	L=(DLinkList *)malloc(sizeof(DLinkList));  	//创建头结点
	L->prior=L->next=NULL;
	for (i=0;i<n;i++)
	{	
		s=(DLinkList *)malloc(sizeof(DLinkList));//创建新结点
		s->data=a[i];
		s->next=L->next;			//将*s插在原开始结点之前,头结点之后
		if (L->next!=NULL) L->next->prior=s;
		L->next=s;s->prior=L;
	}
}
void CreateListR(DLinkList *&L,ElemType a[],int n)
//尾插法建双链表
{
	DLinkList *s,*r;int i;
	L=(DLinkList *)malloc(sizeof(DLinkList));  	//创建头结点
	L->prior=L->next=NULL;
	r=L;					//r始终指向终端结点,开始时指向头结点
	for (i=0;i<n;i++)
	{	
		s=(DLinkList *)malloc(sizeof(DLinkList));//创建新结点
		s->data=a[i];
		r->next=s;s->prior=r;	//将*s插入*r之后
		r=s;
	}
	r->next=NULL;			//终端结点next域置为NULL
}
void InitList(DLinkList *&L)
{
	L=(DLinkList *)malloc(sizeof(DLinkList));  	//创建头结点
	L->prior=L->next=NULL;
}
void DestroyList(DLinkList *&L)
{
	DLinkList *p=L,*q=p->next;
	while (q!=NULL)
	{
		free(p);
		p=q;
		q=p->next;
	}
	free(p);
}
bool ListEmpty(DLinkList *L)
{
	return(L->next==NULL);
}
int ListLength(DLinkList *L)
{
	DLinkList *p=L;
	int i=0;
	while (p->next!=NULL)
	{
		i++;
		p=p->next;
	}
	return(i);
}
void DispList(DLinkList *L)
{
	DLinkList *p=L->next;
	while (p!=NULL)
	{
		printf("%d ",p->data);
		p=p->next;
	}
	printf("\n");
}
bool GetElem(DLinkList *L,int i,ElemType &e)
{
	int j=0;
	DLinkList *p=L;
	while (j<i && p!=NULL)
	{
		j++;
		p=p->next;
	}
	if (p==NULL)
		return false;
	else
	{
		e=p->data;
		return true;
	}
}
int LocateElem(DLinkList *L,ElemType e)
{
	int n=1;
	DLinkList *p=L->next;
	while (p!=NULL && p->data!=e)
	{
		n++;
		p=p->next;
	}
	if (p==NULL)
		return(0);
	else
		return(n);
}
bool ListInsert(DLinkList *&L,int i,ElemType e)
{
	int j=0;
	DLinkList *p=L,*s;
	while (j<i-1 && p!=NULL)
	{
		j++;
		p=p->next;
	}
	if (p==NULL)	//未找到第i-1个结点
		return false;
	else			//找到第i-1个结点*p
	{
		s=(DLinkList *)malloc(sizeof(DLinkList));	//创建新结点*s
		s->data=e;	
		s->next=p->next;		//将*s插入到*p之后
		if (p->next!=NULL) p->next->prior=s;
		s->prior=p;
		p->next=s;
		return true;
	}
}
bool ListDelete(DLinkList *&L,int i,ElemType &e)
{
	int j=0;
	DLinkList *p=L,*q;
	while (j<i-1 && p!=NULL)
	{
		j++;
		p=p->next;
	}
	if (p==NULL)				//未找到第i-1个结点
		return false;
	else						//找到第i-1个结点*p
	{
		q=p->next;				//q指向要删除的结点
		if (q==NULL) 
			return false;		//不存在第i个结点
		e=q->data;
		p->next=q->next;		//从单链表中删除*q结点
		if (p->next!=NULL) p->next->prior=p;
		free(q);				//释放*q结点
		return true;
	}
}
