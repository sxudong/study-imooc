package com.SpringSourceAnalysis.ch04.customtag.test;

/**
 * spring的自定义标签
 * https://cloud.tencent.com/developer/article/1718111
 */
public class User {

    private String id;
    private String name;
    private String password;
    private int age;
    private byte sex;

    public User(String id, String name, String password, int age, byte sex) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.age = age;
        this.sex = sex;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public byte getSex() {
        return sex;
    }

    public void setSex(byte sex) {
        this.sex = sex;
    }
}