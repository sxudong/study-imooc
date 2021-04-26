package chap2.Arrays.example4.QueryAndUpdateElement;

public class Main {

    public static void main(String[] args) {

        Array arr = new Array(20);
        for(int i = 0 ; i < 10 ; i ++)
            arr.addLast(i);
        System.out.println(arr);

        arr.add(1, 100);
        System.out.println(arr);

        arr.addFirst(-1);
        System.out.println(arr);
    }
}
/* Output:
Array: size = 10 , capacity = 20
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
Array: size = 11 , capacity = 20
[0, 100, 1, 2, 3, 4, 5, 6, 7, 8, 9]
Array: size = 12 , capacity = 20
[-1, 0, 100, 1, 2, 3, 4, 5, 6, 7, 8, 9]
 */