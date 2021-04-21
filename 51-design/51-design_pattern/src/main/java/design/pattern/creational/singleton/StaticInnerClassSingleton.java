package design.pattern.creational.singleton;

/**
 * 8-4 单例设计模式-静态内部类-基于类初始化的延迟加载解决方案及原理解析
 * Java 静态内部类的加载时机：https://www.cnblogs.com/zouxiangzhongyan/p/10762540.html
 */
public class StaticInnerClassSingleton {
    // 静态内部类
    private static class InnerClass{
        private static StaticInnerClassSingleton staticInnerClassSingleton =
                                                    new StaticInnerClassSingleton();
    }

    public static StaticInnerClassSingleton getInstance(){
        return InnerClass.staticInnerClassSingleton;
    }

    // 私有构造器
    private StaticInnerClassSingleton(){
        if(InnerClass.staticInnerClassSingleton != null){
            throw new RuntimeException("单例构造器禁止反射调用");
        }
    }
}
