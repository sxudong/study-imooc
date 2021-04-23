package chap14.HashTable.example7.ThirdVersion;

/**
 * https://www.cnblogs.com/treasury/p/12777712.html
 */
public class HashTest {
    public static void main(String[] args) {
        HashTable hashTable = new HashTable();
        hashTable.insert(new Info("a","张三"));
        hashTable.insert(new Info("tc","李四"));
        hashTable.insert(new Info("b","王五"));

        System.out.println(hashTable.hash3("a"));
        System.out.println(hashTable.hash3("tc"));
        System.out.println(hashTable.hash3("b"));

        System.out.println(hashTable.delete("a"));
        System.out.println(hashTable.find("a"));
        System.out.println(hashTable.find("tc").getValue());
        System.out.println(hashTable.find("b").getValue());

    }
}
/* Output:
1
1
2
Info{key='a', value='张三'}
null
李四
*///~