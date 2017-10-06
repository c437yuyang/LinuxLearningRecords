#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>


int main(int argc, const char* argv[])
{
    printf("argc : %d, argv[0] = %s, argv[1] = %s\n", argc, argv[0], argv[1]);
    
    return 0;
}
