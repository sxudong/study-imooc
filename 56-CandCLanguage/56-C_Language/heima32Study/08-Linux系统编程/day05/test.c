#include <stdio.h>
#include <unistd.h>

//execl.c调用
//./test hello world
int main(int argc, char *argv[])
{
	int i = 0;
	for(i=0; i<argc; i++){
		printf("[%d]:[%s]\n", i, argv[i]);
	}

	sleep(100);
	return 0;
}
