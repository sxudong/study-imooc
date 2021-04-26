package chap2.Arrays.example1.ArrayBasics;

public class ArrayBasics {
    public static void main(String[] args) {

        int[] arr = new int[10];
        for(int i = 0 ; i < arr.length ; i ++)
            arr[i] = i;

        int[] scores = new int[]{100, 99, 66};
        for(int i = 0 ; i < scores.length ; i ++)
            System.out.println(scores[i]);

        //方法一
        for(int score: scores)
            System.out.println(score);
        //可以修改数组中的变量
        scores[0] = 96;

        //方法二
        for(int i = 0 ; i < scores.length ; i ++)
            System.out.println(scores[i]);
    }
}
/* Output:
100
99
66
100
99
66
96
99
66
 */