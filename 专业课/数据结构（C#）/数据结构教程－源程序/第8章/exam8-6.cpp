#include <stdio.h>
#include <malloc.h>
#include "graph.h"
#define INF 32767       //INF表示∞
typedef struct
{
	int data;					//顶点编号
	int parent;					//前一个顶点的位置
} QUERE;						//非环形队列类型
int visited[MAXV];
void ShortPath(ALGraph *G,int u,int v)
{	//输出从顶点u到顶点v的最短逆路径
	ArcNode *p;
	int w,i;
	QUERE qu[MAXV];				//非环形队列
	int front=-1,rear=-1;		//队列的头、尾指针
	int visited[MAXV];
	for (i=0;i<G->n;i++)		//访问标记置初值0
		visited[i]=0;
	rear++;						//顶点u进队
	qu[rear].data=u;
	qu[rear].parent=-1;
	visited[u]=1;
	while (front!=rear)			//队不空循环
	{
		front++;				//出队顶点w
		w=qu[front].data;
		if (w==v)				//找到v时输出路径之逆并退出
		{
			i=front;			//通过队列输出逆路径
			while (qu[i].parent!=-1)
			{
				printf("%2d ",qu[i].data);
				i=qu[i].parent;
			}
			printf("%2d\n",qu[i].data);
			break; 
		}
		p=G->adjlist[w].firstarc;	//找w的第一个邻接点
		while (p!=NULL)
		{
			if (visited[p->adjvex]==0)
			{
				visited[p->adjvex]=1;
				rear++;				//将w的未访问过的邻接点进队
				qu[rear].data=p->adjvex;
				qu[rear].parent=front;
			}
			p=p->nextarc;			//找w的下一个邻接点
		}
	}
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
	int i,j,u=0,v=4;
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
	printf("顶点%d到顶点%d的最短逆路径:",u,v);
	ShortPath(G,u,v);
	printf("\n");
}
