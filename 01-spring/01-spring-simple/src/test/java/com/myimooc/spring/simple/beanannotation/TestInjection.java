package com.myimooc.spring.simple.beanannotation;

import com.myimooc.spring.simple.base.UnitTestBase;
import com.myimooc.spring.simple.beanannotation.injection.service.InjectionService;
import com.myimooc.spring.simple.beanannotation.multiple.BeanInvoker;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 *
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class TestInjection extends UnitTestBase {
	
	public TestInjection() {
		super("classpath:spring-beanannotation.xml");
	}

	/**
	 * 测试 InjectionServiceImpl类中使用的 Autowired 注解
	 * 视频：4-2 Spring Bean装配之 Autowired 注解说明-1
	 */
	@Test
	public void testAutowired() {
		InjectionService service = super.getBean("injectionServiceImpl", InjectionService.class);
		service.save("This is autowired.");
	} /* Output:
	Service接收参数：This is autowired.
	保存数据：This is autowired.:418179060
	*///~

	/**
	 * Autowired 用于装配 集合list
	 * Autowired 用于装配 key 为 String 的 Map
	 * 视频：4-3 Spring Bean装配之 Autowired 注解说明-2
	 */
	@Test
	public void testMultiBean() {
		BeanInvoker invoker = super.getBean("beanInvoker", BeanInvoker.class);
		invoker.say();
	} /* Output:
	list...          //通过list集合获取到Bean
	com.myimooc.spring.simple.beanannotation.multiple.BeanImplTwo   //@Order(1)
	com.myimooc.spring.simple.beanannotation.multiple.BeanImplOne   //@Order(2)

	map...           //通过map的key获取到Bean
	beanImplOne      com.myimooc.spring.simple.beanannotation.multiple.BeanImplOne  //通过map的key获取到Bean
	beanImplTwo      com.myimooc.spring.simple.beanannotation.multiple.BeanImplTwo

	com.myimooc.spring.simple.beanannotation.multiple.BeanImplTwo
	*///~
}
