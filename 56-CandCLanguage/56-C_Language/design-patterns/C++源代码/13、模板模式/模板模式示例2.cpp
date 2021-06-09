#include <iostream>
using namespace std;
#include <cstdio>
#include <Windows.h>
// ����
class FingerprintModule
{
public:
	FingerprintModule(){}
	void getImage(){
		printf("��ָ��ͼ��\n");
	}
	void output(){
		printf("ָ��ͼ�������!\n");
	}
	virtual bool isSafeMode() = 0;
	virtual void processImage() = 0;
	// �ӽ���
	virtual void encrypt() = 0;
	virtual void decrypt() = 0;

	// ģ�巽��
	void algorithm(){
		// 1.��ͼ
		getImage();
		// 2.��ȫģʽ�¼��ܺͽ���
		if (isSafeMode()){
			// 2.1. ����
			encrypt();
			// 2.2. ����
			decrypt();
		}
		// 3.����Image
		processImage();
		// 4.������
		output();
	}
};
// ������
class FingerprintModuleA :public FingerprintModule
{
public:
	FingerprintModuleA(){}
	void processImage(){
		printf("ʹ�� ��һ���汾�㷨 ����ָ��ͼ��\n");
	}
	bool isSafeMode(){
		printf("��ȫģʽ\n");
		return true;
	}
	void encrypt(){
		printf("ʹ��RSA��Կ����\n");
	}
	void decrypt(){
		printf("ʹ��RSA��Կ����\n");
	}
};

// ������
class FingerprintModuleB :public FingerprintModule
{
public:
	FingerprintModuleB(){}
	void processImage(){
		printf("ʹ�� �ڶ����汾�㷨 ����ָ��ͼ��\n");
	}
	bool isSafeMode(){
		printf("�ǰ�ȫģʽ\n");
		return false;
	}
	void encrypt(){}
	void decrypt(){}
};

// ������
class FingerprintModuleC :public FingerprintModule
{
public:
	FingerprintModuleC(){}
	void processImage(){
		printf("ʹ�� ��һ���汾�㷨 ����ָ��ͼ��\n");
	}
	bool isSafeMode(){
		printf("��ȫģʽ\n");
		return true;
	}
	void encrypt(){
		printf("ʹ��DH��Կ����\n");
	}
	void decrypt(){
		printf("ʹ��DH��Կ����\n");
	}
};


int main()
{
	FingerprintModule *fp = new FingerprintModuleA();
	fp->algorithm();

	fp = new FingerprintModuleB();
	fp->algorithm();

	fp = new FingerprintModuleC();
	fp->algorithm();


	printf("\n\n");
	system("pause");
	return 0;
}
