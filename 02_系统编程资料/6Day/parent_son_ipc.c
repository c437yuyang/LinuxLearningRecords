#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>
int main()
{

    int fdpipe[2];
    int ret = pipe(fdpipe);
    if(ret == -1)
    {
        perror("创建pipe失败!");
        exit(1);
    }

    pid_t pid = fork();
    if(pid==-1)
    {
        printf("fork error!\n");
        exit(1);
    }


    //父进程
    //ps aux
    if(pid > 0){
        //关闭读端    
        close(fdpipe[0]);
        //先进行终端文件描述符的重定向
        //stdout->管道的写端
        dup2(fdpipe[1],STDOUT_FILENO);
        execlp("ps","ps","aux",NULL);
        perror("execlp:");
        exit(1);
    }
    else if(pid==0)
    {
        close(fdpipe[1]);
        dup2(fdpipe[0],STDIN_FILENO);
        execlp("grep","grep","bash","--color=auto",NULL);
    }


    //通常来说创建后是3和4，因为前面被占用，fdpipe[0]是读，fdpipe[1]是写
    printf("pipe[0] = %d,pipe[1] = %d\n",fdpipe[0],fdpipe[1]);

    close(fdpipe[0]);
    close(fdpipe[1]);
    return 0;
}
