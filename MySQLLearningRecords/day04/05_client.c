//select2 查询功能 完善
#include "mysql.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define _HOST_  "127.0.0.1"   //主机
#define _USER_  "root"   //用户 mysql的用户
#define _PASSWD_ "yxpsaber"   //密码 mysql
#define _DB_     "scott"  //库

//显示结果集的函数
void showresult(MYSQL_RES *result,MYSQL *mysql)
{
	unsigned int num_fields;
	unsigned int i;
	MYSQL_FIELD *fields;
	 
	num_fields = mysql_num_fields(result);//获得字段数
	fields = mysql_fetch_fields(result);//获取字段数组
	for(i = 0; i < num_fields; i++)
	{
	   printf("%s\t", fields[i].name);//打印字段,也就是表头
	}
	printf("\n");
    
    printf("----------------------------------------------------------------\n");
    
    MYSQL_ROW row;
    if(result != NULL)//代表有结果集
    {
    	//	MYSQL_ROW mysql_fetch_row(MYSQL_RES *result) 
		while( (row=mysql_fetch_row(result) )) {
			for(i = 0; i < num_fields ; i ++)//num_fields 列数 
			{
				printf("%s\t",row[i]);
			}
			printf("\n");//上面处理是一行,此处换行
		}
		
    }
    printf("----------------------------------------------------------------\n");
    printf("%ld rows in set\n",(long) mysql_affected_rows(mysql));

}

int main()
{
    MYSQL *mysql = NULL;
    //1. mysql_init
    mysql = mysql_init(NULL);
    if(mysql == NULL){
        printf("mysql init err\n");
        exit(1);
    }
    //2. mysql_real_connect
    //MYSQL *mysql_real_connect(MYSQL *mysql, const char *host, const char *user, const char *passwd, const char *db, unsigned int port, const char *unix_socket, unsigned long client_flag) 
    mysql = mysql_real_connect(mysql,_HOST_,_USER_,_PASSWD_,_DB_,0,NULL,0);
    if(mysql == NULL ){
    	printf("mysql connect err!\n");
    	exit(1);
    }
    printf("welcome to mysql!\n");
    
    mysql_set_character_set(mysql,"utf8"); //设置字符集


    //在此处添加业务代码
    char rSql[512];
    
    
	while(1){
		printf("yekaiSQL>");
		memset(rSql,0x00,sizeof(rSql));
		fgets(rSql, sizeof(rSql), stdin);
		printf("rSql:%s\n",rSql);
		if(strncmp(rSql,"quit",4) == 0 || strncmp(rSql,"QUIT",4) == 0)
		{
			printf("bye bye\n");
			break;
		}
		//执行sql
	    if(mysql_query(mysql,rSql) ){
			printf("mysql query err\n");
			//mysql_close(mysql);
			//exit(1);
		}
		//处理查询结果集
    	MYSQL_RES *result = mysql_store_result(mysql);
    	if(result != NULL){
    		showresult(result,mysql);//打印结果集
    		mysql_free_result(result);
    	}
	}
    
    //3. mysql_close
    mysql_close(mysql);
    return 0;
}
