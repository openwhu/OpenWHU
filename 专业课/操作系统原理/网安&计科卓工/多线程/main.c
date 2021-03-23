#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <pthread.h>

static int sum;
void *sum_value(void*param);

int main(int argc,char**argv)
{
pid_t pid;
	pid=fork();//Create Processn B
	if(pid<0){
		fprintf(stderr,"Fork Failed\n");
		return 1;
	}
	else if(pid==0)//Child Process
	{
		pthread_attr_t attr;
		pthread_t sum_id;
		if(argc!=2)
		{
			printf("%s [list of values]\n",*argv);
			return 1;
		}
		if(pthread_attr_init(&attr)!=0)
		{
			fputs("pthread_attr_init didn't work\n",stdout);
			return 2;
		}
		//int value=atoi(argv[1]);
		int ret=pthread_create(&sum_id,&attr,sum_value,argv[1]);
		if(ret!=0)
		{
			printf("Could't create sum value thread\n");
			return 3;
		}
		
		if(pthread_join(sum_id,NULL)==0)
			printf("The sum value is %d\n",sum);
		else
			fputs("pthread_join didn't work for""sum value thread",stdout);	
		
		pthread_attr_destroy(&attr);	
	}
	else{//Parrent Process A
		wait(NULL);		
		execlp("./hello",NULL);
		printf("Failed to exec()\n");
	}
	return 0;
}
void *sum_value(void*param)
{
	int i,upper=atoi(param);
	sum=0;
	for(i=1;i<=upper;i++)
		sum+=i;
	pthread_exit(0);
} 

