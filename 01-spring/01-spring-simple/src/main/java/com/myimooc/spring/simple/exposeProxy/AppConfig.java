package com.myimooc.spring.simple.exposeProxy;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@EnableAspectJAutoProxy(exposeProxy=true)
@Configuration
@ComponentScan("com.myimooc.spring.simple.exposeProxy")
public class AppConfig {
}
