#include <iostream>
using namespace std;
#include <string>
#include <vector>
#include <mutex>
// ������Ԫ��
class NetDevice
{
public:
	NetDevice(){}
	virtual string getName() = 0;

	void print(){
		printf("NetDevice :%s\n", getName().c_str());
	}
};
// ������Ԫ��:������
class Hub :public NetDevice
{
public:
	Hub(){}
	string getName(){
		return "������";
	}
};

// ������Ԫ��:������
class Switch :public NetDevice
{
public:
	Switch(){}
	string getName(){
		return "������";
	}
};
// ��Ԫ������
class NetDeviceFactory
{
public:
	NetDevice* getNetDevice(char ch){
		if (ch == 'S'){
			return devicePool[1];
		}
		else if (ch == 'H'){
			return devicePool[0];
		}
		else{
			printf("wrong input!\n");
		}
		return NULL;
	}

	// ����ģʽ��������Ԫ�������Ψһʵ��
	static NetDeviceFactory* getFactory(){
		if (instance == NULL){
			m_mutex.lock();
			if (instance == NULL){
				instance = new NetDeviceFactory();
			}
			m_mutex.unlock();
		}
		return instance;
	}

private:
	NetDeviceFactory(){
		Hub *hub = new Hub();
		Switch *switcher = new Switch();
		devicePool.push_back(hub);
		devicePool.push_back(switcher);
	}
	static NetDeviceFactory* instance;
	static std::mutex m_mutex;

	// ����أ���һ��vector����ʾ
	vector<NetDevice*> devicePool;
};

NetDeviceFactory* NetDeviceFactory::instance = NULL;
std::mutex NetDeviceFactory::m_mutex;



int main()
{
	NetDeviceFactory *factory = NetDeviceFactory::getFactory();

	NetDevice *device1, *device2, *device3, *device4;

	// �ͻ���1��ȡһ��hub
	device1 = factory->getNetDevice('H');
	device1->print();
	// �ͻ���2��ȡһ��hub
	device2 = factory->getNetDevice('H');
	device2->print();
	// �ж�����hub�Ƿ���ͬһ��
	printf("�ж�����hub�Ƿ���ͬһ��:\n");
	printf("device1:%p\ndevice2:%p\n", device1, device2);

	printf("\n\n\n\n");
	// �ͻ���3��ȡһ��switch
	device3 = factory->getNetDevice('S');
	device3->print();
	// �ͻ���4��ȡһ��switch
	device4 = factory->getNetDevice('S');
	device4->print();
	// �ж�����switch�Ƿ���ͬһ��
	printf("�ж�����switch�Ƿ���ͬһ��:\n");
	printf("device3:%p\ndevice4:%p\n", device3, device4);

	printf("\n\n");

	system("pause");
	return 0;
}
