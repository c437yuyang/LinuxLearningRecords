#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>


int main(int argc, char* argv[])
{
    if(argc < 3)
    {
        printf("a.out filename mode\n");
        exit(1);
    }
    int mode = strtol(argv[2], NULL, 8);//转换成8进制的数
    int ret = chmod(argv[1], mode);//设置模式
    if(ret == -1)
    {
        perror("chmod");
        exit(1);
    }

    ret = chown(argv[1], 1001, 1002);
    if(ret == -1)
    {
        perror("chown");
        exit(1);
    }
    return 0;
}
