package com.SpringSourceAnalysis.ch07.aop.dynamicAOP;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;


/**
 * 《Spring源码尝试解析》7.1 动态AOP使用示例 P168
 */
@Aspect
public class AspectJTest {
    @Pointcut("execution(* com.SpringSourceAnalysis.ch07.aop.dynamicAOP.TestBean.*(..))")
    public void test() {
    }

    @Before("test()")
    public void beforeTest(){
        System.out.println("beforeTest");
    }

    @After("test()")
    public void afterTest() {
        System.out.println("afterTest");
    }

    @Around("test()")
    public Object arountTest(ProceedingJoinPoint p){
        System.out.println("before1");
        Object o = null;
        try {
            o = p.proceed();
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
        System.out.println("before2");
        return o;
    }
}
