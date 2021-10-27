package com.myimooc.spring.simple.beanannotation;


import com.myimooc.spring.simple.base.UnitTestBase;
import com.myimooc.spring.simple.beanannotation.javabased.MyDriverManager;
import com.myimooc.spring.simple.beanannotation.javabased.Store;
import com.myimooc.spring.simple.beanannotation.javabased.StringStore;

import com.myimooc.spring.simple.beanannotation.javabased.TestBean;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * 基于Java配置测试
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class JavaBasedTest extends UnitTestBase {

    public JavaBasedTest() {
        super("spring-beanannotation.xml");
    }

    /**
     * 视频：4-5 Spring Bean装配之Java的容器注解说明 —— @Bean
     * 测试类：com.myimooc.spring.simple.beanannotation.javabased.StoreConfig
     */
    @Test
    public void test() {
        Store store = super.getBean("stringStore", Store.class);
        System.out.println(store.getClass().getName());
    } /* Output:
    com.myimooc.spring.simple.beanannotation.javabased.StringStore
    *///~


    /**
     * 视频：4-6 Spring Bean装配之Java的容器注解说明 —— @ImportResource 和 @Value
     * 测试类：com.myimooc.spring.simple.beanannotation.javabased.StoreConfig
     */
    @Test
    public void testMyDriverManager() {
        MyDriverManager manager = super.getBean("myDriverManager", MyDriverManager.class);
        System.out.println(manager.getClass().getName());
    }/*Output:
    url : 127.0.0.1
    userName: root
    password: root
    com.myimooc.spring.simple.beanannotation.javabased.MyDriverManager
    *///~

    /**
     * 视频：4-7 Spring Bean装配之Java的容器注解说明 —— @Bean 和 @Scope
     * 测试类：com.myimooc.spring.simple.beanannotation.javabased.StoreConfig
     */
    @Test
    public void testScope() {
        Store store = super.getBean("stringStore", Store.class);
        System.out.println(store.hashCode());

        store = super.getBean("stringStore", Store.class);
        System.out.println(store.hashCode());
    } /* Output:
    164332069
    1991278377
    *///~

    /**
     * 视频：4-8 Spring Bean装配之基于Java的容器注解说明 —— 基于"泛型"的自动装配
     * 测试类：com.myimooc.spring.simple.beanannotation.javabased.StoreConfig
     */
    @Test
    public void testG() {

        /* 报错：
         * Error creating bean with name 'storeConfig': Unsatisfied dependency expressed through field 's1';
         * nested exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException:
         *   No qualifying bean of type 'com.myimooc.spring.simple.beanannotation.javabased.Store<java.lang.String>'available:
         *   expected single matching bean but found 2: stringStore,stringStoreTest
         */
        //StringStore store = super.getBean("stringStoreTest");
        TestBean testBean = super.getBean("stringStoreTest");
    } /* Output:
    s1 : com.myimooc.spring.simple.beanannotation.javabased.StringStore
    s2 : com.myimooc.spring.simple.beanannotation.javabased.IntegerStore
    *///~

}
