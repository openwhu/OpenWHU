#include <stdio.h>
#include <malloc.h>
#include "graph.h"
#define INF 32767       //INF表示∞
int visited[MAXV];
int Maxdist(ALGraph *G,int v)
{
	ArcNode *p;
	int Qu[MAXV];					//环形队列
	int front=0,rear=0;				//队列的头、尾指针
	int visited[MAXV];				//访问标记数组
	int i,j,k;
	for (i=0;i<G->n;i++)			//初始化访问标志数组
		visited[i]=0;
	rear++;Qu[rear]=v;				//顶点v进队
	visited[v]=1;					//标记v已访问
	while (rear!=front) 
	{
		front=(front+1)%MAXV;
		k=Qu[front];				//顶点k出队
		p=G->adjlist[k].firstarc;	//找第一个邻接点
		while (p!=NULL)				//所有未访问过的相邻点进队
		{
			j=p->adjvex;			//邻接点为顶点j
			if (visited[j]==0)		//若j未访问过
			{
				visited[j]=1;
				rear=(rear+1)%MAXV;Qu[rear]=j; //进队
			}
			p=p->nextarc;			//找下一个邻接点
		}
	}
	return k;
}
void MatToList(MGraph g,ALGraph *&G)
//将邻接矩阵g转换成邻接表G
{
	int i,j,n=g.n;						//n为顶点数
	ArcNode *p;
	G=(ALGraph *)malloc(sizeof(ALGraph));
	for (i=0;i<n;i++)					//给邻接表中所有头结点的指针域置初值
		G->adjlist[i].firstarc=NULL;
	for (i=0;i<n;i++)					//检查邻接矩阵中每个元素
		for (j=n-1;j>=0;j--)
			if (g.edges[i][j]!=0)				//邻接矩阵的当前元素不为0
			{   
			   	p=(ArcNode *)malloc(sizeof(ArcNode));	//创建一个结点*p
				p->adjvex=j;
				p->info=g.edges[i][j];
				p->nextarc=G->adjlist[i].firstarc;		//将*p链到链表后
				G->adjlist[i].firstarc=p;
			}
	G->n=n;G->e=g.e;
}
void ListToMat(ALGraph *G,MGraph &g)
//将邻接表G转换成邻接矩阵g
{
	int i,n=G->n;
	ArcNode *p;
	for (i=0;i<n;i++) 
	{	
		p=G->adjlist[i].firstarc;
	    while (p!=NULL) 
		{	
			g.edges[i][p->adjvex]=p->info;
		    p=p->nextarc;
		}
	}
	g.n=n;g.e=G->e;
}
void DispMat(MGraph g)
//输出邻接矩阵g
{
	int i,j;
	for (i=0;i<g.n;i++)
	{
		for (j=0;j<g.n;j++)
			if (g.edges[i][j]==INF)
				printf("%3s","∞");
			else
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
		if (p!=NULL) printf("%3d: ",i);
		while (p!=NULL)
		{
			printf("%3d",p->adjvex);
			p=p->nextarc;
		}
		printf("\n");
	}
}
void main()
{ 
	int i,j,v=0;
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
	printf("离顶点%d最远的顶点:%d",v,Maxdist(G,v));
	printf("\n");
}
