#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/wait.h>

int main(int argc, const char* argv[])
{
    pid_t pid;

    for(int i=0; i<10; ++i)
    {
        pid = fork();
        if(pid == 0)
        {
            break;
        }
    }

    if(pid > 0)
    {
        // 父进程
        printf("parent process, pid = %d, ppid = %d\n", getpid(), getppid());
        // 回收子进程
        pid_t wpid;
        int status;
        while( ( wpid = waitpid(-1, &status, WNOHANG) ) != -1 )//第一个参数pid==-1表示等待任一子进程，与wait等效.第三个参数是options，WNOHANG表示非阻塞，0就是阻塞
        {
            if(wpid == 0)//返回值为0表示子进程正在运行
                continue;
            printf("died process pid = %d\n", wpid);
            // 判断进程退出方式，和wait是一样的
            if(WIFEXITED(status))
            {
                printf("------ exit value: %d\n", WEXITSTATUS(status));
            }
            if(WIFSIGNALED(status))
            {
                printf("=======exit by signal: %d\n", WTERMSIG(status));
            }
        }
    }
    else
    {
        // 子进程
        printf("child process, pid = %d, ppid = %d\n", getpid(), getppid());
    }
    return 9;
}
