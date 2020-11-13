#include "btree.cpp"
#define MaxSize 100
void AllPath2(BTNode *b)
{
	struct snode
	{
		BTNode *node;			//存放当前结点指针
		int parent;				//存放双亲结点在队列中的位置
	} qu[MaxSize];				//定义非环形队列
	BTNode *q;
	int front,rear,p;			//定义队头和队尾指针
	front=rear=-1;				//置队列为空队列
	rear++;
	qu[rear].node=b;			//根结点指针进入队列
	qu[rear].parent=-1;			//根结点没有双亲结点
	while (front!=rear)			//队列不为空
	{
		front++;
		q=qu[front].node;		//队头出队列,该结点指针仍在qu中
		if (q->lchild==NULL && q->rchild==NULL)	//*q为叶子结点
		{
			p=front;
			while (qu[p].parent!=-1)
			{	
				printf("%c->",qu[p].node->data);
				p=qu[p].parent;
			}
			printf("%c\n",qu[p].node->data);
		}
		if (q->lchild!=NULL)		//*q结点有左孩子时将其进列
		{	
			rear++;
			qu[rear].node=q->lchild;
			qu[rear].parent=front;
		}
		if (q->rchild!=NULL)		//*q结点有右孩子时将其进列
		{	
			rear++;
			qu[rear].node=q->rchild;
			qu[rear].parent=front;
		}
	}
}
void main()
{
	BTNode *b;
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("输出所有从叶子结点到根结点的序列:\n");
	AllPath2(b);
}
