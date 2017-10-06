#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/mman.h>
#include <fcntl.h>


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
    
    char *str = (char *)ptr;
    for(;*str != '\0';++str)
    {
        printf("%c",*(str));
    }
    //printf("%s",(char *)str);
    //关闭映射区
    munmap(ptr,len);
    close(fd);



    return 0;
}
