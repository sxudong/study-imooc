package com.myimooc.spring.simple.postprocessor;

import org.junit.Before;
import org.junit.Test;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class TestPostProcessor {
    AbstractApplicationContext ctx = null;
    @Before
    public void before() {
        System.out.println("》》》Spring ApplicationContext容器开始初始化了......");
        ctx = new ClassPathXmlApplicationContext(new String[]{"spring-post-processor.xml"});
        System.out.println("》》》Spring ApplicationContext容器初始化完毕了......");
    }

    @Test
    public void  test() {
        User user = (User) ctx.getBean("user");
        System.out.println(user.getName());
        ctx.registerShutdownHook();
    }

}
/* Output:
》》》Spring ApplicationContext容器开始初始化了......
后置处理器处理bean=【injectionDao】初始化后             //injectionDao“初始化方法前”被过滤
后置处理器处理bean=【user】初始化方法前
张三
Bean start .
后置处理器处理bean=【user】初始化方法后
》》》Spring ApplicationContext容器初始化完毕了......
李四                                               //在"初始化方法"前将默认名字修改
Bean stop.
*///~