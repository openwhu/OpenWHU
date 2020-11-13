#include <stdio.h>
#include <malloc.h>
#include "exam8-2.cpp"
#define INF 32767       //INF表示∞
int visited[MAXV],path[MAXV];  //path[]用于存放回路路径,均为全局变量
void DFSPath(ALGraph *g ,int i,int j,int d)
{
	int v,k;
	ArcNode *p;
	visited[i]=1;
	d++;path[d]=i;
	if (i==j && d>2)         	//找到一条回路,则输出
	{	
		printf("  ");
		for (k=1;k<=d;k++)
			printf("%d ",path[k]);
		printf("\n");
	}
	p=g->adjlist[i].firstarc;  //找顶点i的第一个邻接顶点
	while (p!=NULL) 
	{	
		v=p->adjvex;          	//v为顶点i的邻接顶点
		if (visited[v]==0 || v==j) 
			DFSPath(g,v,j,d); 	//若该顶点未标记访问,或为vj,则递归访问之
		p=p->nextarc;           //找顶点i的下一个邻接顶点
	}
	visited[i]=0;              //取消访问标记,以使该顶点可重新使用
}
void FindCyclePath(ALGraph *G,int k)	//输出经过顶点k的所有回路
{
	printf("经过顶点%d的所有回路\n",k);
    DFSPath(G,k,k,0);
}

void main()
{ 
	int i,j;
	MGraph g;
	ALGraph *G;
	g.n=5;g.e=7;
	int A[MAXV][MAXV]={
		{0,1,1,0,0},
		{0,0,1,0,0},
		{0,0,0,1,1},
		{0,0,0,0,1},
		{1,0,0,0,0}};	
	for (i=0;i<g.n;i++)	
		for (j=0;j<g.n;j++)
			g.edges[i][j]=A[i][j];
	MatToList(g,G);
	for (i=0;i<g.n;i++) 		//visited数组置初值
		visited[i]=0;
	printf("图G:\n");DispAdj(G);//输出邻接表
	FindCyclePath(G,0);
	printf("\n");
}
