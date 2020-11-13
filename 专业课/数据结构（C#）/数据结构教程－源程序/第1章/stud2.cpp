#include <stdio.h>
#define MaxCour 300	//学生成绩记录数最多为50*6
struct stud
{
	int no;			//学号
	char name[10];	//姓名
	int bno;		//班号
	int cno;		//课程编号
	int deg;		//课程分数
};
double studavg(struct stud s[],int n,int i)	//求学号为i的学生的平均分
{
	int j,m=0;			//m为学号为i的学生选学课程数
	double sum=0;		//学号为i的学生总分
	for (j=0;j<n;j++)
		if (s[j].no==i)	//学号为i时统计
		{
			m++;
			sum+=s[j].deg;
		}
	return(sum/m);
}
double couravg(struct stud s[],int n,int i)	//求编号为i的课程的平均分
{
	int j,m=0;				//m为编号为i的课程选修人数
	double sum=0;			//编号为i的课程总分
	for (j=0;j<n;j++)
	{
		if (s[j].cno==i)	//课程编号为i时统计
		{
			m++;
			sum+=s[j].deg;
		}
	}
	return(sum/m);
}
void allavg(struct stud s[],int n)	//求学生平均分和课程平均分
{
	int i,j;
	printf("学生平均分:\n");
	printf("  学号     姓名 平均分\n");
	i=0;
	while (i<n)
	{
		j=s[i].no;
		printf("%4d %10s %g\n",s[i].no,s[i].name,studavg(s,n,j));
		i++;
		while (s[i].no==j)	//若下一个记录与上一个记录学号相同,跳过该记录
			i++;
	}
	printf("课程平均分:\n");
	for (i=1;i<=6;i++)
		printf(" 课程%d:%g\n",i,couravg(s,n,i));
}
void main()
{
	int n=21;			//学生记录个数
	struct stud s[MaxCour]={	//规定课程的编号从1到6,同一学生记录连续存放
		{1,"张斌",9901,1,67},
		{1,"张斌",9901,2,98},
		{1,"张斌",9901,4,65},
		{8,"刘丽",9902,1,98},
		{8,"刘丽",9902,3,90},
		{8,"刘丽",9902,6,67},
		{34,"李英",9901,2,56},
		{34,"李英",9901,4,65},
		{34,"李英",9901,6,77},
		{20,"陈华",9902,1,68},
		{20,"陈华",9902,2,92},
		{20,"陈华",9902,3,64},
		{12,"王奇",9901,4,76},
		{12,"王奇",9901,5,75},
		{12,"王奇",9901,6,78},
		{26,"董强",9902,1,67},
		{26,"董强",9902,5,78},
		{26,"董强",9902,6,62},
		{5,"王萍",9901,1,94},
		{5,"王萍",9901,2,92},
		{5,"王萍",9901,6,89}};
	allavg(s,n);
}