package chap9.SegmentTree.example2.BuildingSegmentTree;

/**
 * 9-3 创建线段树
 * @param <E>
 */
public class SegmentTree<E> {

    private E[] tree;
    private E[] data;
    private Merger<E> merger; // 两个区间的融合器

    public SegmentTree(E[] arr, Merger<E> merger){

        this.merger = merger;

        // new 一个静态数组
        data = (E[]) new Object[arr.length];
        for(int i = 0 ; i < arr.length ; i ++)
            data[i] = arr[i];

        // 4倍空间存储线段树所有节点
        tree = (E[]) new Object[4 * arr.length];
        // 创建“求和”的线段树
        buildSegmentTree(0, 0, arr.length - 1);
    }

    /**
     * 在 treeIndex 的位置创建表示 区间[l...r] 的线段树
     * @param treeIndex 节点
     * @param l 区间左端点，开始位置
     * @param r 区间右端点，结束位置
     */
    private void buildSegmentTree(int treeIndex, int l, int r){
        // 终止条件，区间只有一个元素
        if(l == r) {
            // 此时这个节点存储的就是它本身
            tree[treeIndex] = data[l];
            return;
        }

        int leftTreeIndex = leftChild(treeIndex);
        int rightTreeIndex = rightChild(treeIndex);

        // int mid = (l + r) / 2;
        int mid = l + (r - l) / 2;
        // 创建左右树,递归调用
        buildSegmentTree(leftTreeIndex, l, mid);
        buildSegmentTree(rightTreeIndex, mid + 1, r);

        // tree[treeIndex] = tree[leftTreeIndex] + tree[rightTreeIndex];
        // 创建一个Merger接口，用户可以根据自已的场景自由的组织自已的逻辑来使用我们的线段树
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
