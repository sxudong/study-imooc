package design.pattern.creational.prototype.clone;

import java.util.Date;

/**
 * 具体的原型
 */
public class Pig implements Cloneable{
    private String name;
    private Date birthday;

    public Pig(String name, Date birthday) {
        this.name = name;
        this.birthday = birthday;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        // 调用父类的克隆方法
        Pig pig = (Pig) super.clone();

        // 深克隆
        //pig.birthday = (Date) this.getBirthday().clone();
        //pig.birthday = (Date) this.birthday.clone();
        pig.birthday = (Date) pig.birthday.clone();
        return pig;
    }

    @Override
    public String toString() {
        return "Pig{" +
                "name='" + name + '\'' +
                ", birthday=" + birthday +
                '}'+super.toString();
    }
}
