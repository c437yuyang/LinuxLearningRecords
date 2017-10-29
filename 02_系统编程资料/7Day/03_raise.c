#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>
#include <sys/wait.h>


int main(int argc, const char* argv[])
{
    pid_t pid = fork();

    if(pid > 0)
    {
        // parent
        int s;
        wait(&s);//wait会阻塞
        if(WIFSIGNALED(s))
        {
            printf("term by signal: %d\n", WTERMSIG(s));
        }
    }
    else if(pid == 0)
    {
        //自己给自己发信号
        raise(SIGQUIT);//3
        abort();//6
    }

    return 0;
}
