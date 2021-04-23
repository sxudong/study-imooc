package chap11.UnionFind.example4.OptimizedBySize;

public interface UF {

    int getSize(); // 并查集一共考虑多少个元素
    boolean isConnected(int p, int q); // 两个元素是不是可以连接的
    void unionElements(int p, int q);  // 将两个元素并在一起
}
