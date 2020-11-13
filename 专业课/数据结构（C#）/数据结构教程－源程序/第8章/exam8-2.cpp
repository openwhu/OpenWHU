#include <stdio.h>
#include <malloc.h>
#include "graph.h"
void MatToList(MGraph g,ALGraph *&G)
//将邻接矩阵g转换成邻接表G
{	int i,j;
	ArcNode *p;
	G=(ALGraph *)malloc(sizeof(ALGraph));
	for (i=0;i<g.n;i++)					//给邻接表中所有头节点的指针域置初值
		G->adjlist[i].firstarc=NULL;
	for (i=0;i<g.n;i++)					//检查邻接矩阵中每个元素
		for (j=g.n-1;j>=0;j--)
			if (g.edges[i][j]!=0)		//存在一条边
			{	p=(ArcNode *)malloc(sizeof(ArcNode));	//创建一个节点*p
				p->adjvex=j;
				p->nextarc=G->adjlist[i].firstarc;		//采用头插法插入*p
				G->adjlist[i].firstarc=p;
			}
	G->n=g.n;G->e=g.e;
}
void ListToMat(ALGraph *G,MGraph &g)
//将邻接表G转换成邻接矩阵g
{	int i;
	ArcNode *p;
	for (i=0;i<G->n;i++)
	{	p=G->adjlist[i].firstarc;
		while (p!=NULL)
		{	g.edges[i][p->adjvex]=1;
			p=p->nextarc;
		}
	}
	g.n=G->n;g.e=G->e;
}
void DispMat(MGraph g)
//输出邻接矩阵g
{
	int i,j;
	for (i=0;i<g.n;i++)
	{
		for (j=0;j<g.n;j++)
			printf("%3d",g.edges[i][j]);
		printf("\n");
	}
}
void DispAdj(ALGraph *G)
//输出邻接表G
{
	int i;
	ArcNode *p;
	for (i=0;i<G->n;i++)
	{
		p=G->adjlist[i].firstarc;
		printf("%3d: ",i);
		while (p!=NULL)
		{
			printf("%3d",p->adjvex);
			p=p->nextarc;
		}
		printf("\n");
	}
}
/*以下主函数用作调试
void main()
{
	int i,j;
	MGraph g,g1;
	ALGraph *G;
	int A[MAXV][6]={
		{0,5,0,7,0,0},
		{0,0,4,0,0,0},
		{8,0,0,0,0,9},
		{0,0,5,0,0,6},
		{0,0,0,5,0,0},
		{3,0,0,0,1,0}};
	g.n=6;g.e=10;
	for (i=0;i<g.n;i++)
		for (j=0;j<g.n;j++)
			g.edges[i][j]=A[i][j];
	printf("\n");
	printf(" 有向图G的邻接矩阵:\n");
	DispMat(g);
	G=(ALGraph *)malloc(sizeof(ALGraph));
	printf(" 图G的邻接矩阵转换成邻接表:\n");
	MatToList(g,G);
	DispAdj(G);
	printf(" 图G的邻接表转换成邻接邻阵:\n");
	for (i=0;i<g.n;i++)
	   	for (j=0;j<g.n;j++)
			g1.edges[i][j]=0;
	ListToMat(G,g1);
	DispMat(g1);
	printf("\n");
}
*/
int visited[MAXV];						//全局变量
void DFSTrav(MGraph g,int parent,int child,int &len)
{	int clen,v=0,maxlen;
	clen=len;
	maxlen=len;
	while (v<g.n && g.edges[child][v]==0)	//找child的第一个邻接点v
		v++;
    	while (v<g.n)							//存在邻接点时循环
	{	if (v!=parent)
		{	len=len+g.edges[child][v];
		    	DFSTrav(g,child,v,len);
		    	if (len>maxlen)  maxlen=len;
		}
		v++;
	    	while (v<g.n && g.edges[child][v]==0)//找child的下一个邻接点
		    v++;
	    	len=clen;
	}
	len=maxlen;
}
int Diameter(MGraph g,int v)
{	int maxlen1=0;     	//存放到目前找到根v到叶节点的最大值
	int maxlen2=0;     	//存放到目前找到根v到叶节点的次大值
	int len=0;         	//记录深度优先遍历中到某个叶节点的距离
	int w=0;           	//存放v的邻接顶点
	while (w<g.n && g.edges[v][w]==0) //找与v相邻的第一个顶点w
		w++;
    	while (w<g.n)						//存在邻接点时循环
	{	len=g.edges[v][w];
		DFSTrav(g,v,w,len);
		if (len>maxlen1)
		{	maxlen2=maxlen1;
			maxlen1=len;
		}
		else if (len>maxlen2)
			maxlen2=len;
		w++;
	    	while (w<g.n && g.edges[v][w]==0)  //找v的下一个邻接点w
			w++;
	}
	return maxlen1+maxlen2;
}

void PathAll(ALGraph *G,int u,int v,int path[],int d)
{
	ArcNode *p;
	int j,w;
	visited[u]=1;
	p=G->adjlist[u].firstarc;			//p指向顶点u的第一条边的边头节点
	while (p!=NULL)
	{	w=p->adjvex;					//w为u的邻接顶点
		if (w==v)
		{	path[d+1]=w;
			for (j=0;j<=d+1;j++)
				printf("%2d",path[j]);
			printf("\n");
		}
		else if (visited[w]==0)			//若该顶点未标记访问,则递归访问之
		{	path[d+1]=w;
			PathAll(G,w,v,path,d+1);
		}
		p=p->nextarc;					//找u的下一个邻接顶点
	}
	visited[u]=0;
}

void main()
{	int i,j;
	int u=0,v=3,path[MAXV];
	MGraph g;
	ALGraph *G;
	int A[MAXV][5]={{0,1,0,1,1},{1,0,1,1,0},
			{0,1,0,1,1},{1,1,1,0,1},{1,0,1,1,0}};
	g.n=5;g.e=8;
	for (i=0;i<g.n;i++)			//建立《教程》中图8.1(a)的邻接矩阵
		for (j=0;j<g.n;j++)
			g.edges[i][j]=A[i][j];
	G=(ALGraph *)malloc(sizeof(ALGraph));
	MatToList(g,G);				//生成《教程》中图8.1(a)的邻接表G
	printf("图G的邻接表:\n");
	DispAdj(G);
	for (i=0;i<g.n;i++)			//访问标识数组置初值0
		visited[i]=0;
	printf("从%d到%d的所有简单路径:\n",u,v);
	path[0]=u;visited[u]=1;
	PathAll(G,u,v,path,0);
}
