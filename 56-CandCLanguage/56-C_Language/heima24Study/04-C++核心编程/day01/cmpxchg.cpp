#include<iostream>
using namespace std;

/*
* cpu cmpxchg ָ����� (CAS)
* https://blog.csdn.net/xiuye2015/article/details/53406432
*
* ��ʽ��CMPXCHG Ŀ�Ĳ����� Դ������
* ���ã��Ƚϲ�����������
* �磺CMPXCHG r/m,r ��r�ǼĴ�����m���ڴ棩���ۼ���AL/AX/EAX/RAX�е�ֵ���ײ�������Ŀ�Ĳ��������Ƚ�
* �����ȣ���2��������Դ����������ֵװ�ص��ײ�������zf��1��
* ������ȣ� �ײ�������ֵװ�ص�AL/AX/EAX/RAX������zf��0��
*
*/
int main() {
	int a = 0, b = 0, c = 0;

	//��Ƕ������cmpxchgָ��(CAS)
	__asm {
		mov eax, 100;
		mov a, eax
	}
	cout << "a := " << a << endl; //11

	b = 99;
	c = 11;
	__asm {
		mov ebx, b

		//���ۼ���eax�е�ֵ��100�����ײ�����c��11���Ƚ�
		cmpxchg c, ebx  // 100��11�Ƚϣ�����ȣ��ײ�����c��ֵ��11��װ�ص�EAX
		mov a, eax      // ��EAX��ֵ��11������a
	}

	//���:( ������ȣ� "�ײ�����" c ��ֵװ�ص� EAX,����zf��0)
	cout << "b := " << b << endl; //99
	cout << "c := " << c << endl; //11
	cout << "a := " << a << endl; //11

	return 0;
}

int main2() {
	int a = 0, b = 0, c = 0;

    //��Ƕ������cmpxchgָ��(CAS)
	__asm {
		mov eax, 100;
		mov a, eax
	}
	cout << "a := " << a << endl; //100

	b = 99;
	c = 99;
	__asm {
		mov eax, 99
		mov ebx, 777

		//���ۼ���eax�е�ֵ��99�����ײ�����c��99���Ƚ�
		cmpxchg c, ebx  // 99��99�Ƚϣ���ȣ���2������ebx��mov ebx, 777����ֵװ�ص��ײ�������zf��1
		mov a, eax
	}

	//���:( �����ȣ���2������ ebx��777����ֵװ�ص��ײ����� c��zf��1)
	cout << "b := " << b << endl; //99
	cout << "c := " << c << endl; //777
	cout << "a := " << a << endl; //99

	return 0;
}