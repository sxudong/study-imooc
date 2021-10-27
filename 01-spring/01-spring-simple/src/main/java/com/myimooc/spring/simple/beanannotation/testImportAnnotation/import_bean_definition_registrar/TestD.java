package com.myimooc.spring.simple.beanannotation.testImportAnnotation.import_bean_definition_registrar;

public class TestD {
    public void fun(String str) {
        System.out.println(str);
    }

    public void printName() {
        System.out.println("类名 ：" + Thread.currentThread().getStackTrace()[1].getClassName());
    }
}
