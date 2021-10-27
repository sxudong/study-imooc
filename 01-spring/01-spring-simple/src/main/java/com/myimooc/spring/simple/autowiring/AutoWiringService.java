package com.myimooc.spring.simple.autowiring;

/**
 * 服务
 *
 * 视频：3-4 Spring Bean 装配之自动装配
 * 单元测试类：AutoWiringTest.java
 */
public class AutoWiringService {

    private AutoWiringDao autoWiringDAO;

    public AutoWiringService(AutoWiringDao autoWiringDAO) {
        System.out.println("AutoWiringService");
        this.autoWiringDAO = autoWiringDAO;
    }

    public void setAutoWiringDAO(AutoWiringDao autoWiringDAO) {
        System.out.println("setAutoWiringDAO");
        this.autoWiringDAO = autoWiringDAO;
    }

    public void say(String word) {
        this.autoWiringDAO.say(word);
    }

}
