package com.myimooc.spring.simple.ioc.interfaces;

import com.myimooc.spring.simple.base.UnitTestBase;
import com.myimooc.spring.simple.ioc.injection.service.InjectionService;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * Bean注入测试类
 *
 * 视频：2-2 Spring注入方式
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class InjectionTest extends UnitTestBase {

    public InjectionTest() {
        super("spring-injection.xml");
    }


    /**
     * 测试需打开 spring-injection.xml 配置文件的 设置值注入
     */
    @Test
    public void testSetter() {
        InjectionService service = super.getBean("injectionService", InjectionService.class);
        service.save("这是要保存的数据");
    } /* Output:
    Service接收参数：这是要保存的数据
    保存数据：这是要保存的数据:504858437
    *///~

    /**
     * 测试需打开 /resources/spring-injection.xml 配置文件的 构造器注入
     */
    @Test
    public void testCons() {
        InjectionService service = super.getBean("injectionService", InjectionService.class);
        service.save("这是要保存的数据");
    } /* Output:
    Service接收参数：这是要保存的数据
    保存数据：这是要保存的数据:504858437
    *///~

}
