package design.pattern.behavioral.observer;

/**
 * 问题
 */
public class Question {
    private String userName;
    private String questionContent; // 问题的内容

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getQuestionContent() {
        return questionContent;
    }

    public void setQuestionContent(String questionContent) {
        this.questionContent = questionContent;
    }
}
