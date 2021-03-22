#include <sys/wait.h>
#include <unistd.h>     /* For fork() */
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/reg.h>   /* For constants ORIG_RAX etc */
#include <sys/user.h>
#include <sys/syscall.h> /* SYS_write */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char**argv) 
{
    
    pid_t child;    //存放孩子进程的pid
    long sys_id;  //存放子进程的系统调用号
    
    int status;
    int iscalling = 0;
    struct user_regs_struct regs;
    struct timeval time1,time2;
    child=fork();   //父进程创建子进程,父进程的child得到子进程Pid,子进程pid=0 
    
    if(child<0) //创建失败
    {
        fprintf(stderr,"Fork Failed\n");
		return -1;
    }
    else if(child==0) //子进程
    {
        if(argc!=2)//主进程没有得到传入的要跟踪的程序名称参数或者参数过多
		{
			printf("%s [list of values]\n",*argv);
			return -2;
		}
        ptrace(PTRACE_TRACEME,0,NULL,NULL);//允许父进程跟踪
        char *temp=(char*)malloc(sizeof(char)*(strlen(argv[1])+3));
        temp[0]='.';
        temp[1]='/';
        strcat(temp,argv[1]);
	printf("-----------------------------\n");
	printf("The program you are stracing is %s\n",temp);
	printf("-----------------------------\n");        
	execl(temp,NULL);
    }
    else    //父进程
    {
            wait(&status);
            if(WIFEXITED(status))//判断是否是正常退出
                return 0;
            sys_id = ptrace(PTRACE_PEEKUSER,child, 8 * ORIG_RAX,NULL);
	    ptrace(PTRACE_SYSCALL,child,NULL,NULL);
	    printf("the sys_id is %ld\n",sys_id);
              
        while(1)
	    {
			wait(&status);
			if(WIFEXITED(status))
			{
				long re=ptrace(PTRACE_PEEKUSER, child, RAX*8, NULL);//获取寄存器参数
				gettimeofday(&time2,NULL);
				double last = (time2.tv_usec+time2.tv_sec*1000000-time1.tv_usec-time1.tv_sec*1000000)/1000000;		
				printf("the return is %ld,the time is %lf\n",re,last);
				return 0;
			}			
			if(iscalling == 0)
			{
				sys_id = ptrace(PTRACE_PEEKUSER, child, ORIG_RAX*8, &regs);
				gettimeofday(&time1,NULL);
				printf("the sys_id is %ld \n",sys_id);
				printf("\t[Enter SYS_write call] with regs.rdi [%ld], regs.rsi[%ld], regs.rdx[%ld], regs.rax[%ld], regs.orig_rax[%ld]\n",
							regs.rdi, regs.rsi, regs.rdx,regs.rax, regs.orig_rax);			
				iscalling = 1;
			}
			else
			{
				long re = ptrace(PTRACE_PEEKUSER, child, RAX*8,&regs);
				gettimeofday(&time2,NULL);
				printf("\t[Leave SYS_write call] return regs.rax [%ld], regs.orig_rax [%ld]\n", regs.rax, regs.orig_rax);
				double last = (time2.tv_usec+time2.tv_sec*1000000-time1.tv_usec-time1.tv_sec*1000000)/1000000;
				printf("the return is %ld,the time is %lf\n",re,last);
				iscalling = 0;
			}
			ptrace(PTRACE_SYSCALL, child, NULL, NULL);//继续执行目标进程	
	    }
	    
		    /*
		  while(1)
		  {
		    wait(&status);
		    if(WIFEXITED(status))//判断是否是正常退出
		        return 0;
		    orig_rax = ptrace(PTRACE_PEEKUSER,child, 8 * ORIG_RAX,NULL);
		    if(orig_rax == SYS_write)
		    {
		        ptrace(PTRACE_GETREGS, child, NULL, &regs);    //获取寄存器参数
		        if(!iscalling)          //进入系统调用
		        {
		            iscalling = 1;          
		            printf("[Enter SYS_write call] with regs.rdi [%ld], regs.rsi[%ld], regs.rdx[%ld], regs.rax[%ld], regs.orig_rax[%ld]\n",
		                    regs.rdi, regs.rsi, regs.rdx,regs.rax, regs.orig_rax);
		        }
		        else            //离开此次系统调用
		        {
		            printf("[Leave SYS_write call] return regs.rax [%ld], regs.orig_rax [%ld]\n", regs.rax, regs.orig_rax);
		            iscalling = 0;
		        }
		    }
		    ptrace(PTRACE_SYSCALL, child, NULL, NULL);//继续执行目标进程
		}

		    */
    }
    return 0;
}
