#include "btree.cpp"
bool ancestor(BTNode *b,ElemType x)
{
	if (b==NULL)
		return false;
	else if (b->lchild!=NULL && b->lchild->data==x || b->rchild!=NULL && b->rchild->data==x)
	{
		printf("%c ",b->data);
		return true;
	}
	else if (ancestor(b->lchild,x) || ancestor(b->rchild,x))
	{
		printf("%c ",b->data);
		return true;
	}
	else
		return false;
}
void main()
{
	BTNode *b;
	ElemType x='G';
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("结点%c的所有祖先:",x);
	ancestor(b,x);printf("\n");
}
