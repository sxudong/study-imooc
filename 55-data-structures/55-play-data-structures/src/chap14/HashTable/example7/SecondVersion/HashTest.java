package chap14.HashTable.example7.SecondVersion;


/**
 * https://www.cnblogs.com/treasury/p/12777712.html
 */
public class HashTest {
    public static void main(String[] args) {
        HashTable hashTable = new HashTable();
        hashTable.insert(new Info("a","111"));
        hashTable.insert(new Info("tc","222"));
        hashTable.insert(new Info("cba","333"));
        hashTable.insert(new Info("wangwu","王五"));
        hashTable.delete("wangwu");

        System.out.println(hashTable.find("a").getValue());
        System.out.println(hashTable.find("tc").getValue());
        System.out.println(hashTable.find("cba").getValue());
        System.out.println(hashTable.find("wangwu").getValue());
    }
}
/* Output:
111
222
333
null
*///~