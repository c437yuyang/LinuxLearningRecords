#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>
//定义节点结构
typedef struct node
{
    int data;
    struct node* next;
} Node;

//永远指向链表头部的指针
Node *head = NULL;


//生产者和消费者的信号量
sem_t sem_producer;
sem_t sem_consumer;

void* th_producer(void *args)
{
    while(1)
    {
        sem_wait(&sem_producer); //等待生产者可用信号量，如果为0则阻塞，否则--
        Node *node = (Node *)malloc(sizeof(Node));
        node->data = rand() % 100;
        node->next = head;
        head = node;
        printf("%lu生产了一个烧饼:%d\n",pthread_self(),head->data);
        sem_post(&sem_consumer); //让消费者可用信号++
        sleep(rand() % 3);
    }
    return NULL;
}

void* th_consumer(void *args)
{
    while(1)
    {
        sem_wait(&sem_consumer);
        Node * node = head;
        head = head->next;
        printf("%lu消费了一个烧饼:%d\n",pthread_self(),node->data);
        free(node);
        sem_post(&sem_producer);
        sleep(rand()%3);
    }
    return NULL;
}
int main()
{

    pthread_t thid_producer,thid_consumer;

    //init
    sem_init(&sem_producer,0,4);
    sem_init(&sem_consumer,0,0);

    //创建生产者线程
    pthread_create(&thid_producer,NULL,th_producer,NULL);
    //创建消费者线程
    pthread_create(&thid_consumer,NULL,th_consumer,NULL);

    //回收子线程
    pthread_join(thid_producer,NULL);
    pthread_join(thid_consumer,NULL);


    return 0;
}
