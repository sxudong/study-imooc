package design.pattern.creational.singleton.imooic7;

/**
 * 《Effective Java》推荐的枚举单例
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

    // ObjectInputStream#readObject()
    // -> readObject0(false){
    //         switch (tc)
    //            case TC_ENUM:
    //               return checkResolve(readEnum(unshared));
    //    }
    // -> readEnum() {
    //       String name = readString(false);获取到枚举对象的名称，
    //       再通过类型和 name 来获得枚举常量，因为枚举中的name是唯一的
    //       Enum<?> en = Enum.valueOf((Class)cl, name); // 这样就没有创建新的对象，维持了这个对象的单例属性
    //    }
    public static void main(String[] args) {
        EnumInstance instance = EnumInstance.getInstance();
        instance.printTest(); // Geely Print Test
    }
}
