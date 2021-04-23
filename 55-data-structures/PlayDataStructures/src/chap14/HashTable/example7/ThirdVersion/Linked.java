package chap14.HashTable.example7.ThirdVersion;

public class Linked {
    public LinkedNode head;

    public Linked() {
        head = null;
    }

    //插入节点,在头结点之后插入.
    //重点是不要让节点丢失
    public void insert(Info info) {
        LinkedNode node = new LinkedNode(info);

        if (head == null) {
            head = node;
        } else {
            node.next = head.next;
//        head.next=node;此处不应该这么写，会形成环
            head.next = node;
        }

    }

    //在头结点之后删除一个元素
    public LinkedNode delete() throws Exception {
        if(head.next==null){
            head=null;
            return null;

        }else{
            LinkedNode tmp = head.next;
            head.next = tmp.next;
            return tmp;
        }
    }


    //查找方法
    public LinkedNode find(String key) {
        LinkedNode tmp = head;
        if(tmp==null)
            return null;
        while (!key.equals(tmp.info.getKey())){

            if(tmp.next==null)
                return null;
            tmp=tmp.next;
        }
        return tmp;
    }
    //根据值来删除元素
    public LinkedNode deleteByvalue(String  key){
        LinkedNode ans = null;
        LinkedNode pretmp = head;
        LinkedNode tmp =head.next;

        if(key.equals(head.info.getKey())){
            ans=head;
            head=head.next;
            return ans;
        }
        while (tmp!=null){
            if(key.equals(tmp.info.getKey())){
                ans=tmp;
                pretmp.next=tmp.next;
            }
            pretmp=pretmp.next;
            tmp=tmp.next;
        }
        return ans;
    }
}