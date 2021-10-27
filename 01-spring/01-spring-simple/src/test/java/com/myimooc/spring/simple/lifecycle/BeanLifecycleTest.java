package com.myimooc.spring.simple.lifecycle;


import com.myimooc.spring.simple.base.UnitTestBase;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * Bean生命周期测试
 * 视视频：3-2 Spring Bean装配之Bean的生命周期
 * 在 /resurces/spring-lifecycle.xml 中配置了bean
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class BeanLifecycleTest extends UnitTestBase {

    public BeanLifecycleTest() {
        super("spring-lifecycle.xml");
    }

    @Test
    public void test1() {
        super.getBean("beanLifeCycle", BeanLifeCycle.class);
        super.getBean(ExampleInitializingBean.class);
        super.getBean(ExampleDisposableBean.class);
    }

} /* Output:
Bean afterPropertiesSet.
Bean start .
com.myimooc.spring.simple.lifecycle.ExampleInitializingBean：initializing
com.myimooc.spring.simple.lifecycle.ExampleDisposableBean：destroy
Bean destroy.
Bean stop.
*///~
