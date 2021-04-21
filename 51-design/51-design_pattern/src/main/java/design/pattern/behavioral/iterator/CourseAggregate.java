package design.pattern.behavioral.iterator;

/**
 * 课程容器接口
 */
public interface CourseAggregate {
    // 添加课程
    void addCourse(Course course);
    // 删除课程
    void removeCourse(Course course);
    // 获得课程迭代器
    CourseIterator getCourseIterator();
}
