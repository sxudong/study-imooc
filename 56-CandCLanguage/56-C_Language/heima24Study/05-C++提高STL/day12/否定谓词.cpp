#include <algorithm>
#include <numeric>
#include <iterator>
#include <functional> //ͷ�ļ�
#include <iostream>
#include <vector>

/*
* STL ��ν�� not1() not2()
* not1 �ǹ���һ����ν�ʽ�����෴����һԪ��������
* not2 �ǹ���һ����ν�ʽ�����෴���Ķ�Ԫ��������
* ʾ����https://www.jianshu.com/p/c7f3a04f88b7
*/


struct LessThan7 : std::unary_function<int, bool>
{
    bool operator()(int i) const { return i < 7; }
};



/*
* not1 �ǹ���һ����ν�ʽ�����෴����һԪ��������
*/
void test01() {
    std::vector<int> v(10);
    std::iota(begin(v), end(v), 0); //std::iota :��˳�������ֵ��ֵָ����Χ�ڵ�Ԫ�� ��
    for (size_t i =0; i < v.size(); i ++) {
        int d = v[i];
        std::cout << d;
    }
    std::cout << std::endl;
    std::cout << "v.size: " << v.size() << std::endl;

    //not1 С��7 ��ȡ�������� >=7 ��,ֻ��7��8��9��3�����֡�
    std::cout << std::count_if(begin(v), end(v), std::not1(LessThan7())) << "\n"; //3

    //ͬ�ϣ���ʹ�� `std::function`
    std::function<bool(int)> less_than_9 = [](int x){ return x < 9; };
    //count_if ��������������Χ�ڵ�Ԫ�ظ���
    //not1 С��7 ��ȡ�������� >=9 ��,ֻ��9��1�����֡�
    std::cout << std::count_if(begin(v), end(v), std::not1(less_than_9)) << "\n"; //1
}
/* Output:
0123456789
v.size: 10
3
1
*/

/*
* not2 �ǹ���һ����ν�ʽ�����෴���Ķ�Ԫ��������
*/
void test02(){
    std::vector<int> nums = {5, 3, 4, 9, 1, 7, 6, 2, 8};

    std::function<bool(int, int)> ascendingOrder = [](int a, int b) { return a < b; };

    // ����������ֽ������򣺲�������
    std::sort(nums.begin(), nums.end(), std::not2(ascendingOrder));

    for(int i:nums) {
        std::cout << i << "\t";
    }

}
/* Output:
9       8       7       6       5       4       3       2       1
*/

int main(){
    test01();
    test02();
}
