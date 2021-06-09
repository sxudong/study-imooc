#include <iostream>
using namespace std;
#include <string>
#include <vector>
#include <mutex>
// 抽象享元类
class NetDevice
{
public:
	NetDevice(){}
	virtual string getName() = 0;

	void print(){
		printf("NetDevice :%s\n", getName().c_str());
	}
};
// 具体享元类:集线器
class Hub :public NetDevice
{
public:
	Hub(){}
	string getName(){
		return "集线器";
	}
};

// 具体享元类:交换机
class Switch :public NetDevice
{
public:
	Switch(){}
	string getName(){
		return "交换机";
	}
};
// 享元工厂类
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

	// 单例模式：返回享元工厂类的唯一实例
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

	// 共享池：用一个vector来表示
	vector<NetDevice*> devicePool;
};

NetDeviceFactory* NetDeviceFactory::instance = NULL;
std::mutex NetDeviceFactory::m_mutex;



int main()
{
	NetDeviceFactory *factory = NetDeviceFactory::getFactory();

	NetDevice *device1, *device2, *device3, *device4;

	// 客户端1获取一个hub
	device1 = factory->getNetDevice('H');
	device1->print();
	// 客户端2获取一个hub
	device2 = factory->getNetDevice('H');
	device2->print();
	// 判断两个hub是否是同一个
	printf("判断两个hub是否是同一个:\n");
	printf("device1:%p\ndevice2:%p\n", device1, device2);

	printf("\n\n\n\n");
	// 客户端3获取一个switch
	device3 = factory->getNetDevice('S');
	device3->print();
	// 客户端4获取一个switch
	device4 = factory->getNetDevice('S');
	device4->print();
	// 判断两个switch是否是同一个
	printf("判断两个switch是否是同一个:\n");
	printf("device3:%p\ndevice4:%p\n", device3, device4);

	printf("\n\n");

	system("pause");
	return 0;
}
