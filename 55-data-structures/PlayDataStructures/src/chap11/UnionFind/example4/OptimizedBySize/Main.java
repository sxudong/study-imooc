package chap11.UnionFind.example4.OptimizedBySize;

import java.util.Random;

public class Main {

    private static double testUF(UF uf, int m){

        int size = uf.getSize();
        Random random = new Random();

        long startTime = System.nanoTime();


        for(int i = 0 ; i < m ; i ++){
            int a = random.nextInt(size);
            int b = random.nextInt(size);
            uf.unionElements(a, b); // 合并
        }

        for(int i = 0 ; i < m ; i ++){
            int a = random.nextInt(size);
            int b = random.nextInt(size);
            uf.isConnected(a, b); // 是否连接
        }

        long endTime = System.nanoTime();

        return (endTime - startTime) / 1000000000.0;
    }

    public static void main(String[] args) {

        // UnionFind1 慢于 UnionFind2
//        int size = 100000;
//        int m = 10000;

        // UnionFind2 慢于 UnionFind1, 但UnionFind3最快
        int size = 100000;
        int m = 100000;

        UnionFind1 uf1 = new UnionFind1(size);
        System.out.println("UnionFind1 : " + testUF(uf1, m) + " s");

        UnionFind2 uf2 = new UnionFind2(size);
        System.out.println("UnionFind2 : " + testUF(uf2, m) + " s");

    }
            }
/* Output:
UnionFind1 : 6.4727383 s
UnionFind2 : 14.5835588 s
UnionFind3 : 0.0250148 s
*///~