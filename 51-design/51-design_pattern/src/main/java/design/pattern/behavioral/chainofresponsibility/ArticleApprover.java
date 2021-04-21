package design.pattern.behavioral.chainofresponsibility;

import org.apache.commons.lang3.StringUtils;

/**
 * 手记的批准者
 */
public class ArticleApprover extends Approver {

    @Override
    public void deploy(Course course) {
        if (StringUtils.isNoneEmpty(course.getArticle())) {
            System.out.println(course.getName() + "含有手记，批准");
            if (approver != null) {
                // 交给下一个审批者校验
                approver.deploy(course);
            }
        } else {
            System.out.println(course.getName() + "不含有手记，不批准，流程结束");
            return;
        }
    }
}
