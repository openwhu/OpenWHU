#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char** argv)
{
    getpid(); //该系统调用起到标识作用
    if(argc < 2)
    {
        printf("hang (user|system)\n");
        return 1;
    }
    if(!strcmp(argv[1], "user"))
        while(1);
    else if(!strcmp(argv[1], "system"))
        sleep(500);
    return 0;
}

