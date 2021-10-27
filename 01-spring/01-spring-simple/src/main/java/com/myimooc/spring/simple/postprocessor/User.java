package com.myimooc.spring.simple.postprocessor;


/**
 * Bean生命周期
 *
 * 视频：3-2 Spring Bean装配之Bean的生命周期
 * 在 BeanLifecycleTest 中单元测试
 */
public class User {

    private String name;
    private String sex;

    public void start() {
        System.out.println("Bean start .");
    }

    public void stop() {
        System.out.println("Bean stop.");
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }
}
