#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <fcntl.h>

int main(int argc, const char* argv[])
{
    if(argc < 2)
    {
        printf("./a.out fifoname\n");
        exit(1);
    }

    // 判断文件是否存在
    int ret = access(argv[1], F_OK);
    if(ret == -1)
    {
        int r = mkfifo(argv[1], 0664);
        if(r == -1)
        {
            perror("mkfifo error");
            exit(1);
        }
        printf("有名管道%s创建成功\n", argv[1]);
    }

    int fd = open(argv[1], O_RDONLY);
    if(fd == -1)
    {
        perror("open error");
        exit(1);
    }
    
    char buf[512];
    while(1)
    {   //fifo判断读取结束和管道差不多的，本身是阻塞的，然后读取如果返回长度为0则代表结束
        //读端加上sleep验证写端会因为缓冲区还有数据而阻塞
        sleep(2);
        int len = read(fd, buf, sizeof(buf));
        if(len==0)
        {
            printf("读取结束.\n");
            break;
        }
        buf[len] = 0;
        printf("buf = %s, len = %d\n", buf, len);
    }

    close(fd);
    
    return 0;
}
