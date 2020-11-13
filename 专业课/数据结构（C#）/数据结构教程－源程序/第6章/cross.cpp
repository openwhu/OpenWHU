#include <stdio.h>
#include <malloc.h>
#define M 3         			//矩阵行
#define N 3            			//矩阵列
#define Max ((M)>(N)?(M):(N))   //矩阵行列较大者
typedef int ElemType;
typedef struct mtxn 
{ 
	int row;					//行号
	int col;					//列号
   	struct mtxn *right,*down;	//向右和向下的指针
	union 
	{
		ElemType value;
		struct mtxn *link;
	} tag;
} MatNode;			//十字链表类型定义
void CreatMat(MatNode *&mh,ElemType a[][N])
{
	int i,j;
	MatNode *h[Max],*p,*q,*r;
	mh=(MatNode *)malloc(sizeof(MatNode));//创建十字链表的头节点
	mh->row=M;mh->col=N;
	r=mh;					//r指向尾节点
	for (i=0;i<Max;i++)		//采用尾插法创建头节点h1,h2,…循环链表
	{
		h[i]=(MatNode *)malloc(sizeof(MatNode));
		h[i]->down=h[i]->right=h[i];		//将down和right方向置为循环的
		r->tag.link=h[i];					//将h[i]加到链表中
		r=h[i];
	}
	r->tag.link=mh;							//置为循环链表
	for (i=0;i<M;i++)						//处理每一行
	{
		for (j=0;j<N;j++)					//处理每一列
		{
			if (a[i][j]!=0)					//处理非零元素
			{
				p=(MatNode *)malloc(sizeof(MatNode));	//创建一个新节点
				p->row=i;p->col=j;p->tag.value=a[i][j];
				q=h[i];      					//查找在行表中的插入位置
                while (q->right!=h[i] && q->right->col<j) 
                  	q=q->right;
				p->right=q->right;q->right=p;	//完成行表的插入
				q=h[j];      					//查找在列表中的插入位置
				while (q->down!=h[j] && q->down->row<i) 
					q=q->down;
				p->down=q->down;q->down=p;  	//完成列表的插入
			}
		}
	}
}
void DispMat(MatNode *mh)
{
	MatNode *p,*q;
	printf("行=%d  列=%d\n", mh->row,mh->col);
	p=mh->tag.link;
	while (p!=mh) 
	{	
		q=p->right;
		while (p!=q) 		//输出一行非零元素
		{
			printf("%d\t%d\t%d\n", q->row,q->col,q->tag.value);
			q=q->right;
		}
		p=p->tag.link;
	}
}
//本主程序用于调试
void main()
{
	ElemType a[M][N]={{1,0,3},{0,2,0},{0,0,5}};
	ElemType b[M][N]={{-1,0,2},{0,-2,0},{1,0,-5}};
	MatNode *mx,*my;
	CreatMat(mx,a);
	CreatMat(my,b);
	printf("a的十字链表:\n");DispMat(mx);
	printf("b的十字链表:\n");DispMat(my);
}
