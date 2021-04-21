package design.pattern.structural.adapter;

/**
 * 12-2 适配器模式coding
 */
public class Test {
    public static void main(String[] args) {
        DC5 dc5 = new PowerAdapter();
        dc5.outputDC5V();
    }
}
/* Output:
输出交流电220V
使用PowerAdapter输入AC:220V输出DC:5V
*///~