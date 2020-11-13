#include <stdio.h>
#define MaxSize 100
#define M 8
#define N 8
int mg[M+2][N+2]=
{	
	{1,1,1,1,1,1,1,1,1,1},
	{1,0,0,1,0,0,0,1,0,1},
	{1,0,0,1,0,0,0,1,0,1},
	{1,0,0,0,0,1,1,0,0,1},
	{1,0,1,1,1,0,0,0,0,1},
	{1,0,0,0,1,0,0,0,0,1},
	{1,0,1,0,0,0,1,0,0,1},
	{1,0,1,1,1,0,1,1,0,1},
	{1,1,0,0,0,0,0,0,0,1},
	{1,1,1,1,1,1,1,1,1,1}
};
typedef struct
{
	int i;				//当前方块的行号
	int j;				//当前方块的列号
} Box;
typedef struct
{
	Box data[MaxSize];
    int length;			//路径长度
} PathType;				//定义路径类型
int count=0;			//存放迷宫路径的条数
void mgpath(int xi,int yi,int xe,int ye,PathType path)
//求解路径为:(xi,yi)->(xe,ye)
{
	int di,k,i,j;
	if (xi==xe && yi==ye)		//找到了出口,输出路径
	{
		path.data[path.length].i = xi;
		path.data[path.length].j = yi;
		path.length++;
		printf("迷宫路径%d如下:\n",++count);
		for (k=0;k<path.length;k++)
		{
			printf("\t(%d,%d)",path.data[k].i,path.data[k].j);
			if ((k+1)%5==0)		//每输出每5个方块后换一行
				printf("\n");  
		}
		printf("\n");
	}
	else						//(xi,yi)不是出口
	{
		if (mg[xi][yi]==0)		//(xi,yi)是一个可走方块
		{
			di=0;
			while (di<4)		//找(xi,yi)的一个相邻方块(i,j)
			{
				path.data[path.length].i = xi;
				path.data[path.length].j = yi;
				path.length++;
				switch(di)
				{
				case 0:i=xi-1; j=yi;   break;
				case 1:i=xi;   j=yi+1; break;
				case 2:i=xi+1; j=yi;   break;
				case 3:i=xi;   j=yi-1; break;
				}
				mg[xi][yi]=-1;			//避免重复找路径
				mgpath(i,j,xe,ye,path);
				mg[xi][yi]=0;			//恢复(xi,yi)为可走
				path.length--;			//回退一个方块
				di++;
			}
		}
	}
}
void main()
{
	PathType path;
	path.length=0;				//初始化路径长度
	mgpath(1,1,M,N,path);
}
