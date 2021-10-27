package com.myimooc.spring.simple.aop.schema.advisors;

import org.aspectj.lang.ProceedingJoinPoint;
import org.springframework.core.Ordered;

/**
 * 执行
 *
 * 视频：5-7 Advisors
 * 单元测试类: TestAOPSchemaAdvisors
 */
public class ConcurrentOperationExecutor implements Ordered {

    private static final int DEFAULT_MAX_RETRIES = 2; //默认值是2

    private int maxRetries = DEFAULT_MAX_RETRIES;

    private int order = 1;

    public void setMaxRetries(int maxRetries) {
        this.maxRetries = maxRetries;
    }

    @Override
    public int getOrder() {
        return this.order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public Object doConcurrentOperation(ProceedingJoinPoint pjp) throws Throwable {
        int numAttempts = 0;
        RuntimeException exception;
        do {
            numAttempts++;
            System.out.println("Try times : " + numAttempts); //打印尝试次数
            try {
                // 环绕通知前
                return pjp.proceed();
            } catch (RuntimeException ex) {
                //捕获到 RuntimeException,将 异常赋值给 exception,只要 numAttempts <= this.maxRetries 继续尝试
                exception = ex;
            }
            // 环绕通知后
        } while (numAttempts <= this.maxRetries);
        System.out.println("Try error : " + numAttempts); //打印最后尝试的总次数
        throw exception; // 尝试失败后,抛出异常
    }
}
