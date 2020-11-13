#include "exam8-2.cpp"
int visited[MAXV];
void DFS(ALGraph *G,int v)  
{
	ArcNode *p;
	visited[v]=1;                   //置已访问标记
	printf("%d  ",v); 				//输出被访问顶点的编号
	p=G->adjlist[v].firstarc;      	//p指向顶点v的第一条弧的弧头结点
	while (p!=NULL) 
	{
		if (visited[p->adjvex]==0)	//若p->adjvex顶点未访问,递归访问它
			DFS(G,p->adjvex);    
		p=p->nextarc;              	//p指向顶点v的下一条弧的弧头结点
	}
}

void main()
{
	int i,j;
	MGraph g;
	ALGraph *G;
	int A[MAXV][5]={ 
		{0,1,0,1,1},
		{1,0,1,1,0},
		{0,1,0,1,1},
		{1,1,1,0,1},
		{1,0,1,1,0}};
	g.n=5;g.e=16;
	for (i=0;i<g.n;i++)
		for (j=0;j<g.n;j++)
			g.edges[i][j]=A[i][j];
	G=(ALGraph *)malloc(sizeof(ALGraph));	
	MatToList(g,G);
	printf(" 邻接表:\n");DispAdj(G);
	for (i=0;i<MAXV;i++)
		visited[i]=0;
	printf("深度优先序列:");DFS(G,2);printf("\n");
}
