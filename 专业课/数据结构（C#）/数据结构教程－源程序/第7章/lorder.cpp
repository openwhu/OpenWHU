#include "btree.cpp"
#define MaxSize 100
void LevelOrder(BTNode *b)
{
	BTNode *p;
	BTNode *qu[MaxSize];			//定义环形队列,存放结点指针
	int front,rear;					//定义队头和队尾指针
	front=rear=-1;					//置队列为空队列
	rear++;
	qu[rear]=b;						//根结点指针进入队列
	while (front!=rear)				//队列不为空
	{
		front=(front+1)%MaxSize;
		p=qu[front];				//队头出队列
		printf("%c ",p->data);		//访问结点
		if (p->lchild!=NULL)		//有左孩子时将其进队
		{	
			rear=(rear+1)%MaxSize;
			qu[rear]=p->lchild;
		}
		if (p->rchild!=NULL)		//有右孩子时将其进队
		{	
			rear=(rear+1)%MaxSize;
			qu[rear]=p->rchild;
		}
	} 
}
void main()
{
	BTNode *b;
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("层次遍历序列:");LevelOrder(b);printf("\n");
}
