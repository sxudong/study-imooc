package com.learn.test;

import org.apache.catalina.LifecycleException;

import javax.servlet.ServletException;

/**
 * 在 Spring 源码项目中创建使用 SpringMVC 功能模块
 * https://www.cnblogs.com/wk-missQ1/p/13283985.html
 */
public class Test {
    public static void main(String[] args) {
        try {
            SpringApplicationWk.run();
        } catch (ServletException e) {
            e.printStackTrace();
        } catch (LifecycleException e) {
            e.printStackTrace();
        }
    }
}