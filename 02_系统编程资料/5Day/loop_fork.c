#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>

int counter = 100;

int main(int argc, const char* argv[])
{
    pid_t pid;

    int i=0;
    for(i=0; i<3; i++)
    {
        pid = fork();
        if(pid == 0)
        {
            break; //子进程的返回值是0，直接退出，避免产生孙子进程.
        }
    }

    // 父进程出来后肯定是3
    if(i == 3)
    {
        counter += 100;
        printf("parent process, pid = %d, ppid = %d, %d\n", getpid(), getppid(), counter);
        //        sleep(1);
    }
    // 子进程
    else if(i == 0)
    {
        // 1th
        counter += 200;
        printf("child process, pid = %d, ppid = %d, %d\n", getpid(), getppid(), counter);
    }
    else if(i == 1)
    {
        // 2th
        counter += 300;
        printf("child process, pid = %d, ppid = %d, %d\n", getpid(), getppid(), counter);
    }
    else if(i == 2)
    {
        // 3th
        counter += 400;
        printf("child process, pid = %d, ppid = %d, %d\n", getpid(), getppid(), counter);
    }


    return 0;
}
