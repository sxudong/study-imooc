package com.myimooc.spring.simple.resource;

import com.myimooc.spring.simple.base.UnitTestBase;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

import java.io.IOException;

/**
 * 模拟加载资源测试
 *
 * 视频：3-5 Spring Bean装配之Resource
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class ResourceTest extends UnitTestBase {

    public ResourceTest() {
        super("spring-resource.xml");
    }

    @Test
    public void testResource() {
        MockResource resource = super.getBean("mockResource", MockResource.class);
        try {
            resource.resource();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
} /* Output:
config.txt       //获取到resources文件下的文件
18
*///~
