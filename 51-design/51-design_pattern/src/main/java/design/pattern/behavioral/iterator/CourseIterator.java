package design.pattern.behavioral.iterator;

/**
 * 课程迭代器接口
 */
public interface CourseIterator {
    // 下一个课程
    Course nextCourse();
    // 是最后一个课程吗
    boolean isLastCourse();
}
