package chap8.HeapAndPriorityQueue.example3.ExtractAndSiftDownInHeap;

/**
 * 8-4 从堆中取出元素和 Sift Down
 * @param <E>
 */
public class MaxHeap<E extends Comparable<E>> {

    private Array<E> data;

    public MaxHeap(int capacity){
        data = new Array<>(capacity);
    }

    public MaxHeap(){
        data = new Array<>();
    }

    // 返回堆中的元素个数
    public int size(){
        return data.getSize();
    }

    // 返回一个布尔值, 表示堆中是否为空
    public boolean isEmpty(){
        return data.isEmpty();
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的父亲节点的索引
    private int parent(int index){
        if(index == 0)
            throw new IllegalArgumentException("index-0 doesn't have parent.");
        return (index - 1) / 2;
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的左孩子节点的索引
    private int leftChild(int index){
        return index * 2 + 1;
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的右孩子节点的索引
    private int rightChild(int index){
        return index * 2 + 2;
    }

    // 向堆中添加元素
    public void add(E e){
        data.addLast(e);
        siftUp(data.getSize() - 1);
    }

    private void siftUp(int k){

        while(k > 0 && data.get(parent(k)).compareTo(data.get(k)) < 0 ){
            data.swap(k, parent(k));
            k = parent(k);
        }
    }

    /**
     * 看堆中的最大元素
     */
    public E findMax(){
        if(data.getSize() == 0)
            throw new IllegalArgumentException("Can not findMax when heap is empty.");
        return data.get(0);
    }

    /**
     * 取出堆中最大元素
     */
    public E extractMax(){

        E ret = findMax();

        // 交换位置
        data.swap(0, data.getSize() - 1);
        // 删除末尾元素
        data.removeLast();
        // 数据下沉
        siftDown(0);

        return ret;
    }

    /**
     * 数据下沉
     * @param k 索引
     */
    private void siftDown(int k){

        // 循环到 k 所处的这个节点已经没有孩子了，是叶子节点，循环结束
        // k 的左孩子索引大于节点总数就越界了，因为右孩子对应索引肯定比左孩子还要大。
        while(leftChild(k) < data.getSize()){
            // 比较 k 这个节点和它左右孩子最大的节点，看 k 节点是不是比它小？
            // 首先找到 k 节点左右两个节点较大的那个节点是谁？
            int j = leftChild(k);
            // 在此轮循环中,data[k]和data[j]交换位置
            // j + 1 右孩子小于总数，右节点大于左节点
            if( j + 1 < data.getSize() &&
                    data.get(j + 1).compareTo(data.get(j)) > 0 ) {
                // j = rightChild(k);
                j++; // 此时 data[j] 是 leftChild 和 rightChild 中的最大值
            }

            // 如果 k >= j 此时大于左右孩子，
            // 没有违反堆性质，下沉结束跳出循环
            if(data.get(k).compareTo(data.get(j)) >= 0 )
                break;

            // 否则交换位置
            data.swap(k, j);
            // 交换完以后，把 j 赋值给 k, 时行下一轮的循环
            k = j;
        }
    }
}
