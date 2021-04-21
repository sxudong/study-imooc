package design.pattern.behavioral.iterator;

/**
 * 18-2 迭代器模式coding
 *
 * java.util.Iterator
 * public interface Iterator<E> {
 *     boolean hasNext();
 *     E next();
 * }
 */
public class Test {
    public static void main(String[] args) {
        Course course1 = new Course("Java电商一期");
        Course course2 = new Course("Java电商二期");
        Course course3 = new Course("Java设计模式精讲");
        Course course4 = new Course("Python课程");
        Course course5 = new Course("算法课程");
        Course course6 = new Course("前端课程");

        CourseAggregate courseAggregate = new CourseAggregateImpl();
        courseAggregate.addCourse(course1);
        courseAggregate.addCourse(course2);
        courseAggregate.addCourse(course3);
        courseAggregate.addCourse(course4);
        courseAggregate.addCourse(course5);
        courseAggregate.addCourse(course6);
        System.out.println("-----课程列表-----");
        printCourses(courseAggregate);

        System.out.println();

        courseAggregate.removeCourse(course4);
        courseAggregate.removeCourse(course5);
        System.out.println("-----删除操作之后的课程列表-----");
        printCourses(courseAggregate);
    }

    public static void printCourses(CourseAggregate courseAggregate) {
        // 拿到课程迭代器
        CourseIterator courseIterator = courseAggregate.getCourseIterator();
        while (!courseIterator.isLastCourse()) {
            Course course = courseIterator.nextCourse();
            System.out.println(course.getName());
        }
    }

}
/* Output:
-----课程列表-----
返回课程,位置是: 0
Java电商一期
返回课程,位置是: 1
Java电商二期
返回课程,位置是: 2
Java设计模式精讲
返回课程,位置是: 3
Python课程
返回课程,位置是: 4
算法课程
返回课程,位置是: 5
前端课程

-----删除操作之后的课程列表-----
返回课程,位置是: 0
Java电商一期
返回课程,位置是: 1
Java电商二期
返回课程,位置是: 2
Java设计模式精讲
返回课程,位置是: 3
前端课程
*///~