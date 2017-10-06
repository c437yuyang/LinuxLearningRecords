#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
int main()
{
    for(int i=0;i!=8;++i)
    {
        printf(" parent i = %d\n",i);
    }

    pid_t pid = fork();

    //让子进程执行ls命令
    if(pid==0)
    {
        //ls执行的是子进程的地址空间,第二个参数通常传命令名就行了。
        execl("/bin/ls","第二个参数无意义，只是占位.","/home/yxp/Desktop","-l",NULL);
        
    }


    for(int i=0;i<3;++i)
    {
        printf("parent i = %d \n",i);
    }
    
    return 0;
}
