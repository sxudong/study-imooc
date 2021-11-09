package com.SpringSourceAnalysis.ch04.customtag;

import org.springframework.beans.factory.xml.NamespaceHandlerSupport;

/**
 * 4.1 自定义标签使用  《Spring源码深度解析》P69
 * 创建一个 Handler 文件，扩展自 NamespaceHandlerSupport，目的是将组件注册到 Spring 容器。
 */
public class MyNamespaceHandler extends NamespaceHandlerSupport {
    @Override
    public void init() {
        registerBeanDefinitionParser("user", new UserBeanDefinitionParser());
    }
}
