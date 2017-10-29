#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/time.h>
#include <signal.h>


int main()
{
    struct itimerval new_value;
    new_value.it_interval.tv_sec = 1;//每次触发的间隔是1s
    new_value.it_interval.tv_usec = 0;

    new_value.it_value.tv_sec = 2;//第一次触发的时间是2秒后
    new_value.it_value.tv_usec = 0;

    //设置定时器
    
    int ret = setitimer(ITIMER_REAL,&new_value,NULL);//按照自然时间
    
    while(1)
    {
        sleep(1);
        printf("hello \n");
    }


    return 0;
}
