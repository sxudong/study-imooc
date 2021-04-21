package design.pattern.behavioral.observer;

public class Test {
    public static void main(String[] args) {
        Course course = new Course("Java设计模式精讲");
        Teacher teacher1 = new Teacher("Alpha");
        Teacher teacher2 = new Teacher("Beta");

        course.addObserver(teacher1);
        course.addObserver(teacher2);

        // 业务逻辑代码
        Question question = new Question();
        question.setUserName("ldc");
        question.setQuestionContent("Java的主函数如何编写");

        // 触发事件
        course.produceQuestion(course, question);
    }
}
/* Output:
ldc 在 Java设计模式精讲 提交了一个问题
Beta 老师的 Java设计模式精讲 课程接收到一个 ldc 同学提交的问答：Java的主函数如何编写
Alpha 老师的 Java设计模式精讲 课程接收到一个 ldc 同学提交的问答：Java的主函数如何编写
*///~