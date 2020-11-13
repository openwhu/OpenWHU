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
   	int n,e;   					//顶点数,弧数
	VertexType vexs[MAXV];		//存放顶点信息
} MGraph;						//图的邻接矩阵类型
void DisMinTree(int path[],int s[],int n,int v) 
//由path求最小的生成树
{
	int i,pre,j,k;
	int edges[MAXV][2],edgenum=0;	//edges数组用于存放最小生成树的所有边,
	//edges[i][0]存放第i条边的起点,edges[i][1]存放第i条边的终点
	printf(" 最小生成树的所有边:\n\t");
	for (i=0;i<n;i++)
		if (s[i]==1 && i!=v) 
		{	
			j=i;
			pre=path[i];
			do						//搜索最短路径生成最小生成树的所有边
			{	if (edgenum==0)		//将(pre,j)边加入到edges中
				{	edges[edgenum][0]=pre;
					edges[edgenum][1]=j;
					edgenum++;
				}
				else
				{
					k=0;
					while (k<edgenum&&(edges[k][0]!=pre||edges[k][1]!=j))
						k++;
					if (k>=edgenum)		//(pre,j)边未在edges中时加入
					{
						edges[edgenum][0]=pre;
						edges[edgenum][1]=j;
						edgenum++;
					}
				}
				j=pre;
				pre=path[pre];
			} while (pre!=v);
		}
		for (k=0;k<edgenum;k++)
			printf("(%d,%d) ",edges[k][0],edges[k][1]);
		printf("\n");
}

void Dijkstra(MGraph g,int v)
{
	int dist[MAXV],path[MAXV];
	int s[MAXV];
	int mindis,i,j,u;
	for (i=0;i<g.n;i++) 
	{	
		dist[i]=g.edges[v][i];   	//距离初始化
		s[i]=0;                		//s[]置空
		if (g.edges[v][i]<INF)		//路径初始化
			path[i]=v;
		else
		    path[i]=-1;
	}
	s[v]=1;path[v]=0;        		//源点编号v放入s中
	for (i=0;i<g.n;i++)    			//循环直到所有顶点的最短路径都求出
	{	
		mindis=INF;					//mindis置最小长度初值
		for (j=0;j<g.n;j++)     	//选取不在s中且具有最小距离的顶点u
			if (s[j]==0 && dist[j]<mindis) 
			{ 	
				u=j;
				mindis=dist[j];	
			}
		s[u]=1;               		//顶点u加入s中
		for (j=0;j<g.n;j++)     	//修改不在s中的顶点的距离
			if (s[j]==0) 
				if (g.edges[u][j]<INF && dist[u]+g.edges[u][j]<dist[j]) 
				{	
					dist[j]=dist[u]+g.edges[u][j];
					path[j]=u;
				}  
	}
	DisMinTree(path,s,g.n,v);  	//输出最小生成树
}

void main()
{
	int i,j;
	MGraph g;
	g.n=7;g.e=12;
	int a[7][MAXV]={
		{0,4,6,6,INF,INF,INF},
		{INF,0,1,INF,7,INF,INF},
		{INF,INF,0,INF,6,4,INF},
		{INF,INF,2,0,INF,5,INF},
		{INF,INF,INF,INF,0,INF,6},
		{INF,INF,INF,INF,1,0,8},
		{INF,INF,INF,INF,INF,INF,0}};
	for (i=0;i<g.n;i++)		//建立图的邻接矩阵
		for (j=0;j<g.n;j++)
			g.edges[i][j]=a[i][j];
	Dijkstra(g,0);
	printf("\n");
}