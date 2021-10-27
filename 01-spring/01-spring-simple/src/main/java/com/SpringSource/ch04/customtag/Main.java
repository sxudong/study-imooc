package com.SpringSource.ch04.customtag;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 4.1 自定义标签使用  《Spring源码深度解析》P69
 *
 * spring.handlers 和 spring.schemas 默认位置是在工程的 META-INF/文件夹下
 */
public class Main {

    public static void main(String[] args) {
        ApplicationContext bf = new ClassPathXmlApplicationContext("test/customtag/test.xml");
        User user = (User) bf.getBean("testbean");
        System.out.println(user.getUserName() + "," + user.getEmail());
    }
}
/* Output:
aaa,bbb
*///~