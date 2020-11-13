#include "exam8-2.cpp"
void TopSort(ALGraph *G)
{
	int i,j;
	int St[MAXV],top=-1;  			//栈St的指针为top
	ArcNode *p;
	for (i=0;i<G->n;i++)			//入度置初值0
		G->adjlist[i].count=0;
	for (i=0;i<G->n;i++)			//求所有顶点的入度
	{
		p=G->adjlist[i].firstarc;
		while (p!=NULL)
		{
			G->adjlist[p->adjvex].count++;
			p=p->nextarc;
		}
	}
	for (i=0;i<G->n;i++)
		if (G->adjlist[i].count==0)  //入度为0的顶点进栈
		{
			top++; 
			St[top]=i;  
		}
	while (top>-1)             		//栈不为空时循环
	{
		i=St[top];top--;  			//出栈
		printf("%d ",i);      		//输出顶点
		p=G->adjlist[i].firstarc;	//找第一个相邻顶点
		while (p!=NULL) 
		{
			j=p->adjvex;
			G->adjlist[j].count--; 
			if (G->adjlist[j].count==0)//入度为0的相邻顶点进栈
			{
				top++;
				St[top]=j;
			}
			p=p->nextarc;       //找下一个相邻顶点
		}
	}
}

void main()
{
	int i,j;
	MGraph g;
	ALGraph *G;
	int A[MAXV][6]={
		{0,1,0,0,0,0},
		{0,0,1,0,0,0},
		{0,0,0,1,0,0},
		{0,0,0,0,0,0},
		{0,1,0,0,0,1},
		{0,0,0,1,0,0}};
	g.n=6;g.e=6;
	for (i=0;i<g.n;i++)
		for (j=0;j<g.n;j++)
			g.edges[i][j]=A[i][j];
	G=(ALGraph *)malloc(sizeof(ALGraph));
	MatToList(g,G);
	DispAdj(G);
	printf("\n");
	printf("拓扑序列:");TopSort(G);printf("\n");
}
