package design.pattern.behavioral.templatemethod;

/**
 * 17-2 模板方法模式
 *
 * 在在父类中定义处理流程的框架，在子类中实现具体处理的模式称为 Template Method 模式。
 *
 * 优点：在父类的模板方法中编写了算法，因此无需在每个子类中再编写算法。
 *       在模板方法中发现Bug时，只需要修改模板方法即可解决问题。
 *
 * 缺点：在看不到父类的源代码的情况下，想要编写出子类是非常困难的。
 *
 * 哪些类使用了模板方法：
 * AbstractList抽象类中的 addAll 是模板方法，里面调用了 add(), add()需要子类实现。
 * ArrayList 里重写了 addAll()方法，所以不会调用父类 AbstractList 抽象类中的 addAll() 方法，
 * 如果测试删除 ArrayList 中的 addAll() 方法测试可以调用父类中的 addAll() 方法并调用子类的
 * add()方法，实现模板调用。
 *
 *     java.util.AbstractList
 *
 *     public boolean addAll(int index, Collection<? extends E> c) {
 *         rangeCheckForAdd(index);
 *         boolean modified = false;
 *         for (E e : c) {
 *             add(index++, e);   // 里面调用了 add(), add()需要子类实现
 *             modified = true;
 *         }
 *         return modified;
 *     }
 *
 *     // add()需要子类实现
 *     public void add(int index, E element) {
 *         throw new UnsupportedOperationException();
 *     }
 */
public class Test {
    public static void main(String[] args) {
        System.out.println("后端设计模式课程start---");
        ACourse designPatternCourse = new DesignPatternCourse();
        designPatternCourse.makeCourse();
        System.out.println("后端设计模式课程end---"+"\n");

        // 测试AbstractList抽象类中的addAll()模板方法
//        List<Object> list1 = new ArrayList<Object>();
//        list1.add(1);
//        list1.add(2);
//        List<Object> list2=new ArrayList<Object>();
//        list2.add(0);
//        list2.add(3);
//
//        list1.addAll(1, list2); //1表示在哪个位置添加元素

        System.out.println("前端课程start---");
        ACourse feCourse = new FECourse(false);
        feCourse.makeCourse();
        System.out.println("前端课程end---");
    }
}
/* Output:
后端设计模式课程start---
制作PPT
制作视频
编写手记
提供课程Java源代码
后端设计模式课程end---

前端课程start---
制作PPT
制作视频
提供课程的前端代码
提供课程的图片等多媒体素材
前端课程end---
*///~