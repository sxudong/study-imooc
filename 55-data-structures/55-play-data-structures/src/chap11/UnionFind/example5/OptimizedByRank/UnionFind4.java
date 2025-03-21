package chap11.UnionFind.example5.OptimizedByRank;

/**
 * 我们的第四版Union-Find
 */
public class UnionFind4 implements UF {
    private int[] rank;   // rank[i]表示以i为根的集合所表示的树的层数
    private int[] parent; // parent[i]表示第i个元素所指向的父节点

    // 构造函数
    public UnionFind4(int size){
        rank = new int[size];
        parent = new int[size];

        // 初始化, 每一个parent[i]指向自己, 表示每一个元素自己自成一个集合
        for( int i = 0 ; i < size ; i ++ ){
            parent[i] = i;
            rank[i] = 1;
        }
    }

    @Override
    public int getSize(){
        return parent.length;
    }

    // 查找过程, 查找元素p所对应的集合编号
    // O(h)复杂度, h为树的高度
    private int find(int p){
        if(p < 0 || p >= parent.length)
            throw new IllegalArgumentException("p is out of bound.");

        // 不断去查询自己的父亲节点, 直到到达根节点
        // 根节点的特点: parent[p] == p
        while(p != parent[p])
            p = parent[p];
        return p;
    }

    // 查看元素p和元素q是否所属一个集合
    // O(h)复杂度, h为树的高度
    @Override
    public boolean isConnected( int p , int q ){
        return find(p) == find(q);
    }

    // 合并元素p和元素q所属的集合
    // O(h)复杂度, h为树的高度
    @Override
    public void unionElements(int p, int q){
        int pRoot = find(p);
        int qRoot = find(q);

        if( pRoot == qRoot )
            return;

        /**
         * 根据两个元素所在树的 rank 不同判断合并方向
         * 将 rank低的集合 合并到 rank高的集合上
         */
        if(rank[pRoot] < rank[qRoot])
            //p树深度比q树深度小，相当于q树多了一个子树，
            //也就是说q树的高度没有变化，所以合并之后不需要维护rank数组。
            parent[pRoot] = qRoot;
        else if(rank[qRoot] < rank[pRoot])
            parent[qRoot] = pRoot;
        else { // rank[pRoot] == rank[qRoot]
            parent[pRoot] = qRoot;
            // 两个深度一样，parent[pRoot]指向 qRoot，
            // qRoot 的深度要加1。此时, 我维护 rank 的值
            rank[qRoot] += 1;
        }
    }
}
