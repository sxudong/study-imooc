package design.pattern.behavioral.visitor;

import design.pattern.behavioral.templatemethod.java.util.ArrayList;
import java.util.List;

/**
 * 26-2 访问者模式
 *
 * 大多数情况下不使用 java.nio.FileVisitor
 */
public class Test {
    public static void main(String[] args) {
        List<Course> courseList = new ArrayList<>();

        FreeCourse freeCourse = new FreeCourse();
        freeCourse.setName("SpringMVC数据绑定");

        CodingCourse codingCourse = new CodingCourse();
        codingCourse.setName("Java设计模式精讲 -- By Geely");
        codingCourse.setPrice(299);

        courseList.add(freeCourse); // 接受免费课程对象访问
        courseList.add(codingCourse); // 接受实战课程对象访问

        for (Course course : courseList) {
            course.accept(new Visitor());
        }
    }
}
/* Output:
免费课程：SpringMVC数据绑定
实战课程：Java设计模式精讲 -- By Geely 价格：299
*///~