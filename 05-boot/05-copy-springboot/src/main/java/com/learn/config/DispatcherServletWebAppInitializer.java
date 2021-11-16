package com.learn.config;

import com.learn.config.RootConfig;
import com.learn.config.WebConfig;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

/**
 * 加载SpringMVCDispatcherServlet
 */
public class DispatcherServletWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

	// 加载根容器 spring核心
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] { RootConfig.class };
	}

	// 加载SpringMVC容器
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] { WebConfig.class };
	}

	// SpringMVCDispatcherServlet 拦截的url映射，拦截所有请求
	protected String[] getServletMappings() {
		return new String[] { "/" };
	}

}
