#include <stdio.h>
#define MaxSize 100
#define N 10		//问题涉及的人数,人的编号从1到N
#define M 7			//亲戚关系个数
#define Q 3			//询问个数
typedef struct node
{
	int data;		//结点对应人的编号
	int rank;		//结点对应秩
	int parent;		//结点对应双亲下标
} UFSTree;
void MAKE_SET(UFSTree t[])	//初始化并查集树
{ 
	int i;
	for (i=1;i<=N;i++)
	{
		t[i].data=i;		//数据为该人的编号
		t[i].rank=0;		//秩初始化为0
		t[i].parent=i;		//双亲初始化指向自已
	}
}
int FIND_SET(UFSTree t[],int x)	//在x所在子树中查找集合编号
{
	if (x!=t[x].parent)					//双亲不是自已
		return(FIND_SET(t,t[x].parent));//递归在双亲中找x
	else
		return(x);						//双亲是自已,返回x
}
void UNION(UFSTree t[],int x,int y)	//将x和y所在的子树合并
{ 
	x=FIND_SET(t,x);
	y=FIND_SET(t,y);
	if (t[x].rank>t[y].rank)		//y结点的秩小于x结点的秩
		t[y].parent=x;				//将y连到x结点上,x作为y的孩子结点
	else							//y结点的秩大于等于x结点的秩
	{ 
		t[x].parent=y;				//将x连到y结点上,y作为x的孩子结点
		if (t[x].rank==t[y].rank)	//x和y结点的秩相同
			t[y].rank++;			//y结点的秩增1
	}
}
void main()
{
	int i,x,y;
	UFSTree t[MaxSize];
	int rel[M][2]={{2,4},{5,7},{1,3},{8,9},{1,2},{5,6},{2,3}};
	int ans[Q][2]={{3,4},{7,10},{8,9}};
	MAKE_SET(t);					//初始化并查集树t
	for (i=0;i<M;i++)				//根据关系进行合并操作
		UNION(t,rel[i][0],rel[i][1]);
	printf("data  rank  parent\n");	//输出并查集树t
	for (i=1;i<=N;i++)
		printf("%4d%5d%6d\n",t[i].data,t[i].rank,t[i].parent);
	printf("\n");
	printf("各询问的结果:\n");		//输出求解结果
	for (i=0;i<Q;i++)
	{
		x=FIND_SET(t,ans[i][0]);
		y=FIND_SET(t,ans[i][1]);
		if (x==y)
			printf("  (%d,%d):Yes\n",ans[i][0],ans[i][1]);
		else
			printf("  (%d,%d):No\n",ans[i][0],ans[i][1]);
	}
}
