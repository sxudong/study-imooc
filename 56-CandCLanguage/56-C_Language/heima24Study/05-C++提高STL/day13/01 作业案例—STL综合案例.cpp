#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <vector>
#include <map>
#include <string>
#include <algorithm>
#include <deque>
#include <numeric>
#include <functional>
#include <ctime>

/*
* 1) ����ѡ�� �� ABCDEFGHIJKLMNOPQRSTUVWX �� �������÷֣�ѡ�ֱ��*
* 2) ��1��    ѡ�ֳ�ǩ ѡ�ֱ��� �鿴�������
* 3) ��2��    ѡ�ֳ�ǩ ѡ�ֱ��� �鿴�������
* 4) ��3��    ѡ�ֳ�ǩ ѡ�ֱ��� �鿴�������
*/

/*
* �ݽ�����
*/
class Speaker
{
public:
	string m_Name;   //����
	int m_Score[3];  //�÷�����
};

/*
* ����ѡ��
* @param v  ѡ�ֱ��
* @param m  ��Ӧ�ľ����ѡ��
*/
void createSpeaker(vector<int> & v, map<int, Speaker> & m)
{
	string nameSeed = "ABCDEFGHIJKLMNOPQRSTUVWX";
	for (int i = 0; i < nameSeed.size(); i++) {
		string name = "ѡ��";
		name += nameSeed[i];   //ѡ��A

		Speaker sp;
		sp.m_Name = name;      //ѡ������
		for (int j = 0; j < 3; j++)
			sp.m_Score[j] = 0; //ѡ�ֳ�ʼ����Ϊ0

		v.push_back(i + 100);  //���  100 ~ 123
		m.insert(make_pair(i + 100, sp));
	}
}

//��ǩ
void speechDraw(vector<int> v)
{
	//ϴ��
	random_shuffle(v.begin(), v.end());
}


/*
* ����
*
* @param index  �ڼ���
* @param  v1    ����ѡ�ֱ��
* @param  m     ��ѡ�ֱ�ź;���ѡ��
* @param  v2    ����ѡ�ֱ��������������һ�ֱ�������Ա��ţ�
*/
void speechContest(int index, vector<int> & v1, map<int, Speaker> & m, vector<int> & v2)
{
	// key  ����  value  ���
	multimap<int, int, greater<int>> groupMap; //greater�Ӵ�С����

	int num = 0;
	for (vector<int>::iterator it = v1.begin(); it != v1.end(); it++) {
		num++;
		deque<int> d;
		for (int i = 0; i < 10; i++) {
			int score = rand() % 41 + 60; // 60 ~100
			d.push_back(score);
		}

		//����
		sort(d.begin(), d.end());

		//ȥ�������ͷ�
		d.pop_back();
		d.pop_front();

		//�ۻ�����
		int sum = accumulate(d.begin(), d.end(), 0);
		int avg = sum / d.size();

		//cout << "����ѡ�ֱ�ţ�" << *it << endl;

		//��ƽ���� ���뵽m������
		m[*it].m_Score[index - 1] = avg; // map[key] = value�� map[id] = Speaker, Speaker.m_Score[i] = avg

		//ÿ6����  ȡǰ���� ����
		//��ʱ���� ����6����
		//��ʱ���� ��������
		groupMap.insert(make_pair(avg, *it)); //first��key��ƽ����������second��value����š�

		if (num % 6 == 0) { //��6���˽���һ��

			//cout << "С������ɼ����£�" << endl;
			//for (multimap<int, int, greater<int>>::iterator mit = groupMap.begin(); mit != groupMap.end();mit++)
			//	//cout << "��ţ� " << (*mit).second << " ������" << m[(*mit).second].m_Name << "�÷֣�" << m[(*mit).second].m_Score[index - 1] << endl;
			//	cout << "��ţ� " << mit->second << " ������" << m[mit->second].m_Name << "�÷֣�" << m[mit->second].m_Score[index - 1] << endl;


			//������ʱ���� ȡ��ǰ������
			int count = 0;
			for (multimap<int, int, greater<int>>::iterator mit = groupMap.begin(); mit != groupMap.end(), count < 3; mit++, count++)
				//�������� ��ȡ��ȡ����
				v2.push_back(mit->second); //mit->second ��� (first�ǵ�����ָ�򡰼�ֵ����second�ǵ�����ָ���Ӧ�ġ�ֵ��)

			groupMap.clear(); //�����ʱ����
		}
	}
}


/*
* ��ʾ�������
*
* @param index  �ڼ���
* @param  v     ����ѡ�ֱ������
* @param  m     ��ѡ�ֱ�ź;���ѡ��
*/
void showScore(int index, vector<int> & v, map<int, Speaker> & m)
{
	cout << "��" << index << "�� �����ɼ����£�" << endl;

	for (map<int, Speaker>::iterator it = m.begin(); it != m.end(); it++)
		cout << "ѡ�ֱ�ţ� " << it->first << " ������ " << it->second.m_Name << " ������ " << it->second.m_Score[index - 1] << endl;

	cout << "����ѡ�ֱ��" << endl;
	for (vector<int>::iterator it = v.begin(); it != v.end(); it++)
		cout << *it << endl;
}

int main() {

	//���������
	srand((unsigned int)time(NULL));

	vector<int> v1; //ѡ�ֱ��

	map<int, Speaker> m; //���ѡ�ֱ�� �Ͷ�Ӧ�ľ����ѡ��

	//����ѡ��
	createSpeaker(v1, m);

	//��ǩ
	speechDraw(v1);

	//������һ�ֱ�������Ա���
	vector<int> v2;

	//����
	speechContest(1, v1, m, v2);

	//��ʾ�������
	showScore(1, v2, m); // ����  �������  ������Ա��Ϣ


	//�ڶ��ֱ���
	speechDraw(v2);
	vector<int>v3;
	speechContest(2, v2, m, v3);
	showScore(2, v3, m);

	//������
	speechDraw(v3);
	vector<int>v4;
	speechContest(3, v3, m, v4);
	showScore(3, v4, m);

	//����
	cout << "------------" << endl;
	for (map<int, Speaker>::iterator it = m.begin(); it != m.end();it++)
		cout << "��ţ�" << it->first << " ������" << it->second.m_Name << endl;

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��1�� �����ɼ����£�
ѡ�ֱ�ţ� 100 ������ ѡ��A ������ 83
ѡ�ֱ�ţ� 101 ������ ѡ��B ������ 75
ѡ�ֱ�ţ� 102 ������ ѡ��C ������ 79
ѡ�ֱ�ţ� 103 ������ ѡ��D ������ 80
ѡ�ֱ�ţ� 104 ������ ѡ��E ������ 79
ѡ�ֱ�ţ� 105 ������ ѡ��F ������ 74
ѡ�ֱ�ţ� 106 ������ ѡ��G ������ 84
ѡ�ֱ�ţ� 107 ������ ѡ��H ������ 76
ѡ�ֱ�ţ� 108 ������ ѡ��I ������ 85
ѡ�ֱ�ţ� 109 ������ ѡ��J ������ 69
ѡ�ֱ�ţ� 110 ������ ѡ��K ������ 78
ѡ�ֱ�ţ� 111 ������ ѡ��L ������ 79
ѡ�ֱ�ţ� 112 ������ ѡ��M ������ 83
ѡ�ֱ�ţ� 113 ������ ѡ��N ������ 82
ѡ�ֱ�ţ� 114 ������ ѡ��O ������ 82
ѡ�ֱ�ţ� 115 ������ ѡ��P ������ 78
ѡ�ֱ�ţ� 116 ������ ѡ��Q ������ 78
ѡ�ֱ�ţ� 117 ������ ѡ��R ������ 86
ѡ�ֱ�ţ� 118 ������ ѡ��S ������ 86
ѡ�ֱ�ţ� 119 ������ ѡ��T ������ 80
ѡ�ֱ�ţ� 120 ������ ѡ��U ������ 77
ѡ�ֱ�ţ� 121 ������ ѡ��V ������ 82
ѡ�ֱ�ţ� 122 ������ ѡ��W ������ 84
ѡ�ֱ�ţ� 123 ������ ѡ��X ������ 79
����ѡ�ֱ��
100
103
102
108
106
111
117
112
113
118
122
121
��2�� �����ɼ����£�
ѡ�ֱ�ţ� 100 ������ ѡ��A ������ 80
ѡ�ֱ�ţ� 101 ������ ѡ��B ������ 0
ѡ�ֱ�ţ� 102 ������ ѡ��C ������ 82
ѡ�ֱ�ţ� 103 ������ ѡ��D ������ 83
ѡ�ֱ�ţ� 104 ������ ѡ��E ������ 0
ѡ�ֱ�ţ� 105 ������ ѡ��F ������ 0
ѡ�ֱ�ţ� 106 ������ ѡ��G ������ 78
ѡ�ֱ�ţ� 107 ������ ѡ��H ������ 0
ѡ�ֱ�ţ� 108 ������ ѡ��I ������ 72
ѡ�ֱ�ţ� 109 ������ ѡ��J ������ 0
ѡ�ֱ�ţ� 110 ������ ѡ��K ������ 0
ѡ�ֱ�ţ� 111 ������ ѡ��L ������ 79
ѡ�ֱ�ţ� 112 ������ ѡ��M ������ 81
ѡ�ֱ�ţ� 113 ������ ѡ��N ������ 84
ѡ�ֱ�ţ� 114 ������ ѡ��O ������ 0
ѡ�ֱ�ţ� 115 ������ ѡ��P ������ 0
ѡ�ֱ�ţ� 116 ������ ѡ��Q ������ 0
ѡ�ֱ�ţ� 117 ������ ѡ��R ������ 84
ѡ�ֱ�ţ� 118 ������ ѡ��S ������ 75
ѡ�ֱ�ţ� 119 ������ ѡ��T ������ 0
ѡ�ֱ�ţ� 120 ������ ѡ��U ������ 0
ѡ�ֱ�ţ� 121 ������ ѡ��V ������ 85
ѡ�ֱ�ţ� 122 ������ ѡ��W ������ 83
ѡ�ֱ�ţ� 123 ������ ѡ��X ������ 0
����ѡ�ֱ��
103
102
100
121
117
113
��3�� �����ɼ����£�
ѡ�ֱ�ţ� 100 ������ ѡ��A ������ 83
ѡ�ֱ�ţ� 101 ������ ѡ��B ������ 0
ѡ�ֱ�ţ� 102 ������ ѡ��C ������ 82
ѡ�ֱ�ţ� 103 ������ ѡ��D ������ 78
ѡ�ֱ�ţ� 104 ������ ѡ��E ������ 0
ѡ�ֱ�ţ� 105 ������ ѡ��F ������ 0
ѡ�ֱ�ţ� 106 ������ ѡ��G ������ 0
ѡ�ֱ�ţ� 107 ������ ѡ��H ������ 0
ѡ�ֱ�ţ� 108 ������ ѡ��I ������ 0
ѡ�ֱ�ţ� 109 ������ ѡ��J ������ 0
ѡ�ֱ�ţ� 110 ������ ѡ��K ������ 0
ѡ�ֱ�ţ� 111 ������ ѡ��L ������ 0
ѡ�ֱ�ţ� 112 ������ ѡ��M ������ 0
ѡ�ֱ�ţ� 113 ������ ѡ��N ������ 81
ѡ�ֱ�ţ� 114 ������ ѡ��O ������ 0
ѡ�ֱ�ţ� 115 ������ ѡ��P ������ 0
ѡ�ֱ�ţ� 116 ������ ѡ��Q ������ 0
ѡ�ֱ�ţ� 117 ������ ѡ��R ������ 78
ѡ�ֱ�ţ� 118 ������ ѡ��S ������ 0
ѡ�ֱ�ţ� 119 ������ ѡ��T ������ 0
ѡ�ֱ�ţ� 120 ������ ѡ��U ������ 0
ѡ�ֱ�ţ� 121 ������ ѡ��V ������ 84
ѡ�ֱ�ţ� 122 ������ ѡ��W ������ 0
ѡ�ֱ�ţ� 123 ������ ѡ��X ������ 0
����ѡ�ֱ��
121
100
102
------------
��ţ�100 ������ѡ��A
��ţ�101 ������ѡ��B
��ţ�102 ������ѡ��C
��ţ�103 ������ѡ��D
��ţ�104 ������ѡ��E
��ţ�105 ������ѡ��F
��ţ�106 ������ѡ��G
��ţ�107 ������ѡ��H
��ţ�108 ������ѡ��I
��ţ�109 ������ѡ��J
��ţ�110 ������ѡ��K
��ţ�111 ������ѡ��L
��ţ�112 ������ѡ��M
��ţ�113 ������ѡ��N
��ţ�114 ������ѡ��O
��ţ�115 ������ѡ��P
��ţ�116 ������ѡ��Q
��ţ�117 ������ѡ��R
��ţ�118 ������ѡ��S
��ţ�119 ������ѡ��T
��ţ�120 ������ѡ��U
��ţ�121 ������ѡ��V
��ţ�122 ������ѡ��W
��ţ�123 ������ѡ��X
�밴���������. . .
*/