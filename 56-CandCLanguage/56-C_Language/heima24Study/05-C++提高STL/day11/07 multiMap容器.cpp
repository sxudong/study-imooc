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
 *   multimap����ӳ������
 *   multimap����ӳ������:���������ݽṹ���ú�������й���
 *	 multimap������Ԫ�ض���pair:��һԪ��Ϊ��ֵ(key),�����޸�;�ڶ�Ԫ��Ϊʵֵ(value),�ɱ��޸�
 *	 multimap�����Լ��÷���map��ȫ��ͬ��Ψһ�Ĳ������:
 *   �����ظ���ֵ��Ԫ�ز�������(ʹ����RB-Tree��insert_equal����)
 *   ���:
 *      ��ֵkey��Ԫ��value��ӳ�չ�ϵ�Ƕ�Զ�Ĺ�ϵ
 *      û�ж���[]��������
 */

#include <iostream>
#include <string>
#include <map>



int main(int argc, char* argv[])
{
    std::multimap<std::string, int> myMultiMap;

    // ����
    myMultiMap.insert(std::pair<std::string, int>("Jack", 1));
    myMultiMap.insert(std::pair<std::string, int>("Jack", 2));
    myMultiMap.insert(std::pair<std::string, int>("Bob", 1));
    myMultiMap.insert(std::pair<std::string, int>("Navy", 3));
    myMultiMap.insert(std::pair<std::string, int>("Demo", 4));
    myMultiMap.insert(std::pair<std::string, int>("Bob", 5));

    // ����
    std::cout << "================All member" << std::endl;
    for (std::multimap<std::string, int>::iterator iter = myMultiMap.begin(); iter != myMultiMap.end(); ++iter)
    {
        //first�ǵ�����ָ�򡰼�ֵ����second�ǵ�����ָ���Ӧ�ġ�ֵ��
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


    // ͳ��keyΪ"Jack"����Ŀ
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


    // ɾ������keyΪ"Bob"�ļ�ֵ��
    myMultiMap.erase("Bob");
    std::cout << "================After erase Bob" << std::endl;
    for (std::multimap<std::string, int>::iterator iter = myMultiMap.begin(); iter != myMultiMap.end(); ++iter)
    {
        std::cout << (*iter).first << ":" << (*iter).second << std::endl;
    }


    // ɾ���ظ���key
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