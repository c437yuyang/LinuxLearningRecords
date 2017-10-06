#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    pid_t pid = fork();
    //子进程运行后就死亡了   
    if(pid==0)
    {
        while(1)
        {
            sleep(1);
            printf("child pid = %d,ppid = %d \n",getpid(),getppid());  
        }
    }

    else if(pid > 0) 
    {
        //父进程一直运行而不去释放子进程的PCB
        printf("===parent\n");
        printf("parent pid = %d,ppid = %d\n",getpid(),getppid());
        //回收子进程
        int status;
        pid_t wpid = wait(&status);
        if(WIFEXITED(status))
        { 
            printf("exit value: %d \n",WIFEXITED(status));
        }
        //是否被信号杀死
        if(WIFSIGNALED(status)){
            printf("exit by signal : %d \n",WTERMSIG(status));
        }
        printf("died child pid = %d\n",wpid);
    }


    return 9;
}
