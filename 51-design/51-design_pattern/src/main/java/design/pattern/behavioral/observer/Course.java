package design.pattern.behavioral.observer;

import java.util.Observable;

/**
 * 课程
 *
 * 如果继承了 Observable（可观察的），Course就变成被观察对象。
 *
 * Observable 类中方法：
 *   addObserver(Observer o) 添加观察者
 *   deleteObserver(Observer o) 删除观察者
 *   setChanged()               状态发生改变
 *   notifyObservers(Object arg) 通知观察者
 *
 */
public class Course extends Observable {
    private String courseName;

    public Course(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseName() {
        return courseName;
    }

    // 生产一个问题
    public void produceQuestion(Course course, Question question) {
        System.out.println(question.getUserName() + " 在 " + course.getCourseName() + " 提交了一个问题 ");
        setChanged(); // 状态发生改变
        notifyObservers(question); // 通知
    }
}