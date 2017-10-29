#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>

//共享的全局变量
int number;
pthread_rwlock_t rwlock;

void* write_func(void *args)
{
    //循环写
    while(1)
    {
        pthread_rwlock_wrlock(&rwlock);
        number++;
        printf("==write:%lu,%d\n",pthread_self(),number);
        pthread_rwlock_unlock(&rwlock);
        usleep(500);
    }

    return NULL;
}

void* read_func(void *args)
{
    while(1)
    {
        pthread_rwlock_rdlock(&rwlock);
        printf("==read:%lu,%d\n",pthread_self(),number);
        pthread_rwlock_unlock(&rwlock);
        usleep(500);

    }
    return NULL;
}


int main()
{
    pthread_t pthid[8];
    //初始化读写锁
    pthread_rwlock_init(&rwlock,NULL);
    int i=0;
    for(i=0;i!=3;++i)
    {
        pthread_create(&pthid[i],NULL,write_func,NULL);
    }
    for(i = 3;i!=8;++i)
    {
        pthread_create(&pthid[i],NULL,read_func,NULL);
    }


    //阻塞子线程回收的PCB
    for(i=0;i!=8;++i)
    {
        pthread_join(pthid[i],NULL);
    }

    //释放读写锁
    pthread_rwlock_destroy(&rwlock);

}
