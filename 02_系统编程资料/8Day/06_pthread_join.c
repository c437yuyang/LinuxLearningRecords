#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>

int number = 100;
void* subThread(void *args)
{
    //打印子线程的ID
    for(int i=0;i!=5;++i)
    {
        printf("child thread id:%lu,i = %d\n",pthread_self(),i);
        if(i == 3)
        {
            pthread_exit(&number);
        }
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


    void *retVal = NULL;
    pthread_join(thid,&(retVal));

    printf("return value: %d\n",*(int *)(retVal));

    int i = 0;
    while(i < 10)
    {
        printf("parent i = %d\n",++i);
    }
    return 0;
}
