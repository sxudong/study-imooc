package design.pattern.structural.flyweight.Sample;

/**
 * Client 请求者
 * Client角色 使用 FlyweightFactory角色 来生成 Flyweight角色。
 *
 * 由 BigChar 组成的“大型字符串”
 */
public class BigString {
    // “大型字符”的数组
    private BigChar[] bigchars;

    // 构造函数
    public BigString(String string) {
        bigchars = new BigChar[string.length()];
        // 创建实例
        BigCharFactory factory = BigCharFactory.getInstance();
        for (int i = 0; i < bigchars.length; i++) {
            bigchars[i] = factory.getBigChar(string.charAt(i));
        }
    }

    // 显示
    public void print() {
        for (int i = 0; i < bigchars.length; i++) {
            bigchars[i].print();
        }
    }
}
