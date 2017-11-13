//��д�ͻ���  
#include <stdio.h>
#include "mysql.h"
#include <stdlib.h>
#include <string.h>

#define _HOST_ "localhost"  //����
#define _USER_ "root"       //mysql�û�,������
#define _PASSWD_ "yxpsaber"   //����
#define _DBNAME_ "scott"    //����

#define _MAX_COLS_  30 

//�����ʽ������ṹ��
typedef struct _strFormat{
	int length;  // ÿ���ֶ�(��)������ʾ�ĳ���
	char sfm[10]; // ÿ���е�չʾ���ĸ�ʽ��Ч��
	char Column[100]; // ����ʾЧ�� | empno 
	char splitLine[100]; // �����ķָ�����ʾЧ��  +-------
}strFormat;

/*
+-------+--------+-----------+------+------------+------+------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal  | comm | deptno |
+-------+--------+-----------+------+------------+------+------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800 | NULL |     20 |
*/

//��ʾ�����
void show_result(MYSQL_RES *result,MYSQL * mysql)
{
	//չʾresult�Ľ��
	if(result != NULL)
	{
		//�����������м�¼
		if(result->row_count == 0)
		{
			printf("Empty set\n");
			return;	
		}
		//��ӡ��ͷ
		unsigned int num_fields;
		strFormat fm[_MAX_COLS_];
		bzero(&fm,sizeof(strFormat)*_MAX_COLS_);
		unsigned int i,j ;
		MYSQL_FIELD *fields;
		//printf("-------------------------------------------------------------------------\n");
		num_fields = mysql_num_fields(result);
		fields = mysql_fetch_fields(result);//ȡ�ر�ͷ,����������
		//����ѭ��Ϊ����֮ǰ����ṹ���Ӧ�ĸ����еı�׼��ʽ��
		for(i = 0; i < num_fields; i++)
		{
			fm[i].length = fields[i].name_length > fields[i].max_length ? fields[i].name_length:fields[i].max_length;//ÿ���ֶ��ж������,ȡ���ֳ��Ⱥ������ ����֮������ֵ
			fm[i].splitLine[0]='+';
		   	for(j = 1 ; j < fm[i].length+3; j ++)
		   	{
		   		fm[i].splitLine[j]='-';
		   	}
			if(i == num_fields -1)//���һ���ֶ���Ҫ�ر���һ��,��Ҫ��"|" ��Ϊ����
			{
				sprintf(fm[i].sfm,"| %c-%ds |",'%',fm[i].length); // %-17c 
				fm[i].splitLine[j]='+';
			}
			else 
			{
				sprintf(fm[i].sfm,"| %c-%ds ",'%',fm[i].length);//�õ���Ŀ�� �� "| %-8s "
			}
			sprintf(fm[i].Column,fm[i].sfm,fields[i].name);
		}
		for(j = 0 ; j < 3; j ++ )//�˴�Ϊ��ӡ��ͷ,ע��,��ͷ����,�����ķָ����м�������
		{
			if(j == 1)//��������
			{
				for(i = 0; i < num_fields; i++)
				{
					printf("%s",fm[i].Column);
				}
			}
			else//�������ָ���
			{
				for(i = 0; i < num_fields; i++)
				{
					printf("%s",fm[i].splitLine);
					
				}
			}
			printf("\n");
	    }
		
		//printf("-------------------------------------------------------------------------\n");
		MYSQL_ROW row;
		num_fields = mysql_num_fields(result);
		while ((row = mysql_fetch_row(result)))//ѭ��չʾÿһ�еĵ�����
		{
		   for(i = 0; i < num_fields; i++)//���ÿһ��,չʾÿһ��,ʹ��֮ǰ�õ��������ʽ����
		   {
		   	
		   		printf(fm[i].sfm, row[i] ? row[i] : "NULL");
		   }
		   printf("\n");
		}
		for(i = 0; i < num_fields; i++)
		{
			printf("%s",fm[i].splitLine);
		}
		printf("\n%ld rows in set \n",(long) mysql_affected_rows(mysql));

	}
}
int main()
{
	//1.��ʼ��
	MYSQL * mysql = NULL;
	mysql = mysql_init(NULL) ;
	if(mysql == NULL )
	{
		printf("mysql init err\n");
		exit(1);
	}
	//2.����
	mysql = mysql_real_connect(mysql, _HOST_,_USER_, _PASSWD_,_DBNAME_, 0, NULL,0);
	if(mysql == NULL)
	{
		printf("mysql_real_connect connect err\n");
		exit(1);
	}
	mysql_set_character_set(mysql, "utf8");//�����ַ���
	printf("welcome to mysql \n");
	char rSql[512];
	while(1)//����̨
	{
		printf("yekaisql>");
		memset(rSql,0x00,sizeof(rSql));
		fgets(rSql,sizeof(rSql),stdin);
		//�ж��Ƿ��˳� quit
		if(strncmp(rSql,"quit",4) == 0 || strncmp(rSql,"QUIT",4) == 0)
		{
			printf("bye bye\n");
			break;
		}
		//��ѯ
		if(mysql_query(mysql,rSql) != 0)
		{
			printf("query err\n");
			//mysql_close(mysql);
			//exit(1);
			continue;
		}
		//��ӡ���
		//��ȡ�ؽ�� 
		MYSQL_RES *result = NULL ;
		result = mysql_store_result(mysql); 
		
		if(result){
			//��ӡ�����
			show_result(result,mysql);
			//�ͷŽ����
			mysql_free_result(result); 
		}
		else
		{
			printf("Query OK, %ld  rows affected \n",(long) mysql_affected_rows(mysql));
		}
				
	}
	//3.�ر�
    mysql_close(mysql);
    return 0;
}
