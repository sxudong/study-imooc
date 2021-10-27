package com.atguigu.aop;

import java.util.Arrays;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;


/**
 * 切面类
 *
 * @author lfy
 * @Aspect： 告诉Spring当前类是一个切面类
 *
 * 单元测试类：IOCTest_AOP
 * 可参考《Spring实战第4版》P112 示例代码
 */
@Aspect
public class LogAspects {

    //抽取公共的切入点表达式
    //1、本类引用
    //2、其他的切面引用
    @Pointcut("execution(public int com.atguigu.aop.MathCalculator.*(..))")
    public void pointCut() {
    }

    // 可打开测试 @Around
//    @Around("pointCut()") // 环绕通知
//    public Object run2(ProceedingJoinPoint joinPoint) throws Throwable {
//        //获取方法参数值数组
//        Object[] args = joinPoint.getArgs();
//        System.out.println("请求参数为:"+Arrays.asList(args));
//        System.out.println("" + joinPoint.getSignature().getName() + "运行。。。@Around:请求参数为：{" + Arrays.asList(args) + "}");
//        //动态修改其参数
//        //注意，如果调用joinPoint.proceed()方法，则修改的参数值不会生效，必须调用joinPoint.proceed(Object[] args)
//        Object result = joinPoint.proceed(args);
//        System.out.println("" + joinPoint.getSignature().getName() + "运行。。。@Around:响应结果为:{" + result + "}");
//        //如果这里不返回result，则目标对象实际返回值会被置为null
//        return result;
//    }

    //@Before在目标方法之前切入；切入点表达式（指定在哪个方法切入）
    @Before("pointCut()") // 前置通知
    public void logStart(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        System.out.println("" + joinPoint.getSignature().getName() + "运行。。。@Before:参数列表是：{" + Arrays.asList(args) + "}");
    }

    @After("com.atguigu.aop.LogAspects.pointCut()") // 最终通知
    public void logEnd(JoinPoint joinPoint) {
        System.out.println("" + joinPoint.getSignature().getName() + "结束。。。@After");
    }

    //JoinPoint一定要出现在参数表的第一位
    @AfterReturning(value = "pointCut()", returning = "result") // 后置通知
    public void logReturn(JoinPoint joinPoint, Object result) {
        System.out.println("" + joinPoint.getSignature().getName() + "正常返回。。。@AfterReturning:运行结果：{" + result + "}");
    }

    @AfterThrowing(value = "pointCut()", throwing = "exception") // 异常通知
    public void logException(JoinPoint joinPoint, Exception exception) {
        System.out.println("" + joinPoint.getSignature().getName() + "异常。。。异常信息：{" + exception + "}");
    }

}
