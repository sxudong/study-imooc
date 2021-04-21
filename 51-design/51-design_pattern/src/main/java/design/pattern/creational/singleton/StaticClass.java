package design.pattern.creational.singleton;

/**
 * Java 静态内部类的加载时机
 *
 * https://www.cnblogs.com/zouxiangzhongyan/p/10762540.html
 */
public class StaticClass {
    public static long OUTER_DATE = System.currentTimeMillis();

    static {
        System.out.println("外部类静态块加载时间：" + System.currentTimeMillis());
    }

    public StaticClass() {
        System.out.println("外部类构造函数时间：" + System.currentTimeMillis());
    }

    static class InnerStaticClass {
        public static long INNER_STATIC_DATE = System.currentTimeMillis();

        static {
            System.out.println("静态内部类静态块加载时间：" + System.currentTimeMillis());
        }
    }

    class InnerClass {
        public long INNER_DATE = 0;

        public InnerClass() {
            INNER_DATE = System.currentTimeMillis();
        }
    }

    public static void main(String[] args) {


//        /**
//         * 1、当外部内静态变量被调用
//         * 从控制台打印的结果我们可以看到：外部静态变量调用时，外部内进行了加载（注：静态代码块在类被加载时执行）
//         * 并且执行了初始化操作（注：构造方法被调用），而静态内部类并没有被加载（注：静态内部类中的静态代码块没
//         * 有执行），且类的加载顺序必定会在初始化的前面，所有看到先执行了静态代码块中的代码，其次执行了构造方法
//         * 中的代码，完成上面两部后最后才打印出了静态变量
//         */
//        StaticClass outer1 = new StaticClass();
//        System.out.println("外部类静态变量加载时间：" + outer1.OUTER_DATE);
//        /* Output:
//            外部类静态块加载时间：1592872253570
//            外部类构造函数时间：1592872253570
//            外部类静态变量加载时间：1592872253570
//         */
//        System.out.println();
//
//        /**
//         * 2、非静态内部类变量调用时
//         * 从控制台打印的结果我们可以看到：非静态内部类变量被调用时的执行结果和外部静态变量被调用的结果一样，
//         * 并且静态内部类也没有被加载，出现这种情况也在预料之中，因为非静态内部类的初始化不许依赖于外部类，
//         * 如果想实例化一个非静态内部类，则必须先实例化外部类，所以我们就看到了上面的结果
//         */
//        StaticClass outer2 = new StaticClass();
//        System.out.println("非静态内部类加载时间" + outer2.new InnerClass().INNER_DATE);
//
//        System.out.println();

        /**
         * 3、静态内部类中的变量被调用时：
         *
         * 从控制台打印的结果我们可以看到：静态内部类的变量被调用时，我们可以看出外部类进行了加载（注：外部类中
         * 的静态代码块中的代码执行了），但是并没有被初始化（注：外部类的构造方法并没有执行），且静态内部类也完
         * 成了加载。
         */
        System.out.println("静态内部类加载时间：" + InnerStaticClass.INNER_STATIC_DATE);
        /* Output:
           外部类静态块加载时间：1592872041550
           静态内部类静态块加载时间：1592872041560
           静态内部类加载时间：1592872041560
         */

        /**
         * 得出结论：
         *
         * 有上面我们进行的测试可以得出结论，静态内部类和非静态内部类一样，都不会因为外部内的加载而加载，同时静态内
         * 部类的加载不需要依附外部类，在使用时才加载，不过在加载静态内部类的过程中也会加载外部类。
         */
    }
}