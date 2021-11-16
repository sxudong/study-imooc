package com.learn.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * @Date: 2020/5/1 18:57
 * @Description: 根容器 扫面路径下的bean
 */
@Configuration
@ComponentScan(basePackages = "com.learn")
public class RootConfig {

}

