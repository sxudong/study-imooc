#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
1 �����尸��
*/


/*
����
  �����������(Cube)��
  �������������( 2*a*b + 2*a*c + 2*b*c )�����( a * b * c)��
  �ֱ���ȫ�ֺ����ͳ�Ա�����ж������������Ƿ����
*/

class Cube
{
private:
	int m_L; //��
	int m_W; //��
	int m_H; //��

public:
	//���ó�
	void setL(int l){
		m_L = l;
	}

	//��ȡ��
	int getL() const{ //����ˡ�const�����������޸�m_L
		return m_L;
	}

	//���ÿ�
	void setW(int w){
		m_W = w;
	}

	//��ȡ��
	int getW(){
		return m_W;
	}

	//���ø�
	void setH(int h){
		m_H = h;
	}

	//��ȡ��
	int getH(){
		return m_H;
	}

	//������������
	void getCubeS(){
		int s = 2 * m_L*m_W + 2 * m_W*m_H + 2 * m_L*m_H;
		cout << "����������Ϊ�� " << s << endl;;
	}

	//�����������
	void getCubeV(){
		int v = m_L * m_W * m_H;
		cout << "����������Ϊ�� " << v << endl;
	}

	//ͨ����Ա�����ж��Ƿ����
	bool compareCubeByClass( Cube & cub){
		bool ret = m_L == cub.getL() && m_W == cub.getW() && m_H == cub.getH();
		return ret;
	}

};

//Ϊʲô��const���ող�����ӣ� û����֤��Ա�������Ƿ��޸��˳�Ա����
void func(const Cube & cub ) //���getL������û������const��cub.getL()�������ͻᱨ��
{
	cub.getL();
}


//ȫ�ֺ����ж� �����������Ƿ����
bool compareCube( Cube &cub1,  Cube & cub2)
{
	if (cub1.getL() == cub2.getL()  && cub1.getW() == cub2.getW() && cub1.getH() == cub2.getH())
		return true;

	return false;
}

void test01()
{
	Cube c1;
	c1.setL(10);
	c1.setW(10);
	c1.setH(10);

	c1.getCubeS(); // 600
	c1.getCubeV(); // 1000

	//ͨ��ȫ�ֺ����ж������������Ƿ����

	Cube c2;
	c2.setL(10);
	c2.setW(10);
	c2.setH(10);

	bool ret = compareCube(c1, c2);
	if ( ret)
		cout << "c1 �� c2 ����ȵģ�" << endl; //c1 �� c2 ����ȵģ�
	else
		cout << "c1 �� c2�ǲ��ȵģ�" << endl;

	//ͨ������Ա�������ж��������Ƿ����
	bool ret2 = c1.compareCubeByClass(c2);
	if (ret2)
		cout << "ͨ����Ա����c1 �� c2 ����ȵģ�" << endl; //ͨ����Ա����c1 �� c2 ����ȵģ�
	else
		cout << "ͨ����Ա����c1 �� c2�ǲ��ȵģ�" << endl;

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
����������Ϊ�� 600
����������Ϊ�� 1000
c1 �� c2 ����ȵģ�
ͨ����Ա����c1 �� c2 ����ȵģ�
�밴���������. . .
*/