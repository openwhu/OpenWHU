#include <stdio.h>
#define MaxStud 50		//学生人数最多为50
#define MaxCour 300		//学生成绩记录数最多为50*6
struct stud1
{
	int no;			//学号
	char name[10];	//姓名
	int bno;		//班号
};
struct stud2
{
	int no;			//学号
	int cno;		//课程编号
	int deg;		//分数
};
double studavg(struct stud2 s2[],int m,int i)	//求学号为i的学生的平均分
{
	int j,n=0;				//n为学号为i的学生选学课程数
	double sum=0;			//学号为i的学生总分
	for (j=0;j<m;j++)
		if (s2[j].no==i)	//学号为i时统计
		{
			n++;
			sum+=s2[j].deg;
		}
	return(sum/n);
}
double couravg(struct stud2 s2[],int m,int i)	//求编号为i的课程的平均分
{
	int j,n=0;				//n为编号为i的课程选修人数
	double sum=0;			//编号为i的课程总分
	for (j=0;j<m;j++)
	{
		if (s2[j].cno==i)	//课程编号为i时统计
		{
			n++;
			sum+=s2[j].deg;
		}
	}
	return(sum/n);
}
void allavg(struct stud1 s1[],int n,struct stud2 s2[],int m)	//求学生平均分和课程平均分
{
	int i,j;
	printf("学生平均分:\n");
	printf("  学号     姓名 平均分\n");
	i=0;
	while (i<n)
	{
		j=s1[i].no;
		printf("%4d %10s %g\n",s1[i].no,s1[i].name,studavg(s2,m,j));
		i++;
	}
	printf("课程平均分:\n");
	for (i=1;i<=6;i++)
		printf(" 课程%d:%g\n",i,couravg(s2,m,i));
}

void main()
{
	int n=7;		//学生记录人数
	int m=21;		//学生成绩记录数
	struct stud1 s1[MaxStud]={
		{1,"张斌",9901},
		{8,"刘丽",9902},
		{34,"李英",9901},
		{20,"陈华",9902},
		{12,"王奇",9901},
		{26,"董强",9902},
		{5,"王萍",9901}};
	struct stud2 s2[MaxCour]={	//规定课程的编号从1到6,同一学生成绩记录连续存放
		{1,1,67},
		{1,2,98},
		{1,4,65},
		{8,1,98},
		{8,3,90},
		{8,6,67},
		{34,2,56},
		{34,4,65},
		{34,6,77},
		{20,1,68},
		{20,2,92},
		{20,3,64},
		{12,4,76},
		{12,5,75},
		{12,6,78},
		{26,1,67},
		{26,5,78},
		{26,6,62},
		{5,1,94},
		{5,2,92},
		{5,6,89}};
	allavg(s1,n,s2,m);
}