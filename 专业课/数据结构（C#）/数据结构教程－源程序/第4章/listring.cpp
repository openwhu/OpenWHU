#include <stdio.h>
#include <malloc.h>
typedef struct snode 
{	
	char data;
	struct snode *next;
} LiString;
void StrAssign(LiString *&s,char cstr[])	//字符串常量cstr赋给串s
{
	int i;
	LiString *r,*p;
	s=(LiString *)malloc(sizeof(LiString));
	r=s;						//r始终指向尾节点
	for (i=0;cstr[i]!='\0';i++) 
	{	p=(LiString *)malloc(sizeof(LiString));
		p->data=cstr[i];
		r->next=p;r=p;
	}
	r->next=NULL;
}
void StrCopy(LiString *&s,LiString *t)	//串t复制给串s
{
	LiString *p=t->next,*q,*r;
	s=(LiString *)malloc(sizeof(LiString));
	r=s;				//r始终指向尾节点
	while (p!=NULL)		//将t的所有节点复制到s
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	r->next=NULL;
}
bool StrEqual(LiString *s,LiString *t)	//判串相等
{
	LiString *p=s->next,*q=t->next;
	while (p!=NULL && q!=NULL && p->data==q->data) 
	{	p=p->next;
		q=q->next;
	}
	if (p==NULL && q==NULL)
		return true;
	else
		return false;
}
int StrLength(LiString *s)	//求串长
{
	int i=0;
	LiString *p=s->next;
	while (p!=NULL) 
	{	i++;
		p=p->next;
	}
	return i;
}
LiString *Concat(LiString *s,LiString *t)	//串连接
{
	LiString *str,*p=s->next,*q,*r;
	str=(LiString *)malloc(sizeof(LiString));
	r=str;
	while (p!=NULL)			//将s的所有节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	p=t->next;
	while (p!=NULL)			//将t的所有节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	r->next=NULL;
	return str;
}
LiString *SubStr(LiString *s,int i,int j)	//求子串
{
	int k;
	LiString *str,*p=s->next,*q,*r;
	str=(LiString *)malloc(sizeof(LiString));
	str->next=NULL;
	r=str;						//r指向新建链表的尾节点
	if (i<=0 || i>StrLength(s) || j<0 || i+j-1>StrLength(s))
		return str;				//参数不正确时返回空串
	for (k=0;k<i-1;k++)
		p=p->next;
	for (k=1;k<=j;k++) 			//将s的第i个节点开始的j个节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	r->next=NULL;
	return str;
}
LiString *InsStr(LiString *s,int i,LiString *t)		//串插入
{
	int k;
	LiString *str,*p=s->next,*p1=t->next,*q,*r;
	str=(LiString *)malloc(sizeof(LiString));
	str->next=NULL;
	r=str;								//r指向新建链表的尾节点
	if (i<=0 || i>StrLength(s)+1)		//参数不正确时返回空串
		return str;
	for (k=1;k<i;k++)					//将s的前i个节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	while (p1!=NULL)					//将t的所有节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p1->data;
		r->next=q;r=q;
		p1=p1->next;
	}
	while (p!=NULL)						//将*p及其后的节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	r->next=NULL;
	return str;
}
LiString *DelStr(LiString *s,int i,int j)	//串删去
{
	int k;
	LiString *str,*p=s->next,*q,*r;
	str=(LiString *)malloc(sizeof(LiString));
	str->next=NULL;
	r=str;						//r指向新建链表的尾节点
	if (i<=0 || i>StrLength(s) || j<0 || i+j-1>StrLength(s))
		return str;				//参数不正确时返回空串
	for (k=0;k<i-1;k++)			//将s的前i-1个节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	for (k=0;k<j;k++)				//让p沿next跳j个节点
		p=p->next;
	while (p!=NULL)					//将*p及其后的节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;
		r->next=q;r=q;
		p=p->next;
	}
	r->next=NULL;
	return str;
}
LiString *RepStr(LiString *s,int i,int j,LiString *t)	//串替换
{
	int k;
	LiString *str,*p=s->next,*p1=t->next,*q,*r;
	str=(LiString *)malloc(sizeof(LiString));
	str->next=NULL;
	r=str;							//r指向新建链表的尾节点
	if (i<=0 || i>StrLength(s) || j<0 || i+j-1>StrLength(s))
		return str;		 			//参数不正确时返回空串
	for (k=0;k<i-1;k++)  			//将s的前i-1个节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;q->next=NULL;
		r->next=q;r=q;
		p=p->next;
	}
	for (k=0;k<j;k++)				//让p沿next跳j个节点
		p=p->next;
	while (p1!=NULL)				//将t的所有节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p1->data;q->next=NULL;
		r->next=q;r=q;
		p1=p1->next;
	}
	while (p!=NULL)					//将*p及其后的节点复制到str
	{	q=(LiString *)malloc(sizeof(LiString));
		q->data=p->data;q->next=NULL;
		r->next=q;r=q;
		p=p->next;
	}
	r->next=NULL;
	return str;
}
void DispStr(LiString *s)	//输出串
{
	LiString *p=s->next;
	while (p!=NULL)
	{	printf("%c",p->data);
		p=p->next;
	}
	printf("\n");
}
