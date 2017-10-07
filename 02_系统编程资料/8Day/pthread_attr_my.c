#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>

void* subThread(void *args)
{
    sleep(5); //可以看到detach后，即使父线程已经退出，子线程还是会自行回收。
    //打印子线程的ID
    printf("child thread id:%lu\n",pthread_self());
    return NULL;
}



int main()
{
    //创建子线程
    pthread_t thid;
    //返回错误信号
    //初始化线程属性
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_DETACHED);
    //创建线程的时候设置线程分离
    int ret = pthread_create(&thid,&attr,subThread,NULL);
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
    pthread_attr_destroy(&attr);
    return 0;
}
