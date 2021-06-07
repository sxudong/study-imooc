#include <algorithm>
#include <numeric>
#include <iterator>
#include <functional> //头文件
#include <iostream>
#include <vector>

/*
* STL 否定谓词 not1() not2()
* not1 是构造一个与谓词结果“相反”的一元函数对象。
* not2 是构造一个与谓词结果“相反”的二元函数对象。
* 示例：https://www.jianshu.com/p/c7f3a04f88b7
*/


struct LessThan7 : std::unary_function<int, bool>
{
    bool operator()(int i) const { return i < 7; }
};



/*
* not1 是构造一个与谓词结果“相反”的一元函数对象。
*/
void test01() {
    std::vector<int> v(10);
    std::iota(begin(v), end(v), 0); //std::iota :用顺序递增的值赋值指定范围内的元素 。
    for (size_t i =0; i < v.size(); i ++) {
        int d = v[i];
        std::cout << d;
    }
    std::cout << std::endl;
    std::cout << "v.size: " << v.size() << std::endl;

    //not1 小于7 的取反，就是 >=7 的,只有7、8、9，3个数字。
    std::cout << std::count_if(begin(v), end(v), std::not1(LessThan7())) << "\n"; //3

    //同上，但使用 `std::function`
    std::function<bool(int)> less_than_9 = [](int x){ return x < 9; };
    //count_if 返回满足条件范围内的元素个数
    //not1 小于7 的取反，就是 >=9 的,只有9，1个数字。
    std::cout << std::count_if(begin(v), end(v), std::not1(less_than_9)) << "\n"; //1
}
/* Output:
0123456789
v.size: 10
3
1
*/

/*
* not2 是构造一个与谓词结果“相反”的二元函数对象。
*/
void test02(){
    std::vector<int> nums = {5, 3, 4, 9, 1, 7, 6, 2, 8};

    std::function<bool(int, int)> ascendingOrder = [](int a, int b) { return a < b; };

    // 按降序对数字进行排序：不是升序
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
