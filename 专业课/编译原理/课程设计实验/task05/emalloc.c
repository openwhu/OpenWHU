#include <stdlib.h>
#include <stdio.h>
#ifndef __TURBOC__  
#include <unistd.h>
#endif
/* 检查每次申请内存是否成功
 */
void * smalloc(size_t size)
{
    static char msg[] = "分析器内存枯竭\n";
    char* retval = malloc((unsigned)size);

    if(retval == 0) {
	/* fprintf might call malloc(), so... */
	write(2, msg, sizeof(msg));  /* 打印到错误输出
		(file descriptor is 2) */
	exit(-1);
    }
    return retval;
}

void sfree(void *x)
{
  free (x);
}
