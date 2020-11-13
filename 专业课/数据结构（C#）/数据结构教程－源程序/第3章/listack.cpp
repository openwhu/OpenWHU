#include <stdio.h>
#include <malloc.h>
typedef char ElemType;
typedef struct linknode
{	
	ElemType data;				//数据域
	struct linknode *next;		//指针域
} LiStack;						//链栈类型定义
void InitStack(LiStack *&s)
{
	s=(LiStack *)malloc(sizeof(LiStack));
	s->next=NULL;
}
void DestroyQueue(LiStack *&s)
{
	LiStack *p=s->next;
	while (p!=NULL)
	{	
		free(s);
		s=p;
		p=p->next;
	}
	free(s);	//s指向尾结点,释放其空间
}
int StackLength(LiStack *s)
{
	int i=0;
	LiStack *p;
	p=s->next;
	while (p!=NULL)
	{	
		i++;
		p=p->next;
	}
	return(i);
}
bool StackEmpty(LiStack *s)
{
	return(s->next==NULL);
}
void Push(LiStack *&s,ElemType e)
{	LiStack *p;
	p=(LiStack *)malloc(sizeof(LiStack));
	p->data=e;				//新建元素e对应的节点*p
	p->next=s->next;		//插入*p节点作为开始节点
	s->next=p;
}
bool Pop(LiStack *&s,ElemType &e)
{	LiStack *p;
	if (s->next==NULL)		//栈空的情况
		return false;
	p=s->next;				//p指向开始节点
	e=p->data;
	s->next=p->next;		//删除*p节点
	free(p);				//释放*p节点
	return true;
}
bool GetTop(LiStack *s,ElemType &e)
{	if (s->next==NULL)		//栈空的情况
		return false;
	e=s->next->data;
	return true;
}
