#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <deque>
#include <algorithm>

// deque �� double-ended queue ����д����˫�˵����项,�� vector �ǵ��˵�! 
// �� vector ��ͬ���ǣ�deque ���ó�������ͷ����ӻ�ɾ��Ԫ�أ����ķѵ�ʱ�临�Ӷ�ҲΪ������O(1)��
// ���Ҹ���Ҫ��һ���ǣ�deque �����д洢Ԫ�ز����ܱ�֤����Ԫ�ض��洢���������ڴ�ռ��С�

/*
* deque���캯��
* 
* deque<T> deqT;           //Ĭ�Ϲ�����ʽ
* deque(beg, end);         //���캯����[beg, end)�����е�Ԫ�ؿ���������
* deque(n, elem);          //���캯����n��elem����������
* deque(const deque &deq); //�������캯����
*/

/*
* 3.3.3.2 deque��ֵ����
* 
* assign(beg, end);                   //��[beg, end)�����е����ݿ�����ֵ������
* assign(n, elem);                    //��n��elem������ֵ������
* deque& operator=(const deque &deq); //���صȺŲ�����
* swap(deq);                          //��deq�뱾���Ԫ�ػ���
*/

/*
* 3.3.3.3 deque��С����
* 
* deque.size();            //����������Ԫ�صĸ���
* deque.empty();           //�ж������Ƿ�Ϊ��
* deque.resize(num);       //����ָ�������ĳ���Ϊnum,�������䳤������Ĭ��ֵ�����λ�á����������̣���ĩβ�����������ȵ�Ԫ�ر�ɾ����
* deque.resize(num, elem); //����ָ�������ĳ���Ϊnum,�������䳤������elemֵ�����λ��,���������̣���ĩβ�����������ȵ�Ԫ�ر�ɾ����
*/

void printDeque(const deque<int> & d)
{
	//iterator ��ͨ������  reverse_iterator ���������  const_iterator ֻ��������
	for (deque<int>::const_iterator it = d.begin(); it != d.end();it++){
		//*it = 100000;
		cout << *it << " ";
	}
	cout << endl;
}

void test01()
{
	//��ʼ��һ����deque����
	deque<int> d;
	//β������Ԫ��
	d.push_back(10);
	d.push_back(40);
	d.push_back(30);
	d.push_back(20);

	printDeque(d); //10 40 30 20

	deque<int>d2(d.begin(), d.end());
	d2.push_back(10000);

	//����
	d.swap(d2);
	printDeque(d); //10 40 30 20 10000


	// d2  10 40 30 20
	if (d2.empty()){
		cout << "Ϊ��" << endl;
	}
	else{
		cout << "��Ϊ�� ��СΪ��" <<d2.size() << endl; //4
	}
}


/*
* deque˫�˲����ɾ������
* 
* push_back(elem);//������β�����һ������
* push_front(elem);//������ͷ������һ������
* pop_back();//ɾ���������һ������
* pop_front();//ɾ��������һ������
*/

/*
* 3.3.3.5 deque���ݴ�ȡ
* 
* at(idx);    //��������idx��ָ�����ݣ����idxԽ�磬�׳�out_of_range��
* operator[]; //��������idx��ָ�����ݣ����idxԽ�磬���׳��쳣��ֱ�ӳ���
* front();    //���ص�һ�����ݡ�
* back();     //�������һ������
*/

/*
* 3.3.3.6 deque�������
* 
* insert(pos,elem);    //��posλ�ò���һ��elemԪ�صĿ��������������ݵ�λ�á�
* insert(pos,n,elem);  //��posλ�ò���n��elem���ݣ��޷���ֵ��
* insert(pos,beg,end); //��posλ�ò���[beg,end)��������ݣ��޷���ֵ��
*/

/*
* 3.3.3.7 dequeɾ������
* 
* clear();        //�Ƴ���������������
* erase(beg,end); //ɾ��[beg,end)��������ݣ�������һ�����ݵ�λ�á�
* erase(pos);     //ɾ��posλ�õ����ݣ�������һ�����ݵ�λ�á�
*/

void test02()
{
	//��ʼ��һ����deque����
	deque<int> d;
	//β������Ԫ��
	d.push_back(10);
	d.push_back(30);
	d.push_back(20);
	//ͷ������Ԫ��
	d.push_front(100);
	d.push_front(200);

	printDeque(d); // 200 100 10 30 20

	//ɾ�� ͷɾ βɾ
	d.pop_back();
	d.pop_front();
	printDeque(d); // 100 10 30

	cout << "front: " << d.front() << endl; //100
	cout << "back: " << d.back() << endl;   //30

	
	/*
	* ����
	*/
	//��ʼ��һ����deque����
	deque<int> d2;
	d2.push_back(50);
	d2.push_back(60);
	//�� d2 ��ʼλ�ò��� d ����Ԫ��
	d2.insert(d2.begin(), d.begin(), d.end());
	printDeque(d2);  //  100 10 30 50 60
}


/*
* �������
*/
bool myCompare(int v1, int v2){
	return v1 > v2; // 100 10
}

/*
* ���� sort()
*/
void test03()
{
	//��ʼ��һ����deque����
	deque<int> d;
	//β������Ԫ��
	d.push_back(5);
	d.push_back(15);
	d.push_back(3);
	d.push_back(40);
	d.push_back(7);

	printDeque(d); //5 15 3 40 7
	//����
	sort(d.begin(), d.end());

	printDeque(d); //3 5 7 15 40

	//�Ӵ�С
	sort(d.begin(), d.end(), myCompare);
	printDeque(d); //40 15 7 5 3

}

int main(){

	//test01();

	//test02();

	test03();

	system("pause");
	return EXIT_SUCCESS;
}