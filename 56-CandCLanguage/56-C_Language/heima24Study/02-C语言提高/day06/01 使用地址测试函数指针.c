#include<stdlib.h>

/*
 * ֻ��ʹ��QT����������
 */

void func()
{
    printf("hello world!");
    printf("\n");
}

/*
* "������"��ʵ���Ǻ�����"��ڵ�ַ"
*/
int main() {

    //�����м�¼�µ�ַ��Ȼ��ŵ��ڶ��������ϲ���
    printf("������ڵ�ַ��%d\n", func);

    int* funcAddr = (int *) 4199984;
    //int* funcAddr = (int *) func;  //Ҳ��
    //int* funcAddr = (int *) &func;

    void(*myfunc)() = funcAddr;
    myfunc(); //ͨ��������ַ��ִ�з���

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
������ڵ�ַ��4199984
hello world!
�밴���������. . .
*/