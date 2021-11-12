package com.SpringSourceAnalysis.ch10.transactional.annotation;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.beans.PropertyVetoException;

@ComponentScan(basePackages = {"com.SpringSourceAnalysis.ch10.transactional"}) //包扫描
@Configuration
@EnableTransactionManagement //开启基于注解的声明式事务
public class SpringTxConfig {

	// 注册数据源
    @Bean
    public DataSource dataSource() throws PropertyVetoException {
        BasicDataSource dataSource = new BasicDataSource();
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUsername("root");
        dataSource.setPassword("root");
        dataSource.setUrl("jdbc:mysql://localhost:3306/spring?serverTimezone=Asia/Shanghai&useSSL=true&useUnicode=true&characterEncoding=UTF-8");
        return dataSource;
    }

	// 注册 JdbcTemplate
    @Bean
    public JdbcTemplate jdbcTemplate() throws PropertyVetoException {
        // 两种方法获取 DataSource
        // 1. 直接在方法放置参数 public JdbcTemplate jdbcTemplate(DataSource dataSource)
        //      默认会去容器中获取
        // 2. 如下： 调用上面的方法

        // spring 对 @Configuration 类有特殊处理，注册组件的方法多次调用只是在 IOC 容器中找组件。
        return new JdbcTemplate(dataSource());
    }

    // 注册事务管理器
    @Bean
    public PlatformTransactionManager transactionManager() throws PropertyVetoException {
        return new DataSourceTransactionManager(dataSource());//需要传入dataSource
    }
}

