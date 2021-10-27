package com.myimooc.spring.simple.aop.api;

/**
 * 业务逻辑实现 (被代理对象，被增加对象)
 *
 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
 * 单元测试类：TestAOPAPI
 */
public class BizLogicImpl implements BizLogic {

    @Override
    public String save() {
        System.out.println("BizLogicImpl : BizLogicImpl save.");
        return "BizLogicImpl save.";
        // throw new RuntimeException();
    }
}
