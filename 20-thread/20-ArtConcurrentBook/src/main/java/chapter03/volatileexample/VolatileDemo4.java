package chapter03.volatileexample;

/**
 * 触发器（happens-bofore）
 *
 * volatile 可以作为刷新之前变量的触发器，我们可以将某个变量
 * 设置为 volatile 修饰，其他线程一旦发现该变量修改的值后，
 * 触发获取到的该变量之前的凑奥都将是最新的且可见。
 *
 * https://blog.csdn.net/weixin_44324174/article/details/105850960
 */
public class VolatileDemo4 {
    public static void main(String[] args) {
        //可以作为刷新之前操作的触发器
        source re = new source();
        new Thread(()->{
            re.write();
        }).start();
        new Thread(()->{
            re.read();
        }).start();
    }
}

class source {
    private int a = 1;
    private int b = 2;
    private int c = 3;
    private volatile boolean flag = true;
    public void write() {
        a = 10;
        b = 20;
        c = 30;
        flag = true;
    }

    public void read() {
        // flag 被 volatile 修饰，充当了触发器,一旦值为被修改为 true,
        // 那么此处对变量之前的操作对于后面的线程都是可见的。
        while (flag) {
            System.out.println("a=" + a + ",b=" + b + ",c=" + c);
        }
    }
}