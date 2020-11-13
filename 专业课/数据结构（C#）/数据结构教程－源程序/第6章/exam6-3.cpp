#include "tup.cpp"
int MatAdd(TSMatrix a,TSMatrix b,TSMatrix &c)
{
	int i=0,j=0,k=0;
	ElemType v;
	if (a.rows!=b.rows || a.cols!=b.cols)
		return 0;				  		 //行数或列数不等时不能进行相加运算
	c.rows=a.rows;c.cols=a.cols; 		 //c的行列数与a的相同
	while (i<a.nums && j<b.nums) 		 //处理a和b中的每个元素
	{	
		if (a.data[i].r==b.data[j].r)	 //行号相等时
		{	
			if(a.data[i].c<b.data[j].c)	 //a元素的列号小于b元素的列号
			{	
				c.data[k].r=a.data[i].r;//将a元素添加到c中
				c.data[k].c=a.data[i].c;
				c.data[k].d=a.data[i].d;
				k++;i++;
           	}
           	else if (a.data[i].c>b.data[j].c)//a元素的列号大于b元素的列号
			{	
				c.data[k].r=b.data[j].r;	  //将b元素添加到c中
               	c.data[k].c=b.data[j].c;
               	c.data[k].d=b.data[j].d;
               	k++;j++;
           	}
           	else					//a元素的列号等于b元素的列号
			{ 	
				v=a.data[i].d+b.data[j].d;
				if (v!=0)			//只将不为0的结果添加到c中
				{
					c.data[k].r=a.data[i].r;
					c.data[k].c=a.data[i].c;
					c.data[k].d=v;
					k++;
				}
				i++;j++;
          	 }
		}
     	else if (a.data[i].r<b.data[j].r) //a元素的行号小于b元素的行号
		{	
			c.data[k].r=a.data[i].r;	  //将a元素添加到c中
			c.data[k].c=a.data[i].c;
			c.data[k].d=a.data[i].d;
			k++;i++;
		}
		else							  //a元素的行号大于b元素的行号
		{
			c.data[k].r=b.data[j].r;	  //将b元素添加到c中
			c.data[k].c=b.data[j].c;
			c.data[k].d=b.data[j].d;
			k++;j++;
     	}
     	c.nums=k;
	}
	return 1;
}
void main()
{
	ElemType a[M][N]={{1,0,3},{0,2,0},{0,0,5}};
	//ElemType b[M][N]={{-1,0,2},{0,-2,0},{1,0,-5}};
	ElemType b[M][N]={{0,0,0},{0,0,0},{0,0,1}};
	TSMatrix x,y,z;
	CreatMat(x,a);
	CreatMat(y,b);
	MatAdd(x,y,z);
	printf("a的三元组:\n");DispMat(x);
	printf("b的三元组:\n");DispMat(y);
	printf("相加后的三元组:\n");DispMat(z);
}