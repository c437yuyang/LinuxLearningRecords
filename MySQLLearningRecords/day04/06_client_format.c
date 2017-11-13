//编写客户端  
#include <stdio.h>
#include "mysql.h"
#include <stdlib.h>
#include <string.h>

#define _HOST_ "localhost"  //主机
#define _USER_ "root"       //mysql用户,非主机
#define _PASSWD_ "yxpsaber"   //密码
#define _DBNAME_ "scott"    //库名

#define _MAX_COLS_  30 

//定义格式化输出结构体
typedef struct _strFormat{
	int length;  // 每个字段(列)最终显示的长度
	char sfm[10]; // 每个列的展示串的格式化效果
	char Column[100]; // 列显示效果 | empno 
	char splitLine[100]; // 华丽的分割线显示效果  +-------
}strFormat;

/*
+-------+--------+-----------+------+------------+------+------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal  | comm | deptno |
+-------+--------+-----------+------+------------+------+------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800 | NULL |     20 |
*/

//显示结果集
void show_result(MYSQL_RES *result,MYSQL * mysql)
{
	//展示result的结果
	if(result != NULL)
	{
		//代表结果集中有记录
		if(result->row_count == 0)
		{
			printf("Empty set\n");
			return;	
		}
		//打印表头
		unsigned int num_fields;
		strFormat fm[_MAX_COLS_];
		bzero(&fm,sizeof(strFormat)*_MAX_COLS_);
		unsigned int i,j ;
		MYSQL_FIELD *fields;
		//printf("-------------------------------------------------------------------------\n");
		num_fields = mysql_num_fields(result);
		fields = mysql_fetch_fields(result);//取回表头,即各个列名
		//以下循环为生成之前定义结构体对应的各个列的标准格式化
		for(i = 0; i < num_fields; i++)
		{
			fm[i].length = fields[i].name_length > fields[i].max_length ? fields[i].name_length:fields[i].max_length;//每个字段有多个长度,取名字长度和内容最长 两者之间的最大值
			fm[i].splitLine[0]='+';
		   	for(j = 1 ; j < fm[i].length+3; j ++)
		   	{
		   		fm[i].splitLine[j]='-';
		   	}
			if(i == num_fields -1)//最后一个字段需要特别处理一下,需要用"|" 作为结束
			{
				sprintf(fm[i].sfm,"| %c-%ds |",'%',fm[i].length); // %-17c 
				fm[i].splitLine[j]='+';
			}
			else 
			{
				sprintf(fm[i].sfm,"| %c-%ds ",'%',fm[i].length);//得到的目标 是 "| %-8s "
			}
			sprintf(fm[i].Column,fm[i].sfm,fields[i].name);
		}
		for(j = 0 ; j < 3; j ++ )//此处为打印表头,注意,表头三行,华丽的分割线中间是列名
		{
			if(j == 1)//处理列名
			{
				for(i = 0; i < num_fields; i++)
				{
					printf("%s",fm[i].Column);
				}
			}
			else//处理华丽分割线
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
		while ((row = mysql_fetch_row(result)))//循环展示每一行的的内容
		{
		   for(i = 0; i < num_fields; i++)//针对每一行,展示每一列,使用之前得到的输出格式化串
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
	//1.初始化
	MYSQL * mysql = NULL;
	mysql = mysql_init(NULL) ;
	if(mysql == NULL )
	{
		printf("mysql init err\n");
		exit(1);
	}
	//2.连接
	mysql = mysql_real_connect(mysql, _HOST_,_USER_, _PASSWD_,_DBNAME_, 0, NULL,0);
	if(mysql == NULL)
	{
		printf("mysql_real_connect connect err\n");
		exit(1);
	}
	mysql_set_character_set(mysql, "utf8");//设置字符集
	printf("welcome to mysql \n");
	char rSql[512];
	while(1)//管理台
	{
		printf("yekaisql>");
		memset(rSql,0x00,sizeof(rSql));
		fgets(rSql,sizeof(rSql),stdin);
		//判断是否退出 quit
		if(strncmp(rSql,"quit",4) == 0 || strncmp(rSql,"QUIT",4) == 0)
		{
			printf("bye bye\n");
			break;
		}
		//查询
		if(mysql_query(mysql,rSql) != 0)
		{
			printf("query err\n");
			//mysql_close(mysql);
			//exit(1);
			continue;
		}
		//打印结果
		//先取回结果 
		MYSQL_RES *result = NULL ;
		result = mysql_store_result(mysql); 
		
		if(result){
			//打印结果集
			show_result(result,mysql);
			//释放结果集
			mysql_free_result(result); 
		}
		else
		{
			printf("Query OK, %ld  rows affected \n",(long) mysql_affected_rows(mysql));
		}
				
	}
	//3.关闭
    mysql_close(mysql);
    return 0;
}
