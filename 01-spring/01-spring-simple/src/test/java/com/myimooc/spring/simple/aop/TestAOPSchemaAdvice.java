package com.myimooc.spring.simple.aop;

import com.myimooc.spring.simple.aop.schema.advice.Fit;
import com.myimooc.spring.simple.aop.schema.advice.biz.AspectBiz;
import com.myimooc.spring.simple.base.UnitTestBase;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;


@RunWith(BlockJUnit4ClassRunner.class)
public class TestAOPSchemaAdvice extends UnitTestBase {
	
	public TestAOPSchemaAdvice() {
		super("classpath:spring-aop-schema-advice.xml");
	}

	/**
	 * 视频：5-4 Advice应用（上）
	 * 打开 spring-aop-schema-advice.xml 中这段代码：
	 *     <!-- 切入点为执行AspectBiz类中的所有方法 -->
	 *     <aop:before method="before" pointcut-ref="mockPointcut"/>
	 */
	@Test
	public void testBiz() {
		AspectBiz biz = super.getBean("aspectBiz");
		biz.biz();
	}
	/* 前通知：
	MockAspect before.
	AspectBiz biz.
	*///~

	/* 返回后通知：
	AspectBiz biz.
	MockAspect afterReturning.
	*///~

	/* 抛出异常后通知:
	AspectBiz biz.
	MockAspect afterThrowing.  //在抛出异常后打印的

	java.lang.RuntimeException
		at com.myimooc.spring.simple.aop.schema.advice.biz.AspectBiz.biz(AspectBiz.java:12)
	*///~

	/* 后通知:
	AspectBiz biz.
	MockAspect after.
	*///~

	/* 环绕通知:
	MockAspect around 1.
	AspectBiz biz.
	MockAspect around 2.
	*///~

	/**
	 * 视频：5-5 Advice应用（下）
	 * <aop:around method="aroundInit" pointcut="execution(* com.myimooc.spring.simple.aop.schema.advice.biz.AspectBiz.init(String, int))
	 *                          							and args(bizName, times)" arg-names="pjp,bizName,times"/>
	 */
	@Test
	public void testInit() {
		AspectBiz biz = super.getBean("aspectBiz");
		biz.init("moocService", 3);
	} /* Output:
	moocService   3                   //进入环绕通知方法中打印的参数
	MockAspect aroundInit 1.
	AspectBiz init : moocService   3  //AspectBiz打印的
	MockAspect aroundInit 2.
	*///~

	/**
	 * 视频：5-6 Introductions应用
	 * 《Springp实战第4版》4.4.4 通过切面引入新的功能 P127
	 */
	@Test
	public void testFit() {
		// 给 AspectBiz.java 指定一个新的父类，强制进行类型转换,使用指定父类的实现类中的方法
		Fit fit = (Fit) super.getBean("aspectBiz");
		fit.filter();
	} /* Output:
	FitImpl filter.
	*///~
	
}
