/**
 *@File MultiMapDemo.cpp
 *
 *@Author: Bob
 *
 *@Create Time: 2016-12-1 11:57:06
 *
 *@Last Modify: Bob
 *
 *@Last Modify Time: 2016-12-1 11:57:06
 *
 *@Description:
 *   multimap多重映照容器
 *   multimap多重映照容器:容器的数据结构采用红黑树进行管理
 *	 multimap的所有元素都是pair:第一元素为键值(key),不能修改;第二元素为实值(value),可被修改
 *	 multimap特性以及用法与map完全相同，唯一的差别在于:
 *   允许重复键值的元素插入容器(使用了RB-Tree的insert_equal函数)
 *   因此:
 *      键值key与元素value的映照关系是多对多的关系
 *      没有定义[]操作运算
 */

#include <iostream>
#include <string>
#include <map>



int main(int argc, char* argv[])
{
    std::multimap<std::string, int> myMultiMap;

    // 插入
    myMultiMap.insert(std::pair<std::string, int>("Jack", 1));
    myMultiMap.insert(std::pair<std::string, int>("Jack", 2));
    myMultiMap.insert(std::pair<std::string, int>("Bob", 1));
    myMultiMap.insert(std::pair<std::string, int>("Navy", 3));
    myMultiMap.insert(std::pair<std::string, int>("Demo", 4));
    myMultiMap.insert(std::pair<std::string, int>("Bob", 5));

    // 遍历
    std::cout << "================All member" << std::endl;
    for (std::multimap<std::string, int>::iterator iter = myMultiMap.begin(); iter != myMultiMap.end(); ++iter)
    {
        //first是迭代器指向“键值”，second是迭代器指向对应的“值”
        std::cout << (*iter).first << ":" << (*iter).second << std::endl;
    }
    /* Output:
    ================All member
    Bob:1
    Bob:5
    Demo:4
    Jack:1
    Jack:2
    Navy:3
    */


    // 统计key为"Jack"的数目
    std::string strFind = "Jack";
    unsigned int uCount = myMultiMap.count(strFind);
    if (uCount == 0)
    {
        std::cout << "================Count " << strFind << ":0" << std::endl;
    }
    else
    {
        std::cout << "================Count " << strFind << ":" << uCount << std::endl;
        std::multimap<std::string, int>::iterator iter = myMultiMap.find(strFind);
        if (iter != myMultiMap.end())
        {
            for (unsigned int i = 0; i < uCount; ++i)
            {
                std::cout << (*iter).first << ":" << (*iter).second << std::endl;
                iter++;
            }
        }
    }


    std::cout << "================use equal_range" << std::endl;
    typedef std::multimap<std::string, int>::iterator MultiMapIterator;
    std::pair<MultiMapIterator, MultiMapIterator> iterPair = myMultiMap.equal_range("Jack");
    for (MultiMapIterator it = iterPair.first; it != iterPair.second; ++it)
    {
        std::cout << (*it).first << ":" << (*it).second << std::endl;
    }


    // 删除所有key为"Bob"的键值对
    myMultiMap.erase("Bob");
    std::cout << "================After erase Bob" << std::endl;
    for (std::multimap<std::string, int>::iterator iter = myMultiMap.begin(); iter != myMultiMap.end(); ++iter)
    {
        std::cout << (*iter).first << ":" << (*iter).second << std::endl;
    }


    // 删除重复的key
    MultiMapIterator iter = myMultiMap.find("Jack");
    myMultiMap.erase(iter);
    std::cout << "================Use unique key, erase \"Jack\" " << std::endl;
    for (std::multimap<std::string, int>::iterator iter = myMultiMap.begin(); iter != myMultiMap.end(); ++iter)
    {
        std::cout << (*iter).first << ":" << (*iter).second << std::endl;
    }

    return 0;
}
/* Output:
================All member
Bob:1
Bob:5
Demo:4
Jack:1
Jack:2
Navy:3
================Count Jack:2
Jack:1
Jack:2
================use equal_range
Jack:1
Jack:2
================After erase Bob
Demo:4
Jack:1
Jack:2
Navy:3
================Use unique key, erase "Jack"
Demo:4
Jack:2
Navy:3
*/