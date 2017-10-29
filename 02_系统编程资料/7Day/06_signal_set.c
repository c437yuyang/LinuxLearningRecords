#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>
int main()
{
    //手动屏蔽信号
    //自定义信号集集合
    sigset_t myset;

    //清空集合
    sigemptyset(&myset);
    //添加要阻塞的信号
    sigaddset(&myset,SIGINT); //ctrl + C
    sigaddset(&myset,SIGQUIT); //ctrl+反斜杠
    sigaddset(&myset,SIGKILL);

    //设置到内核的阻塞信号集区
    
    sigprocmask(SIG_BLOCK,&myset,NULL); //第三个参数是传出参数，就是设置之前的状态

    //每隔1s打印一次当前阻塞信号集,按下阻塞信号里的按键后，可以看到输出发生变化
    while(1)
    {
        sigset_t pendset;

        sigpending(&pendset);

        for(int i=1;i!=32;++i)
        {
            if(sigismember(&pendset,i))
                printf("1");
            else printf("0");
        }
        printf("\n");
        sleep(1);
    }   

    return 0;

}
