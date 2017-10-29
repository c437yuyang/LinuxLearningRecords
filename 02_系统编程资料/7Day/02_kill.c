#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>


int main(int argc, const char* argv[])
{
    pid_t pid = fork();

    //父进程
    if(pid > 0)
    {
        while(1)
        {
            printf("parent process pid:%d\n",getpid());
            sleep(1);
        }
    }

    //子进程杀死父亲
    if(pid == 0)
    {
        sleep(2);
        kill(getppid(),SIGKILL);//第一个参数,如果pid==0，则杀死相同组的所有进程,如果pid==-1,则杀死所有有权限杀死的进程
    }


    return 0;

}
