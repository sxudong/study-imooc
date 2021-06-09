// ConsoleApplication1.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"



#include "stdafx.h"
#include "windows.h"
#include "winbase.h"
#include <process.h>
#include "iostream"

using namespace std;
class Singelton
{
private:
	Singelton()
	{
		count++;
		cout << "Singelton���캯��begin\n" << endl;
		Sleep(1000);
		cout << "Singelton���캯��end\n" << endl;

	}
private:
	//��ֹ��������͸�ֵ����
	Singelton(const Singelton &obj) { ; }
	Singelton& operator=(const Singelton &obj)	{ ; }
public:
	static Singelton *getSingelton()
	{
		//1"����"ģʽ��Ȼ���ŵ㣬����ÿ�ε���GetInstance()��̬����ʱ�������ж�
		//	NULL == m_instance��ʹ������Կ�������
		//2���߳��лᵼ�¶��ʵ���Ĳ������Ӷ��������д��벻��ȷ�Լ��ڴ��й¶��
		//3�ṩ�ͷ���Դ�ĺ���
		return single;
	}

	static Singelton *releaseSingelton()
	{
		if (single != NULL) //��Ҫ�ж�
		{
			cout << "�ͷ���Դ\n" << endl;
			delete single;
			single = NULL;
		}
		return single;
	}
	void pirntS() //���Ժ���
	{
		printf("Singelton printS test count:%d \n", count);
	}

private:
	static Singelton *single;
	static int count;
};

//note ��̬���������ʼ��
Singelton *Singelton::single = new Singelton();
int Singelton::count = 0;

int _tmainTTT(int argc, _TCHAR* argv[])
{
	Singelton *s1 = Singelton::getSingelton();
	Singelton *s2 = Singelton::getSingelton();
	if (s1 == s2)
	{
		cout << "ok....equal" << endl;
	}
	else
	{
		cout << "not.equal" << endl;
	}
	s1->pirntS();
	Singelton::releaseSingelton();
	cout << "hello...." << endl;
	system("pause");
	return 0;
}

unsigned int threadfunc2(void *myIpAdd)
{
	int id = GetCurrentThreadId();
	printf("\n threadfunc%d \n", id);
	return 1;
}

void threadfunc(void *myIpAdd)
{
	int id = GetCurrentThreadId();
	printf("\n threadfunc%d \n", id);
	Singelton::getSingelton()->pirntS();
	return;
}

int _tmain(int argc, _TCHAR* argv[])
{
	int i = 0;
	DWORD dwThreadId[201], dwThrdParam = 1;
	HANDLE hThread[201];
	int threadnum = 3;

	for (i = 0; i<threadnum; i++)
	{
		//hThread[i] = (HANDLE)_beginthreadex( NULL, 0, &threadfunc, NULL, 0,&dwThreadId[i] );
		hThread[i] = (HANDLE)_beginthread(&threadfunc, 0, 0);
		if (hThread[i] == NULL)
		{
			printf("begin thread %d error!!!\n", i);
			break;
		}
	}
	//�ȴ����е����̶߳�������Ϻ�,��ִ�� �������
	for (i = 0; i<threadnum; i++)
	{
		WaitForSingleObject(hThread[i], INFINITE);
	}
	printf("�ȴ��߳̽���\n");
	for (i = 0; i<threadnum; i++)
	{
		//CloseHandle( hThread[i] );
	}
	Singelton::releaseSingelton();
	cout << "hello...." << endl;
	system("pause");
	return 0;
}

