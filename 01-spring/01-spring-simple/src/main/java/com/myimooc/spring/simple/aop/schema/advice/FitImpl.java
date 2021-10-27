package com.myimooc.spring.simple.aop.schema.advice;

/**
 * 接口实现
 *
 * 视频：5-6 Introductions应用
 * 单元测试类: TestAOPSchemaAdvice
 * 《Springp实战第4版》4.4.4 通过切面引入新的功能 P127
 */
public class FitImpl implements Fit {

    @Override
    public void filter() {
        System.out.println("FitImpl filter.");
    }
}
