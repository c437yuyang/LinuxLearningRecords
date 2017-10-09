#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define N 4096

void send_headers(char *type)
{
    HTTP/1.1 200 Ok
    Content-Type: text/plain; charset=iso-8859-1 
    Connection: close
    \r\n
}
void send_err(错误号, 错误名称, 错误描述)
{
    //先加上http的协议头
    
    <html> 
    <head><title>错误号 错误名称</title> </head>
    <body>
    错误描述
    </body>
    </html>
}


// xinetd --> ./xhttpd /home/yxp/root等价于浏览器中的根目录/
int main(int argc, char *argv[])
{
    char line[N];
    char method[N], path[N], protocol[N];

    char *file;
    struct stat sbuf;
    FILE *fp;
    int ich;

    if (argc != 2)
        //send_err();
    if (chdir(argv[1]) == -1) 
        //send_err();

    if (fgets(line, N, stdin) == NULL)      //GET /hello.c HTTP/1.1
        //send_err();
    if (sscanf(line, "%[^ ] %[^ ] %[^ ]", method, path, protocol) != 3)
        //send_err();
    while (fgets(line, N, stdin) != NULL)
        if (strcmp(line, "\r\n"))
            break;
    if (strcmp(method, "GET") != 0)
        //send_err();

    if (path[0] != '/')
        //send_err();
    
    file = path+1;

    if (stat(file, &sbuf) < 0)
        //send_err();
    
    fp = fopen(file, "r");
    if (fp == NULL) 
        //send_err();

    //send_headers();

    while ((ich = getc(fp)) != EOF)
        putchar(ich);
    fflush(stdout);
    fclose(fp);

    return 0;
}

