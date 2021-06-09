#include<iostream>
using namespace std;

// HardDisk类	// 抽象类
class HardDisk{	// 抽象类
	public:
		virtual void work()=0;
protected:
private:
};

// Memory类 // 抽象类
class Memory{
	public:
		virtual void work()=0;
protected:
private:
};

// CPU类 // 抽象类
class CPU{
	public:
		virtual void work()=0;
protected:
private:
};


// 让Computer产品和厂商进行解耦合
class Computer{
public:
	Computer(HardDisk *hardDisk,
			 Memory *memory,
			 CPU *cpu){
		m_HardDisk = hardDisk;
		m_Memory = memory;
		m_CPU = cpu;
	}

	// 工作方法
	void work(){
		m_HardDisk->work();
		m_Memory->work();
		m_CPU->work();
	}
protected:
private:
	// HardDisk
	HardDisk *m_HardDisk;
	// Memory
	Memory *m_Memory;
	// CPU
	CPU *m_CPU;
};

// IntelCPU实现CPU
class IntelCPU:public CPU{	
	public:
		void work(){
			cout<<" I am IntelCPU , I am working"<<endl;
		}
protected:
private:
};

// WestData实现HardDisk
class WestData:public HardDisk{	
	public:
		void work(){
			cout<<" I am WestData , I am working"<<endl;
		}
protected:
private:
};

// Kingston实现Memory
class KingSton:public Memory{	
	public:
		void work(){
			cout<<" I am KingSton , I am working"<<endl;
		}
protected:
private:
};

int main(){
	// 定义声明配件
	HardDisk *hardDisk = new WestData();
	Memory *memory = new KingSton();
	CPU *cpu = new IntelCPU();

	// 组装电脑
	Computer *myComputer = new Computer(hardDisk,memory,cpu);

	// 工作
	myComputer -> work();

	// 释放空间，一般写在析构函数中
	// 后创建，先释放；
	delete myComputer;
	delete cpu;
	delete memory;
	delete hardDisk;
}