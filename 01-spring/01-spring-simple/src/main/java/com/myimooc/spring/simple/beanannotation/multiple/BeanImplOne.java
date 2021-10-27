package com.myimooc.spring.simple.beanannotation.multiple;

import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * 接口实现
 *
 * 视频：4-3 Spring Bean装配之 Autowired 注解说明-2
 * 单元测试类：TestInjection.java
 */
@Order(2)
@Component
public class BeanImplOne implements BeanInterface {

}
