package com.myimooc.spring.simple.beanannotation;

import com.myimooc.spring.simple.base.UnitTestBase;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * 使用 @Component 测试
 * 视频：4-1 Spring Bean装配之Bean的定义及作用域的注解实现
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class BeanAnnotationTest extends UnitTestBase {

    public BeanAnnotationTest() {
        super("classpath*:spring-beanannotation.xml");
    }

    /**
     * 测试获取 Bean
     */
    @Test
    public void testSay() {
        BeanAnnotation bean = super.getBean("beanAnnotation", BeanAnnotation.class);
        bean.say("This is test.");

        bean = super.getBean("beanAnnotation", BeanAnnotation.class);
        bean.say("This is test.");
    } /* Output:
    JsrService init.                 //测试 JsrService类注解定义的初始方法
    BeanAnnotation : This is test.   //Bean的名称是类的名字，首字母小写
    BeanAnnotation : This is test.
    JsrService destroy.              //测试 JsrService类注解定义的销毁方法
    *///~

    /**
     * 测试 Bean 的作用域
     */
    @Test
    public void testScpoe() {
        BeanAnnotation bean = super.getBean("beanAnnotation", BeanAnnotation.class);
        bean.myHashCode();

        bean = super.getBean("beanAnnotation", BeanAnnotation.class);
        bean.myHashCode();
    } /* Output:
    JsrService init.
    BeanAnnotation : 2144838275
    BeanAnnotation : 2144838275  //容器中只有一个Bean
    JsrService destroy.
    *///~

}
