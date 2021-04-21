package design.principle.liskovsubstitution;

import java.util.Collection;
import java.util.Map;

/**
 * 代码清单2-12 子类源代码
 * ——《设计之禅》
 */
public class Son extends Father {
    //放大输入参数类型
    public Collection doSomething(Map map) {
        System.out.println("子类被执行...");
        return map.values();
    }
}