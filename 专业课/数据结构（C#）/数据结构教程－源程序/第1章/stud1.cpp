#include <stdio.h>
#define MaxStud 50	//学生人数最多为50
struct stud
{
	int no;			//学号
	char name[10];	//姓名
	int bno;		//班号
	int deg1;		//课程1分数
	int deg2;		//课程2分数
	int deg3;		//课程3分数
	int deg4;		//课程4分数
	int deg5;		//课程5分数
	int deg6;		//课程6分数
};
double studavg(struct stud s[],int i)	//求s[i]学生的平均分
{
	int m=0;			//s[i]学生选学课程数
	double sum=0;		//s[i]学生总分
	if (s[i].deg1!=-1) 
	{
		m++;
		sum+=s[i].deg1;
	}
	if (s[i].deg2!=-1) 
	{
		m++;
		sum+=s[i].deg2;
	}
	if (s[i].deg3!=-1) 
	{
		m++;
		sum+=s[i].deg3;
	}
	if (s[i].deg4!=-1) 
	{
		m++;
		sum+=s[i].deg4;
	}
	if (s[i].deg5!=-1) 
	{
		m++;
		sum+=s[i].deg5;
	}
	if (s[i].deg6!=-1) 
	{
		m++;
		sum+=s[i].deg6;
	}
	return(sum/m);
}
double couravg(struct stud s[],int n,int i)	//求第i门课程的平均分
{
	int j,m=0;				//m为第i门课程选修人数
	double sum=0;			//第i门课程总分
	switch(i)
	{
	case 1:for (j=0;j<n;j++)
			   if (s[j].deg1!=-1)
			   {
				   m++;
				   sum+=s[j].deg1;
			   }
			   break;
	case 2:for (j=0;j<n;j++)
			   if (s[j].deg2!=-1)
			   {
				   m++;
				   sum+=s[j].deg2;
			   }
			   break;
	case 3:for (j=0;j<n;j++)
			   if (s[j].deg3!=-1)
			   {
				   m++;
				   sum+=s[j].deg3;
			   }
			   break;
	case 4:for (j=0;j<n;j++)
			   if (s[j].deg4!=-1)
			   {
				   m++;
				   sum+=s[j].deg4;
			   }
			   break;
	case 5:for (j=0;j<n;j++)
			   if (s[j].deg5!=-1)
			   {
				   m++;
				   sum+=s[j].deg5;
			   }
			   break;
	case 6:for (j=0;j<n;j++)
			   if (s[j].deg6!=-1)
			   {
				   m++;
				   sum+=s[j].deg6;
			   }
			   break;
	}
	return(sum/m);
}
void allavg(struct stud s[],int n)	//求学生平均分和课程平均分
{
	int i;
	printf("学生平均分:\n");
	printf("  学号     姓名 平均分\n");
	for (i=0;i<n;i++)
	{
		printf("%4d %10s %g\n",s[i].no,s[i].name,studavg(s,i));
	}
	printf("课程平均分:\n");
	for (i=1;i<=6;i++)
		printf(" 课程%d:%g\n",i,couravg(s,n,i));
}
void main()
{
	int n=7;		//学生记录个数
	struct stud s[MaxStud]={
		{1,"张斌",9901,67,98,-1,65,-1,-1},
		{8,"刘丽",9902,98,-1,90,-1,67},
		{34,"李英",9901,-1,56,-1,65,-1,77},
		{20,"陈华",9902,68,92,64,-1,-1,-1},
		{12,"王奇",9901,-1,-1,-1,76,75,78},
		{26,"董强",9902,67,-1,-1,-1,78,62},
		{5,"王萍",9901,94,92,-1,-1,-1,89}};
	allavg(s,n);

}