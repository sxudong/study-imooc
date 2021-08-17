#include<iostream>
using namespace std;

/*
* cpu cmpxchg 指令理解 (CAS)
* https://blog.csdn.net/xiuye2015/article/details/53406432
*
* 格式：CMPXCHG 目的操作数 源操作数
* 作用：比较并交换操作数
* 如：CMPXCHG r/m,r （r是寄存器，m是内存）将累加器AL/AX/EAX/RAX中的值与首操作数（目的操作数）比较
* 如果相等，第2操作数（源操作数）的值装载到首操作数，zf置1。
* 如果不等， 首操作数的值装载到AL/AX/EAX/RAX，并将zf清0。
*
*/
int main() {
	int a = 0, b = 0, c = 0;

	//内嵌汇编理解cmpxchg指令(CAS)
	__asm {
		mov eax, 100;
		mov a, eax
	}
	cout << "a := " << a << endl; //11

	b = 99;
	c = 11;
	__asm {
		mov ebx, b

		//将累加器eax中的值（100）与首操作数c（11）比较
		cmpxchg c, ebx  // 100与11比较，不相等，首操作数c的值（11）装载到EAX
		mov a, eax      // 将EAX的值（11）赋给a
	}

	//输出:( 如果不等， "首操作数" c 的值装载到 EAX,并将zf清0)
	cout << "b := " << b << endl; //99
	cout << "c := " << c << endl; //11
	cout << "a := " << a << endl; //11

	return 0;
}

int main2() {
	int a = 0, b = 0, c = 0;

    //内嵌汇编理解cmpxchg指令(CAS)
	__asm {
		mov eax, 100;
		mov a, eax
	}
	cout << "a := " << a << endl; //100

	b = 99;
	c = 99;
	__asm {
		mov eax, 99
		mov ebx, 777

		//将累加器eax中的值（99）与首操作数c（99）比较
		cmpxchg c, ebx  // 99与99比较，相等，第2操作数ebx（mov ebx, 777）的值装载到首操作数，zf置1
		mov a, eax
	}

	//输出:( 如果相等，第2操作数 ebx（777）的值装载到首操作数 c，zf置1)
	cout << "b := " << b << endl; //99
	cout << "c := " << c << endl; //777
	cout << "a := " << a << endl; //99

	return 0;
}