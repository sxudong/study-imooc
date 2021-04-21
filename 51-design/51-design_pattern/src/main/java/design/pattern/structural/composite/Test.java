package design.pattern.structural.composite;

/**
 * 14-2 组合模式coding
 *
 * 能够使容器与内容具有一致性，创建出递归的模式就是 Composite模式。
 */
public class Test {
    public static void main(String[] args) {
        CatalogComponent imoocMainCourseCatalog = new CourseCatalog("慕课网课程主目录",1); // 一级目录
        CatalogComponent javaCourseCatalog = new CourseCatalog("Java课程目录",2); // 二级目录

        // 添加一级目录下的课程
        CatalogComponent linuxCourse = new Course("Linux课程",11);
        CatalogComponent windowsCourse = new Course("Windows课程",11);
        imoocMainCourseCatalog.add(linuxCourse);
        imoocMainCourseCatalog.add(windowsCourse);


        // 添加二级目录及下面的课程
        imoocMainCourseCatalog.add(javaCourseCatalog);
        CatalogComponent mmallCourse1 = new Course("Java电商一期",55);
        CatalogComponent mmallCourse2 = new Course("Java电商二期",66);
        CatalogComponent designPattern = new Course("Java设计模式",77);
        javaCourseCatalog.add(mmallCourse1);
        javaCourseCatalog.add(mmallCourse2);
        javaCourseCatalog.add(designPattern);

        imoocMainCourseCatalog.print();
    }
}
/* Output:
慕课网课程主目录
  Course Name:Linux课程 Price:11.0
  Course Name:Windows课程 Price:11.0
  Java课程目录
    Course Name:Java电商一期 Price:55.0
    Course Name:Java电商二期 Price:66.0
    Course Name:Java设计模式 Price:77.0
*///~