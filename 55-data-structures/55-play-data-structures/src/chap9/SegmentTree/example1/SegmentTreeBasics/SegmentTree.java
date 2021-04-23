package chap9.SegmentTree.example1.SegmentTreeBasics;

/**
 * 9-2 线段树基础表示
 * @param <E>
 */
public class SegmentTree<E> {

    private E[] tree;
    private E[] data;

    public SegmentTree(E[] arr){

        // new 一个静态数组
        data = (E[]) new Object[arr.length];
        for(int i = 0 ; i < arr.length ; i ++)
            data[i] = arr[i];

        // 4倍空间存储线段树所有节点
        tree = (E[]) new Object[4 * arr.length];
    }

    public int getSize(){
        return data.length;
    }

    public E get(int index){
        if(index < 0 || index >= data.length)
            throw new IllegalArgumentException("Index is illegal.");
        return data[index];
    }

    /**
     * @param index 索引
     * @return 返回完全二叉树的数组表示中，一个索引所表示的元素的左孩子节点的索引
     */
    private int leftChild(int index){
        // index = 0, leftChild = 2 x 0 + 1 = 1
        return 2*index + 1;
    }

    /**
     * @param index 索引
     * @return 返回完全二叉树的数组表示中，一个索引所表示的元素的右孩子节点的索引
     */
    private int rightChild(int index){
        return 2*index + 2;
    }
}
