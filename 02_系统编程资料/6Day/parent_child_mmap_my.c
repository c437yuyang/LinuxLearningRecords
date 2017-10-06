#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <wait.h>

int main(int argc, const char* argv[])
{
    
    //打开文件
    int fd = open("english.txt",O_RDWR);
    int len = lseek(fd,0,SEEK_END); //获取文件大小
    printf("文件大小:%d字节.\n",len);
    //创建内存映射区
    void *ptr = mmap(NULL,len,PROT_READ | PROT_WRITE,MAP_SHARED,fd,0);
    if(ptr == MAP_FAILED)
    {
        perror("mmap error\n");
        exit(1);
    }
 

    //创建子进程
    pid_t pid = fork();
    if(pid == -1)
    {
        perror("fork error;");
        exit(1);
    }


    if(pid > 0)
    {
        //写数据
        sleep(1);//mmap因为是从内存直接读写数据，因此没有阻塞，所以要考虑先后顺序，如果这里加了sleep(1)，相当于是还没写入就在读，读取到的就是错误的信息了。
        strcpy((char *)ptr,"你是个傻瓜1111111.");
        //回收子进程
        wait(NULL);
    }

    if(pid == 0)
    {
        //读数据:
        
        printf("%s\n",(char *)ptr);
    }

//    char *str = (char *)ptr;
//    for(;*str != '\0';++str)
//    {
//        printf("%c",*(str));
//    }
    //printf("%s",(char *)str);
    //关闭映射区
    munmap(ptr,len);
    close(fd);



    return 0;
}
