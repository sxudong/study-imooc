package chap5.Recursion.example5.DebugRecursiveSolution;

public class Solution {
    int i;
    /**
     * 删除元素
     * @param head   链表
     * @param val    要删除的值
     * @param depth  递归深度
     * @return ListNode 删除元素后的链表
     */
    public ListNode removeElements(ListNode head, int val, int depth) {
        ++i;
        String depthString = generateDepthString(depth);

        System.out.print(depthString);
        System.out.println(i + "Call: remove " + val + " in " + head);

        if(head == null){
            System.out.print(depthString);
            System.out.println("Return head: " + head);
            return head;
        }

        ListNode res = removeElements(head.next, val, depth + 1);
        --i;
        System.out.print(depthString);
        System.out.println(i + "After remove " + val + ": " + "  head.val: " + head.val + "  head.next: " + head.next + "  head:" + head);

        ListNode ret;
        if(head.val == val)
            ret = res;
        else{
            head.next = res;
            ret = head;
        }
        System.out.print(depthString);
        System.out.println("Return: " + ret);

        return ret;
    }

    /**
     * 生成递归深度字符串
     * @param depth 递归深度
     * @return
     */
    private String generateDepthString(int depth){
        StringBuilder res = new StringBuilder();
        for(int i = 0 ; i < depth ; i ++)
            res.append("--");
        return res.toString();
    }

    public static void main(String[] args) {

        int[] nums = {1, 2, 6, 3, 4, 5, 6};
        ListNode head = new ListNode(nums);
        System.out.println(head);

        ListNode res = (new Solution()).removeElements(head, 6, 0);
        System.out.println(res);
    }

}
/* Output:
1->2->6->3->4->5->6->NULL
1Call: remove 6 in 1->2->6->3->4->5->6->NULL
--2Call: remove 6 in 2->6->3->4->5->6->NULL
----3Call: remove 6 in 6->3->4->5->6->NULL
------4Call: remove 6 in 3->4->5->6->NULL
--------5Call: remove 6 in 4->5->6->NULL
----------6Call: remove 6 in 5->6->NULL
------------7Call: remove 6 in 6->NULL
--------------8Call: remove 6 in null
--------------Return head: null
------------7After remove 6:   head.val: 6  head.next: null  head:6->NULL
------------Return head: null
----------6After remove 6:   head.val: 5  head.next: 6->NULL  head:5->6->NULL
----------Return head: 5->NULL  //当前 5.next 指向上一步返回的 null 得出 5->NULL
--------5After remove 6:   head.val: 4  head.next: 5->NULL  head:4->5->NULL
--------Return head: 4->5->NULL
------4After remove 6:   head.val: 3  head.next: 4->5->NULL  head:3->4->5->NULL
------Return head: 3->4->5->NULL
----3After remove 6:   head.val: 6  head.next: 3->4->5->NULL  head:6->3->4->5->NULL
----Return head: 3->4->5->NULL
--2After remove 6:   head.val: 2  head.next: 6->3->4->5->NULL  head:2->6->3->4->5->NULL
--Return head: 2->3->4->5->NULL
1After remove 6:   head.val: 1  head.next: 2->3->4->5->NULL  head:1->2->3->4->5->NULL
Return head: 1->2->3->4->5->NULL
1->2->3->4->5->NULL
*///~