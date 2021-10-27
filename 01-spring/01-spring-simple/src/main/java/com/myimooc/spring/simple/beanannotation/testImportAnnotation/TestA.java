package com.myimooc.spring.simple.beanannotation.testImportAnnotation;

/**
 * 普通的类
 * 单元测试类：com.myimooc.spring.simple.testImportAnnotation.ImportAnnotionTest
 */
public class TestA {

    public void fun(String str) {
        System.out.println(str);
    }

    public void printName() {
        System.out.println("类名 ：" + Thread.currentThread().getStackTrace()[1].getClassName());
    }
}
