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
    //int num = *(int *)(args);
    int num = (int)(args);
    printf("child thread id:%lu,是第%d个被创建的线程.\n",pthread_self(),num);
    return NULL;
}



int main()
{
    //创建子线程
    pthread_t thid[5];
    //返回错误信号
    for(int i=0;i!=5;++i)
    {
        //第4个参数是传地址的方式有问题
        //改成传值，这里刚好void * 和 int的大小一样，才能这样做
        //int ret = pthread_create(&thid[i],NULL,subThread,(void*)&i);
        int ret = pthread_create(&thid[i],NULL,subThread,(void*)i);
        if(ret!=0)
        {
            printf("create thread failed\n");
            exit(1);
        }
    }
    printf("parent thread id:%lu\n",pthread_self());
    
    for(int i=0;i!=5;++i)
    {
        printf("%d ",i);
    }
    printf("\n");
    //必须等待一会儿
    sleep(2);
    return 0;
}
