#include "btree.cpp"
int Level(BTNode *b,ElemType x,int h)
{
	int l;
	if (b==NULL)
		return(0);
	else if (b->data==x)
		return(h);
	else
	{
		l=Level(b->lchild,x,h+1);
		if (l!=0)
			return(l);
		else
			return(Level(b->rchild,x,h+1));
	}
}
void main()
{
	BTNode *b;
	int h;
	ElemType x;
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("结点值:");
	scanf("%c",&x);
	h=Level(b,x,1);
	if (h==0)
		printf("b中不存在%c结点\n",x);
	else
		printf("在b中%c结点的层次为%d\n",x,h);
}
