package design.pattern.behavioral.visitor;

public interface IVisitor {
    // 访问方法中的参数是不同的对象，不同的对象访问的结果不一样
    void visit(FreeCourse freeCourse);
    void visit(CodingCourse codingCourse);
}
