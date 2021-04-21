package design.pattern.structural.flyweight.A1;

/**
 * 由 BigChar 组成的“大型字符串”，就是一个BigChar类型数组
 */
public class BigString {
    // 大型文字的数组
    private BigChar[] bigchars;
    // 构造函数
    public BigString(String string) {
        initShared(string);
    }

    // 构造函数
    public BigString(String string, boolean shared) {
        if (shared) {
            initShared(string);
        } else {
            initUnshared(string);
        }
    }

    // 共享方式初始化
    private void initShared(String string) {
        bigchars = new BigChar[string.length()];
        // FlyweightFactory 轻量级工厂从缓存中获取
        BigCharFactory factory = BigCharFactory.getInstance();
        for (int i = 0; i < bigchars.length; i++) {
            bigchars[i] = factory.getBigChar(string.charAt(i)); 
        }
    }

    // 非共享方式初始化
    private void initUnshared(String string) {
        bigchars = new BigChar[string.length()];
        for (int i = 0; i < bigchars.length; i++) {
            bigchars[i] = new BigChar(string.charAt(i));    
        }
    }

    // 显示（遍历打印数组中所有的BigChar）
    public void print() {
        for (int i = 0; i < bigchars.length; i++) {
            bigchars[i].print();
        }
    }
}
