package com.SpringSourceAnalysis.ch03.lookupMethod.bean;

/**
 * 4.解析子元素 lookup-method
 * 《Spring源码深度解析》P44
 */
public class Student extends User {


    @Override
    public void showMe() {
        System.out.println("i am student");
    }
}
