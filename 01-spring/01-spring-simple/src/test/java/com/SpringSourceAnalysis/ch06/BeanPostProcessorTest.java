package com.SpringSourceAnalysis.ch06;

import com.SpringSourceAnalysis.ch06.applicationContext.test.Dog;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.core.io.ClassPathResource;


/**
 * 10--Spring BeanPostProcessor和 BeanFactoryPostProcessor 的区别
 * 在 bean 未实例化之前修改属性
 *
 * 参考简书示例：https://www.jianshu.com/p/81349bb9859d
 */
public class BeanPostProcessorTest {
    private XmlBeanFactory xmlBeanFactory;

    @Before
    public void initXmlBeanFactory() {
        System.setProperty("spring.profiles.active", "dev");
        System.out.println("\n========测试方法开始=======\n");
        xmlBeanFactory = new XmlBeanFactory(new ClassPathResource("META-INF/day02.xml"));
    }

    @After
    public void after() {
        System.out.println("\n========测试方法结束=======\n");
    }

    /**
     * 测试时注释掉 BeanFactoryPostProcessor 的 Bean
     */
    @Test
    public void test1() {
        // 测试 BeanPostProcessor
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("META-INF/day02.xml");
        Dog dog = applicationContext.getBean("dog", Dog.class);
        dog.sayHello();
    }


    /**
     * 测试时注释掉 BeanPostProcessor 的 Bean
     */
    @Test
    public void test2() {
        // 测试 BeanFactoryPostProcessor
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("META-INF/day02.xml");
        Dog dog = applicationContext.getBean("dog", Dog.class);
        dog.sayHello();
    }
    /* Output:
    ========测试方法开始=======
    BeanFactoryPostProcessor第0次被调动
    dog属性值:PropertyValues: length=0
    修改dog的作用域为prototype

    BeanFactoryPostProcessor第1次被调动
    大家好，我叫小明, 我今年3岁了

    ========测试方法结束=======
     *///~

    /**
     * 使用自定义 BeanFactoryPostProcessor
     * 《Spring源码深度解析》6.6.1 激活注册的BeanFactoryPostProcessor p148
     */
    @Test
    public void testPropertyConfigurer(){
        ConfigurableListableBeanFactory bf = new XmlBeanFactory(new ClassPathResource("META-INF/BeanFactory.xml"));
        BeanFactoryPostProcessor bfpp = (BeanFactoryPostProcessor) bf.getBean("bfpp");
        bfpp.postProcessBeanFactory(bf);
        System.out.println(bf.getBean("simpleBean"));
    }
    /* Output:
    SimplePostProcessor{connectionString='*****', username='*****', password='imaginecup'}
    *///~
}
