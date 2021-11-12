package com.SpringSourceAnalysis.ch06;

import com.SpringSourceAnalysis.ch06.applicationContext.propertyEditor.UserManager;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 使用自定义属性编程器
 * 《Spring源码深度解析》P140
 */
public class propertyEditorTest {
    @Test
    public void test(){
        ApplicationContext context = new ClassPathXmlApplicationContext("test/propertyEditor.xml");
        UserManager userManager = (UserManager) context.getBean("userManager");
        System.out.println(userManager);
    }
}
