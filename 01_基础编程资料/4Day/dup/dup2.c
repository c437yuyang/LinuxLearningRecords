#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
	int fd = open("temp", O_RDWR | O_CREAT | O_APPEND, 0664);
	if(fd == -1)
	{
		perror("open");
		exit(1);
	}

	int fd2 = open("temp1", O_RDWR | O_CREAT | O_APPEND, 0664);
	if(fd2 == -1)
	{
		perror("open open");
		exit(1);
	}
	// 复制文件描述符
	dup2(fd, fd2);//把fd复制给fd2一份
	// 写文件
	char* p = "change the world by programing。。。。。。";
	write(fd2, p, strlen(p));
	close(fd2);

	char buf[1024];
	lseek(fd, 0, SEEK_SET);//SEEK_SET是文件头部
	read(fd, buf, sizeof(buf));
	printf(" buf = %s\n", buf);
	close(fd);

	return 0;
}
