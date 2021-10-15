package com.atguigu.servlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 监听 Tomcat 启动和关闭
 * ServletContextListener 接口，它能够监听 ServletContext 对象的生命周期，实际上就是监听 Web应用 的生命周期。
 * 当 Servlet容器 启动或终止 Web应用 时，会触发 ServletContextEvent事件，该事件由 ServletContextListener 来处理。
 */
public class UserListener implements ServletContextListener {

	/**
	 * 监听 ServletContext 销毁
	 *
	 * 当Servlet 容器启动Web 应用时调用该方法。在调用完该方法之后，容器再对Filter 初始化，
	 * 并且对那些在Web 应用启动时就需要被初始化的Servlet 进行初始化。
	 */
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		System.out.println("UserListener...contextDestroyed...");
	}

	/**
	 * 监听 ServletContext 启动初始化
	 *
	 * 当 Servlet容器 终止 Web应用 时调用该方法。在调用该方法之前，容器会先销毁所有的 Servlet 和 Filter过滤器
	 */
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		/**
		 * web容器是管理servlet（通过servlet容器），以及监听器(Listener)和过滤器(Filter)的。这些都是在web容器的掌控范围里。
		 * 但他们不在spring和springmvc的掌控范围里。因此，我们无法在这些类中直接使用Spring注解的方式来注入我们需要的对象，
		 * 是无效的，web容器是无法识别的。
		 * 注意：要确保spring容器已经初始化完毕！spring容器的初始化也是由Listener（ContextLoaderListener）完成。
		 *
		 * 提供两个方法获取spring的bean对象：
		 */
		// 方法一：
//		ApplicationContext context = (ApplicationContext) arg0.getServletContext().getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
//		UserService userService = (UserService) context.getBean("userService");
		// 方法二：
//		WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(arg0.getServletContext());
//		UserService userService = (UserService) webApplicationContext.getBean("userService");

		// 获取ServletContext
		ServletContext servletContext = arg0.getServletContext();
		System.out.println("UserListener...contextInitialized...");
	}
}
/* Output:
13-Aug-2020 07:53:43.611 信息 [main] org.apache.catalina.startup.Catalina.start Server startup in [98] milliseconds
Connected to server
[2020-08-13 07:53:44,085] Artifact servlet3.0:war: Artifact is being deployed, please wait...
感兴趣的类型：
class com.atguigu.service.AbstractHelloService
class com.atguigu.service.HelloServiceImpl
interface com.atguigu.service.HelloServiceExt
13-Aug-2020 07:53:49.515 信息 [RMI TCP Connection(3)-127.0.0.1] org.apache.jasper.servlet.TldScanner.scanJars 至少有一个JAR被扫描用于TLD但尚未包含TLD。 为此记录器启用调试日志记录，以获取已扫描但未在其中找到TLD的完整JAR列表。 在扫描期间跳过不需要的JAR可以缩短启动时间和JSP编译时间。
UserListener...contextInitialized...
[2020-08-13 07:53:49,575] Artifact servlet3.0:war: Artifact is deployed successfully
[2020-08-13 07:53:49,575] Artifact servlet3.0:war: Deploy took 5,490 milliseconds
UserFilter...doFilter...
UserFilter...doFilter...
13-Aug-2020 07:53:53.618 信息 [Catalina-utility-2] org.apache.catalina.startup.HostConfig.deployDirectory 把web 应用程序部署到目录 [D:\software\Tomcat\apache-tomcat-9\webapps\manager]
13-Aug-2020 07:53:53.748 信息 [Catalina-utility-2] org.apache.jasper.servlet.TldScanner.scanJars 至少有一个JAR被扫描用于TLD但尚未包含TLD。 为此记录器启用调试日志记录，以获取已扫描但未在其中找到TLD的完整JAR列表。 在扫描期间跳过不需要的JAR可以缩短启动时间和JSP编译时间。
13-Aug-2020 07:53:53.748 信息 [Catalina-utility-2] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory [D:\software\Tomcat\apache-tomcat-9\webapps\manager] has finished in [130] ms
D:\software\Tomcat\apache-tomcat-9\bin\catalina.bat stop
Disconnected from the target VM, address: '127.0.0.1:14941', transport: 'socket'
Using CATALINA_BASE:   "C:\Users\Arron\.IntelliJIdea2019.3\system\tomcat\Unnamed_spring-code"
Using CATALINA_HOME:   "D:\software\Tomcat\apache-tomcat-9"
Using CATALINA_TMPDIR: "D:\software\Tomcat\apache-tomcat-9\temp"
Using JRE_HOME:        "C:\Java\jdk1.8.0_172"
Using CLASSPATH:       "D:\software\Tomcat\apache-tomcat-9\bin\bootstrap.jar;D:\software\Tomcat\apache-tomcat-9\bin\tomcat-juli.jar"
13-Aug-2020 07:54:09.577 信息 [main] org.apache.catalina.core.StandardServer.await A valid shutdown command was received via the shutdown port. Stopping the Server instance.
13-Aug-2020 07:54:09.577 信息 [main] org.apache.coyote.AbstractProtocol.pause Pausing ProtocolHandler ["http-nio-8080"]
13-Aug-2020 07:54:10.701 信息 [main] org.apache.coyote.AbstractProtocol.pause Pausing ProtocolHandler ["ajp-nio-8009"]
13-Aug-2020 07:54:11.754 信息 [main] org.apache.catalina.core.StandardService.stopInternal Stopping service [Catalina]
13-Aug-2020 07:54:11.764 信息 [main] org.apache.coyote.AbstractProtocol.stop Stopping ProtocolHandler ["http-nio-8080"]
UserListener...contextDestroyed...
13-Aug-2020 07:54:11.764 信息 [main] org.apache.coyote.AbstractProtocol.stop Stopping ProtocolHandler ["ajp-nio-8009"]
13-Aug-2020 07:54:11.774 信息 [main] org.apache.coyote.AbstractProtocol.destroy 正在摧毁协议处理器 ["http-nio-8080"]
13-Aug-2020 07:54:11.774 信息 [main] org.apache.coyote.AbstractProtocol.destroy 正在摧毁协议处理器 ["ajp-nio-8009"]
Disconnected from server
 */