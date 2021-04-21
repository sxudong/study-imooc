package design.principle.liskovsubstitution;

import java.util.HashMap;

/**
 * 代码清单2-13 场景类源代码
 * ——《设计之禅》
 */
//public class Client {
//    public static void invoker() {
//        //父类存在的地方， 子类就应该能够存在
//        Father f = new Father();
//        HashMap map = new HashMap();
//        f.doSomething(map);
//    }
//
//    public static void main(String[] args) {
//        invoker();
//    }
//}
/* output:
父类被执行...
*/

/**
 * 代码清单2-14 子类替换父类后的源代码
 * ——《设计之禅》
 */
public class Client {
    public static void invoker() {
        //父类存在的地方， 子类就应该能够存在
        Son f = new Son();
        HashMap map = new HashMap();
        f.doSomething(map);
    }

    public static void main(String[] args) {
        invoker();
    }
}
/* output:
父类被执行...
*/