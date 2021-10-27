package com.myimooc.spring.simple.beanannotation.scoped.proxy.mode;

import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;


/**
 * Spring源码之@Scope注解中proxyMode属性理解
 * https://blog.csdn.net/geng2568/article/details/112874664
 *
 * 视频：4-7 Spring Bean装配之Java的容器注解说明 —— @Bean 和 @Scope
 * 单元测试类：TestScopeProxyBean.java
 */
//@Scope(value = DefaultListableBeanFactory.SCOPE_PROTOTYPE /*,proxyMode = ScopedProxyMode.TARGET_CLASS*/)
@Scope(value = DefaultListableBeanFactory.SCOPE_PROTOTYPE, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ScopeProxyBean {
    public void code() {
        System.out.println(this.hashCode());
    }
}