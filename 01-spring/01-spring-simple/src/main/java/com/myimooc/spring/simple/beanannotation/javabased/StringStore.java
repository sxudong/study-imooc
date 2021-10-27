package com.myimooc.spring.simple.beanannotation.javabased;

/**
 * 字符串仓库
 *
 * 视频：4-1 Spring Bean装配之Bean的定义及作用域的注解实现
 */
public class StringStore implements Store<String> {

    public void init() {
        System.out.println("This is init.");
    }

    public void destroy() {
        System.out.println("This is destroy.");
    }

}
