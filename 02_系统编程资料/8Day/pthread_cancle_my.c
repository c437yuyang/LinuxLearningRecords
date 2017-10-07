#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>

void* subThread(void *args)
{
    while(1)
    {
        int i,j,k;
        i = 10;
        j = 20;
        k  = i + j;
        printf("k = %d\n",k); //必须到了系统调用的地方才能被pthread_cancle杀死
        // pthread_testcancel(); //强制加一个系统调用点
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
