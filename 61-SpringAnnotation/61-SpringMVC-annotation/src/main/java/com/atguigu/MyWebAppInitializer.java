package com.atguigu;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import com.atguigu.config.AppConfig;
import com.atguigu.config.RootConfig;

// web容器 启动的时候创建对象；调用方法来"初始化容器"以及"前端控制器"
// AbstractAnnotationConfigDispatcherServletInitializer -> AbstractDispatcherServletInitializer
// -> AbstractContextLoaderInitializer -> WebApplicationInitializer#onStartup()
public class MyWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

	// 获取根容器的配置类；（Spring的配置文件）父容器；
	@Override
	protected Class<?>[] getRootConfigClasses() {
		// TODO Auto-generated method stub
		return new Class<?>[]{RootConfig.class}; // 根容器
	}

	// 获取web容器的配置类（SpringMVC配置文件）子容器；
	@Override
	protected Class<?>[] getServletConfigClasses() {
		// TODO Auto-generated method stub
		return new Class<?>[]{AppConfig.class}; // web配置
	}

	// 获取 DispatcherServlet 的映射信息
	//  /：拦截所有请求（包括静态资源（xx.js,xx.png）），但是不包括*.jsp；
	//  /*：拦截所有请求；连*.jsp页面都拦截；jsp页面是tomcat的jsp引擎解析的；
	@Override
	protected String[] getServletMappings() {
		// TODO Auto-generated method stub
		return new String[]{"/"};
	}
}