package com.SpringSource.ch07.dynamicAOP;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;


/**
 * 《Spring源码尝试解析》7.1 动态AOP使用示例
 */
@Aspect
public class AspectJTest {
    @Pointcut("execution(* com.SpringSource.ch07.dynamicAOP.TestBean.*(..))")
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
