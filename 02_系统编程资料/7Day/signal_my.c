#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>


//参数就是捕捉到的信号number
void handler(int sig)
{
    printf("catched your signal number %d\n",sig);
}


int main()
{

    //捕捉ctrl+c
    signal(SIGINT,handler);

    while(1)
    {}

    return 0;

}
