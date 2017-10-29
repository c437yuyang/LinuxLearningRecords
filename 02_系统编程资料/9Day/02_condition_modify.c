#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>
//修改为每生产三个后才通知消费者进行消费


//定义节点结构
typedef struct node
{
    int data;
    struct node* next;
}Node;

//永远指向链表头部的指针
Node *head = NULL;

//线程同步需要互斥所
pthread_mutex_t mutex;
//阻塞线程用的条件变量
pthread_cond_t cond;

//当前生产的个数
int produced_num = 0;

void* th_producer(void *args)
{
    while(1)
    {
        Node *node = (Node *)malloc(sizeof(Node));
        node->data = rand() % 100;
        //使用互斥所保护共享数据
        pthread_mutex_lock(&mutex);
        node->next = head;
        head = node;
        printf("%lu生产了一个烧饼:%d\n",pthread_self(),head->data);
        pthread_mutex_unlock(&mutex);

        //生产完成后，通知阻塞的消费者线程解除阻塞
        if(++produced_num==3)
        {
            pthread_cond_signal(&cond);
        }
        sleep(rand() % 3);
    }
    return NULL;
}

void* th_consumer(void *args)
{
    while(1)
    {
        pthread_mutex_lock(&mutex);
        //判断是否有可以消费的数据
        if(head == NULL)
        {
            //没有数据就让线程阻塞
            //该函数对互斥锁解锁
            pthread_cond_wait(&cond,&mutex);
            //continue;
            //解除互斥锁之后，会对互斥锁进行加锁操作
        }
        Node * node = head;
        head = head->next;
        printf("%lu消费了一个烧饼:%d\n",pthread_self(),node->data);
        free(node);
        produced_num--;
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}
int main()
{

    pthread_t thid_producer,thid_consumer;

    //init
    pthread_mutex_init(&mutex,NULL);
    pthread_cond_init(&cond,NULL);

    //创建生产者线程
    pthread_create(&thid_producer,NULL,th_producer,NULL);
    //创建消费者线程
    pthread_create(&thid_consumer,NULL,th_consumer,NULL);

    //回收子线程
    pthread_join(thid_producer,NULL);
    pthread_join(thid_consumer,NULL);

    //destory
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);

    return 0;
}
