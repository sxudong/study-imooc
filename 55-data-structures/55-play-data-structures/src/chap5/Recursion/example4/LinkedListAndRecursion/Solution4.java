package chap5.Recursion.example4.LinkedListAndRecursion;
/// Leetcode 203. Remove Linked List Elements 移除链表元素
/// https://leetcode.com/problems/remove-linked-list-elements/description/
/// https://leetcode-cn.com/problems/remove-linked-list-elements/


/**
 * 使用链表递归解决
 *
 *  首先遵从设计一个递归算法来说，我要先解决最基本的情况，然后构建递归过程。
 *  所谓的构建递归过程，就是用更小规模的解去构建原规模的解。
 *
 *  在这个过程中就是将 removeElements() 当做子函数调用，我知道它要完成的功能，
 *  基于它过多成的功能得到的结果来构建我最终的逻辑。
 */
class Solution4 {

    public ListNode removeElements(ListNode head, int val) {

        if(head == null) // 求解最基本问题
            return head;

        // 参考PPT图片“解决链表中删除元素的问题.jpg”说明
        // res 是头节点后面跟着的val全部删除后，剩下的链表
        ListNode res = removeElements(head.next, val);  // 此此不断的递归调用，直到最底层，最小问题
        // 如果当前head.val = val, 则返回删除之后的结果链表res
        if(head.val == val)
            return res;
        else { // 如果当前head.val != val, 将head.next链表删除后的结果钟表res
            head.next = res;
            return head;
        }
    }

    public static void main(String[] args) {

        int[] nums = {1, 2, 6, 3, 4, 5, 6};
        ListNode head = new ListNode(nums);
        System.out.println(head);

        ListNode res = (new Solution4()).removeElements(head, 6);
        System.out.println(res);
    }
}
/* Output:
1->2->6->3->4->5->6->NULL
1->2->3->4->5->NULL
*///~