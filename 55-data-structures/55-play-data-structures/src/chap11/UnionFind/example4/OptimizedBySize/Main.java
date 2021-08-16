package chap11.UnionFind.example4.OptimizedBySize;

import java.util.Random;

public class Main {

    /**
     * 测试并查集
     * @param uf 实现了UF接口的并查集对象
     * @param m  对 uf 这个并查集执行多少的操作来测试我们的并查集性能
     */
    private static double testUF(UF uf, int m){

        int size = uf.getSize(); //获取一共维护了多少的数据
        Random random = new Random();

        long startTime = System.nanoTime();

        //进行m次合并操作
        for(int i = 0 ; i < m ; i ++){
            //每次随机合并两个元素
            int a = random.nextInt(size);
            int b = random.nextInt(size);
            uf.unionElements(a, b); // 合并
        }

        //进行m次的查询操作
        for(int i = 0 ; i < m ; i ++){
            //每次随机查询两个元素
            int a = random.nextInt(size);
            int b = random.nextInt(size);
            uf.isConnected(a, b); // 是否连接
        }

        long endTime = System.nanoTime();

        return (endTime - startTime) / 1000000000.0; //纳秒转成秒
    }

    public static void main(String[] args) {

        // UnionFind1 慢于 UnionFind2
//        int size = 100000;
//        int m = 10000;

        // UnionFind2 慢于 UnionFind1, 但UnionFind3最快
        int size = 100000; //并查集一共要维护的数据量
        int m = 100000;    //执行一万次操作

        UnionFind1 uf1 = new UnionFind1(size);
        System.out.println("UnionFind1 : " + testUF(uf1, m) + " s");

        UnionFind2 uf2 = new UnionFind2(size);
        System.out.println("UnionFind2 : " + testUF(uf2, m) + " s");

        UnionFind3 uf3 = new UnionFind3(size);
        System.out.println("UnionFind3 : " + testUF(uf3, m) + " s");
    }
}
/* Output:
UnionFind1 慢于 UnionFind2：int size = 100000; int m = 10000;
UnionFind1 : 0.2978346 s
UnionFind2 : 0.0017093 s
UnionFind3 : 0.0019313 s

UnionFind2 慢于 UnionFind1：int size = 100000; int m = 100000;
UnionFind1 : 5.5842242 s
UnionFind2 : 11.5056276 s
UnionFind3 : 0.0178081 s
*///~