#include<iostream>
using namespace std;

// HardDisk��	// ������
class HardDisk{	// ������
	public:
		virtual void work()=0;
protected:
private:
};

// Memory�� // ������
class Memory{
	public:
		virtual void work()=0;
protected:
private:
};

// CPU�� // ������
class CPU{
	public:
		virtual void work()=0;
protected:
private:
};


// ��Computer��Ʒ�ͳ��̽��н����
class Computer{
public:
	Computer(HardDisk *hardDisk,
			 Memory *memory,
			 CPU *cpu){
		m_HardDisk = hardDisk;
		m_Memory = memory;
		m_CPU = cpu;
	}

	// ��������
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

// IntelCPUʵ��CPU
class IntelCPU:public CPU{	
	public:
		void work(){
			cout<<" I am IntelCPU , I am working"<<endl;
		}
protected:
private:
};

// WestDataʵ��HardDisk
class WestData:public HardDisk{	
	public:
		void work(){
			cout<<" I am WestData , I am working"<<endl;
		}
protected:
private:
};

// Kingstonʵ��Memory
class KingSton:public Memory{	
	public:
		void work(){
			cout<<" I am KingSton , I am working"<<endl;
		}
protected:
private:
};

int main(){
	// �����������
	HardDisk *hardDisk = new WestData();
	Memory *memory = new KingSton();
	CPU *cpu = new IntelCPU();

	// ��װ����
	Computer *myComputer = new Computer(hardDisk,memory,cpu);

	// ����
	myComputer -> work();

	// �ͷſռ䣬һ��д������������
	// �󴴽������ͷţ�
	delete myComputer;
	delete cpu;
	delete memory;
	delete hardDisk;
}