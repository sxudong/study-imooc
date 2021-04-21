package design.pattern.creational.prototype.imooic;

/**
 * 具体原型
 *
 * clone() 定义在 java.lang.Object中。因为 Object类是所有Java类的父类，
 * 因此所有的Java类都继承了clone方法。
 */
public class Mail implements Cloneable {
    private String name;
    private String emailAddress;
    private String content;

    public Mail(){
        System.out.println("Mail Class Constructor");
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "Mail{" +
                "name='" + name + '\'' +
                ", emailAddress='" + emailAddress + '\'' +
                ", content='" + content + '\'' +
                '}'+super.toString();
    }

    // 浅复制
    @Override
    protected Object clone() throws CloneNotSupportedException {
        System.out.println("clone mail object");
        return super.clone();
    }
}
