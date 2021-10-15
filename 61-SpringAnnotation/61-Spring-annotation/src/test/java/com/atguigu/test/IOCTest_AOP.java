package com.atguigu.test;

import com.atguigu.AopTargetUtils;
import com.atguigu.aop.Blue;
import org.junit.Test;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.atguigu.aop.MathCalculator;
import com.atguigu.bean.Boss;
import com.atguigu.bean.Car;
import com.atguigu.bean.Color;
import com.atguigu.bean.Red;
import com.atguigu.config.MainConfigOfAOP;
import com.atguigu.config.MainConifgOfAutowired;
import com.atguigu.dao.BookDao;
import com.atguigu.service.BookService;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/** applicationContext.getBean(Blue.class);
public abstract class AbstractBeanFactory extends FactoryBeanRegistrySupport implements ConfigurableBeanFactory {

    private final Map<String, Object> singletonObjects = new ConcurrentHashMap<String, Object>(256);

    @Override
    public Object getSingleton(String beanName) {
        return getSingleton(beanName, true);
    }

    protected Object getSingleton(String beanName, boolean allowEarlyReference) {

        // 从 singletonObject 中取出单便对象
        Object singletonObject = this.singletonObjects.get(beanName);

        if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
            synchronized (this.singletonObjects) {
                singletonObject = this.earlySingletonObjects.get(beanName);
                if (singletonObject == null && allowEarlyReference) {
                    ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                    if (singletonFactory != null) {
                        singletonObject = singletonFactory.getObject();
                        this.earlySingletonObjects.put(beanName, singletonObject);
                        this.singletonFactories.remove(beanName);
                    }
                }
            }
        }
        return (singletonObject != NULL_OBJECT ? singletonObject : null);
    }
*/
public class IOCTest_AOP {

	@Test
	public void test01() throws Exception {
		// 创建基于注解的 SpringIOC 容器
		AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfigOfAOP.class);
		//创建基于配置文件的 SpringIOC 容器
		//ApplicationContext xmlApplicationContext = new ClassPathXmlApplicationContext("/spring-beans.xml");

		// 无论哪种方式，最终都会调用 AbstractApplicationContext 的一个重要方法—— refresh()，首先来看这个方法的 Spring 源码



		//1、不要自己创建对象
//		MathCalculator mathCalculator = new MathCalculator();
//		mathCalculator.div(1, 1);
		MathCalculator mathCalculator = applicationContext.getBean(MathCalculator.class);
		Blue blue = applicationContext.getBean(Blue.class);

		System.out.println(mathCalculator);
		mathCalculator.div(1, 1);
		//mathCalculator.div(1, 0); // 测试异常通知

		MathCalculator targetSource = (MathCalculator)AopTargetUtils.getTarget(mathCalculator);
		System.out.println("targetSource："+targetSource);

		blue.init();

		applicationContext.close();
	} /*
		正常测试：
			div运行。。。@Before:参数列表是：{[1, 1]}
			MathCalculator...div...
			div结束。。。@After
			div正常返回。。。@AfterReturning:运行结果：{1}

		测试异常通知:
			div运行。。。@Before:参数列表是：{[1, 0]}
			MathCalculator...div...
			div结束。。。@After
			div异常。。。异常信息：{java.lang.ArithmeticException: / by zero}
	*///~
}

