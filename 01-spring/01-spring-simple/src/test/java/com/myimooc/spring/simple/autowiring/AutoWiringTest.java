package com.myimooc.spring.simple.autowiring;

import com.myimooc.spring.simple.base.UnitTestBase;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * 自动注入测试
 *
 * 视频：3-4 Spring Bean 装配之自动装配
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class AutoWiringTest extends UnitTestBase {

    public AutoWiringTest() {
        super("spring-autowiring.xml");
    }

    @Test
    public void testSay() {
        AutoWiringService service = super.getBean("autoWiringService", AutoWiringService.class);
        service.say(" this is a test");
    }/* Output:
        AutoWiringService                 //在AutoWiringService的构造器中注入时打印
        AutoWiringDao :  this is a test   //方法中调用了autoWiringDAO的say()方法
     *///~

}
