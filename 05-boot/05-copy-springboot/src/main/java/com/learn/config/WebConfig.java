package com.learn.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

/**
 * @Auther: 洺润Star
 * @Date: 2020/5/1 18:54
 * @Description: SpringMVC容器
 * @EnableWebMvc 开启SpringMVC功能
 * @Configuration 配置
 */
@Configuration
@EnableWebMvc //开启SpringMVC功能
@ComponentScan(basePackages = {"com.learn.controller"})
//public class WebConfig extends WebMvcConfigurerAdapter { //已废弃
//public class WebConfig implements WebMvcConfigurer { //可用
public class WebConfig extends WebMvcConfigurationSupport {


    //配置视图转换器
    //SpringMVC视图解析器
    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");
        //可以在JSP页面中通过${}访问beans
        viewResolver.setExposeContextBeansAsAttributes(true);
        return viewResolver;
    }

}
