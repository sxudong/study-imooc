package com.myimooc.spring.simple.beanannotation.jsr;

import org.springframework.stereotype.Repository;

/**
 * 使用@Repository
 *
 * 视频：4-9 Spring Bean装配之Spring对 JSR 支持的说明
 * 单元测试类：JsrTest.java
 */
@Repository
public class JsrDao {

    public void save() {
        System.out.println("JsrDao invoked.");
    }

}
