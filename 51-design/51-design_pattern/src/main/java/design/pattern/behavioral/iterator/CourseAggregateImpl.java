package design.pattern.behavioral.iterator;

import java.util.ArrayList;
import java.util.List;

/**
 * 具体的课程容器
 */
public class CourseAggregateImpl implements CourseAggregate {

    //容纳对象的容器
    private List courseList;

    public CourseAggregateImpl() {
        this.courseList = new ArrayList();
    }

    @Override
    public void addCourse(Course course) {
        courseList.add(course);
    }

    @Override
    public void removeCourse(Course course) {
        courseList.remove(course);
    }

    // 返回迭代器对象
    @Override
    public CourseIterator getCourseIterator() {
        return new CourseIteratorImpl(courseList);
    }
}
