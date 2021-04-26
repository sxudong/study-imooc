package chap5.Recursion.example1.LinkedListAndRecursion;
/// Leetcode 203. Remove Linked List Elements 移除链表元素
/// https://leetcode.com/problems/remove-linked-list-elements/description/
/// https://leetcode-cn.com/problems/remove-linked-list-elements/

/**
 * 这个解决方案没有使用“虚拟头节点”
 *
 * 删除链表中等于给定值 val 的所有节点。
 * <p>
 * 示例:
 * <p>
 * 输入: 1->2->6->3->4->5->6, val = 6，删除值为6的节点
 * 输出: 1->2->3->4->5
 * https://leetcode-cn.com/problems/remove-linked-list-elements/
 */
class Solution {
    /**
     * 输入：[1,2,6,3,4,5,6] , 6
     * @param head 链表
     * @param val  要删除的节点
     * @return 删除后的链表
     */
    public ListNode removeElements(ListNode head, int val) {

        // 如果头节点的val==要删除的val，将其删除断开连接
        // 删除值相同的头结点后，可能新的头结点也值相等，用while循环解决
        while (head != null && head.val == val) {
            ListNode delNode = head;
            head = head.next;
            delNode.next = null;
        }

        // 一种情况，链表里全是要删除的元素，到这里已经为空
        if (head == null)
            return head;

        // 删除链表中间的 val
        // 此时的 head 已经不是要删除的节点了
        // [1, [2, [6, [3, [4, [5, [6, null]]]]]]]
        ListNode prev = head;
        while (prev.next != null) {
            // 下一个节点的val==要删除的val
            if (prev.next.val == val) {
                /**
                 * 删除的过程
                 */
                // 1、声明要删除的节点
                ListNode delNode = prev.next;
                // 2、绕过delNode，把它隔开
                // 前一个节点的next = 指向删除节点的下一个节点next，delNode已经与prev断开了联系
                prev.next = delNode.next;
                // 3、delNode==null和链表断开联系
                delNode.next = null;
            }
            // 否则的话prev.next不用删除，将prev向后挪，回到while循环中
            else {
                // 第一次循环1的next=2, 2 ！= null, 2的next = 3, 不等于val值6，
                // 将 prev.next 的下一个节点赋值给 prev 进行 while 下一次循环
                // 循环到最后一次，prev = [5, null]
                prev = prev.next;
            }
        }

        return head;
    }

    public static void main(String[] args) {
        ListNode heard = new ListNode(1);
        heard.next = new ListNode(2);
        heard.next.next = new ListNode(6);
        heard.next.next.next = new ListNode(3);
        heard.next.next.next.next = new ListNode(4);
        heard.next.next.next.next.next = new ListNode(5);
        heard.next.next.next.next.next.next = new ListNode(6);
        Solution solution = new Solution();
        ListNode listNode = solution.removeElements(heard, 6);
        System.out.println(listNode);
    }
}
/* Output:
1->2->3->4->5->NULL
*///~