src = $(wildcard ./*.c)
obj = $(patsubst %.c,%.o,$(src))
target = app
app:$(obj)
	gcc $^ -o $@ #这里是依赖于所有的依赖
#	gcc $(obj) -o $(target)

%.o:%.c #在这里就只有一个依赖每次
	gcc -c $< -o $@

#add.o:add.c
#	gcc add.c -c

#sub.o:sub.c
#	gcc sub.c -c

#mul.o:mul.c
#	gcc mul.c -c


hello:
	echo "how are you?"

.PHONY:clean
clean:
	-mkdir /abc
	-rm $(obj) $(target) -f  # add "-" to force do this command ignore the former error
