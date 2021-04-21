package design.pattern.behavioral.templatemethod;

/**
 * 课程（抽象类）
 */
public abstract class ACourse {

    // 制作课程
    protected final void makeCourse() {
        this.makePPT();
        this.makeVideo();
        if (needWriteArticle()) {
            this.writeArticle();
        }
        this.packageCourse(); // 交给子类实现
    }

    // final修饰是不可以重写的方法
    final void makePPT() {
        System.out.println("制作PPT");
    }

    final void makeVideo() {
        System.out.println("制作视频");
    }

    final void writeArticle() {
        System.out.println("编写手记");
    }

    // 钩子方法
    protected boolean needWriteArticle() { // 是否需要编写手记？
        return false;
    }

    // 抽象方法
    abstract void packageCourse();
}
