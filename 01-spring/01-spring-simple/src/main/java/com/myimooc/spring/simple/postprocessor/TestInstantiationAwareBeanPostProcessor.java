package com.myimooc.spring.simple.postprocessor;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class TestInstantiationAwareBeanPostProcessor {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext-Instantion.xml");
        BeanTest bean = ctx.getBean("bean", BeanTest.class) ;
        //bean.setName("原始值");
        String name = bean.getName(); //getName()方法会进入到方法拦截里面去
        System.out.println(name);
    }
}
/* Output:
beanName:bean执行..postProcessBeforeInstantiation 方法
执行构造函数
执行 postProcessAfterInitialization...
调用 getName 方法
被替换掉啦
*///~

/* 正常情况：
beanName: bean执行..postProcessBeforeInstantiation 方法
执行构造函数
beanName: bean执行..postProcessAfterInstantiation 方法
beanName: postProcessProperties 执行postProcessProperties...
执行初始化前 postProcessBeforeInitialization...
执行初始化后 postProcessAfterInitialization...
原始值
*///~