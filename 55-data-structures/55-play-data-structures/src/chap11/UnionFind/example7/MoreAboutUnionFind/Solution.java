package chap11.UnionFind.example7.MoreAboutUnionFind;
/// Leetcode 547. Friend Circles
/// https://leetcode.com/problems/friend-circles/description/
///
/// 课程中在这里暂时没有介绍这个问题
/// 该代码主要用于使用Leetcode上的问题测试我们的UF类
import java.util.TreeSet;

/**
 * 547. 朋友圈
 * 班上有 N 名学生。其中有些人是朋友，有些则不是。他们的友谊具有是传递性。如果已知 A 是 B 的朋友，B 是 C 的朋友，那么我们可以认为 A 也是 C 的朋友。所谓的朋友圈，是指所有朋友的集合。
 *
 * 给定一个 N * N 的矩阵 M，表示班级中学生之间的朋友关系。如果M[i][j] = 1，表示已知第 i 个和 j 个学生互为朋友关系，否则为不知道。你必须输出所有学生中的已知的朋友圈总数。
 *
 * 示例 1:
 *
 * 输入:
 * [[1,1,0],
 *  [1,1,0],
 *  [0,0,1]]
 * 输出: 2
 * 说明：已知学生0和学生1互为朋友，他们在一个朋友圈。
 * 第2个学生自己在一个朋友圈。所以返回2。
 * 示例 2:
 *
 * 输入:
 * [[1,1,0],
 *  [1,1,1],
 *  [0,1,1]]
 * 输出: 1
 * 说明：已知学生0和学生1互为朋友，学生1和学生2互为朋友，所以学生0和学生2也是朋友，所以他们三个在一个朋友圈，返回1。
 *
 * 注意：
 * N 在[1,200]的范围内。
 * 对于所有学生，有M[i][i] = 1。
 * 如果有M[i][j] = 1，则有M[j][i] = 1。
 *
 * 链接：https://leetcode-cn.com/problems/friend-circles/
 */
class Solution {

    private interface UF {
        int getSize();
        boolean isConnected(int p, int q);
        void unionElements(int p, int q);
    }

    // 我们的第六版Union-Find
    private class UnionFind6 implements UF {

        // rank[i]表示以i为根的集合所表示的树的层数
        // 在后续的代码中, 我们并不会维护rank的语意, 也就是rank的值在路径压缩的过程中, 有可能不在是树的层数值
        // 这也是我们的rank不叫height或者depth的原因, 他只是作为比较的一个标准
        private int[] rank;
        private int[] parent; // parent[i]表示第i个元素所指向的父节点

        // 构造函数
        public UnionFind6(int size){

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

            // path compression 2, 递归算法
            if(p != parent[p])
                parent[p] = find(parent[p]);
            return parent[p];
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

            // 根据两个元素所在树的rank不同判断合并方向
            // 将rank低的集合合并到rank高的集合上
            if( rank[pRoot] < rank[qRoot] )
                parent[pRoot] = qRoot;
            else if( rank[qRoot] < rank[pRoot])
                parent[qRoot] = pRoot;
            else{ // rank[pRoot] == rank[qRoot]
                parent[pRoot] = qRoot;
                rank[qRoot] += 1;   // 此时, 我维护rank的值
            }
        }
    }

    public int findCircleNum(int[][] M) {

        int n = M.length;
        UnionFind6 uf = new UnionFind6(n);
        for(int i = 0 ; i < n ; i ++)
            for(int j = 0 ; j < i ; j ++)
                if(M[i][j] == 1)
                    uf.unionElements(i, j);

        TreeSet<Integer> set = new TreeSet<>();
        for(int i = 0 ; i < n ; i ++)
            set.add(uf.find(i));
        return set.size();
    }
}
