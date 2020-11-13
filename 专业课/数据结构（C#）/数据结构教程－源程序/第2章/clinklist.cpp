//循环单链表基本运算函数
#include <stdio.h>
#include <malloc.h>
typedef int ElemType;
typedef struct LNode		//定义单链表结点类型
{
	ElemType data;
    struct LNode *next;
} LinkList;
void CreateListF(LinkList *&L,ElemType a[],int n)
//头插法建立循环单链表
{
	LinkList *s;int i;
	L=(LinkList *)malloc(sizeof(LinkList));  	//创建头结点
	L->next=NULL;
	for (i=0;i<n;i++)
	{	
		s=(LinkList *)malloc(sizeof(LinkList));//创建新结点
		s->data=a[i];
		s->next=L->next;			//将*s插在原开始结点之前,头结点之后
		L->next=s;
	}
	s=L->next;	
	while (s->next!=NULL)			//查找尾结点,由s指向它
		s=s->next;
	s->next=L;						//尾结点next域指向头结点

}
void CreateListR(LinkList *&L,ElemType a[],int n)
//尾插法建立循环单链表
{
	LinkList *s,*r;int i;
	L=(LinkList *)malloc(sizeof(LinkList));  	//创建头结点
	L->next=NULL;
	r=L;					//r始终指向终端结点,开始时指向头结点
	for (i=0;i<n;i++)
	{	
		s=(LinkList *)malloc(sizeof(LinkList));//创建新结点
		s->data=a[i];
		r->next=s;			//将*s插入*r之后
		r=s;
	}
	r->next=L;				//尾结点next域指向头结点
}
void InitList(LinkList *&L)
{
	L=(LinkList *)malloc(sizeof(LinkList));	//创建头结点
	L->next=L;
}
void DestroyList(LinkList *&L)
{
	LinkList *p=L,*q=p->next;
	while (q!=L)
	{
		free(p);
		p=q;
		q=p->next;
	}
	free(p);
}
bool ListEmpty(LinkList *L)
{
	return(L->next==L);
}
int ListLength(LinkList *L)
{
	LinkList *p=L;int i=0;
	while (p->next!=L)
	{
		i++;
		p=p->next;
	}
	return(i);
}
void DispList(LinkList *L)
{
	LinkList *p=L->next;
	while (p!=L)
	{
		printf("%d ",p->data);
		p=p->next;
	}
	printf("\n");
}
bool GetElem(LinkList *L,int i,ElemType &e)
{
	int j=0;
	LinkList *p;
	if (L->next!=L)		//单链表不为空表时
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
	else				//单链表为空表时
		return false;
}
int LocateElem(LinkList *L,ElemType e)
{
	LinkList *p=L->next;
	int n=1;
	while (p!=L && p->data!=e)
	{
		p=p->next;
		n++;
	}
	if (p==L)
		return(0);
	else
		return(n);
}
bool ListInsert(LinkList *&L,int i,ElemType e)
{
	int j=0;
	LinkList *p=L,*s;
	if (p->next==L || i==1)		//原单链表为空表或i==1时
	{
		s=(LinkList *)malloc(sizeof(LinkList));	//创建新结点*s
		s->data=e;								
		s->next=p->next;		//将*s插入到*p之后
		p->next=s;
		return true;
	}
	else
	{
		p=L->next;
		while (j<i-2 && p!=L)
		{
			j++;
			p=p->next;
		}
		if (p==L)				//未找到第i-1个结点
			return false;
		else					//找到第i-1个结点*p
		{
			s=(LinkList *)malloc(sizeof(LinkList));	//创建新结点*s
			s->data=e;								
			s->next=p->next;						//将*s插入到*p之后
			p->next=s;
			return true;
		}
	}
}
bool ListDelete(LinkList *&L,int i,ElemType &e)
{
	int j=0;
	LinkList *p=L,*q;
	if (p->next!=L)					//原单链表不为空表时
	{
		if (i==1)					//i==1时
		{
			q=L->next;				//删除第1个结点
			e=q->data;
			L->next=q->next;
			free(q);
			return true;
		}
		else						//i不为1时
		{
			p=L->next;
			while (j<i-2 && p!=L)
			{
				j++;
				p=p->next;
			}
			if (p==L)				//未找到第i-1个结点
				return false;
			else					//找到第i-1个结点*p
			{
				q=p->next;			//q指向要删除的结点
				e=q->data;
				p->next=q->next;	//从单链表中删除*q结点
				free(q);			//释放*q结点
				return true;
			}
		}
	}
	else return 0;
}
