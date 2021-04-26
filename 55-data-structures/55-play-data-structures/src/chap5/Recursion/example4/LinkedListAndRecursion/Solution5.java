package chap5.Recursion.example4.LinkedListAndRecursion;
/// Leetcode 203. Remove Linked List Elements 移除链表元素
/// https://leetcode.com/problems/remove-linked-list-elements/description/
/// https://leetcode-cn.com/problems/remove-linked-list-elements/

/**
 *   head.next = removeElements(head.next, val);
 *   return head.val == val ? head.next : head;
 *
 *   6.next = null
 *   6 == 6 ? null : 5 -> null                                          返回 null
 *   5.next = null
 *   5 == 6 ? null : 5 -> null                                          返回 5 -> null
 *   4.next = 5 -> null
 *   4 == 6 ? 5 -> null : 4 -> 5 -> null                                返回 4 -> 5 -> null
 *   3.next = 4 -> 5 -> null
 *   3 == 6 ? 4 -> 5 -> null : 3 -> 4 -> 5 -> null                      返回 3 -> 4 -> 5 -> null
 *   6.next = 3 -> 4 -> 5 -> null
 *   6 == 6 ? 3 -> 4 -> 5 -> null : 6 -> 3 -> 4 -> 5 -> null            返回 3 -> 4 -> 5 -> null
 *   2.next = 3 -> 4 -> 5 -> null
 *   2 == 6 ? 3 -> 4 -> 5 -> null : 2 -> 3 -> 4 -> 5 -> null            返回 2 -> 3 -> 4 -> 5 -> null
 *   1.next = 2 -> 3 -> 4 -> 5 -> null
 *   1 == 6 ? 2 -> 3 -> 4 -> 5 -> null : 1 -> 2 -> 3 -> 4 -> 5 -> null  返回 1 -> 2 -> 3 -> 4 -> 5 -> null
 */
class Solution5 {

    public ListNode removeElements(ListNode head, int val) {

        if(head == null)
            return null;

        // 简化
        head.next = removeElements(head.next, val);
        // 如果等于要“删除的节点”头节点的val等于val，返回从next指向到最后的链表。
        // 如果等于要“删除的节点”头节点的val等于val，返回从head指向到最后的链表。
        return head.val == val ? head.next : head;
    }

    public static void main(String[] args) {

        int[] nums = {1, 2, 6, 3, 4, 5, 6};
        ListNode head = new ListNode(nums);
        System.out.println(head);

        ListNode res = (new Solution5()).removeElements(head, 6);
        System.out.println(res);
    }
}
/* Output:
1->2->6->3->4->5->6->NULL
1->2->3->4->5->NULL
*///~