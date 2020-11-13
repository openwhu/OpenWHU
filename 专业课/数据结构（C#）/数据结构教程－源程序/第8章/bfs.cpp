#include "exam8-2.cpp"
void BFS(ALGraph *G,int v)  
{
	ArcNode *p;
	int queue[MAXV],front=0,rear=0;			//定义循环队列并初始化
	int visited[MAXV];            			//定义存放结点的访问标志的数组
	int w,i;
	for (i=0;i<G->n;i++) visited[i]=0;		//访问标志数组初始化
	printf("%2d",v); 						//输出被访问顶点的编号
	visited[v]=1;              				//置已访问标记
	rear=(rear+1)%MAXV;
	queue[rear]=v;             				//v进队
	while (front!=rear)       				//若队列不空时循环
	{	
		front=(front+1)%MAXV;
		w=queue[front];       				//出队并赋给w
		p=G->adjlist[w].firstarc; 			//找与顶点w邻接的第一个顶点
		while (p!=NULL) 
		{	
			if (visited[p->adjvex]==0) 		//若当前邻接顶点未被访问
			{
				printf("%2d",p->adjvex);  	//访问相邻顶点
				visited[p->adjvex]=1;		//置该顶点已被访问的标志
				rear=(rear+1)%MAXV;			//该顶点进队
				queue[rear]=p->adjvex;
           	}
           	p=p->nextarc;              		//找下一个邻接顶点
		}
	}
	printf("\n");
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
	printf("广度优先序列:");BFS(G,2);printf("\n");
}
