#include <stdio.h>
#include <malloc.h>
#define MaxCol  10			//最大列数
typedef int ElemType;
typedef struct Node1		//定义数据结点类型
{	
	ElemType data[MaxCol];
	struct Node1 *next;		//指向后继数据结点
} DList;
typedef struct Node2		//定义头结点类型
{	
	int Row,Col;			//行数和列数
	DList *next;			//指向第一个数据结点
} HList;
void CreateTable(HList *&h)
{
	int i,j;
	DList *r,*s;
	h=(HList *)malloc(sizeof(HList));		//创建头结点
	h->next=NULL;
	printf("表的行数,列数:");
	scanf("%d%d",&h->Row,&h->Col);
	for (i=0;i<h->Row;i++)
	{	printf("  第%d行:",i+1);
		s=(DList *)malloc(sizeof(DList));	//创建数据结点
		for (j=0;j<h->Col;j++)				//输入一行的数据初步统计
			scanf("%d",&s->data[j]);
		if (h->next==NULL)					//插入第一个数据结点
			h->next=s;
		else								//插入其他数据结点
			r->next=s;						//将*s插入到*r结点之后
		r=s;								//r始终指向最后一个数据结点
	}
	r->next=NULL;							//表尾结点next域置空
}
void DestroyTable(HList *&h)
{
	DList *pre=h->next,*p=pre->next;
	while (p!=NULL)
	{	free(pre);
		pre=p;				
		p=pre->next;
	}
	free(pre);
}
void DispTable(HList *h)
{
	int j;
	DList *p=h->next;
	while (p!=NULL)
	{	for (j=0;j<h->Col;j++)
			printf("%4d",p->data[j]);
		printf("\n");
		p=p->next;
	}
}
void LinkTable(HList *h1,HList *h2,HList *&h)
{
	int f1,f2,i;
	DList *p=h1->next,*q,*s,*r;
	printf("连接字段是:第1个表位序,第2个表位序:");
	scanf("%d%d",&f1,&f2);
	h=(HList *)malloc(sizeof(HList));
	h->Row=0;
	h->Col=h1->Col+h2->Col;
	h->next=NULL;
	while (p!=NULL)
	{	q=h2->next;
		while (q!=NULL)
		{	if (p->data[f1-1]==q->data[f2-1])		//对应字段值相等
			{	s=(DList *)malloc(sizeof(DList));	//创建一个数据结点
				for (i=0;i<h1->Col;i++)				//复制表1的当前行
					s->data[i]=p->data[i];
				for (i=0;i<h2->Col;i++)
					s->data[h1->Col+i]=q->data[i];	//复制表2的当前行
				if (h->next==NULL)				//插入第一个数据结点
					h->next=s;
				else							//插入其他数据结点
					r->next=s;
				r=s;							//r始终指向最后数据结点
				h->Row++;						//表行数增1
			}
			q=q->next;							//表2下移一个记录
		}
		p=p->next;								//表1下移一个记录
	}
	r->next=NULL;								//表尾结点next域置空
}
void main()
{
	HList *h1,*h2,*h;
	printf("表1:\n");	
	CreateTable(h1);			//创建表1
	printf("表2:\n");  
	CreateTable(h2);			//创建表2
	LinkTable(h1,h2,h);			//连接两个表
	printf("连接结果表:\n");	
	DispTable(h);				//输出连接结果
	DestroyTable(h1);			//销毁单链表h1
	DestroyTable(h2);			//销毁单链表h2
	DestroyTable(h);			//销毁单链表h
}
