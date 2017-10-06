#include <stdio.h>
#include "hello.h"
int main()
{
	int a = 1;
	int b = 2;
	
	#ifdef DEBUG
	printf("hello:%d",NUM1+NUM2);
	#endif 	
	return 0;
}
