��̬�����������:
1 ��.c�ļ�����.o�ļ�
	gcc -c add.c divd.c mul.c sub.c
2 ʹ��ar���.o�ļ�����ɾ�̬���ļ�
	ar rcs libtest1.a add.o divd.o mul.o sub.o
��̬���ʹ��:
	gcc -o main1 main.c -I./ -L./ -ltest1

aaron@aaron:~/����/��2����ҵ$ ./main1
a+b==[30]
a-b==[10]
a*b==[200]
a/b==[2]
