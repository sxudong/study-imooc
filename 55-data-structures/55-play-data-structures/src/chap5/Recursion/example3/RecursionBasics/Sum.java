package chap5.Recursion.example3.RecursionBasics;

public class Sum {

    public static int sum(int[] arr){
        return sum(arr, 0);
    }

    /**
     * 递归函数
     *
     * @param arr   数组
     * @param l     从数组下标 0 开始,把数组中每一个值取出来递归相加
     * @discription 计算 arr[l...n) 这个区间内所有数字的和
     */
    private static int sum(int[] arr, int l){
        if(l == arr.length)
            return 0;

        return arr[l] + sum(arr, l + 1); // 把arr[0]取出来 + susm(arr, 0 + 1), 1 + 1, 2 + 1, 3 + 1
    }

    public static void main(String[] args) {

        int[] nums = {1, 2, 3, 4, 5, 6, 7, 8};
        System.out.println(sum(nums)); // 36
    }
}
