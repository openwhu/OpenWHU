#include <stdio.h>
#define M 6
#define N 7
#define MaxSize  100         //矩阵中非零元素最多个数
typedef int ElemType;
typedef struct
{
	int r;					//行号
	int c;					//列号
	ElemType d;				//元素值
} TupNode;					//三元组定义
typedef struct 
{	
	int rows;				//行数
	int cols;				//列数
	int nums;				//非零元素个数
	TupNode data[MaxSize];
} TSMatrix;					//三元组顺序表定义

void CreatMat(TSMatrix &t,ElemType A[M][N])  //从一个二维稀疏矩阵创建其三元组表示
{
	int i,j;
	t.rows=M;t.cols=N;t.nums=0;
	for (i=0;i<M;i++)
	{
		for (j=0;j<N;j++) 
			if (A[i][j]!=0) 	//只存储非零元素
			{
				t.data[t.nums].r=i;t.data[t.nums].c=j;
				t.data[t.nums].d=A[i][j];t.nums++;
			}
	}
}
bool Value(TSMatrix &t,ElemType x,int i,int j)  //三元组元素赋值
{
	int k=0,k1;
	if (i>=t.rows || j>=t.cols)
		return false;				//失败时返回false
	while (k<t.nums && i>t.data[k].r) k++;					//查找行
	while (k<t.nums && i==t.data[k].r && j>t.data[k].c) k++;//查找列
	if (t.data[k].r==i && t.data[k].c==j)	//存在这样的元素
		t.data[k].d=x;
	else									//不存在这样的元素时插入一个元素
	{	
		for (k1=t.nums-1;k1>=k;k1--)
		{
			t.data[k1+1].r=t.data[k1].r;
			t.data[k1+1].c=t.data[k1].c;
			t.data[k1+1].d=t.data[k1].d;
		}
		t.data[k].r=i;t.data[k].c=j;t.data[k].d=x;
		t.nums++;
	}
	return true;						//成功时返回true
}

bool Assign(TSMatrix t,ElemType &x,int i,int j)  //将指定位置的元素值赋给变量
{
	int k=0;
	if (i>=t.rows || j>=t.cols)
		return false;			//失败时返回false
	while (k<t.nums && i>t.data[k].r) k++;					//查找行
	while (k<t.nums && i==t.data[k].r && j>t.data[k].c) k++;//查找列
	if (t.data[k].r==i && t.data[k].c==j)
		x=t.data[k].d;
	else
		x=0;				//在三元组中没有找到表示是零元素
	return true;			//成功时返回true
}
void DispMat(TSMatrix t)		//输出三元组
{
	int i;
	if (t.nums<=0)			//没有非零元素时返回
		return;
	printf("\t%d\t%d\t%d\n",t.rows,t.cols,t.nums);
	printf("\t------------------\n");
	for (i=0;i<t.nums;i++)
		printf("\t%d\t%d\t%d\n",t.data[i].r,t.data[i].c,t.data[i].d);
}
void TranTat(TSMatrix t,TSMatrix &tb)		//矩阵转置
{
	int p,q=0,v;					//q为tb.data的下标
	tb.rows=t.cols;tb.cols=t.rows;tb.nums=t.nums;
	if (t.nums!=0)					//当存在非零元素时执行转置
	{
		for (v=0;v<t.cols;v++)		//tb.data[q]中的记录以c域的次序排列
			for (p=0;p<t.nums;p++)	//p为t.data的下标
				if (t.data[p].c==v)
				{
					tb.data[q].r=t.data[p].c;
					tb.data[q].c=t.data[p].r;
					tb.data[q].d=t.data[p].d;
					q++;
				}
	}
}
/*
void main()
{
	TSMatrix t,tb;
	int x,y=10;
	int A[6][7]={
		{0,0,1,0,0,0,0},
		{0,2,0,0,0,0,0},
		{3,0,0,0,0,0,0},
		{0,0,0,5,0,0,0},
		{0,0,0,0,6,0,0},
		{0,0,0,0,0,7,4}};
	CreatMat(t,A);
	printf("b:\n"); DispMat(t);
	if (Assign(t,x,2,5)==true)  //调用时返回true
		printf("Assign(t,x,2,5)=>x=%d\n",x);
	else  //调用时返回false
		printf("Assign(t,x,2,5)=>参数错误\n");
	Value(t,y,2,5);
	printf("执行Value(t,10,2,5)\n");
	if (Assign(t,x,2,5)==true)  //调用时返回true
		printf("Assign(t,x,2,5)=>x=%d\n",x);
	else  //调用时返回false
		printf("Assign(t,x,2,5)=>参数错误\n");
	printf("b:\n"); DispMat(t);
	TranTat(t,tb);
	printf("tb:\n"); DispMat(tb);
}
*/