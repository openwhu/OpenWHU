#include <stdio.h>
#include <malloc.h>
#define MaxSize 100
typedef int ElemType;
typedef struct
{
	ElemType data[MaxSize];
	int front;			//队头指针
	int count;			//队列中元素个数
} QuType;
void InitQueue(QuType *&qu)						//初始化队运算算法
{	qu=(QuType *)malloc(sizeof(QuType));
	qu->front=0;
	qu->count=0;
}
void DestroyQueue(QuType *&qu)
{
	free(qu);
}
bool EnQueue(QuType *&qu,ElemType x)			//进队运算算法
{	int rear;									//临时队尾指针
	if (qu->count==MaxSize)						//队满上溢出
		return false;
	else
	{	rear=(qu->front+qu->count)%MaxSize;	//求队尾位置
		rear=(rear+1)%MaxSize;					//队尾循环增1
		qu->data[rear]=x;
		qu->count++;							//元素个数增1
		return true;
	}
}
bool DeQueue(QuType *&qu,ElemType &x)			//出队运算算法
{	if (qu->count==0)							//队空下溢出
		return false;
	else
	{	qu->front=(qu->front+1)%MaxSize;		//队头循环增1
		x=qu->data[qu->front];
		qu->count--;							//元素个数减1
		return true;
	}
}
bool QueueEmpty(QuType *qu)						//判队空运算算法
{
	return(qu->count==0);
}
void main()
{
	QuType *q;
	ElemType e;
	InitQueue(q);
	EnQueue(q,1);
	EnQueue(q,2);
	EnQueue(q,3);
	EnQueue(q,4);
	printf("出队顺序:");
	while (!QueueEmpty(q))
	{
		DeQueue(q,e);
		printf("%d ",e);
	}
	printf("\n");
	DestroyQueue(q);
}







