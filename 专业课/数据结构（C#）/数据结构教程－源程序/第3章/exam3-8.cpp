#include <stdio.h>
#include <malloc.h>
typedef int ElemType;
typedef struct node
{
	ElemType data;
	struct node *next;
} LinkList;
void initQueue(LinkList *&rear)				//初始化队运算算法
{
	rear=NULL;
}
void enQueue(LinkList *&rear,ElemType x)	//进队运算算法
{	
	LinkList *p;
	p=(LinkList *)malloc(sizeof(LinkList));	//创建新节点
	p->data=x;
	if (rear==NULL)						//原链队为空
	{
		p->next=p;						//构成循环链表
		rear=p;
	}
	else
	{
		p->next=rear->next;				//将*p节点插入到*rear节点之后
		rear->next=p;
		rear=p;							//让rear指向这个新插入的节点
	}
}
bool deQueue(LinkList *&rear,ElemType &x)		//出队运算算法
{
	LinkList *q;
	if (rear==NULL)						//队空
		return false;
	else if (rear->next==rear)			//原队中只有一个节点
	{
		x=rear->data;
		free(rear);
		rear=NULL;
	}
	else									//原队中有两个或以上的节点
	{	
		q=rear->next;
		x=q->data;
		rear->next=q->next;
		free(q);
	}
	return true;
}
bool queueEmpty(LinkList *rear)				//判队空运算算法
{
	return(rear==NULL);
}

void main()
{
	LinkList *q;
	ElemType e;
	initQueue(q);
	enQueue(q,1);
	enQueue(q,2);
	enQueue(q,3);
	enQueue(q,4); 
	printf("出队顺序:");
	while (!queueEmpty(q))
	{
		deQueue(q,e);
		printf("%d ",e);
	}
	printf("\n"); 
}
