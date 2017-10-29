#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#define SERV_PORT 8000
//没写epoll的代码,就是普通的socket模型
int main()
{

    int lfd,cfd;
    char buf[1024];
    int len;
    struct sockaddr_in serv_addr,clin_addr;

    //AF:INET:ipv4 SOCK_STREAM:stream协议 0:tcp
    lfd = socket(AF_INET,SOCK_STREAM,0);

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY); //每块网卡都绑定
    serv_addr.sin_port = htons(SERV_PORT); //host to 网络序-大端存储

    //IP+PORT
    bind(lfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr));


    listen(lfd,128);

    //函数定义
    int clin_len = sizeof(clin_addr);
    cfd = accept(lfd,(struct sockaddr *)&clin_addr,&clin_len);
    len = read(cfd,buf,sizeof(buf));
    write(STDOUT_FILENO,buf,len);

    close(lfd);
    close(cfd);

    return 0;
}
