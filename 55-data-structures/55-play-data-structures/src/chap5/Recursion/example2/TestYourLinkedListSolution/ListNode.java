package chap5.Recursion.example2.TestYourLinkedListSolution;

// Definition for singly-linked list.
// 单链列表的定义。
public class ListNode {

    public int val;
    public ListNode next;

    public ListNode(int x) {
        val = x;
    }

    // 链表节点的构造函数
    // 使用arr为参数，创建一个链表，当前的ListNode为链表头结点
    public ListNode(int[] arr) {

        // 检查
        if(arr == null || arr.length == 0)
            throw new IllegalArgumentException("arr can not be empty");

        this.val = arr[0];   // 第一个元素
        ListNode cur = this; // 当前节点从this开始
        // 遍历整个数组，把数组中元素一个一个的创建成新的ListNode接在前一个节点上，形成一个链表
        for(int i = 1 ; i < arr.length ; i ++) {
            cur.next = new ListNode(arr[i]); // new节点
            cur = cur.next;                  // 当前节点指向它
        }
        // 最后我们的this其实就是用这个循环创建出来的链表相对应的头节点
    }

    // 以当前节点为头结点的链表信息字符串
    @Override
    public String toString() {

        StringBuilder s = new StringBuilder();
        ListNode cur = this;
        while(cur != null) {
            s.append(cur.val + "->");
            cur = cur.next;
        }
        s.append("NULL");
        return s.toString();
    }
}