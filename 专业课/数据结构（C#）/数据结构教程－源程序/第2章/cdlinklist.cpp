//循环双链表基本运算函数
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
//头插法建立循环双链表
{
	DLinkList *s;int i;
	L=(DLinkList *)malloc(sizeof(DLinkList));  	//创建头结点
	L->next=NULL;
	for (i=0;i<n;i++)
	{	
		s=(DLinkList *)malloc(sizeof(DLinkList));//创建新结点
		s->data=a[i];
		s->next=L->next;			//将*s插在原开始结点之前,头结点之后
		if (L->next!=NULL) L->next->prior=s;
		L->next=s;s->prior=L;
	}
	s=L->next;	
	while (s->next!=NULL)			//查找尾结点,由s指向它
		s=s->next;
	s->next=L;						//尾结点next域指向头结点
	L->prior=s;						//头结点的prior域指向尾结点

}
void CreateListR(DLinkList *&L,ElemType a[],int n)
//尾插法建立循环双链表
{
	DLinkList *s,*r;int i;
	L=(DLinkList *)malloc(sizeof(DLinkList));  //创建头结点
	L->next=NULL;
	r=L;					//r始终指向尾结点,开始时指向头结点
	for (i=0;i<n;i++)
	{	
		s=(DLinkList *)malloc(sizeof(DLinkList));//创建新结点
		s->data=a[i];
		r->next=s;s->prior=r;	//将*s插入*r之后
		r=s;
	}
	r->next=L;				//尾结点next域指向头结点
	L->prior=r;				//头结点的prior域指向尾结点
}
void InitList(DLinkList *&L)
{
	L=(DLinkList *)malloc(sizeof(DLinkList));  	//创建头结点
	L->prior=L->next=L;
}
void DestroyList(DLinkList *&L)
{
	DLinkList *p=L,*q=p->next;
	while (q!=L)
	{
		free(p);
		p=q;
		q=p->next;
	}
	free(p);
}
bool ListEmpty(DLinkList *L)
{
	return(L->next==L);
}
int ListLength(DLinkList *L)
{
	DLinkList *p=L;
	int i=0;
	while (p->next!=L)
	{
		i++;
		p=p->next;
	}
	return(i);
}
void DispList(DLinkList *L)
{
	DLinkList *p=L->next;
	while (p!=L)
	{
		printf("%d ",p->data);
		p=p->next;
	}
	printf("\n");
}
bool GetElem(DLinkList *L,int i,ElemType &e)
{
	int j=0;
	DLinkList *p;
	if (L->next!=L)		//双链表不为空表时
	{
		if (i==1)
		{
			e=L->next->data;
			return true;
		}
		else			//i不为1时
		{
			p=L->next;
			while (j<i-1 && p!=L)
			{
				j++;
				p=p->next;
			}
			if (p==L)
				return false;
			else
			{
				e=p->data;
				return true;
			}
		}
	}
	else				//双链表为空表时
		return 0;
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
	if (p->next==L)					//原双链表为空表时
	{	
		s=(DLinkList *)malloc(sizeof(DLinkList));	//创建新结点*s
		s->data=e;
		p->next=s;s->next=p;
		p->prior=s;s->prior=p;
		return true;
	}
	else if (i==1)					//原双链表不为空表但i=1时
	{
		s=(DLinkList *)malloc(sizeof(DLinkList));	//创建新结点*s
		s->data=e;
		s->next=p->next;p->next=s;	//将*s插入到*p之后
		s->next->prior=s;s->prior=p;
		return true;
	}
	else
	{	
		p=L->next;
		while (j<i-2 && p!=L)
		{	j++;
			p=p->next;
		}
		if (p==L)				//未找到第i-1个结点
			return false;
		else					//找到第i-1个结点*p
		{
			s=(DLinkList *)malloc(sizeof(DLinkList));	//创建新结点*s
			s->data=e;	
			s->next=p->next;	//将*s插入到*p之后
			if (p->next!=NULL) p->next->prior=s;
			s->prior=p;
			p->next=s;
			return true;
		}
	}
}
bool ListDelete(DLinkList *&L,int i,ElemType &e)
{
	int j=0;
	DLinkList *p=L,*q;
	if (p->next!=L)					//原双链表不为空表时
	{	
		if (i==1)					//i==1时
		{	
			q=L->next;				//删除第1个结点
			e=q->data;
			L->next=q->next;
			q->next->prior=L;
			free(q);
			return true;
		}
		else						//i不为1时
		{	
			p=L->next;
			while (j<i-2 && p!=NULL)		
			{
				j++;
				p=p->next;
			}
			if (p==NULL)				//未找到第i-1个结点
				return false;
			else						//找到第i-1个结点*p
			{
				q=p->next;				//q指向要删除的结点
				if (q==NULL) return 0;	//不存在第i个结点
				e=q->data;
				p->next=q->next;		//从单链表中删除*q结点
				if (p->next!=NULL) p->next->prior=p;
				free(q);				//释放*q结点
				return true;
			}
		}
	}
	else return false;	//原双链表为空表时
}
