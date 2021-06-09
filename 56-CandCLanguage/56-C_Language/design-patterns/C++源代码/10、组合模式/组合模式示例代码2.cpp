#include <iostream>
using namespace std;
#include <string>
#include <vector>
//���󹹼�
class Component
{
public:
	Component(){}
	Component(string iName){
		this->name = iName;
	}
	//����һ�����Ż�칫��
	virtual void add(Component*) = 0;
	//����һ�����Ż�칫��
	virtual void remove(Component*) = 0;
	//
	virtual Component* getChild(int) = 0;
	//�����Ų���
	virtual void operation() = 0;
	string getName(){
		return name;
	}
private:
	string name;
};
//Ҷ�ӹ������칫��
class Office :public Component
{
public:
	Office(string iName){
		this->name = iName;
	}
	Office(){}
	void add(Component* c){
		printf("not support!\n");
	}
	void remove(Component* c){
		printf("not support!\n");
	}
	Component* getChild(int i){
		printf("not support!\n");
		return NULL;
	}
private:
	string name;
};

//Ҷ�ӹ����������칫��
class AdminOffice :public Office
{
public:
	AdminOffice(string iName){
		this->name = iName;
	}
	void operation(){
		printf("-----Administration Office:%s\n", name.c_str());
	}
private:
	string name;
};

//Ҷ�ӹ���������칫��
class DeanOffice :public Office
{
public:
	DeanOffice(string iName){
		this->name = iName;
	}
	void operation(){
		printf("-----Dean Office:%s\n", name.c_str());
	}
private:
	string name;
};
//��������SubComponent
class SubComponent :public Component
{
public:
	SubComponent(string iName){
		this->name = iName;
	}
	void add(Component *c){
		componentList.push_back(c);
	}
	void remove(Component *c){
		for (int i = 0; i < componentList.size(); i++){
			if (componentList[i]->getName() == c->getName()){
				componentList.erase(componentList.begin() + i);
				break;
			}
		}
	}
	Component* getChild(int i){
		return (Component*)componentList[i];
	}
	void operation(){
		printf("%s\n", this->name.c_str());
		for (int i = 0; i < componentList.size(); i++){
			((Component*)componentList[i])->operation();
		}
	}
private:
	string name;

	//�����б�
	vector<Component*>componentList;
};


int main()
{
	Component *head, *sichuanBranch, *cdBranch, *myBranch, *office1, *office2, *office3,
		*office4, *office5, *office6, *office7, *office8;

	head = new SubComponent("�ܲ�");
	sichuanBranch = new SubComponent("�Ĵ��ֲ�");
	office1 = new AdminOffice("�����칫��");
	office2 = new DeanOffice("����칫��");

	cdBranch = new SubComponent("�ɶ��ֲ�");
	myBranch = new SubComponent("�����ֲ�");
	office3 = new AdminOffice("�����칫��");
	office4 = new DeanOffice("����칫��");

	office5 = new AdminOffice("�����칫��");
	office6 = new DeanOffice("����칫��");

	office7 = new AdminOffice("�����칫��");
	office8 = new DeanOffice("����칫��");

	cdBranch->add(office5);
	cdBranch->add(office6);

	myBranch->add(office7);
	myBranch->add(office8);

	sichuanBranch->add(office3);
	sichuanBranch->add(office4);
	sichuanBranch->add(cdBranch);
	sichuanBranch->add(myBranch);

	head->add(office1);
	head->add(office2);
	head->add(sichuanBranch);

	head->operation();

	system("pause");
	return 0;
}
