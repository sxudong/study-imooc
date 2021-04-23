package chap14.HashTable.example7.SecondVersion;

import java.math.BigInteger;

public class HashTable {
    private Info[] arrays;

    /**
     * 默认构造方法,实现哈希表的本质是哈希函数将不同类型的数据转化成数组下表
     */
    public HashTable() {
        this.arrays = new Info[100];
    }
    /**
     * 指定大小
     */
    public HashTable(int maxsize){
        this.arrays=new Info[maxsize];
    }

    /**
     * 插入数据,直接把员工号作为数组索引
     */
    public void insert(Info info){
        String key=info.getKey();
        //关键字对应的哈希值，将要作为下标
        int hashValue=hash3(key);

        //如果被占用，并且key对应的value也不为空（因为删除的时候是删除info对象里的value,而不是全部）
        while (arrays[hashValue]!=null&&arrays[hashValue].getValue()!=null){
            //一直找到一个没被占用的
            hashValue++;
            //比如99和599哈希值取模后都是99，99加1后数组会越界，但是前面还有空的位置
            hashValue%=arrays.length;
            //直到整个数组都填满
        }
        arrays[hashValue]=info;

    }
    /**
     * 查找数据,直接把员工号作为数组索引
     */
    public Info find(String key){
        int hashValue=hash3(key);
        //从第一次的位置，到最终插入位置是连续的
        while (arrays[hashValue]!=null){
            //如果key值相等说明找到了
            if(arrays[hashValue].getKey().equals(key))
                return arrays[hashValue];
            hashValue++;
            hashValue%=arrays.length;
        }
        return null;
    }
    public Info delete(String key){
        int hashValue=hash3(key);
        //从第一次的位置，到最终插入位置是连续的
        while (arrays[hashValue]!=null){
            //如果key值相等说明找到了,将Info的value值空
            if(arrays[hashValue].getKey().equals(key)){
                Info info=arrays[hashValue];
                arrays[hashValue].setValue(null);
                return info;
            }
            hashValue++;
            hashValue%=arrays.length;
        }
        return null;
    }
    public int hashCode(String key){
        return hash3(key);

    }



    public int hash1(String key){
        //1.将字母转化成ASCII,然后相加
        int hashvalue=0;
        for (int i = 0; i < key.length(); i++) {
            //a是97,其他字母减去97就是字母对应的数字
            int letter=key.charAt(i)-96;
            hashvalue+= letter;
        }
        //取模可以压缩可选值，比如想把100个可选择压缩到0-9,对数组长度取模
        return hashvalue%arrays.length;
    }
    public int hash2(String key){
        //2.幂的连乘,这里可能hashvalue的值超过范围，使用long也不行，可以用bigint
        int hashvalue=0;
        int pow27=1;
        for (int i = 0; i < key.length(); i++) {
            //比如abc,1*27^0+2*27^1+2*27^2
            int letter=key.charAt(i)-96;
            hashvalue+= letter*pow27;
            pow27*=27;
        }
        return hashvalue%arrays.length;
    }
    public int hash3(String key){
        //3.用bigint

        BigInteger hashvalue=new BigInteger("0");
        BigInteger pow27=new BigInteger("1");

        for (int i = 0; i < key.length(); i++) {
            //比如abc,1*27^0+2*27^1+3*27^2

            int letter=key.charAt(i)-96;
            //把letter用bigint包装起来
            BigInteger bigLetter=new BigInteger(letter+"");
            hashvalue=hashvalue.add(bigLetter.multiply(pow27));
            pow27=pow27.multiply(new BigInteger(27+""));
        }
        return hashvalue.mod(new BigInteger(arrays.length+"")).intValue();
    }

}