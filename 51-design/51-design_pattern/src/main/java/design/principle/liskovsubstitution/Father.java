package design.principle.liskovsubstitution;

import java.util.Collection;
import java.util.HashMap;

/**
 * 代码清单2-11 Father类源代码
 */
public class Father {
    public Collection doSomething(HashMap map) {
        System.out.println("父类被执行...");
        return map.values();
    }
}