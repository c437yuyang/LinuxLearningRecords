#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include<sys/stat.h>
#include <string.h>
#include <fcntl.h>

int main()
{
    //打开文件
    int fd = open("english1.txt",O_RDWR);
    printf("fd = %d\n",fd);

    if(fd == -1)
    {
        perror("this is prefix");
        return -1;
    }    
    //打开另一个文件，用来写
    int fdDst = open("dst.txt",O_WRONLY | O_CREAT,0664);
    printf("fdDst = %d\n",fd);

    char buf[4096];
    int len = read(fd,buf,sizeof(buf));
    while(len > 0)
    {
        //写入数据
        int ret =  write(fdDst,buf,len);
        printf("ret = %d\n",ret);
        //接着读取
        len = read(fd,buf,sizeof(buf));
        printf("len = %d\n",len);
    }
    close(fd);
    close(fdDst);
    return 0;
}
