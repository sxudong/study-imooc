package com.SpringSourceAnalysis.ch03.replacemethod;

import org.springframework.beans.factory.support.MethodReplacer;

import java.lang.reflect.Method;

/**
 * 5．解析子元素 replaced-method
 * 《Spring源码深度解析》P46
 */
public class TestMethodReplacer implements MethodReplacer {

    @Override
    public Object reimplement(Object obj, Method method, Object[] args) throws Throwable {
        System.out.println("我替换了原有的方法!");
        return null;
    }
}
