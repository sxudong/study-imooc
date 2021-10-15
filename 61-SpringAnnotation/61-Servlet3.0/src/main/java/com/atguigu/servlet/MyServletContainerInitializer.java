package com.atguigu.servlet;

import java.util.EnumSet;
import java.util.Set;

import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContainerInitializer;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import javax.servlet.annotation.HandlesTypes;

import com.atguigu.service.HelloService;

/**
 * 54、servlet3.0-ServletContainerInitializer
 *    使用Tomcat启动项目
 */
//容器启动的时候会将 @HandlesTypes 指定的这个类型下面的子类（实现类，子接口等）传递过来；
//传入感兴趣的类型；
@HandlesTypes(value={HelloService.class})
// 1、Servlet容器启动会扫描，当前应用里面每一个jar包里面 META-INF/services/javax.servlet.ServletContainerInitializer 指定的实现类
public class MyServletContainerInitializer implements ServletContainerInitializer {

	/**
	 * 应用启动的时候，会运行onStartup方法；
	 *
	 * Set<Class<?>> arg0：感兴趣的类型的所有子类型；
	 * ServletContext arg1:代表当前Web应用的ServletContext；一个Web应用一个ServletContext；
	 *
	 * 55、servlet3.0-ServletContext注册三大组件:
	 * 1）、使用 ServletContext 注册 Web组件（Servlet、Filter、Listener）
	 * 2）、使用编码的方式，在项目启动的时候给ServletContext里面添加组件；
	 * 		必须在项目启动的时候来添加；
	 * 		1）、ServletContainerInitializer 得到的 ServletContext；
	 * 		2）、ServletContextListener 得到的 ServletContext；
	 */
	@Override
	public void onStartup(Set<Class<?>> arg0, ServletContext servletContext) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("感兴趣的类型：");  // @HandlesTypes(value={HelloService.class}) 传入感兴趣的类型
		for (Class<?> claz : arg0) {
			System.out.println(claz);
		}

		//注册组件  ServletRegistration
		ServletRegistration.Dynamic servlet = servletContext.addServlet("userServlet", new UserServlet()); // 在ServletContainerInitializer实现类中注册servlet
		//配置servlet的映射信息
		servlet.addMapping("/user");

		//注册Listener
		servletContext.addListener(UserListener.class); // UserListener implements ServletContextListener

		//注册Filter  FilterRegistration
		FilterRegistration.Dynamic filter = servletContext.addFilter("userFilter", UserFilter.class);
		//配置Filter的映射信息
		filter.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST), true, "/*");

	}
}
/* Output:
感兴趣的类型：
class com.atguigu.service.AbstractHelloService
class com.atguigu.service.HelloServiceImpl
interface com.atguigu.service.HelloServiceExt
UserListener...contextInitialized...
[2020-07-29 10:06:49,683] Artifact servlet3.0:war: Artifact is deployed successfully
[2020-07-29 10:06:49,683] Artifact servlet3.0:war: Deploy took 545 milliseconds
UserFilter...doFilter...
UserFilter...doFilter...
*///~