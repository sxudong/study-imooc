静态库的制作过程:
1 将.c文件生成.o文件
	gcc -c add.c divd.c mul.c sub.c
2 使用ar命令将.o文件打包成静态库文件
	ar rcs libtest1.a add.o divd.o mul.o sub.o
静态库的使用:
	gcc -o main1 main.c -I./ -L./ -ltest1

aaron@aaron:~/桌面/第2天作业$ ./main1
a+b==[30]
a-b==[10]
a*b==[200]
a/b==[2]
