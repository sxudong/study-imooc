package design.pattern.structural.flyweight.A2;

/**
 * 图解设计模式 第20章
 */
public class Test {
    //创建一个容量 1000 的 BigString 数组
    private static BigString[] bsarray = new BigString[1000];

    public static void main(String[] args) {
        System.out.println("共享时:");
        testAllocation(true);
        System.out.println("非共享时:");
        testAllocation(false);
    }
    public static void testAllocation(boolean shared) {
        for (int i = 0; i < bsarray.length; i++) {
            bsarray[i] = new BigString("1212123", shared);
        }
        showMemory();
    }
    public static void showMemory() {
        Runtime.getRuntime().gc();
        long used = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        System.out.println("使用内存 = " + used);
    }
}
/* Output:
共享时:
使用内存 = 736496
非共享时:
使用内存 = 2525208
 */