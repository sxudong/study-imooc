src=$(wildcard *.c)
objs=$(patsubst %.c,%.o,$(src))
target=main

$(target):$(objs)
    #动态库在 mylib/ 下面
	gcc -o $@ $^ -L../mylib -ltest1
	#test2找不到，修改环境变量，添加动态库路径
	#gcc -o $@ $^ -L../mylib -ltest2

%.o:%.c
    #头文件在 include/ 下面
	gcc -c $< -I../include  

.PHONY:clean
clean:
	-rm -f $(target) $(objs)
