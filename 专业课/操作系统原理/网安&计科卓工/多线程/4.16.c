#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

static int *values = NULL; //用于存放传入转换好的数字的数组的头指针
static int size = 0;       //记录传入的程序的参数个数

static float average;
static int minimum;
static int maximum;

int init_values(int argc, char **argv); //将传入的字符串转换为数字,用时需要调整argc,argv

void *average_value(void *param);
void *minimum_value(void *param);
void *maximum_value(void *param);

int main(int argc, char **argv)
{
    pthread_attr_t attr; //表示定义一种线程属性

    // The ids of the threads that calculate
    // the average, the minimum and the maximum
    pthread_t average_id, minimum_id, maximum_id; //声明线程标识符，不同的计算线程有其自己的标识符

    int ret; // The return value of functions

    if (argc == 1) //argv[0]是程序名称，argc=1表示没有传入数字，打印信息后返回
    {
        printf("%s [list of values]\n", *argv);
        return 1;
    }

    // Initialize the values buffer
    ret = init_values(argc - 1, argv + 1); //由于argv[0]是程序名称，因此实际传入的参数个数是argc-1.而参数列表指针应该右移，跳过程序名称的参数

    if (ret < 0) //ret记录传入数字字符串参数初始化后的状态，小于0表示异常，返回退出
        return 2;

    // Initialize the pthreads library
    if (pthread_attr_init(&attr) != 0) //设置定义的一种线程的属性，没有明确设置，默认缺省属性；!=0,设置异常
    {
        fputs("pthread_attr_init didn't work\n", stdout); //打印错误信息
        // Free the values buffer
        free(values);
        return 3; //返回异常状态码
    }

    // Create the thread that finds the average value
    //创建一个新的单独线程,要传入线程标识符，线程的属性(这里是定义的那种缺省属性)，运行函数的名称，运行函数的参数这里为空
    ret = pthread_create(&average_id, &attr, average_value, NULL);

    if (ret != 0) //创建新线程异常
    {
        printf("Couldn't create average value thread\n");
        // Free the values buffer
        free(values);
        return 4;
    }

    //Create the thread that finds the minimum value.
    ret = pthread_create(&minimum_id, &attr, minimum_value, NULL);
    if (ret != 0)
    {
        printf("Couldn't create minimum value thread\n");
        // Free the values buffer
        free(values);
        return 4;
    }

    // Create the thread that finds the maximum value
    ret = pthread_create(&maximum_id, &attr, maximum_value, NULL);
    //Checking the condition whether ret is equal to 0 or not.
    if (ret != 0)
    {
        printf("Couldn't create maximum value thread\n");
        // Free the values buffer
        free(values);
        return 4;
    }

    //等待三个线程完成
    // Wait for the average value thread to exit
    // and print out the average value
    if (pthread_join(average_id, NULL) == 0)
        printf("The average value is %f\n", average);
    else
        fputs("pthread_join didn't work for "
              "average value thread",
              stdout);

    // Wait for the minimum value thread to exit
    // and print out the minimum value
    if (pthread_join(minimum_id, NULL) == 0)
        printf("The minimum value is %d\n", minimum);
    else
        fputs("pthread_join didn't work for "
              "minimum value thread",
              stdout);

    // Wait for the maximum value thread to exit
    // and print out the maximum value
    if (pthread_join(maximum_id, NULL) == 0)
        printf("The maximum value is %d\n", maximum);
    else
        fputs("pthread_join didn't work for "
              "maximum value thread",
              stdout);

    // De-init the pthreads library
    pthread_attr_destroy(&attr);
    // Free the values buffer
    free(values);
    return 0;
}

int init_values(int argc, char **argv)
{
    // The index into the passed arguments
    int index;

    // Are the passed arguments valid?
    if (argc < 1 || !argv) //程序错误
        return -1;

    // Allocate space to the values buffer
    /*
    typeof，是gcc中对c/c++语法的一个扩展，用来静态获取参数类型
    比如
    int a = 3;
    typeof(a) b = 4; // 相当于 int b = 4;
    */
    values = (__typeof__(values))malloc(argc * sizeof(*values)); //values是int*类型，*values就是int了
    //将values指向一个argc个元素的int数组，values是静态全局变量.

    if (!values) //失败为空
    {
        printf("Couldn't allocate %lu bytes\n", argc * sizeof(*values));
        return -2;
    }

    // Set the size of the buffer
    size = argc;
    // Fill in the values in the buffer
    for (index = 0; index < argc; index++)
        values[index] = atoi(argv[index]); //传入参数转换为数字 argv[1] - agrv[argc-1]是传入的数字，argv[0]=程序名称
    return 0;
}

void *average_value(void *param) //
{
    // Does the values buffer exist
    // and is its size valid?
    if (values && size > 0)
    {
        // Index into the values buffer
        int index;
        // Set the average to the 1st element
        average = values[0];
        // For the rest of the values in the buffer
        for (index = 1; index < size; index++)
            // Add the value to the average
            average += values[index];
        // Divide by size to get the average
        average /= size;
    }
    // Exit from this thread
    pthread_exit(0); //调用后线程终止
}

void *minimum_value(void *param)

{
    // Does the values buffer exist
    // and is its size valid?
    if (values && size > 0)
    {
        // Index into the values buffer
        int index;
        // Set the minimum to the 1st element
        minimum = values[0];
        // For the rest of the values in the buffer
        for (index = 1; index < size; index++)
            // Is the minimum greater than this element
            if (minimum > values[index])
                // Update the value of the minimum
                minimum = values[index];
    }
    // Exit from this thread
    pthread_exit(0);
}

void *maximum_value(void *param)

{
    // Does the values buffer exist
    // and is its size valid?
    if (values && size > 0)
    {
        // Index into the values buffer
        int index;
        // Set the maximum to the 1st element
        maximum = values[0];
        // For the rest of the values in the buffer
        for (index = 1; index < size; index++)
            // Is the maximum less than this element
            if (maximum < values[index])
                // Update the value of the maximum
                maximum = values[index];
    }
    // Exit from this thread
    pthread_exit(0);
}