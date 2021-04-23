package chap9.SegmentTree.example4.SegmentTreeProblemsInLeetcode;

public class SegmentTree<E> {

    private E[] tree;
    private E[] data;
    private Merger<E> merger;

    public SegmentTree(E[] arr, Merger<E> merger){

        this.merger = merger;

        data = (E[])new Object[arr.length];
        for(int i = 0 ; i < arr.length ; i ++)
            data[i] = arr[i];

        tree = (E[])new Object[4 * arr.length];
        buildSegmentTree(0, 0, arr.length - 1);
    }

    // 在treeIndex的位置创建表示区间[l...r]的线段树
    private void buildSegmentTree(int treeIndex, int l, int r){

        if(l == r){
            tree[treeIndex] = data[l];
            return;
        }

        int leftTreeIndex = leftChild(treeIndex);
        int rightTreeIndex = rightChild(treeIndex);

        // int mid = (l + r) / 2;
        int mid = l + (r - l) / 2;
        buildSegmentTree(leftTreeIndex, l, mid);
        buildSegmentTree(rightTreeIndex, mid + 1, r);

        tree[treeIndex] = merger.merge(tree[leftTreeIndex], tree[rightTreeIndex]);
    }

    public int getSize(){
        return data.length;
    }

    public E get(int index){
        if(index < 0 || index >= data.length)
            throw new IllegalArgumentException("Index is illegal.");
        return data[index];
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的左孩子节点的索引
    private int leftChild(int index){
        return 2*index + 1;
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的右孩子节点的索引
    private int rightChild(int index){
        return 2*index + 2;
    }

    /**
     * @param queryL 区间左侧值
     * @param queryR 区间右侧值
     * @return 返回区间[queryL, queryR]的值
     */
    public E query(int queryL, int queryR){

        if(queryL < 0 || queryL >= data.length ||
                queryR < 0 || queryR >= data.length || queryL > queryR)
            throw new IllegalArgumentException("Index is illegal.");

        // 递归函数
        return query(0, 0, data.length - 1, queryL, queryR);
    }

    /**
     * 在以treeIndex为根的线段树中 [l...r] 的范围里，搜索区间 [queryL...queryR] 的值
     * @param treeIndex 根节
     * @param l 区间左端点，开始位置
     * @param r 区间右端点，结束位置
     * @param queryL 查询区间左侧值
     * @param queryR 查询区间右侧值
     * @return
     */
    private E query(int treeIndex, int l, int r, int queryL, int queryR){

        // 1、终止条件
        if(l == queryL && r == queryR)
            return tree[treeIndex];

        // 2、如果不是从左右孩子中去找
        int mid = l + (r - l) / 2;
        // treeIndex的节点分为[l...mid]和[mid+1...r]两部分

        int leftTreeIndex = leftChild(treeIndex);
        int rightTreeIndex = rightChild(treeIndex);
        if(queryL >= mid + 1) // 如果左边界大于中间数+1，去右支树查找
            return query(rightTreeIndex, mid + 1, r, queryL, queryR);
        else if(queryR <= mid) // 如果左边界小于中间数，去左支树查找
            return query(leftTreeIndex, l, mid, queryL, queryR);

        // 如果左右都需要查找
        // 在区间 l ~ mid 之间查找 queryL ~ mid
        // 在区间 mid + 1 ~ r 查找 mid+1 ~ queryR
        E leftResult = query(leftTreeIndex, l, mid, queryL, mid);
        E rightResult = query(rightTreeIndex, mid + 1, r, mid + 1, queryR);
        return merger.merge(leftResult, rightResult);
    }

    @Override
    public String toString(){
        StringBuilder res = new StringBuilder();
        res.append('[');
        for(int i = 0 ; i < tree.length ; i ++){
            if(tree[i] != null)
                res.append(tree[i]);
            else
                res.append("null");

            if(i != tree.length - 1)
                res.append(", ");
        }
        res.append(']');
        return res.toString();
    }
}
