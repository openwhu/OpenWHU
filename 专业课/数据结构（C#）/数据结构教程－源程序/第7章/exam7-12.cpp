#include "btree.cpp"
void AllPath1(BTNode *b)
{
	BTNode *St[MaxSize];
	BTNode *p;
	int flag,i,top=-1;				//栈指针置初值
	if (b!=NULL)
	{	
		do
		{	
			while (b!=NULL)			//将*b的所有左结点进栈
			{	
				top++;
				St[top]=b;
				b=b->lchild;
			}
			p=NULL;					//p指向栈顶结点的前一个已访问的结点
			flag=1;					//设置b的访问标记为已访问过
			while (top!=-1 && flag)
			{	
				b=St[top];			//取出当前的栈顶元素
				if (b->rchild==p)	
				{	
					if (b->lchild==NULL && b->rchild==NULL)	//若为叶子结点
					{	//输出栈中所有结点值
						for (i=top;i>0;i--)
							printf("%c->",St[i]->data);
						printf("%c\n",St[0]->data);
					}
					top--;
					p=b;			//p指向刚访问过的结点
				}
				else
				{	b=b->rchild;	//b指向右孩子结点
					flag=0;			//设置未被访问的标记
				}
			}
		} while (top!=-1);
		printf("\n");
	} 
}
void main()
{
	BTNode *b;
	CreateBTNode(b,"A(B(D(,G)),C(E,F))");
	printf("b:");DispBTNode(b);printf("\n");
	printf("输出所有从叶子结点到根结点的序列:\n");
	AllPath1(b);
}
