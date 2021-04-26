package chap5.Recursion.example1.LinkedListAndRecursion;
/// Leetcode 203. Remove Linked List Elements 移除链表元素
/// https://leetcode.com/problems/remove-linked-list-elements/description/
/// https://leetcode-cn.com/problems/remove-linked-list-elements/

/**
 * 使用虚拟头节点
 *
 * 用虚拟头节点后，代码变得更简洁
 */
class Solution3 {

    public ListNode removeElements(ListNode head, int val) {

        // 创建虚拟头节点
        // 这是一个虚拟的头节点它的取值并不重要，永远
        // 不会访问它的值，所以在这里可以随便给一个值
        ListNode dummyHead = new ListNode(-1);
        // dummyHead成为整个链表比第一个元素head指向的node再之前的一个节点
        // 此时head指向的链表中所有的节点都有前一个节点了，我们就不需要对第
        // 一个节点进行特殊处理了。
        dummyHead.next = head;

        // dummyHead 也就是从第一个元素之前的节点开始不停的看下一个元素是不
        // 是该删除的元素，如果是就把它删除掉。
        ListNode prev = dummyHead;
        while (prev.next != null) { // 从虚拟节点开始遍历
            if (prev.next.val == val)
                prev.next = prev.next.next;
            else
                // 将 prev.next 的下一个节点赋值给 prev 进行 while 下一次循环
                prev = prev.next;
        }

        // return时要把dummyHead.next返回去，也就是说对于虚拟头节点的建立是对
        // 调用这个算法的人屏蔽的，他并不知道这个虚拟头节点的存在。
        return dummyHead.next;
    }
}