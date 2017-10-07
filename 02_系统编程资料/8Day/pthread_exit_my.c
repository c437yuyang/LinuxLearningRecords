#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>

void* subThread(void *args)
{
    //打印子线程的ID
    for(int i=0;i!=5;++i)
    {
        printf("child thread id:%lu,i = %d\n",pthread_self(),i);

    }
    return NULL;
}



int main()
{
    //创建子线程
    pthread_t thid;
    //返回错误信号
    int ret = pthread_create(&thid,NULL,subThread,NULL);
    if(ret)
    {
        printf("error number:%d\n",ret);
        printf("%s\n",strerror(ret)); //打印错误信息
    }
    printf("parent thread id:%lu\n",pthread_self());
    
    for(int i=0;i!=5;++i)
    {
        printf("parent i = %d\n",i);
    }
    //退出父线程
    pthread_exit(NULL);
    return 0;
}
