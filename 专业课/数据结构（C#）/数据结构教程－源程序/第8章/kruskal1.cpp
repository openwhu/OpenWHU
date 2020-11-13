#include <stdio.h>
#define MaxSize 100
#define INF 32767	//INF表示∞
#define	MAXV 100	//最大顶点个数
typedef int InfoType;

typedef struct 
{  	
	int no;						//顶点编号
	InfoType info;				//顶点其他信息
} VertexType;					//顶点类型
typedef struct  				//图的定义
{  	
	int edges[MAXV][MAXV]; 		//邻接矩阵
   	int n,e;   					//顶点数，弧数
	VertexType vexs[MAXV];		//存放顶点信息
} MGraph;						//图的邻接矩阵类型

typedef struct 
{	
	int u;			//边的起始顶点
    int v;			//边的终止顶点
    int w;			//边的权值
} Edge;
typedef struct node
{	
	int rank;		//结点对应秩
	int parent;		//结点对应双亲下标
} UFSTree;			//并查集树结点类型
void MAKE_SET(UFSTree t[],int n)	//初始化并查集树
{ 
	int i;
	for (i=0;i<n;i++)		//顶点编号从0到n-1
	{
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
void sift(Edge E[],int low,int high)	//筛选算法
{
	int i=low,j=2*i;     				//E[j]是E[i]的左孩子
	Edge temp=E[i];
	while (j<=high) 
	{
		if (j<high && E[j].w<E[j+1].w) 	//若右孩子较大,把j指向右孩子
			j++;    					//f变为2i+1
		if (temp.w<E[j].w) 
		{
			E[i]=E[j];              	//将E[j]调整到双亲结点位置上
			i=j;                    	//修改i和j值,以便继续向下筛选
			j=2*i;
		}
		else break;                 	//筛选结束
	}
	E[i]=temp;                      	//被筛选结点的值放入最终位置
}
void HeapSort(Edge E[],int n)
{
	int i;
	Edge temp;
	for (i=n/2;i>=1;i--)  	//循环建立初始堆
		sift(E,i,n); 
	for (i=n;i>=2;i--)   	//进行n-1次循环,完成推排序
	{
		temp=E[1];        	//将第一个元素同当前区间内R[1]对换
		E[1]=E[i];
		E[i]=temp;
		sift(E,1,i-1);     	//筛选R[1]结点,得到i-1个结点的堆
	}
}
void Kruskal(MGraph g)
{
	int i,j,k,u1,v1,sn1,sn2;
	UFSTree t[MaxSize];
	Edge E[MaxSize];
	k=1;					//e数组的下标从1开始计
	for (i=0;i<g.n;i++)		//由g产生的边集e
		for (j=0;j<g.n;j++)
			if (g.edges[i][j]!=0 && g.edges[i][j]!=INF)
			{
				E[k].u=i;E[k].v=j;E[k].w=g.edges[i][j];
				k++;
			}
	HeapSort(E,g.e);		//采用堆排序对E数组按权值递增排序
	MAKE_SET(t,g.n);		//初始化并查集树t
	k=1;               		//k表示当前构造生成树的第几条边,初值为1
	j=1;               		//E中边的下标,初值为1
	while (k<g.n)       	//生成的边数小于n时循环
	{	
		u1=E[j].u;
		v1=E[j].v;			//取一条边的头尾顶点编号u1和v2
		sn1=FIND_SET(t,u1);
		sn2=FIND_SET(t,v1); //分别得到两个顶点所属的集合编号
		if (sn1!=sn2)     	//两顶点属于不同的集合,该边是最小生成树的一条边
		{	
			printf("  (%d,%d):%d\n",u1,v1,E[j].w);
			k++;			//生成边数增1
			UNION(t,u1,v1);	//将u1和v1两个顶点合并
		}
		j++;   				//扫描下一条边
	}
}

void main()
{
	int i,j;
	MGraph g;
	g.n=6;g.e=20;
	int a[6][MAXV]={
		{0,6,1,5,INF,INF},
		{6,0,5,INF,3,INF},
		{1,5,0,5,6,4},
		{5,INF,5,0,INF,2},
		{INF,3,6,INF,0,6},
		{INF,INF,4,2,6,0}};
	for (i=0;i<g.n;i++)	
		for (j=0;j<g.n;j++)
			g.edges[i][j]=a[i][j];
	printf("最小生成树构成:\n");
	Kruskal(g);
	printf("\n");
}