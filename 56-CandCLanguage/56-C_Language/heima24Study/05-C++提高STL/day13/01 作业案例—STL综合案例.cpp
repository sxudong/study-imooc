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
* 1) 产生选手 （ ABCDEFGHIJKLMNOPQRSTUVWX ） 姓名、得分；选手编号*
* 2) 第1轮    选手抽签 选手比赛 查看比赛结果
* 3) 第2轮    选手抽签 选手比赛 查看比赛结果
* 4) 第3轮    选手抽签 选手比赛 查看比赛结果
*/

/*
* 演讲者类
*/
class Speaker
{
public:
	string m_Name;   //姓名
	int m_Score[3];  //得分数组
};

/*
* 创建选手
* @param v  选手编号
* @param m  对应的具体的选手
*/
void createSpeaker(vector<int> & v, map<int, Speaker> & m)
{
	string nameSeed = "ABCDEFGHIJKLMNOPQRSTUVWX";
	for (int i = 0; i < nameSeed.size(); i++) {
		string name = "选手";
		name += nameSeed[i];   //选手A

		Speaker sp;
		sp.m_Name = name;      //选手名字
		for (int j = 0; j < 3; j++)
			sp.m_Score[j] = 0; //选手初始分数为0

		v.push_back(i + 100);  //编号  100 ~ 123
		m.insert(make_pair(i + 100, sp));
	}
}

//抽签
void speechDraw(vector<int> v)
{
	//洗牌
	random_shuffle(v.begin(), v.end());
}


/*
* 比赛
*
* @param index  第几轮
* @param  v1    比赛选手编号
* @param  m     是选手编号和具体选手
* @param  v2    晋级选手编号容器（进入下一轮比赛的人员编号）
*/
void speechContest(int index, vector<int> & v1, map<int, Speaker> & m, vector<int> & v2)
{
	// key  分数  value  编号
	multimap<int, int, greater<int>> groupMap; //greater从大到小排序

	int num = 0;
	for (vector<int>::iterator it = v1.begin(); it != v1.end(); it++) {
		num++;
		deque<int> d;
		for (int i = 0; i < 10; i++) {
			int score = rand() % 41 + 60; // 60 ~100
			d.push_back(score);
		}

		//排序
		sort(d.begin(), d.end());

		//去除最高最低分
		d.pop_back();
		d.pop_front();

		//累积分数
		int sum = accumulate(d.begin(), d.end(), 0);
		int avg = sum / d.size();

		//cout << "比赛选手编号：" << *it << endl;

		//将平均分 放入到m容器中
		m[*it].m_Score[index - 1] = avg; // map[key] = value， map[id] = Speaker, Speaker.m_Score[i] = avg

		//每6个人  取前三名 晋级
		//临时容器 保存6个人
		//临时容器 存入数据
		groupMap.insert(make_pair(avg, *it)); //first是key“平均分数”，second是value“编号”

		if (num % 6 == 0) { //够6个人进来一次

			//cout << "小组比赛成绩如下：" << endl;
			//for (multimap<int, int, greater<int>>::iterator mit = groupMap.begin(); mit != groupMap.end();mit++)
			//	//cout << "编号： " << (*mit).second << " 姓名：" << m[(*mit).second].m_Name << "得分：" << m[(*mit).second].m_Score[index - 1] << endl;
			//	cout << "编号： " << mit->second << " 姓名：" << m[mit->second].m_Name << "得分：" << m[mit->second].m_Score[index - 1] << endl;


			//遍历临时容器 取“前三名”
			int count = 0;
			for (multimap<int, int, greater<int>>::iterator mit = groupMap.begin(); mit != groupMap.end(), count < 3; mit++, count++)
				//晋级容器 获取获取数据
				v2.push_back(mit->second); //mit->second 编号 (first是迭代器指向“键值”，second是迭代器指向对应的“值”)

			groupMap.clear(); //清空临时容器
		}
	}
}


/*
* 显示比赛结果
*
* @param index  第几轮
* @param  v     晋级选手编号容器
* @param  m     是选手编号和具体选手
*/
void showScore(int index, vector<int> & v, map<int, Speaker> & m)
{
	cout << "第" << index << "轮 比赛成绩如下：" << endl;

	for (map<int, Speaker>::iterator it = m.begin(); it != m.end(); it++)
		cout << "选手编号： " << it->first << " 姓名： " << it->second.m_Name << " 分数： " << it->second.m_Score[index - 1] << endl;

	cout << "晋级选手编号" << endl;
	for (vector<int>::iterator it = v.begin(); it != v.end(); it++)
		cout << *it << endl;
}

int main() {

	//随机数种子
	srand((unsigned int)time(NULL));

	vector<int> v1; //选手编号

	map<int, Speaker> m; //存放选手编号 和对应的具体的选手

	//创建选手
	createSpeaker(v1, m);

	//抽签
	speechDraw(v1);

	//进入下一轮比赛的人员编号
	vector<int> v2;

	//比赛
	speechContest(1, v1, m, v2);

	//显示比赛结果
	showScore(1, v2, m); // 轮数  晋级编号  具体人员信息


	//第二轮比赛
	speechDraw(v2);
	vector<int>v3;
	speechContest(2, v2, m, v3);
	showScore(2, v3, m);

	//第三轮
	speechDraw(v3);
	vector<int>v4;
	speechContest(3, v3, m, v4);
	showScore(3, v4, m);

	//测试
	cout << "------------" << endl;
	for (map<int, Speaker>::iterator it = m.begin(); it != m.end();it++)
		cout << "编号：" << it->first << " 姓名：" << it->second.m_Name << endl;

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
第1轮 比赛成绩如下：
选手编号： 100 姓名： 选手A 分数： 83
选手编号： 101 姓名： 选手B 分数： 75
选手编号： 102 姓名： 选手C 分数： 79
选手编号： 103 姓名： 选手D 分数： 80
选手编号： 104 姓名： 选手E 分数： 79
选手编号： 105 姓名： 选手F 分数： 74
选手编号： 106 姓名： 选手G 分数： 84
选手编号： 107 姓名： 选手H 分数： 76
选手编号： 108 姓名： 选手I 分数： 85
选手编号： 109 姓名： 选手J 分数： 69
选手编号： 110 姓名： 选手K 分数： 78
选手编号： 111 姓名： 选手L 分数： 79
选手编号： 112 姓名： 选手M 分数： 83
选手编号： 113 姓名： 选手N 分数： 82
选手编号： 114 姓名： 选手O 分数： 82
选手编号： 115 姓名： 选手P 分数： 78
选手编号： 116 姓名： 选手Q 分数： 78
选手编号： 117 姓名： 选手R 分数： 86
选手编号： 118 姓名： 选手S 分数： 86
选手编号： 119 姓名： 选手T 分数： 80
选手编号： 120 姓名： 选手U 分数： 77
选手编号： 121 姓名： 选手V 分数： 82
选手编号： 122 姓名： 选手W 分数： 84
选手编号： 123 姓名： 选手X 分数： 79
晋级选手编号
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
第2轮 比赛成绩如下：
选手编号： 100 姓名： 选手A 分数： 80
选手编号： 101 姓名： 选手B 分数： 0
选手编号： 102 姓名： 选手C 分数： 82
选手编号： 103 姓名： 选手D 分数： 83
选手编号： 104 姓名： 选手E 分数： 0
选手编号： 105 姓名： 选手F 分数： 0
选手编号： 106 姓名： 选手G 分数： 78
选手编号： 107 姓名： 选手H 分数： 0
选手编号： 108 姓名： 选手I 分数： 72
选手编号： 109 姓名： 选手J 分数： 0
选手编号： 110 姓名： 选手K 分数： 0
选手编号： 111 姓名： 选手L 分数： 79
选手编号： 112 姓名： 选手M 分数： 81
选手编号： 113 姓名： 选手N 分数： 84
选手编号： 114 姓名： 选手O 分数： 0
选手编号： 115 姓名： 选手P 分数： 0
选手编号： 116 姓名： 选手Q 分数： 0
选手编号： 117 姓名： 选手R 分数： 84
选手编号： 118 姓名： 选手S 分数： 75
选手编号： 119 姓名： 选手T 分数： 0
选手编号： 120 姓名： 选手U 分数： 0
选手编号： 121 姓名： 选手V 分数： 85
选手编号： 122 姓名： 选手W 分数： 83
选手编号： 123 姓名： 选手X 分数： 0
晋级选手编号
103
102
100
121
117
113
第3轮 比赛成绩如下：
选手编号： 100 姓名： 选手A 分数： 83
选手编号： 101 姓名： 选手B 分数： 0
选手编号： 102 姓名： 选手C 分数： 82
选手编号： 103 姓名： 选手D 分数： 78
选手编号： 104 姓名： 选手E 分数： 0
选手编号： 105 姓名： 选手F 分数： 0
选手编号： 106 姓名： 选手G 分数： 0
选手编号： 107 姓名： 选手H 分数： 0
选手编号： 108 姓名： 选手I 分数： 0
选手编号： 109 姓名： 选手J 分数： 0
选手编号： 110 姓名： 选手K 分数： 0
选手编号： 111 姓名： 选手L 分数： 0
选手编号： 112 姓名： 选手M 分数： 0
选手编号： 113 姓名： 选手N 分数： 81
选手编号： 114 姓名： 选手O 分数： 0
选手编号： 115 姓名： 选手P 分数： 0
选手编号： 116 姓名： 选手Q 分数： 0
选手编号： 117 姓名： 选手R 分数： 78
选手编号： 118 姓名： 选手S 分数： 0
选手编号： 119 姓名： 选手T 分数： 0
选手编号： 120 姓名： 选手U 分数： 0
选手编号： 121 姓名： 选手V 分数： 84
选手编号： 122 姓名： 选手W 分数： 0
选手编号： 123 姓名： 选手X 分数： 0
晋级选手编号
121
100
102
------------
编号：100 姓名：选手A
编号：101 姓名：选手B
编号：102 姓名：选手C
编号：103 姓名：选手D
编号：104 姓名：选手E
编号：105 姓名：选手F
编号：106 姓名：选手G
编号：107 姓名：选手H
编号：108 姓名：选手I
编号：109 姓名：选手J
编号：110 姓名：选手K
编号：111 姓名：选手L
编号：112 姓名：选手M
编号：113 姓名：选手N
编号：114 姓名：选手O
编号：115 姓名：选手P
编号：116 姓名：选手Q
编号：117 姓名：选手R
编号：118 姓名：选手S
编号：119 姓名：选手T
编号：120 姓名：选手U
编号：121 姓名：选手V
编号：122 姓名：选手W
编号：123 姓名：选手X
请按任意键继续. . .
*/