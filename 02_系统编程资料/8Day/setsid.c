#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <stdlib.h>


int main()
{

    pid_t pid = fork();
    if(pid > 0) 
    {
        exit(1);
    }
    else if(pid == 0){
        //子进程变成会长
        setsid();//启动一个守护进程
        while(1);
    }

    return 0;
}
