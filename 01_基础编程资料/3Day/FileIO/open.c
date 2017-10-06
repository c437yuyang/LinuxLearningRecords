#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
int main()
{
    int fd = open("hello",O_RDWR| O_CREAT,0777);
    if(fd==-1){
        printf("open failed!");
    }
    close(fd);
    return 0;
}

