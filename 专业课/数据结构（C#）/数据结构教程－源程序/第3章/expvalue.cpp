#include <stdio.h>
#include <stdlib.h>
#define MaxSize 100
#define MaxOp 7
struct 
{
	char ch;   //运算符
	int pri;   //优先级
} 
 lpri[]={{'=',0},{'(',1},{'*',5},{'/',5},{'+',3},{'-',3},{')',6}},
 rpri[]={{'=',0},{'(',6},{'*',4},{'/',4},{'+',2},{'-',2},{')',1}};
int leftpri(char op)    //求左运算符op的优先级
{
	int i;
	for (i=0;i<MaxOp;i++)
		if (lpri[i].ch==op) return lpri[i].pri;
}
int rightpri(char op)  //求右运算符op的优先级
{
	int i;
	for (i=0;i<MaxOp;i++)
		if (rpri[i].ch==op) return rpri[i].pri;
}
int InOp(char ch)       //判断ch是否为运算符
{
	if (ch=='(' || ch==')' || ch=='+' || ch=='-' || ch=='*' || ch=='/')
		return 1;
	else
		return 0;
}
int Precede(char op1,char op2)  //op1和op2运算符优先级的比较结果
{
	if (leftpri(op1)==rightpri(op2))
		return 0;
	else if (leftpri(op1)<rightpri(op2))
		return -1;
	else
		return 1;
}
void trans(char *exp,char postexp[])     
//将算术表达式exp转换成后缀表达式postexp
{

	struct
	{	
		char data[MaxSize];		//存放运算符
		int top;				//栈指针
	} op;						//定义运算符栈
	int i=0;					//i作为postexp的下标
	op.top=-1;
	op.top++;                   //将'='进栈
	op.data[op.top]='='; 
	while (*exp!='\0')			//exp表达式未扫描完时循环
	{	
		if (!InOp(*exp))		//为数字字符的情况
		{
			while (*exp>='0' && *exp<='9') //判定为数字
			{	
				postexp[i++]=*exp;
				exp++;
			}
			postexp[i++]='#';	//用#标识一个数值串结束
		}
		else					//为运算符的情况
			switch(Precede(op.data[op.top],*exp))
			{	
	        case -1:			//栈顶运算符的优先级低
				op.top++;op.data[op.top]=*exp;
				exp++;			//继续扫描其他字符
				break;
			case 0:				//只有括号满足这种情况
				op.top--;		//将(退栈
				exp++;			//继续扫描其他字符
				break;
			case 1:             //退栈并输出到postexp中
				postexp[i++]=op.data[op.top];
				op.top--;
				break;
		}
	}
	while (op.data[op.top]!='=') //此时exp扫描完毕,退栈到'='为止
	{	
		postexp[i++]=op.data[op.top];
		op.top--;  
	}
	postexp[i]='\0';			//给postexp表达式添加结束标识
}
float compvalue(char *postexp )	//计算后缀表达式的值
{
	struct 
	{	
		float data[MaxSize];	//存放数值
		int top;				//栈指针
	} st;						//定义数值栈
	float d,a,b,c;
	st.top=-1;
	while (*postexp!='\0')		//postexp字符串未扫描完时循环
	{	
		switch (*postexp)
		{
		case '+':				//判定为'+'号
			a=st.data[st.top];
			st.top--;			//退栈取数值a
			b=st.data[st.top];
			st.top--;			//退栈取数值b
			c=a+b;				//计算c
			st.top++;
			st.data[st.top]=c;	//将计算结果进栈
			break;
		case '-':				//判定为'-'号
			a=st.data[st.top];
			st.top--;			//退栈取数值a
			b=st.data[st.top];
			st.top--;			//退栈取数值b
			c=b-a;				//计算c
			st.top++;
			st.data[st.top]=c;	//将计算结果进栈
			break;
		case '*':				//判定为'*'号
			a=st.data[st.top];
			st.top--;			//退栈取数值a
			b=st.data[st.top];
			st.top--;			//退栈取数值b
			c=a*b;				//计算c
			st.top++;
			st.data[st.top]=c;	//将计算结果进栈
			break;
		case '/':				//判定为'/'号
			a=st.data[st.top];
			st.top--;			//退栈取数值a
			b=st.data[st.top];
			st.top--;			//退栈取数值b
			if (a!=0)
			{
				c=b/a;			//计算c
				st.top++;
				st.data[st.top]=c;	//将计算结果进栈
			}
			else
		    {	
				printf("\n\t除零错误!\n");
				exit(0);		//异常退出
			}
			break;
		default:				//处理数字字符
			d=0;				//将连续的数字字符转换成对应的数值存放到d中
			while (*postexp>='0' && *postexp<='9')   //判定为数字字符
			{	
				d=10*d+*postexp-'0';  
				postexp++;
			}
			st.top++;
			st.data[st.top]=d;
			break;
		}
		postexp++;				//继续处理其他字符
	}
	return(st.data[st.top]);
}
void main()
{
	char exp[]="(56-20)/(4+2)";
	//char exp[]="1+2*3+6/2";
	char postexp[MaxSize];
	trans(exp,postexp);
	printf("中缀表达式:%s\n",exp);
	printf("后缀表达式:%s\n",postexp);
	printf("表达式的值:%g\n",compvalue(postexp));
}