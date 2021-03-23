/**
 * Solution to the problem <producer - consumer> 
 * using counting semaphores as well as a mutex lock.
 *
 * This is a POSIX solution using unnamed semaphores.
 * 
 * This solution will not work on OS X systems, 
 * but will work with Linux.
 */

#include "buffer.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define TRUE 1

buffer_item buffer[BUFFER_SIZE];

/*pthread互斥锁*/
pthread_mutex_t mutex;
/*信号量的数据类型*/
sem_t empty;    //缓冲区空
sem_t full;     //缓冲区满

int insertPoniter=0;
int removePointer=0;

/* 线程调用函数 */
void *producer(void *param);
void *consumer(void *param);

int insert_item(buffer_item item)
{
    /**
     *sem_wait( sem_t *sem )被用来阻塞当前线程直到信号量sem的值大于0,
     *解除阻塞后将sem的值减一,表明公共资源经使用后减少.
     *类似PV原语中的P原子操作
     */
    /* Acquire Empty Semaphore */
    sem_wait(&empty);
    
    /**
     * 当pthread_mutex_lock()返回时,该互斥锁已被锁定.
     * 线程调用该函数让互斥锁上锁,如果该互斥锁已被另一个线程锁定和拥有,
     * 则调用该线程将阻塞,直到该互斥锁变为可用为止.
     * /
    
    /* Acquire mutex lock to protect buffer */
    pthread_mutex_lock(&mutex);

    buffer[insertPoniter++]=item;
    insertPoniter=insertPoniter % 5;

    /* Release mutex lock and full semaphore */
    pthread_mutex_unlock(&mutex);
    
    
    /**
     * 函数sem_post( sem_t *sem )
     * 用来增加信号量的值当有线程阻塞在这个信号量上时,
     * 调用这个函数会使其中的一个线程不再阻塞,
     * 选择机制同样是由线程的调度策略决定的.
     * 类似V操作
    */
    sem_post(&full);

    return 0;
}

int remove_item(buffer_item *item)
{
    /*Acquire Full Semaphore*/
    sem_wait(&full);

    /* Acquire mutex lock to protect buffer */
    pthread_mutex_lock(&mutex);

    *item=buffer[removePointer];
    buffer[removePointer++]=-1;
    removePointer=removePointer % 5;

    /* Release mutex lock and empty semaphore */
    pthread_mutex_unlock(&mutex);
    sem_post(&empty);

    return 0;
}


/**
 * 需传入3个参数
 * <sleep time> <producer threads> <consumer threads>
*/
int main(int argc,char*argv[])
{
    int sleepTime,producerThreads,consumerThreads;
    int i,j;
    if(argc!=4)
    {
        fprintf(stderr,"Useage: <sleep time> <producer threads> <consumer threads>\n");
        return -1;
    }

    sleepTime=atoi(argv[1]);
    producerThreads=atoi(argv[2]);
    consumerThreads=atoi(argv[3]);

    /* Initialize the synchronization tools */
    printf("%d\n",pthread_mutex_init(&mutex,NULL));
    printf("%d\n",sem_init(&empty,0,5));
    printf("%d\n",sem_init(&empty,0,5));
    srand(time(0));

    /* Create the producer and consumer threads */
    for(i=0;i<producerThreads;i++)
    {
        pthread_t tid;
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        pthread_create(&tid,&attr,producer,NULL);
    }

    for(j=0;j<consumerThreads;j++)
    {
        pthread_t tid;
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        pthread_create(&tid,&attr,consumer,NULL);
    }

    /* Sleep for user specified time */
    sleep(sleepTime);
    return 0;
}

void *producer(void*param)
{
    buffer_item random;
    int r;
    while(TRUE)
    {
        r=rand()%5;
        sleep(r);
        random=rand();
        if(insert_item(random))
            fprintf(stderr,"Error");
        
        printf("Producer produced %d \n",random);
    }
}

void *consumer(void *param)
{
    buffer_item random;
    int r;
    while(TRUE)
    {
        r=rand() % 5;
        sleep(r);
        if(remove_item(&random))
            fprintf(stderr,"Error Consuming");
        else
            printf("Consumer consumed %d\n",random);
    }
}
