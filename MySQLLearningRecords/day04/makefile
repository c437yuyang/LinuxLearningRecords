src=$(wildcard *.c)
target=$(patsubst %.c,%.out,$(src))
GCC=gcc -std=gnu99
include=/usr/include/mysql
lib=/usr/lib64/mysql
pubLib=-lmysqlclient -lstdc++ -ldl -lpthread -lrt
all:$(target)

%.out:%.c
	$(GCC) $? -o $@ -I$(include) -L$(lib) $(pubLib)

clean:
	rm -f $(target)

test:
	echo $(target)
#gcc 01_hello.c -o 01_hello.out -I/usr/include/mysql -L/usr/lib64/mysql/ -lmysqlclient
