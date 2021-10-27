package com.myimooc.spring.simple.aop;

import com.myimooc.spring.simple.aop.api.BizLogic;
import com.myimooc.spring.simple.base.UnitTestBase;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;


@RunWith(BlockJUnit4ClassRunner.class)
public class TestAOPAPI extends UnitTestBase {
	
	public TestAOPAPI() {
		super("classpath:spring-aop-api.xml");
	}

	/**
	 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
	 */
	@Test
	public void testSave() {
		BizLogic logic = (BizLogic) super.getBean("bizLogicImpl");
		logic.save();
	}
}
/* Output:
MockBeforeAdvice : save   com.myimooc.spring.simple.aop.api.BizLogicImpl       //前置通知
MockMethodInterceptor 1 : save     java.lang.reflect.Method                    //环绕通知1
BizLogicImpl : BizLogicImpl save.                                              //被代理对象执行
MockMethodInterceptor 2 : BizLogicImpl save.                                   //环绕通知2
MockAfterReturningAdvice : save ## com.myimooc.spring.simple.aop.api.BizLogicImpl   BizLogicImpl save.  //返回后通知
*///~