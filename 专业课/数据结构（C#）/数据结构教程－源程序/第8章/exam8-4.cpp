#include <stdio.h>
#include <malloc.h>
#include "exam8-2.cpp"
#define INF 32767       //INF表示∞
int visited[MAXV];
void PathAll(ALGraph *G,int u,int v,int l,int path[],int d)
//d是到当前为止已走过的路径长度，调用时初值为-1
{
	int m,i;
	ArcNode *p;
	visited[u]=1;
	d++;						//路径长度增1
	path[d]=u;					//将当前顶点添加到路径中
	if (u==v && d==l)			//输出一条路径
	{	
		printf("  ");
		for (i=0;i<=d;i++)
			printf("%d ",path[i]);
		printf("\n");
	}
	p=G->adjlist[u].firstarc;  	//p指向顶点u的第一条弧的弧头结点
	while (p!=NULL)
	{	m=p->adjvex;			//m为u的邻接顶点
		if (visited[m]==0)		//若该顶点未标记访问,则递归访问之
			PathAll(G,m,v,l,path,d);
		p=p->nextarc;			//找u的下一个邻接顶点
	}
	visited[u]=0;				//恢复环境：使该顶点可重新使用
}
void main()
{ 
	int path[MAXV],u=1,v=4,d=3,i,j;
	MGraph g;
	ALGraph *G;
	g.n=5;g.e=8;
	int A[MAXV][MAXV]={
		{0,1,0,1,1},
		{1,0,1,1,0},
		{0,1,0,1,1},
		{1,1,1,0,1},
		{1,0,1,1,0}};	
	for (i=0;i<g.n;i++)		
		for (j=0;j<g.n;j++)
			g.edges[i][j]=A[i][j];
	MatToList(g,G);
	for (i=0;i<g.n;i++) 		//visited数组置初值
		visited[i]=0;
	printf("图G:\n");DispAdj(G);//输出邻接表
	printf("从%d到%d的所有长度为%d路径:\n",u,v,d);
	PathAll(G,u,v,d,path,-1);
	printf("\n");
}
