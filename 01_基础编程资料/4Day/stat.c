#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

int main()
{
    struct stat st;

    int ret = stat("english.txt",&st);

    if(ret == -1)
    {
        perror("stat error");
        exit(1);
    }

    printf("file size= %d \n",st.st_size);

    return 0;

}
