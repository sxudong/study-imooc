package com.myimooc.spring.simple.aop.schema.advisors.service;

import org.springframework.stereotype.Service;

/**
 * 服务
 *
 * 视频：5-7 Advisors
 * 单元测试类: TestAOPSchemaAdvisors
 */
@Service
public class InvokeService {

    public void invoke() {
        System.out.println("InvokeService ......");
    }

    public void invokeException() {
        throw new RuntimeException("手动抛异常进行模拟");
    }
}
