#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main()
{
    pid_t pid = fork();
    
    if(pid==0){
        sleep(1);
        printf("child pid = %d,ppid = %d \n",getpid(),getppid());
    }

    else if(pid > 0) 
    {
        printf("===parent\n");
        printf("parent pid = %d,ppid = %d\n",getpid(),getppid());
    }


    return 0;
}
