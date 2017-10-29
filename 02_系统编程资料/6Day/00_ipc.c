#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/wait.h>

int main(int argc, const char* argv[])
{
    int fd[2];
    int ret  = pipe(fd);
    if(ret == -1)
    {
        perror("pipe error");
        exit(1);
    }

    printf("fd[0] = %d\n", fd[0]);
    printf("fd[1] = %d\n", fd[1]);

    pid_t pid = fork();
    if(pid == -1)
    {
        perror("fork error");
        exit(1);
    }

    // 父进程　写　，　关闭读操作
    if(pid > 0)
    {
        sleep(1);//延时验证管道是阻塞的
        close(fd[0]);
        char* p = "hell, world\n";
        write(fd[1], p, strlen(p)+1);
        close(fd[1]);

        wait(NULL);
    }
    else if(pid == 0)
    {
        close(fd[1]);
        char buf[1024];
        read(fd[0], buf, sizeof(buf));
        printf("buf = %s\n", buf);
        close(fd[0]);
    }
    //不用显式释放，操作管道的进程销毁之后，管道自动释放
    //管道的读端当判断到管道的写端全部关闭的时候，read就会接触阻塞
    //管道的写端会检查读端是否有，如果没有，则进程被终止
    //如果有，就往缓冲区写，如果写满了，则写端阻塞，等到读走了后再写
    //管道的局限性就在于:数据只能读取一次
    return 0;
}
