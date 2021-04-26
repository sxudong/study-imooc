package chap2.Arrays.example7.DynamicArray;

public class Main {
    public static void main(String[] args) {

        Array<Integer> arr = new Array<>(); // 默认10
        for(int i = 0 ; i < 10 ; i ++)
            arr.addLast(i);
        System.out.println(arr);

        arr.add(1, 100); // 添加一个元素
        System.out.println(arr);

        arr.addFirst(-1);
        System.out.println(arr);

        arr.remove(2);
        System.out.println(arr);

        arr.removeElement(4);
        System.out.println(arr);

        arr.removeFirst();
        System.out.println(arr);

    }
}
/* Output:
Array: size = 10 , capacity = 10
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
Array: size = 11 , capacity = 20
[0, 100, 1, 2, 3, 4, 5, 6, 7, 8, 9]
Array: size = 12 , capacity = 20
[-1, 0, 100, 1, 2, 3, 4, 5, 6, 7, 8, 9]
Array: size = 11 , capacity = 20
[-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
Array: size = 10 , capacity = 10
[-1, 0, 1, 2, 3, 5, 6, 7, 8, 9]
Array: size = 9 , capacity = 10
[0, 1, 2, 3, 5, 6, 7, 8, 9]
 */