#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
��׼���������� ���� cin

9 ��׼��������
	9.1	cin.get()              �������ж�ȡһ���ַ�
	9.2	cin.get(��������)      �������з�
	9.3	cin.getline()          ��ȡ���� �����ӵ�
	9.4	cin.ignore ���ԣ�N��   N��������ַ���
	9.5	cin.peek()             ͵�� ͵��1���ַ�Ȼ��Ż�ȥ
	9.6	cin.putback()          �Ż� ���ַ��Żػ�����

10	����������
	10.1 �ж��û���������ַ����������� ����͵�� ���� �Ż�
	10.2 ���û�����ָ����Χ�ڵ����֣��������ȷ ��������
		10.2.1	cin.fail() ����־λ  0���� 1������
		10.2.2	cin.clear()���ñ�־λ
		10.2.3	cin.syne() ��ջ�����
*/

/*
cin.get()         //һ��ֻ�ܶ�ȡһ���ַ�
cin.get(һ������) //��һ���ַ�
cin.get(��������) //���Զ��ַ���
cin.getline()
cin.ignore()
cin.peek()
cin.putback()
*/


/*
*  cin.get()  һ��ֻ�ܶ�ȡһ���ַ�
*/
void test01()
{
	// ����as   �������У� a  s  ���У���һ���� a�� �ڶ��� �� s�� �������û��У����Ĵεȴ��´����롣
	char c = cin.get(); //�ȴ�����
	cout << "c = " << c << endl;

	c = cin.get(); //�ӻ������õ�2���ַ�
	cout << "c = " << c << endl;

	c = cin.get(); //�ӻ������õ�3���ַ�
	cout << "c = " << c << endl;

	c = cin.get();
	cout << "c = " << c << endl;
}
/* Output:
as
c = a
c = s
c =

bcd
c = b
�밴���������. . .
*/


/*
* cin.get(��������) ���Զ��ַ���
* ��ȡ�ַ���ʱ������ѻ��з����ߣ������ڻ�������
*/
void test02()
{
	char buf[1024];
	cin.get(buf, 1024); //cin.get(��������) //���Զ��ַ���

	char c = cin.get();

	if (c == '\n'){
		cout << "���л��ڻ�����" << endl;
	}else{
		cout << "���в��ڻ�����" << endl;
	}

	cout << buf << endl;
}
/* ����hello world:
hello world
���л��ڻ�����
hello world
�밴���������. . .
*/


/*
* cin.getline() �ѻ��з���ȡ�������ӵ�
*/
void test03()
{
	char buf[1024];
	cin.getline(buf, 1024);

	char c = cin.get();
	if (c == '\n'){
		cout << "���л��ڻ�����" << endl;
	}else{
		cout << "���в��ڻ�����" << endl;
	}
}
/* ����hello world:
hello world
                //ͣ������һ�У��ȴ��´�����
*/

/*
* cin.ignore() ����
*/
void test04()
{
	//û�в��� �������һ���ַ� �������� N��������� N ���ַ�
	cin.ignore(2);
	char c =  cin.get();

	cout << "c = " << c << endl;
}
/* ����world:
world
c = r             //������wo��2���ַ�
�밴���������. . .
*/



/*
* cin.peek() peek������˼��͵����
*/
void test05()
{
	//����as  ͵��һ�� a��Ȼ���ٷŻػ��������������л���as
	char c = cin.peek();

	cout << "c = " << c << endl;

	c = cin.get();

	cout << "c = " << c << endl;
}
/* Output:
as
c = a
c = a
�밴���������. . .
*/


/*
* cin.putback() �Ż�
*/
void test06()
{
	//����abc
	char c = cin.get();
	cin.putback(c);

	char buf[1024];

	cin.getline(buf,1024); //��ȡ�� buf ����
	cout << buf << endl;
}
/* ����hello world:
hello world
hello world
�밴���������. . .
*/


/*
* ����1���ж��û������ַ��� �������֣�
*/
void test07()
{
	cout << "������һ�����ֻ����ַ���" << endl;

	//͵��
	char c = cin.peek();

	if (c >= '0' && c <= '9'){
		int num;
		cin >> num; //�ѻ��������������뵽 num

		cout << "������������ ������Ϊ" << num << endl;
	}else{
		char buf[1024];
		cin >> buf;

		cout << "���������ַ��� ���ַ���Ϊ" << buf << endl;
	}
}
/* Output:
������һ�����ֻ����ַ���
a
���������ַ��� ���ַ���Ϊa
�밴���������. . .
*/



/*
* ����2�����û����� 1 �� 10 �����֣������������ ��������
* VS�����볬��10�����ֲ���û���⣬�������ַ����������������QT�²���û���⡣
*/
void test08()
{
	int num;

	cout << "������һ��1��10�����֣�" << endl;

	while (true){
		cin >> num; //�ѻ��������������뵽 num
		if (num > 0 && num <= 10){
			cout << "���������Ϊ" << num << endl;
			break;
		}
		//cout << "�Բ�������������" << endl;

		/*
		* ��������һ������־λ��������Ҫһ��int���͵�ʱ��
		* ����ȷ����һ��charʱ���������־λ���ͱ����ˣ�
		* ���˾Ϳ����������Ľ���������ı�־��һֱ���ڣ�
		* ���޵Ĵӻ������õ��Ķ����Ǹ������ֵ������һֱִ��
		* ���Բ������������롱���д��롣
		*/

		cin.clear(); //���ñ�־λ

		// 2015 �汾��vs �� ��ignore ���� cin.ignore(N);

		cin.sync(); //��ջ�����

		//���������еġ���־λ��
		//��־λ 0�������ģ�1�ǲ������ġ�
		//cout << "��־λ: " << cin.fail() << endl;
	}

}
/* ֱ������������0-10����:
������һ��1��10�����֣�
1000
ad
10
���������Ϊ10
�밴���������. . .
*/



int main(){

	//test01();

	//test02();

	//test03();

	//test04();

	//test05();

	//test06();

	//test07();

	test08();

	system("pause");
	return EXIT_SUCCESS;
}