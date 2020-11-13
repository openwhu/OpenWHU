#include <stdio.h>
#include <string.h>
#define MaxSize 100
typedef char ElemType[10];
typedef struct
{	
	ElemType data;		//数据域
	int next;			//游标域,指示下一个元素在数组中的位置
} StaticList[MaxSize];
void CreateList(StaticList L,ElemType a[],int n)//创建静态链表
{
	int i;
	L[0].next=1;
	for (i=1;i<=n;i++)
	{
		strcpy(L[i].data,a[i-1]);
		L[i].next=i+1;
	}
	L[n].next=0;
}
void InitList(StaticList L)
{
	int j;
	L[0].next=0;			//置为空表
	for (j=1;j<MaxSize;j++)
		L[j].next=-1;		//-1表示该位置为空
}
int ListEmpty(StaticList L)
{
	return(L[0].next==0);
}
int ListLength(StaticList L)
{
	int n=0,j=0;
	while (L[j].next!=0)
	{	n++;
		j=L[j].next;
	}
	return(n);
}
void DispList(StaticList L)
{
	int j=0;
	while (L[j].next!=0)
	{	j=L[j].next;
		printf("%d:%s,%d\n",j,L[j].data,L[j].next);
	}
	printf("\n");
}
int GetElem(StaticList L,int i,ElemType &e)
{
	int k=0,j=L[0].next;
	while (k<i-1 && j!=0)
	{	k++;
		j=L[j].next;
	}
	if (j==0)				//不存在第i个数据结点
		return 0;
	else					//存在第i个数据结点
	{	strcpy(e,L[j].data);
		return 1;
	}
}
int LocateElem(StaticList L,ElemType e)
{
	int j=L[0].next;
	int n=1;
	while (j!=0 && strcmp(L[j].data,e)!=0)
	{	j=L[j].next;
		n++;
	}
	if (j==0)
		return(0);
	else
		return(n);
}
int ListInsert(StaticList &L,int i,ElemType e)
{
	int j=L[0].next,j1,j2,k;
	if (i==1)						//插入作为第一个结点
	{	if (j==0)					//原链表为空
		{  	strcpy(L[1].data,e);
			L[0].next=1;
			L[1].next=0;
			return 1;
		}
		else						//原链表不为空
		{	k=j+1;
			while (k!=j)			//在链表中循环找存放e的空位置
				if (L[k].next==-1)
					break;
				else
					k=(k+1)%MaxSize;
			if (k!=j)				//在链表中找到了一个空位置k存放e
			{	strcpy(L[k].data,e);
				L[k].next=L[0].next;
				L[0].next=k;
				return 1;
			}
			else return 0;			//链表已满,上溢出
		}
	}
	else	//插入作为其他结点
	{	k=0;
		while (k<i-2 && j!=0)		//查找第i-1个结点
		{	k++;
			j=L[j].next;
		}
		if (j==0)					//未找到第i-1个结点
			return 0;
		else						//找到第i-1个结点
		{	j1=j;					//用j1保存j
			j2=L[j].next;			//用j2保存原来L[j]的next域
			k=j+1;
			while (k!=j)			//在链表中循环找存放e的空位置
				if (L[k].next==-1)
					break;
				else
					k=(k+1)%MaxSize;
			if (k!=j)				//在链表中找到了一个空位置k存放e
			{	strcpy(L[k].data,e);
				L[j1].next=k;
				L[k].next=j2;
				return 1;
			}
			else return 0;			//链表已满,上溢出
		}
	}
}
int ListDelete(StaticList L,int i,ElemType &e)
{
	int j=L[0].next,j1,k;
	if (L[0].next==0)				//空表时删除失败
		return(0);	
	if (i==1)						//删除第1个结点
	{	j1=L[0].next;
		L[0].next=L[j1].next;
		strcpy(e,L[j1].data);
		L[j1].next=-1;
		return(1);
	}
	else							//删除其他结点
	{	k=0;
		while (k<i-2 && j!=0)		//查找第i-1个结点
		{	k++;
			j=L[j].next;
		}
		if (j==0)					//未找到第i-1个结点
			return 0;
		else						//找到第i-1个结点L[j]
		{	if (L[j].next==0)		//不存在第i个结点
				return(0);	
			j1=L[j].next;
			L[j].next=L[j1].next;
			strcpy(e,L[j1].data);
			L[j1].next=-1;
			return 1;
		}
	}
}
void main()
{
	ElemType a[7]={"张斌","刘丽","李英","陈华","王奇","董强","王萍"};
	ElemType e;
	int i;
	StaticList L;
	InitList(L);
	CreateList(L,a,7);
	printf("L:\n");DispList(L);
	strcpy(e,"陈华");
	i=LocateElem(L,e);
	printf("i=%d\n",i);
	ListDelete(L,i,e);
	printf("L:\n");DispList(L);
	strcpy(e,"王华");
	ListInsert(L,3,e);
	printf("L:\n");DispList(L);
}
