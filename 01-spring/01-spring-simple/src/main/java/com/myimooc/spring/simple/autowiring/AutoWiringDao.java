package com.myimooc.spring.simple.autowiring;

/**
 * DAO
 *
 * 视频：3-4 Spring Bean 装配之自动装配
 * 单元测试类：AutoWiringTest.java
 */
public class AutoWiringDao {

    public void say(String word) {
        System.out.println("AutoWiringDao : " + word);
    }

}
