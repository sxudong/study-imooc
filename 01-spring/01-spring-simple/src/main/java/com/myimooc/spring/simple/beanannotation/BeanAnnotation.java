package com.myimooc.spring.simple.beanannotation;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

/**
 * 使用@Component
 *
 * 视频：4-1 Spring Bean装配之Bean的定义及作用域的注解实现
 * 单元测试类：BeanAnnotationTest.java
 *
 * Bean管理的注解实现及例子:
 *   - Classpath扫描与组件管理
 *   - 类的自动检测与注册Bean
 *   - <context:annotation-config/>
 *   - @Component, @Repository, @Service, @Controller
 *   - @Required
 *   - @Autowired. @Qualifier
 *   - @Resource
 */
@Scope
@Component
public class BeanAnnotation {

    public void say(String arg) {
        System.out.println("BeanAnnotation : " + arg);
    }

    void myHashCode() {
        System.out.println("BeanAnnotation : " + this.hashCode());
    }

}
