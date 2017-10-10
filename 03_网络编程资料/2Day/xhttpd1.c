#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>

#define N 4096

#define log(info, str) \
	do{\
		fprintf(tmp, "%s%s", info, str);\
		fflush(tmp);\
	}while(0)

void send_headers(char *type, off_t length)
{
	printf("%s %d %s\r\n", "HTTP/1.1", 200, "0k");
	printf("Content-Type:%s\r\n", type);
	printf("Content-Length:%lld\r\n", (int64_t)length);
	printf("Connection: close\r\n");
	printf("\r\n");

	//HTTP/1.1 200 OK
	//Content-Type:text/plain; charset=utf-8
	//Content-Length:32
	//Connection: close
	//\r\n
}

//html中换行使用\n, http中换行使用\r\n

void send_error(int status, char *title, char *text)
{
	send_headers("text/html", -1);      //http header协议头

	printf("<html><head><title>%d %s</title></head>\n", status, title);
	printf("<body bgcolor=\"#cc99cc\"><h4>%d %s</h4>\n", status, title);
	printf("%s\n", text);
	printf("<hr>\n</body>\n</html>\n");

	fflush(stdout);
	/*<html><head><title>错误号 错误名</title></head>
	 *<body bgcolor="#cc99cc"><h4>错误号 错误名</h4>
	 *错误原因描述
	 *<hr>
	 *</body>
	 *</html>
	 */
	exit(1);
}

int main(int argc, char *argv[])
{
	char line[N];
	char method[N], path[N], protocol[N];//protocol实际上后来没有用到
	char *file;

	struct stat sb;			//s_buf;
	FILE *fp;
	int ich;
	char *type;

	if(argc != 2)
		send_error(500, "Internal Error", "Config error - no dir specified.");

	if(chdir(argv[1]) < 0)
		send_error(500, "Internal Error", "Config error - couldn't chdir().");

	if(fgets(line, sizeof(line), stdin) == NULL)	//GET /1.txt HTTP/1.1
		send_error(400, "Bad Request", "No request found.");

	if(sscanf(line, "%[^ ] %[^ ] %[^ ]", method, path, protocol) != 3)
		send_error(400, "Bad Request", "Can't parse request.");

	while(fgets(line, sizeof(line), stdin) != NULL)
		if(strcmp(line, "\n") == 0 || strcmp(line, "\r\n") == 0)
			break;

	if(strcasecmp("GET", method) != 0)
		send_error(501, "Not Implemented", "That method is not implemented.");

	if(path[0] != '/')
		send_error(400, "Bad Request", "Bad filename.");

	file = path+1;  // '/'之后是文件名

#if 1
	FILE *tmp = fopen("/home/yxp/xhttpd/root/log.txt", "a"); 
	if(tmp == NULL){
		perror("fopen tmp.txt error");
		exit(1);
	}
	log("path+1:", path+1);
	fclose(tmp);
#endif

	if(stat(file, &sb) < 0)
		send_error(404, "Not Found", "File not found.");

	fp = fopen(file, "r");
	if(fp == NULL){
		send_error(403, "Forbidden", "File is protected.");
	}

	char *dot = strrchr(file, '.');

	if(dot == NULL){                                // xhttpd   ASCII text
		type = "text/plain; charset=utf-8";
	} else if(strcmp(dot, ".html") == 0){
		type = "text/html; charset=utf-8";
	} else if(strcmp(dot, ".jpg") == 0){
		type = "image/jpeg";
	} else if(strcmp(dot, ".gif") == 0){
		type = "image/gif";
	} else if(strcmp(dot, ".png") == 0){
		type = "image/png";
	} else if(strcmp(dot, ".mp3") == 0){
		type = "audio/mpeg";
	}  else {
		type = "text/plain; charset=iso-8859-1";
	}

	send_headers(type, sb.st_size);

	while((ich = getc(fp)) != EOF)
		putchar(ich);

	fflush(stdout);

	fclose(fp);

	return 0;
}
