package chap14.HashTable.example7.ThirdVersion;

import java.math.BigInteger;

public class HashTable {
    private Linked[] arrays;

    /**
     * 默认构造方法,实现哈希表的本质是哈希函数将不同类型的数据转化成数组下表
     */
    public HashTable() {
        this.arrays = new Linked[100];
    }

    /**
     * 指定大小
     */
    public HashTable(int maxsize) {
        this.arrays = new Linked[maxsize];
    }

    /**
     * 插入数据,直接把员工号作为数组索引
     */
    public void insert(Info info) {
        String key = info.getKey();
        //关键字对应的哈希值，将要作为下标
        int hashValue = hash3(key);
        //
        if (arrays[hashValue] == null) {
            arrays[hashValue] = new Linked();
        }
        //插入
        arrays[hashValue].insert(info);

    }

    /**
     * 查找数据,直接把员工号作为数组索引
     */
    public Info find(String key) {
        int hashValue = hash3(key);
        //从第一次的位置，到最终插入位置是连续的

        LinkedNode node = arrays[hashValue].find(key);
        if (node == null)
            return null;
        return node.info;
    }

    public Info delete(String key) {
        int hashValue = hash3(key);
        //从第一次的位置，到最终插入位置是连续的
        LinkedNode node = arrays[hashValue].deleteByvalue(key);
        return node.info;
    }

    public int hashCode(String key) {
        return hash3(key);

    }


    public int hash1(String key) {
        //1.将字母转化成ASCII,然后相加
        int hashvalue = 0;
        for (int i = 0; i < key.length(); i++) {
            //a是97,其他字母减去97就是字母对应的数字
            int letter = key.charAt(i) - 96;
            hashvalue += letter;
        }
        //取模可以压缩可选值，比如想把100个可选择压缩到0-9,对数组长度取模
        return hashvalue % arrays.length;
    }

    public int hash2(String key) {
        //2.幂的连乘,这里可能hashvalue的值超过范围，使用long也不行，可以用bigint
        int hashvalue = 0;
        int pow27 = 1;
        for (int i = 0; i < key.length(); i++) {
            //比如abc,1*27^0+2*27^1+2*27^2
            int letter = key.charAt(i) - 96;
            hashvalue += letter * pow27;
            pow27 *= 27;
        }
        return hashvalue % arrays.length;
    }

    public int hash3(String key) {
        //3.用bigint

        BigInteger hashvalue = new BigInteger("0");
        BigInteger pow27 = new BigInteger("1");

        for (int i = 0; i < key.length(); i++) {
            //比如abc,1*27^0+2*27^1+3*27^2

            int letter = key.charAt(i) - 96;
            //把letter用bigint包装起来
            BigInteger bigLetter = new BigInteger(letter + "");
            hashvalue = hashvalue.add(bigLetter.multiply(pow27));
            pow27 = pow27.multiply(new BigInteger(27 + ""));
        }
        return hashvalue.mod(new BigInteger(arrays.length + "")).intValue();
    }

    public int hash4(String key) {
        //3.使用开放地址法解决冲突
        //当冲突发生，查找空位置插入，而不再用哈希函数得到数组下标

        return 1;
    }
}