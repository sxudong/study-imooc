package com.myimooc.spring.simple.tag;

import com.SpringSource.ch04.customtag.test.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * spring的自定义标签
 * https://cloud.tencent.com/developer/article/1718111
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class MyTagTest {

    @Test
    public void testMyTag() {
        ClassPathXmlApplicationContext applicationContext
                = new ClassPathXmlApplicationContext("classpath*:test/customtag/customtag.xml");
        User user = (User) applicationContext.getBean("sueUser1");
        System.out.println("name=>" + user.getName());
        System.out.println("password=>" + user.getPassword());
        System.out.println("age=>" + user.getAge());
        System.out.println("sex=>" + user.getSex());
    }
}
/* Output:
name=>苏三
password=>123456
age=>18
sex=>1
*///~