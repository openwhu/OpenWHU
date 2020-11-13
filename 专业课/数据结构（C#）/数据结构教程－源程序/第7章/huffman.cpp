#include <stdio.h>
#include <string.h>
#define N 50		//叶子结点数
#define M 2*N-1		//树中结点总数
typedef struct
{
	char data[5];	//结点值
	double weight;	//权重
	int parent;		//双亲结点
	int lchild;		//左孩子结点
	int rchild;		//右孩子结点
} HTNode;
typedef struct
{
	char cd[N];		//存放哈夫曼码
	int start;
} HCode;
void CreateHT(HTNode ht[],int n)
{
	int i,k,lnode,rnode;
	double min1,min2;
	for (i=0;i<2*n-1;i++)			//所有结点的相关域置初值-1
		ht[i].parent=ht[i].lchild=ht[i].rchild=-1;
	for (i=n;i<2*n-1;i++)			//构造哈夫曼树
	{
		min1=min2=32767;			//lnode和rnode为最小权重的两个结点位置
		lnode=rnode=-1;
		for (k=0;k<=i-1;k++)
			if (ht[k].parent==-1)	//只在尚未构造二叉树的结点中查找
			{
				if (ht[k].weight<min1)
				{
					min2=min1;rnode=lnode;
					min1=ht[k].weight;lnode=k;
				}
				else if (ht[k].weight<min2)
				{
					min2=ht[k].weight;rnode=k;
				}
			}
		ht[i].weight=ht[lnode].weight+ht[rnode].weight;
		ht[i].lchild=lnode;ht[i].rchild=rnode;
		ht[lnode].parent=i;ht[rnode].parent=i;
	}
}
void CreateHCode(HTNode ht[],HCode hcd[],int n)
{
	int i,f,c;
	HCode hc;
	for (i=0;i<n;i++)	//根据哈夫曼树求哈夫曼编码
	{
		hc.start=n;c=i;
		f=ht[i].parent;
		while (f!=-1)	//循序直到树根结点
		{
			if (ht[f].lchild==c)	//处理左孩子结点
				hc.cd[hc.start--]='0';
			else					//处理右孩子结点
				hc.cd[hc.start--]='1';
			c=f;f=ht[f].parent;
		}
		hc.start++;		//start指向哈夫曼编码最开始字符
		hcd[i]=hc;
	}
}
void DispHCode(HTNode ht[],HCode hcd[],int n)
{
	int i,k;
	double sum=0,m=0;
	int j;
	printf("  输出哈夫曼编码:\n"); //输出哈夫曼编码
	for (i=0;i<n;i++)
	{
		j=0;
		printf("      %s:\t",ht[i].data);
		for (k=hcd[i].start;k<=n;k++)
		{
			printf("%c",hcd[i].cd[k]);
			j++;
		}
		m+=ht[i].weight;
		sum+=ht[i].weight*j;
		printf("\n");
	}
	printf("\n  平均长度=%g\n",1.0*sum/m);
}
void main()
{
	int n=8,i;		//n表示初始字符串的个数
	char *str[]={"a","b","c","d","e","f","g","h"};
	double fnum[]={0.07,0.19,0.02,0.06,0.32,0.03,0.21,0.1};
	HTNode ht[M];
	HCode hcd[N];
	for (i=0;i<n;i++)
	{
		strcpy(ht[i].data,str[i]);
		ht[i].weight=fnum[i];
	}
	printf("\n");
	CreateHT(ht,n);
	CreateHCode(ht,hcd,n);
	DispHCode(ht,hcd,n);
	printf("\n");
}
 
