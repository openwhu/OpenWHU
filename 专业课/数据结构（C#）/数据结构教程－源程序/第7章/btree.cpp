#include <stdio.h>
#include <malloc.h>
#define MaxSize 100
typedef char ElemType;
typedef struct node 
{	
	ElemType data;			//数据元素
	struct node *lchild;	//指向左孩子结点
	struct node *rchild;	//指向右孩子结点
} BTNode;
void CreateBTNode(BTNode * &b,char *str)
{
	BTNode *St[MaxSize],*p=NULL;
	int top=-1,k,j=0;  
	char ch;
	b=NULL;				//建立的二叉树初始时为空
	ch=str[j];
	while (ch!='\0')  	//str未扫描完时循环
	{
   	   	switch(ch) 
		{
		case '(':top++;St[top]=p;k=1; break;		//为左孩子结点
		case ')':top--;break;
		case ',':k=2; break;                      		//为孩子结点右结点
		default:p=(BTNode *)malloc(sizeof(BTNode));
				p->data=ch;p->lchild=p->rchild=NULL;
				if (b==NULL)                    	 	//*p为二叉树的根结点
					b=p;
				else  								//已建立二叉树根结点
				{	
					switch(k) 
					{
					case 1:St[top]->lchild=p;break;
					case 2:St[top]->rchild=p;break;
					}
				}
		}
		j++;
		ch=str[j];
	}
}
BTNode *FindNode(BTNode *b,ElemType x) 
{
	BTNode *p;
	if (b==NULL)
		return NULL;
	else if (b->data==x)
		return b;
	else  
	{
		p=FindNode(b->lchild,x);
		if (p!=NULL) 
			return p;
		else 
			return FindNode(b->rchild,x);
	}
}
BTNode *LchildNode(BTNode *p)
{
    return p->lchild;
}
BTNode *RchildNode(BTNode *p)
{
    return p->rchild;
}
int BTNodeHeight(BTNode *b) 
{
   	int lchildh,rchildh;
   	if (b==NULL) return(0); 				//空树的高度为0
   	else  
	{
		lchildh=BTNodeHeight(b->lchild);	//求左子树的高度为lchildh
		rchildh=BTNodeHeight(b->rchild);	//求右子树的高度为rchildh
		return (lchildh>rchildh)? (lchildh+1):(rchildh+1);
   	}
}
void DispBTNode(BTNode *b) 
{
	if (b!=NULL)
	{	printf("%c",b->data);
		if (b->lchild!=NULL || b->rchild!=NULL)
		{	printf("(");						//有孩子结点时才输出(
			DispBTNode(b->lchild);				//递归处理左子树
			if (b->rchild!=NULL) printf(",");	//有右孩子结点时才输出,
			DispBTNode(b->rchild);				//递归处理右子树
			printf(")");						//有孩子结点时才输出)
		}
	}
}
/*以下主函数用做调试
void main()
{
	BTNode *b;
	CreateBTNode(b,"A(B(D,E),C(,F))");
	DispBTNode(b);
	printf("\n");
}
*/