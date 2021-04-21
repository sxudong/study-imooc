package design.pattern.structural.flyweight.A1;

import java.util.HashMap;

/**
 * BigCharFactory类是生成BigChar类的实例的工厂。它实现了共享实例的功能。
 *
 * FlyweightFactory 轻量级工厂
 * FlyweightFactory角色 是生成 Flyweight角色 的工厂。在工厂中生成 Flyweight角色可以实现共享实例。
 */
public class BigCharFactory {
    // 管理已经生成的BigChar的实例
    private HashMap pool = new HashMap();
    // Singleton模式
    private static BigCharFactory singleton = new BigCharFactory();
    // 构造函数
    private BigCharFactory() {
    }
    // 获取唯一的实例
    public static BigCharFactory getInstance() {
        return singleton;
    }
    // 生成（共享）BigChar类的实例
    public synchronized BigChar getBigChar(char charname) {
        BigChar bc = (BigChar)pool.get("" + charname);
        if (bc == null) {
            bc = new BigChar(charname); // 生成BigChar的实例
            pool.put("" + charname, bc);
        }
        return bc;
    }
}
