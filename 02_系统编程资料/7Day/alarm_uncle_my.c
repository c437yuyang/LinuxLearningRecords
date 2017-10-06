#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>

int main()
{
    //设置定时器
    alarm(1);
    int i = 0;
    while(1)
    {
        printf("%d ",++i);
    }




    return 0;
}
