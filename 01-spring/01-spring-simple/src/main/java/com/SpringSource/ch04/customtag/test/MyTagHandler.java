package com.SpringSource.ch04.customtag.test;

import org.springframework.beans.factory.xml.NamespaceHandlerSupport;

/**
 * 对自定义标签进行初始化，让程序可以识别 sue:user 标签
 * 单元测试类：MyTagTest
 * https://cloud.tencent.com/developer/article/1718111
 */
public class MyTagHandler extends NamespaceHandlerSupport {
    @Override
    public void init() {
        registerBeanDefinitionParser("user", new UserBeanDefinitionParser());
    }
}