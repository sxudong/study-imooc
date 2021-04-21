package design.pattern.creational.singleton;

/**
 * 8-8 单例设计模式-Enum枚举单例、原理源码解析以及反编译实战
 */
public enum EnumInstance {
    INSTANCE {
        protected  void printTest(){
            System.out.println("Geely Print Test");
        }
    };
    protected abstract void printTest();
    private Object data;

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
    public static EnumInstance getInstance(){
        return INSTANCE;
    }

    public static void main(String[] args) {
        EnumInstance instance = EnumInstance.getInstance();
        instance.printTest(); // Geely Print Test
    }
}
