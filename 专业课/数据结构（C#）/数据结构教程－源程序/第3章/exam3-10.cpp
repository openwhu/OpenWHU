#include "sqqueue.cpp"
bool deQueue1(SqQueue *&q,ElemType &e)		//从队尾删除
{
	if (q->front==q->rear)					//队空
		return false;
	e=q->data[q->rear];						//提取队尾元素
	q->rear=(q->rear-1+MaxSize)%MaxSize;	//修改除尾指针
	return true;
}
bool enQueue1(SqQueue *&q,ElemType e)		//从队头插入
{	
	if ((q->rear+1)%MaxSize==q->front)		//队满
		return false;
	q->data[q->front]=e;					//e元素进队
	q->front=(q->front-1+MaxSize)%MaxSize;	//修改队头指针
	return true;
}
void main()
{
	ElemType e;
	int i;
	SqQueue *q;
	InitQueue(q);
	printf("从队尾插入a,b,从队头插入c,d,从队尾插入e\n");
	enQueue(q,'a');		//从队尾插入'a'
	enQueue(q,'b');		//从队尾插入'b'
	enQueue1(q,'c');	//从队头插入'c'
	enQueue1(q,'d');	//从队头插入'd'
	enQueue(q,'e');		//从队尾插入'e'
	printf("从队头出队两个元素:\n");
	for (i=1;i<=2;i++)
	{
		deQueue(q,e);		//从队头删除
		printf("%c ",e);
	}
	printf("\n从队尾出队其他元素:\n");
	while (!QueueEmpty(q))
	{
		deQueue1(q,e);		//从队尾删除
		printf("%c ",e);
	}
	printf("\n");
}
