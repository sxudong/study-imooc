package chap11.UnionFind.example1.WhatIsUnionFind;

/**
 * 11-1 什么是并查集
 */
public interface UF { // UF (union find)
    int getSize(); // 并查集一共考虑多少个元素
    boolean isConnected(int p, int q); // 两个元素是不是可以连接的
    void unionElements(int p, int q);  // 将两个元素并在一起
}