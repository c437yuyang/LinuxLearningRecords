target = app
CPPFLAGS=./include
path=./src 
src=$(wildcard ./src/*.c)
obj=$(patsubst %.c,%.o,$(src))
$(target):$(obj)
	gcc $^ -o $@ #这里是依赖于所有的依赖

%.o:%.c #在这里就只有一个依赖每次
	echo $<
	gcc -c $< -I $(CPPFLAGS) -o $@

.PHONY:clean
clean:
	-mkdir /abc
	-rm $(obj) $(target) -f  # add "-" to force do this command ignore the former error
