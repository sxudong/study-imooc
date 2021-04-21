package design.pattern.behavioral.templatemethod;

/**
 * 设计课程 （具体类）
 */
public class DesignPatternCourse extends ACourse {
    @Override
    void packageCourse() {
        System.out.println("提供课程Java源代码");
    }

    // 需要编写手记（父类中的钩子方法）
    @Override
    protected boolean needWriteArticle() {
        return true;
    }
}
