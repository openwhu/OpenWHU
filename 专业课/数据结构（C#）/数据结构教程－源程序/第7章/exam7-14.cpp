#include "btree.cpp"
#define MaxSize 30
typedef char Elemtype;
typedef ElemType SqBTree[MaxSize];
BTNode *trans(SqBTree a,int i)
{
	BTNode *b;
	if (i>MaxSize)
		return(NULL);
	if (a[i]=='#')	return(NULL);			//当节点不存在时返回NULL
	b=(BTNode *)malloc(sizeof(BTNode));	//创建根节点
	b->data=a[i];
	b->lchild=trans(a,2*i);					//递归创建左子树
	b->rchild=trans(a,2*i+1);				//递归创建右子树
	return(b);								//返回根节点
}
void main()
{
	BTNode *b;
	SqBTree a;
	ElemType s[]="0ABCD#EF##G####################";
	b=trans(s,1);
	printf("b:");DispBTNode(b);printf("\n");
}
