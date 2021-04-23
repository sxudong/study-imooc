package chap2.Arrays.example8.AmortizedTimeComplexity;

public class Main {

    public static void main(String[] args) {

        Array<Integer> arr = new Array<>();
        for(int i = 0 ; i < 10 ; i ++)
            arr.addLast(i);
        System.out.println(arr);
        // Array: size = 10 , capacity = 10
        // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        arr.add(1, 100);
        System.out.println(arr);
        // Array: size = 11 , capacity = 20
        // [0, 100, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        arr.addFirst(-1);
        System.out.println(arr);
        // Array: size = 12 , capacity = 20
        // [-1, 0, 100, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        arr.remove(2);
        System.out.println(arr);
        // Array: size = 11 , capacity = 20
        // [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        arr.removeElement(4);
        System.out.println(arr);
        // Array: size = 10 , capacity = 20
        // [-1, 0, 1, 2, 3, 5, 6, 7, 8, 9]

        arr.removeFirst();
        System.out.println(arr);
        // Array: size = 9 , capacity = 20
        // [0, 1, 2, 3, 5, 6, 7, 8, 9]

        for(int i = 0 ; i < 4 ; i ++){
            arr.removeFirst();
            System.out.println(arr);
        }
        /* Output:
            Array: size = 8 , capacity = 20
            [1, 2, 3, 5, 6, 7, 8, 9]
            Array: size = 7 , capacity = 20
            [2, 3, 5, 6, 7, 8, 9]
            Array: size = 6 , capacity = 20
            [3, 5, 6, 7, 8, 9]
            Array: size = 5 , capacity = 10
            [5, 6, 7, 8, 9]
         */
    }
}
