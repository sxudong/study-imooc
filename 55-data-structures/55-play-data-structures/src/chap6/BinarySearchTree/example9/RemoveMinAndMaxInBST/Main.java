package chap6.BinarySearchTree.example9.RemoveMinAndMaxInBST;

import java.util.ArrayList;
import java.util.Random;

/**
 * 6-11 删除二分搜索树的最大元素和最小元素
 */
public class Main {

    public static void main(String[] args) {

        BST<Integer> bst = new BST<>();
        Random random = new Random();

        int n = 1000;

        // test removeMin
        for(int i = 0 ; i < n ; i ++)
            bst.add(random.nextInt(10000)); // 添加随元素

        ArrayList<Integer> nums = new ArrayList<>();
        while(!bst.isEmpty())
            nums.add(bst.removeMin()); // 删除的最小元素添加到List中
        System.out.println(nums);

        // 测试是否是从小到大排序？
        for(int i = 1 ; i < nums.size() ; i ++)
            if(nums.get(i - 1) > nums.get(i)) // 如果前一个比下一个大抛出异常
                throw new IllegalArgumentException("Error!");
        System.out.println("removeMin test completed.");


        // test removeMax
        for(int i = 0 ; i < n ; i ++)
            bst.add(random.nextInt(10000));

        nums = new ArrayList<>();
        while(!bst.isEmpty())
            nums.add(bst.removeMax()); //从大到小remove加入到nums
        System.out.println(nums);

        // 测试是否从大到小排列？
        for(int i = 1 ; i < nums.size() ; i ++)
            if(nums.get(i - 1) < nums.get(i))
                throw new IllegalArgumentException("Error!");
        System.out.println("removeMax test completed.");
    }
}
