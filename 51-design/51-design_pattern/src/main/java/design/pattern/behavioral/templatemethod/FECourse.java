package design.pattern.behavioral.templatemethod;

/**
 * 前端课程（具体类）
 */
public class FECourse extends ACourse {
    private boolean needWriteArticleFlag = false;

    // needWriteArticleFlag 开放给应用层，是否需要编写手记？
    public FECourse(boolean needWriteArticleFlag) {
        this.needWriteArticleFlag = needWriteArticleFlag;
    }

    @Override
    void packageCourse() {
        System.out.println("提供课程的前端代码");
        System.out.println("提供课程的图片等多媒体素材");
    }

    // 是否需要编写手记？默认false（父类中的钩子方法）
    @Override
    protected boolean needWriteArticle() {
        return this.needWriteArticleFlag;
    }
}
