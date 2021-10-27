package com.myimooc.spring.simple.aop.schema.advice.biz;

/**
 * 务方法
 */
public class AspectBiz {

    // 视频：5-4 Advice应用（上）
    public void biz() {
        System.out.println("AspectBiz biz.");
//		throw new RuntimeException();
    }

    // 视频：5-5 Advice应用（下）
    public void init(String bizName, int times) {
        System.out.println("AspectBiz init : " + bizName + "   " + times);
    }

}
