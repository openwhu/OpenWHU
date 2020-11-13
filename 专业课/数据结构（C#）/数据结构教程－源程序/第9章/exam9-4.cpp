#include <stdio.h>
#include <malloc.h>
typedef int KeyType;
typedef char InfoType[10];
typedef struct node           		//记录类型
{
	KeyType key;              		//关键字项
	InfoType data;             		//其他数据域
	struct node *lchild,*rchild;	//左右孩子指针
} BSTNode;
int InsertBST(BSTNode *&p,KeyType k)	
{
   	if (p==NULL)						//原树为空, 新插入的记录为根结点
	{
		p=(BSTNode *)malloc(sizeof(BSTNode));
		p->key=k;
		p->lchild=p->rchild=NULL;
		return 1;
	}
	else if (k==p->key) 				//树中存在相同关键字的结点,返回0
		return 0;
	else if (k<p->key) 
		return InsertBST(p->lchild,k);	//插入到*p的左子树中
	else  
		return InsertBST(p->rchild,k);  //插入到*p的右子树中
}
BSTNode *CreateBST(KeyType A[],int n)	//返回BST树根结点指针
{
	BSTNode *bt=NULL;         			//初始时bt为空树
	int i=0;
	while (i<n) 
	{
		InsertBST(bt,A[i]);  			//将关键字A[i]插入二叉排序树T中
		i++;
    }
    return bt;               			//返回建立的二叉排序树的根指针
}
void DispBST(BSTNode *bt)		//输出一棵排序二叉树
{
	if (bt!=NULL)
	{	printf("%d",bt->key);
		if (bt->lchild!=NULL || bt->rchild!=NULL)
		{	printf("(");						//有孩子结点时才输出(
			DispBST(bt->lchild);				//递归处理左子树
			if (bt->rchild!=NULL) printf(",");	//有右孩子结点时才输出,
			DispBST(bt->rchild);				//递归处理右子树
			printf(")");						//有孩子结点时才输出)
		}
	}
}
KeyType maxnode(BSTNode *p) //返回一棵二叉排序树中的最大结点
{
	while (p->rchild!=NULL)
		p=p->rchild;
	return(p->key);
}
KeyType minnode(BSTNode *p)	  //返回一棵二叉排序树中的最小结点
{
	while (p->lchild!=NULL)
		p=p->lchild;
	return(p->key);
}
void maxminnode(BSTNode *p)
{
	if (p!=NULL)
	{	
		if (p->lchild!=NULL)
			printf("左子树的最大结点为:%d\n",maxnode(p->lchild));
		if (p->rchild!=NULL)
			printf("右子树的最小结点为:%d\n",minnode(p->rchild));
	}
}
void main()
{
	BSTNode *bt;
	int n=12,x=46;
	KeyType a[]={25,18,46,2,53,39,32,4,74,67,60,11};
	bt=CreateBST(a,n);
	printf("BST:");DispBST(bt);printf("\n");
	maxminnode(bt);
}