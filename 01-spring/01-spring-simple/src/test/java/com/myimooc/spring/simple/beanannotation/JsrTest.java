package com.myimooc.spring.simple.beanannotation;

import com.myimooc.spring.simple.base.UnitTestBase;
import com.myimooc.spring.simple.beanannotation.jsr.JsrService;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * 基于JSR标准的注解使用测试
 *
 * 视频：4-9 Spring Bean装配之Spring对 JSR 支持的说明
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class JsrTest extends UnitTestBase {

    public JsrTest() {
        super("spring-beanannotation.xml");
    }

    @Test
    public void testSave() {
        JsrService service = getBean(JsrService.class);
        service.save();
    } /* Output:
    JsrService init.
    JsrDao invoked.
    JsrService destroy.
    *///~
}
