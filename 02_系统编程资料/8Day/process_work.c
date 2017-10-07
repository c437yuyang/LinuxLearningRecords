#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>
void dowork(int sig)
{
    time_t curTime;
    if(sig == SIGALRM)
    {
        time(&curTime);
        //格式化时间
        char *chTime = ctime(&curTime);
        //将时间写入文件
        int fd = open("/home/yxp/Desktop/linuxlearningrecords/tmp.txt",O_CREAT|O_APPEND|O_WRONLY,0664);
        write(fd,chTime,strlen(chTime)+1);
        close(fd);

    }
}

int main()
{
    pid_t pid = fork();
    if(pid >0 )
    {
        exit(1);
    }
    else if (pid == 0)
    {
        //设置守护进程
        setsid();
        //改变当前工作目录
        chdir("/home/yxp");
        //重置文件掩码
        umask(0);
        //关闭文件描述符
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
        //执行核心操作
        
        //注册信号捕捉
        struct sigaction act;
        act.sa_flags = 0;
        act.sa_handler = dowork;
        sigemptyset(&act.sa_mask);
        sigaction(SIGALRM,&act,NULL);
      
        //设置第一次触发的时间
        struct itimerval val;
        val.it_value.tv_sec = 2;
        val.it_value.tv_usec = 0;

        //设置间隔
        val.it_interval.tv_sec = 2;
        val.it_interval.tv_usec = 0;
        
         
        setitimer(ITIMER_REAL,&val,NULL);
        while(1)
        {

        }
    }

    return 0;
}
