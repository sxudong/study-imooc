package design.pattern.behavioral.mediator.imooic;

/**
 *
 */
public class User {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User(String name) {
        this.name = name;
    }

    public void sendMessage(String message) {
        // 使用中介者发送消息
        StudyGroup.showMessage(this, message);
    }
}
