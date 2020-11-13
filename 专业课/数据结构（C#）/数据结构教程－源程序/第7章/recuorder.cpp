#include "btree.cpp"
void PreOrder(BTNode *b)  		//先序遍历的递归算法
{
	if (b!=NULL)  
	{
		printf("%c ",b->data);	//访问根结点
		PreOrder(b->lchild);	//先序遍历左子树
		PreOrder(b->rchild);	//先序遍历右子树
	}
}
void InOrder(BTNode *b)   		//中序遍历的递归算法
{
	if (b!=NULL)  
	{	
		InOrder(b->lchild);		//中序遍历左子树
		printf("%c ",b->data);	//访问根结点
		InOrder(b->rchild);		//中序遍历右子树
	}
}
void PostOrder(BTNode *b) 		//后序遍历的递归算法
{
	if (b!=NULL)  
	{
		PostOrder(b->lchild);	//后序遍历左子树
		PostOrder(b->rchild);	//后序遍历右子树
		printf("%c ",b->data);	//访问根结点
	}
}
void main()
{
	BTNode *b;
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("先序遍历序列:");PreOrder(b);printf("\n");
	printf("中序遍历序列:");InOrder(b);printf("\n");
	printf("后序遍历序列:");PostOrder(b);printf("\n");
}
