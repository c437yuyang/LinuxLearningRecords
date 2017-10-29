#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>


int main(int argc, const char* argv[])
{
    // 需要管道
    int fd[2];
    int ret = pipe(fd);
    if(ret == -1)
    {
        perror("pipe error");
        exit(1);
    }

    // 创建子进程
    pid_t pid = fork();
    if(pid == -1)
    {
        perror("fork error");
        exit(1);
    }

    // ps aux | grep bash
    // 父进程　ps aux , 写管道，　关闭读端
    if(pid > 0)
    {
        sleep(3);
        close(fd[0]);
        // 数据写到管道，STDOUT_FILENO 指向管道的写端
        dup2(fd[1], STDOUT_FILENO);
        execlp("ps", "ps", "aux", NULL);
        perror("execlp ps");
        exit(1);
    }
    // 子进程　grep bash 从管道中搜索，　读管道，　关闭写端
    else if(pid == 0)
    {
        close(fd[1]);
        dup2(fd[0], STDIN_FILENO);//dup2(old new)
        execlp("grep", "grep", "bash", NULL);
        perror("execlp grep");
        exit(1);
    }
    //通常来说创建后是3和4，因为前面被占用，fdpipe[0]是读，fdpipe[1]是写
    printf("pipe[0] = %d,pipe[1] = %d\n",fd[0],fd[1]);
    close(fd[0]);
    close(fd[1]);
    return 0;
}
