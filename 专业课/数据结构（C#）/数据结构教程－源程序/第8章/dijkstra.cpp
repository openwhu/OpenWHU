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

void Ppath(int path[],int i,int v)  //前向递归查找路径上的顶点
{
	int k;
	k=path[i];
	if (k==v)  return;			//找到了起点则返回
	Ppath(path,k,v);			//找顶点k的前一个顶点
	printf("%d,",k);			//输出顶点k
}
void Dispath(int dist[],int path[],int s[],int n,int v)
{
	int i;
	for (i=0;i<n;i++)
		if (s[i]==1) 
		{	
			printf("  从%d到%d的最短路径长度为:%d\t路径为:",v,i,dist[i]);
			printf("%d,",v);	//输出路径上的起点
			Ppath(path,i,v);	//输出路径上的中间点
			printf("%d\n",i);	//输出路径上的终点
		}
		else  printf("从%d到%d不存在路径\n",v,i);
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
	Dispath(dist,path,s,g.n,v);  	//输出最短路径
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
	for (i=0;i<g.n;i++)		//建立图9.16所示的图的邻接矩阵
		for (j=0;j<g.n;j++)
			g.edges[i][j]=a[i][j];
	printf("最小生成树构成:\n");
	Dijkstra(g,0);
	printf("\n");
}