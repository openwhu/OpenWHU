#include "sqqueue.cpp"
void number(int n)
{
	int i;  ElemType e;
	SqQueue q;		//这里SqQueue为顺序队类型，需将ElemType改为int类型
	q.front=q.rear=0;
	for (i=1;i<=n;i++)			//构建初始序列
	{	
		q.rear=(q.rear+1)%MaxSize;
		q.data[q.rear]=i;
	}
	printf("报数出列顺序:");
	while (q.front!=q.rear)		//队列不空循环
	{
		q.front=(q.front+1)%MaxSize;
		e=q.data[q.front];		//出列一个元素
		printf("%d ",e);		//输出元素编号
		if (q.front!=q.rear)	//队列不空
		{
			q.front=(q.front+1)%MaxSize;
			e=q.data[q.front];	//出列一个元素
			q.rear=(q.rear+1)%MaxSize;
			q.data[q.rear]=e;	//将刚出列的元素进队
		}
	}
	printf("\n");
}
void main()
{
	int i,n=8;
	printf("初始序列:");
	for (i=1;i<=n;i++)
		printf("%d ",i);
	printf("\n");
	number(n);
}
