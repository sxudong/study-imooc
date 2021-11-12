package com.SpringSourceAnalysis.ch09.mybatis.config;

import org.apache.commons.dbcp2.BasicDataSource;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.mybatis.spring.mapper.MapperScannerConfigurer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

/**
 * 集成 MyBatis
 * 描述：MyBatis 相关配置
 **/
@Configuration
@MapperScan("com.learn.mybatis.mapper")
public class MyBatisConfig {

    @Autowired
    private Environment environment;

    /**
     * 《Spring源码深度解析》9.3.1 sqlSessionFactory 创建
     *  Spring支持多种 MyBatis 的属性配置.如：dataSource P240
     */
	// 注册数据源
	@Bean
	public DataSource dataSource() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
		dataSource.setUrl("jdbc:mysql://localhost:3306/spring?serverTimezone=Asia/Shanghai&useSSL=true&useUnicode=true&characterEncoding=UTF-8");
		return dataSource;
	}

	  /**
	   * 《Spring源码深度解析》9.3.1 sqlSessionFactory 创建 P237
	   *  读取 MyBatis 的配置创建 sqlSessionFactory。
	   */
	  @Bean
		public SqlSessionFactoryBean sqlSessionFactoryBean() {
			SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
			factoryBean.setDataSource(dataSource());
			factoryBean.setConfigLocation(new ClassPathResource("test/mybatis/mybatis-spring.xml"));
			return factoryBean;
		}

    // mybatis的配置 https://www.cnblogs.com/hhhshct/p/9688079.html
//    @Bean
//    public SqlSessionFactoryBean sqlSessionFactoryBean() throws IOException {
//        ResourcePatternResolver resourcePatternResolver = new PathMatchingResourcePatternResolver();
//        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean(); //mybatis-plus插件类
//        sqlSessionFactoryBean.setDataSource(dataSource()); //数据源
//        sqlSessionFactoryBean.setMapperLocations(resourcePatternResolver.getResources("classpath:mappers/*.xml"));
//        sqlSessionFactoryBean.setTypeAliasesPackage("powerx.io.model"); //别名，让*Mpper.xml实体类映射可以不加上具体包名
//        return sqlSessionFactoryBean;
//    }

    /**
     * 《Spring源码深度解析》9.3.3 MapperScannerConfigurer P241
     *  扫描特定包，批量创建映射器。
     */
    @Bean
	public MapperScannerConfigurer mapperScannerConfigurer() {
		MapperScannerConfigurer configurer = new MapperScannerConfigurer();
		// 扫描包下的所有 Mapper.java
		configurer.setBasePackage("com.SpringSourceAnalysis.ch09.mybatis.mapper");
		configurer.setSqlSessionFactoryBeanName("sqlSessionFactoryBean");
		//configurer.setAnnotationClass(Repository.class); //不用也不影响，源码下是扫描这个包下所有的类注册bean
		return configurer;
	}

}
