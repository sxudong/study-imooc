package com.myimooc.spring.simple.beanannotation.javabased;

/**
 * 驱动管理
 *
 * 视频：4-6 Spring Bean装配之Java的容器注解说明 —— @ImportResource 和 @Value
 * 单元测试类：JavaBasedTest.java
 */
public class MyDriverManager {

    public MyDriverManager(String url, String userName, String password) {
        System.out.println("url : " + url);
        System.out.println("userName: " + userName);
        System.out.println("password: " + password);
    }
}
