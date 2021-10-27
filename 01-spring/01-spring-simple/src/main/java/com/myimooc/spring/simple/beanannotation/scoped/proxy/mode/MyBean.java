package com.myimooc.spring.simple.beanannotation.scoped.proxy.mode;

import org.springframework.beans.factory.annotation.Autowired;


/**
 * 视频：4-7 Spring Bean装配之Java的容器注解说明 —— @Bean 和 @Scope
 * 单元测试类：TestScopeProxyBean
 */
public class MyBean {
    @Autowired
    private ScopeProxyBean proxyBean;
 
    public void test(){
        proxyBean.code();
    }
}