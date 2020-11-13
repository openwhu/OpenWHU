#include "btree.cpp"
void DispLeaf(BTNode *b)
{
	if (b!=NULL) 
	{
		if (b->lchild==NULL && b->rchild==NULL) 
			printf("%c ",b->data);	//访问叶子结点
		DispLeaf(b->lchild);	//输出左子树中的叶子结点
		DispLeaf(b->rchild);	//输出右子树中的叶子结点
	}
}
void DispLeaf1(BTNode *b)
{
	if (b!=NULL) 
	{
		if (b->lchild==NULL && b->rchild==NULL) 
			printf("%c ",b->data);	//访问叶子结点
		DispLeaf1(b->rchild);		//输出右子树中的叶子结点
		DispLeaf1(b->lchild);		//输出左子树中的叶子结点
	}
}
void main()
{
	BTNode *b;
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("从左到右输出所有叶子结点:");DispLeaf(b);printf("\n");
	printf("从右到左输出所有叶子结点:");DispLeaf1(b);printf("\n");
}
