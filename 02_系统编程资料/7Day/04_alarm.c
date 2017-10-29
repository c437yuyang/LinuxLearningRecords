#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>

int main()
{
    //alarm是到达设置的时间后，会发送一个SIGALARM信号
    //收到SIGALARM信号后，程序会停止
    
    int ret = alarm(5);
    printf("ret = %d\n",ret);//第一次设置定时器返回0

    sleep(2);
    //重新设置定时器
    ret = alarm(2);
    printf("ret = %d\n",ret);//第二次设置定时器返回第一次还有多久执行，这里就是3


    while(1)
    {
        printf("hello\n");
        sleep(1);
    }

    return 0;
}
