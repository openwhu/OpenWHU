#include <stdio.h>
#include <malloc.h>
#define MaxSize 100
typedef char ElemType;
typedef struct node 
{
	ElemType data;
	int ltag,rtag;      //增加的线索标记
	struct node *lchild;
	struct node *rchild;
} TBTNode;
void CreateTBTNode(TBTNode * &b,char *str)
{
	TBTNode *St[MaxSize],*p=NULL;
	int top=-1,k,j=0;  
	char ch;
	b=NULL;				//建立的二叉树初始时为空
	ch=str[j];
	while (ch!='\0')	//str未扫描完时循环
	{
   	   	switch(ch) 
		{
		case '(':top++;St[top]=p;k=1; break;		//为左结点
		case ')':top--;break;
		case ',':k=2; break;                      	//为右结点
		default:p=(TBTNode *)malloc(sizeof(TBTNode));
				p->data=ch;p->lchild=p->rchild=NULL;
		        if (b==NULL)					//*p为二叉树的根结点
					b=p;
				else  							//已建立二叉树根结点
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
void DispTBTNode(TBTNode *b) 
{
	if (b!=NULL)
	{
		printf("%c",b->data);
		if (b->lchild!=NULL || b->rchild!=NULL)
		{
			printf("(");
			DispTBTNode(b->lchild);
			if (b->rchild!=NULL) printf(",");
			DispTBTNode(b->rchild);
			printf(")");
		}
	}
}
TBTNode *pre;						//全局变量
void Thread(TBTNode *&p)
{
	if (p!=NULL)	
	{	
		Thread(p->lchild);    		//左子树线索化
		if (p->lchild==NULL)		//前驱线索
		{
			p->lchild=pre;        	//建立当前结点的前驱线索
			p->ltag=1;
		}
		else p->ltag=0;
		if (pre->rchild==NULL)		//后继线索
		{	
			pre->rchild=p;     		//建立前驱结点的后继线索
		   	pre->rtag=1;
		}
		else pre->rtag=0;
	    pre=p;
	   	Thread(p->rchild);  		//右子树线索化
	}
}
TBTNode *CreaThread(TBTNode *b)     //中序线索化二叉树
{
	TBTNode *root;
	root=(TBTNode *)malloc(sizeof(TBTNode));  //创建根结点
	root->ltag=0;root->rtag=1;
	root->rchild=b;
	if (b==NULL)                //空二叉树
		root->lchild=root;
	else
	{  	
		root->lchild=b;
		pre=root;             	//pre是*p的前驱结点,供加线索用
		Thread(b);   			//中序遍历线索化二叉树
		pre->rchild=root;    	//最后处理,加入指向根结点的线索
		pre->rtag=1;
		root->rchild=pre;    	//根结点右线索化
	}
    return root;
}
void ThInOrder(TBTNode *tb)
{
	TBTNode *p=tb->lchild;		//指向根结点
	while (p!=tb)		
	{
		while (p->ltag==0) p=p->lchild;
		printf("%c ",p->data);
		while (p->rtag==1 && p->rchild!=tb)
		{
			p=p->rchild;
			printf("%c ",p->data);
		}
		p=p->rchild;
	}
}
void main()
{
	TBTNode *b,*tb;
	CreateTBTNode(b,"A(B(D(,G)),C(E,F))");
	printf(" 二叉树:");DispTBTNode(b);printf("\n");
	tb=CreaThread(b);
	printf(" 线索中序序列:");ThInOrder(tb);printf("\n");
}