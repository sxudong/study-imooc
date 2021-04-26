package chap5.Recursion.example1.LinkedListAndRecursion;
/// Leetcode 203. Remove Linked List Elements 移除链表元素
/// https://leetcode.com/problems/remove-linked-list-elements/description/
/// https://leetcode-cn.com/problems/remove-linked-list-elements/

/**
 * 针对 Solution 代码的精简
 */
class Solution2 {

    public ListNode removeElements(ListNode head, int val) {

        while(head != null && head.val == val)
//            ListNode delNode = head;
//            head = head.next;
//            delNode.next = null;
            head = head.next;

        if(head == null)
            return head;

        ListNode prev = head;
        while(prev.next != null){
            if(prev.next.val == val)
//                ListNode delNode = prev.next;
//                prev.next = delNode.next;
//                delNode.next = null;
                prev.next = prev.next.next;
            else
                // 将 prev.next 的下一个节点赋值给 prev 进行 while 下一次循环
                prev = prev.next;
        }

        return head;
    }
}