#include <stdio.h>
#include "mysql.h"
#include <stdlib.h>
#define _HOST_ "127.0.0.1"
#define _USER_ "root"
#define _PSWD_ "yxpsaber"
#define _DB_ "scott"
int main()
{
    //1.mysql_init
    MYSQL *mysql = NULL;
    mysql = mysql_init(NULL);
    if(mysql == NULL){
        printf("mysql init failed!\n");
        exit(1);
    }
    //2.mysql_real_connect
    mysql = mysql_real_connect(mysql,_HOST_,_USER_,_PSWD_,_DB_,0,NULL,0);
    if(mysql == NULL){
        printf("mysql connect failed!\n");
        exit(1);
    }

    //执行查询
    if(mysql_query(mysql,"select * from emp;")){
        printf("query failed!\n");
        mysql_close(mysql);
        exit(1);
    }
    //显示结果
    MYSQL_RES *result =  mysql_store_result(mysql);
    MYSQL_ROW row;
    if(result!=NULL){
        while((row=mysql_fetch_row(result))){
            for(int i=0;i<8;++i){
                printf("%s\t",row[i]);
            }
            printf("\n"); //输出一行后换
        }
        mysql_free_result(result);
    }

    //3.mysql_close
    printf("insert ok!\n");
    mysql_close(mysql);

    return 0;
}
