package com.myimooc.spring.simple.beanannotation.javabased;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.*;

import java.util.List;

/**
 * 配置
 *
 * 视频：4-5 Spring Bean装配之Java的容器注解说明 —— @Bean
 * 单元测试类：JavaBasedTest.java
 *
 * 视频：4-6 Spring Bean装配之Java的容器注解说明 —— @ImportResource 和 @Value
 * 单元测试类：JavaBasedTest.java
 */
@Configuration
@ImportResource("classpath:config.xml")
public class StoreConfig {

//	@Value("${url}")
//	private String url;
//
//	@Value("${jdbc.username}")
//	private String username;
//
//	@Value("${password}")
//	private String password;
//
//	@Bean
//	public MyDriverManager myDriverManager() {
//		return new MyDriverManager(url, username, password);
//	}


//	@Bean(name = "stringStore", initMethod="init", destroyMethod="destroy")
//	public Store stringStore() {
//		return new StringStore();
//	}


	/**
	 * 视频：4-7 Spring Bean装配之Java的容器注解说明 —— @Bean 和 @Scope
	 * ScopedProxyMode.TARGET_CLASS是字节码级别多例, 使用一次就会产生一个运行时字节新对象.
	 *
	 * 示例看：com.myimooc.spring.simple.beanannotation.scoped.proxy.mode.ScopeProxyBean
	 *
	 * 示例：
	 * 因为 StoreService 是 signleton，是在容器启动就会创建，而 shoppingcart 是 session,只有用
	 * 户访问时才会创建，所以当 StoreService 企图要注入 shoppingcart 时，很有可能 shoppingcart
	 * 还没创建。spring 用代理解决这个问题，当 ShoppingCart 是接口时，指定 ScopedProxyMode.INTERFACES。
	 * 当 ShoppingCart 是一个类时，则指定 ScopedProxy-Mode.TARGET_CLASS，srping 会通过 CGLib
	 * 来创建基于类的代理对象。当 request 注入到 signleton bean 时，也是一样。
	 * 来自：https://www.cnblogs.com/pc-boke/articles/9160329.html
	 */
//	@Bean(name = "stringStore")
//	@Scope(value= ConfigurableBeanFactory.SCOPE_PROTOTYPE)
//	//加上代理对象模式 proxyMode = ScopedProxyMode.TARGET_CLASS 测试只有一个对象的bean，没有地方用到 stringStore bean，这里的测试不对。
//	//@Scope(value= ConfigurableBeanFactory.SCOPE_PROTOTYPE, proxyMode = ScopedProxyMode.TARGET_CLASS)
//	public Store stringStore() {
//		return new StringStore();
//	}


	/**
	 * 视频：4-8 Spring Bean装配之基于Java的容器注解说明 —— 基于"泛型"的自动装配
	 */
    @Autowired
    private Store<String> s1; //只能装配单个，容器不能有两个，否则报错装配不上

//    @Autowired
//    private List<Store<String>> s;

    @Autowired
    private Store<Integer> s2;

    @Bean
    public StringStore stringStore() {
        return new StringStore();
    }

    @Bean
    public IntegerStore integerStore() {
        return new IntegerStore();
    }

    /* 报错：有两个StringStore
     * Error creating bean with name 'storeConfig': Unsatisfied dependency expressed through field 's1';
     * nested exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException:
     * No qualifying bean of type 'com.myimooc.spring.simple.beanannotation.javabased.Store<java.lang.String>'available:
     * expected single matching bean but found 2: stringStore,stringStoreTest
     * 创建名为“storeConfig”的 bean 时出错：通过字段“s1”表达的不满足的依赖关系；嵌套异常是 org.springframework.beans.factory.NoUniqueBeanDefinitionException:
     * 没有'com.myimooc.spring.simple.beanannotation.javabased.Store<java.lang.String>' 类型合格 bean 可用：
     * 预期的单个匹配 bean 但发现 2: stringStore，stringStoreTest
     */
    //	@Bean(name = "stringStoreTest")
//	public Store stringStoreTest() {
//		System.out.println("s1 : " + s1.getClass().getName());
//		System.out.println("s2 : " + s2.getClass().getName());
//		return new StringStore();
//	}

    @Bean(name = "stringStoreTest")
    public TestBean stringStoreTest() {
        System.out.println("s1 : " + s1.getClass().getName());
        System.out.println("s2 : " + s2.getClass().getName());
        return new TestBean();
    }

}
