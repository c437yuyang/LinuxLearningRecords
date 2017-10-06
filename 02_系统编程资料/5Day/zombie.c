#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main()
{
    pid_t pid = fork();
    //子进程运行后就死亡了   
    if(pid==0){
        sleep(1);
        printf("child pid = %d,ppid = %d \n",getpid(),getppid());
    }

    else if(pid > 0) 
    {
        //父进程一直运行而不去释放子进程的PCB
        while(1)
        {
            sleep(1);
            printf("===parent\n");
            printf("parent pid = %d,ppid = %d\n",getpid(),getppid());
        }
    }


    return 0;
}
