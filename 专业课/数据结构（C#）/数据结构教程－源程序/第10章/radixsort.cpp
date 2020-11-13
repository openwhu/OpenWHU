#include <stdio.h>
#include <malloc.h>
#include <string.h>
#define MAXE 20			//线性表中最多元素个数
#define MAXR 10			//基数的最大取值
#define MAXD 8			//关键字位数的最大取值
typedef struct node
{	
	char data[MAXD];	//记录的关键字定义的字符串
    struct node *next;
} RecType;
void CreaLink(RecType *&p,char *a[],int n);
void DispLink(RecType *p);
void RadixSort(RecType *&p,int r,int d) //实现基数排序:*p为待排序序列链表指针,r为基数,d为关键字位数
{
	RecType *head[MAXR],*tail[MAXR],*t;	//定义各链队的首尾指针
	int i,j,k;
	for (i=0;i<=d-1;i++)           		//从低位到高位循环
	{	
		for (j=0;j<r;j++) 				//初始化各链队首、尾指针
			head[j]=tail[j]=NULL;
		while (p!=NULL)          		//对于原链表中每个结点循环
		{	
			k=p->data[i]-'0';   		//找第k个链队
			if (head[k]==NULL)   		//进行分配
			{
				head[k]=p;
				tail[k]=p;
			}
          	else
			{
              	tail[k]->next=p;
				tail[k]=p;
			}
            p=p->next;             		//取下一个待排序的元素
		}
		p=NULL;							//重新用p来收集所有结点
       	for (j=0;j<r;j++)        		//对于每一个链队循环
        	if (head[j]!=NULL)         	//进行收集
			{	
				if (p==NULL)
				{
					p=head[j];
					t=tail[j];
				}
				else
				{
					t->next=head[j];
					t=tail[j];
				}
			}
		t->next=NULL;					//最后一个结点的next域置NULL
		printf("  按%s位排序\t",(i==0?"个":"十"));
		DispLink(p);
	}
}
void CreateLink(RecType *&p,char a[MAXE][MAXD],int n)	//采用后插法产生链表
{
	int i;
	RecType *s,*t;
	for (i=0;i<n;i++)
	{
		s=(RecType *)malloc(sizeof(RecType));
		strcpy(s->data,a[i]);
		if (i==0)
		{
			p=s;t=s;
		}
		else
		{
			t->next=s;t=s;
		}
	}
	t->next=NULL;
}
void DispLink(RecType *p)	//输出链表
{
	while (p!=NULL)
	{
		printf("%c%c ",p->data[1],p->data[0]);
		p=p->next;
	}
	printf("\n");
}
void main()
{
	int n=10,r=10,d=2;
	int i,j,k;
	RecType *p;
	char a[MAXE][MAXD];
	int b[]={75,23,98,44,57,12,29,64,38,82};
	for (i=0;i<n;i++)		//将b[i]转换成字符串
	{
		k=b[i];
		for (j=0;j<d;j++)	//例如b[0]=75,转换后a[0][0]='7',a[0][1]='5'
		{
			a[i][j]=k%10+'0';
			k=k/10;
		}
		a[i][j]='\0';
	}
	CreateLink(p,a,n);
	printf("\n");
	printf("  初始关键字\t");		//输出初始关键字序列
	DispLink(p);
	RadixSort(p,10,2);
	printf("  最终结果\t");			//输出最终结果
	DispLink(p);
	printf("\n");
}
