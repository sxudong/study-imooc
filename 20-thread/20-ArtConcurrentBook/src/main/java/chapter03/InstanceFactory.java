package chapter03;

public class InstanceFactory {
    // 静态内部类
    private static class InstanceHolder {
        public static Instance instance = new Instance();
    }

    public static Instance getInstance() {
        //这里将导致InstanceHolder类被初始化
        return InstanceHolder.instance;
    }

    static class Instance {
    }
}
