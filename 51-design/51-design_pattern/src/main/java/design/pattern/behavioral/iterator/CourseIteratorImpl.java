package design.pattern.behavioral.iterator;

import java.util.List;

/**
 * 课程具体迭代器
 */
public class CourseIteratorImpl implements CourseIterator {

    private List courseList;
    private int position; //定义当前游标
    private Course course;

    public CourseIteratorImpl(List courseList) {
        this.courseList = courseList;
    }

    // 下一个课程
    @Override
    public Course nextCourse() {
        System.out.println("返回课程,位置是: " + position);
        course = (Course) courseList.get(position);
        position++;
        return course;
    }

    //判断是否到达尾部
    @Override
    public boolean isLastCourse() {
        if (position < courseList.size()) {
            return false;
        }
        return true;
    }
}
