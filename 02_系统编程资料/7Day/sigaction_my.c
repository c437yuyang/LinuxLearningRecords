#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>

void myhandler(int sig)
{
    printf("hello signal: %d\n", sig);
    sleep(5);
    printf("wake up .....\n");
}

int main()
{
    struct sigaction act;
    //int 
    act.sa_flags = 0;
    sigemptyset(&act.sa_mask);
    act.sa_handler = myhandler;
    //添加临时屏蔽信号
    sigaddset(&act.sa_mask,SIGQUIT);    

    //注册
    sigaction(SIGINT,&act,NULL);//第三个参数也是之前的action


    while(1)
    {}



    return 0;
}
