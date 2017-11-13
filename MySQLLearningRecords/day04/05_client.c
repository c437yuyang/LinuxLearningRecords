//select2 ��ѯ���� ����
#include "mysql.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define _HOST_  "127.0.0.1"   //����
#define _USER_  "root"   //�û� mysql���û�
#define _PASSWD_ "yxpsaber"   //���� mysql
#define _DB_     "scott"  //��

//��ʾ������ĺ���
void showresult(MYSQL_RES *result,MYSQL *mysql)
{
	unsigned int num_fields;
	unsigned int i;
	MYSQL_FIELD *fields;
	 
	num_fields = mysql_num_fields(result);//����ֶ���
	fields = mysql_fetch_fields(result);//��ȡ�ֶ�����
	for(i = 0; i < num_fields; i++)
	{
	   printf("%s\t", fields[i].name);//��ӡ�ֶ�,Ҳ���Ǳ�ͷ
	}
	printf("\n");
    
    printf("----------------------------------------------------------------\n");
    
    MYSQL_ROW row;
    if(result != NULL)//�����н����
    {
    	//	MYSQL_ROW mysql_fetch_row(MYSQL_RES *result) 
		while( (row=mysql_fetch_row(result) )) {
			for(i = 0; i < num_fields ; i ++)//num_fields ���� 
			{
				printf("%s\t",row[i]);
			}
			printf("\n");//���洦����һ��,�˴�����
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
    
    mysql_set_character_set(mysql,"utf8"); //�����ַ���


    //�ڴ˴����ҵ�����
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
		//ִ��sql
	    if(mysql_query(mysql,rSql) ){
			printf("mysql query err\n");
			//mysql_close(mysql);
			//exit(1);
		}
		//�����ѯ�����
    	MYSQL_RES *result = mysql_store_result(mysql);
    	if(result != NULL){
    		showresult(result,mysql);//��ӡ�����
    		mysql_free_result(result);
    	}
	}
    
    //3. mysql_close
    mysql_close(mysql);
    return 0;
}
