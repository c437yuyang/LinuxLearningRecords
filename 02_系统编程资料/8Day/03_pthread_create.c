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
    printf("child thread id:%lu\n",pthread_self());
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
    printf("child thread id by thid variable:%lu\n",thid);    
    for(int i=0;i!=5;++i)
    {
        printf("%d ",i);
    }
    printf("\n");
    //必须等待一会儿，否则子线程还没执行的时候父线程退出了使得子线程也被强制退出
    sleep(2);
    return 0;
}
