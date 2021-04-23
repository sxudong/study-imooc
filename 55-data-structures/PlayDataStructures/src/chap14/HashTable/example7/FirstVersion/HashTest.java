package chap14.HashTable.example7.FirstVersion;

/**
 * 哈希表的实现原理
 *
 * https://www.cnblogs.com/treasury/p/12777712.html
 */
public class HashTest {
    public static void main(String[] args) {
        HashTable hashTable = new HashTable();
        hashTable.insert(new Info("a","111"));
        hashTable.insert(new Info("tc","222"));
        hashTable.insert(new Info("cba","333"));

        System.out.println(hashTable.find("a").getValue());
        System.out.println(hashTable.find("tc").getValue());
        System.out.println(hashTable.find("cba").getValue());
    }
}
/* Output: 哈希冲突 tc 和 a 的位置冲突
222
222
333
*///~