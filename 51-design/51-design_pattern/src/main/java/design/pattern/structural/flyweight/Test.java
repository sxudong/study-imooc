package design.pattern.structural.flyweight;

/**
 * 第13章 享元模式
 *
 *  享元模式，一言以蔽之就是“通过尽量共享实例来避免new出实例”。当需要某个
 *  实例时，并不总是通过new关键字来生成实例，而是尽量共和已经存在的实例。
 */
public class Test {
    private static final String departments[] = {"RD", "QA", "PM", "BD"};

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            // 随机调取部门经理做报告
            String department = departments[(int) (Math.random() * departments.length)];
            Manager manager = (Manager) EmployeeFactory.getManager(department);
            manager.report();
        }

        /** Integer源码：
         *  public static Integer valueOf(int i) {
         *      //-128 ~ 127
         *      if (i >= IntegerCache.low && i <= IntegerCache.high)
         *          return IntegerCache.cache[i + (-IntegerCache.low)];
         *      return new Integer(i);
         *  }
         */
        // a和b是同一个对象，在缓存范围里，并不会new对象
        Integer a = Integer.valueOf(100);
        Integer b = 100;

        Integer c = Integer.valueOf(1000);
        Integer d = 1000;

        System.out.println("a==b:"+(a==b));  //true 同一个对象
        System.out.println("c==d:"+(c==d));  //false 不是同一个对象
    }
}
/* Output:
创建部门经理:PM
 创建报告:PM部门汇报:此次报告的主要内容是......
PM部门汇报:此次报告的主要内容是......
创建部门经理:RD
 创建报告:RD部门汇报:此次报告的主要内容是......
RD部门汇报:此次报告的主要内容是......
创建部门经理:QA
 创建报告:QA部门汇报:此次报告的主要内容是......
QA部门汇报:此次报告的主要内容是......
QA部门汇报:此次报告的主要内容是......
PM部门汇报:此次报告的主要内容是......
PM部门汇报:此次报告的主要内容是......
创建部门经理:BD
 创建报告:BD部门汇报:此次报告的主要内容是......
BD部门汇报:此次报告的主要内容是......
PM部门汇报:此次报告的主要内容是......
BD部门汇报:此次报告的主要内容是......
BD部门汇报:此次报告的主要内容是......
a==b:true
c==d:false
*///~