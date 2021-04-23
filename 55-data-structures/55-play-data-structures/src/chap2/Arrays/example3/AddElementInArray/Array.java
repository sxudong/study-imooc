package chap2.Arrays.example3.AddElementInArray;

/**
 * 向数组中添加元素
 */
public class Array {

    private int[] data;
    private int size;

    // 构造函数，传入数组的容量capacity构造Array
    public Array(int capacity){
        data = new int[capacity];
        size = 0;
    }

    // 无参数的构造函数，默认数组的容量capacity=10
    public Array(){
        this(10);
    }

    // 获取数组的容量
    public int getCapacity(){
        return data.length;
    }

    // 获取数组中的元素个数
    public int getSize(){
        return size;
    }

    // 返回数组是否为空
    public boolean isEmpty(){
        return size == 0;
    }

    // 向所有元素后添加一个新元素
    public void addLast(int e){

//        if(size == data.length)
//            throw new IllegalArgumentException("AddLast failed. Array is full.");
//
//        data[size] = e;
//        size ++;
        add(size, e); // 复用
    }

    // 在所有元素前添加一个新元素
    public void addFirst(int e){
        add(0, e); // 复用
    }

    // 在index索引的位置插入一个新元素e
    public void add(int index, int e){

        if(size == data.length)
            throw new IllegalArgumentException("Add failed. Array is full.");

        if(index < 0 || index > size)
            throw new IllegalArgumentException("Add failed. Require index >= 0 and index <= size.");

        // [0,1,2,3,4,5]
        for(int i = size - 1; i >= index ; i --)
            data[i + 1] = data[i]; // 最后一个元素等于前一个元素，认数组的容量capacity=10

        data[index] = e;

        size ++;
    }

}
