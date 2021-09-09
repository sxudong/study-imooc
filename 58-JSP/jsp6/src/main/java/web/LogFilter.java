package web;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * 登录过滤器
 */
public class LogFilter implements Filter {

	//关闭tomcat时自动调用此方法
	@Override
	public void destroy() {
		System.out.println("销毁LogFilter");
	}

	/*
	 * doFilter()--->该方法是处理公共业务的方法
	 * Filter相当于是Servlet们的管家，tomcat在调用Servlet之前会
	 * 将请求提交给Filter，Filter有权让请求继续，也有权让请求终止。
	 * tomcat就是调用doFilter方法让Filter统一处理请求，调用前它会
	 * 创建好request和response并传入，创建的类型：
	 * RequestFacade和ResponseFacade
	 */
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		System.out.println("在前面记日志");

		/*
		 * chain.doFilter(req, res)
		 * 1.若调用该方法则请求继续
		 * 2.若不调用该方法则请求中断
		 */
		//请求继续，向下执行
		//如果不输出“chain.doFilter”请求会终断，不会到Servlet
		//(FindCostServlet/AddCostServlet)
		chain.doFilter(req, res);
		System.out.println("在后面记日志");

	}

	/*
	 * init()
	 * tomcat启动时会自动实例化Filter,然后调用其init()来初始化Filter.
	 * 调用此方法时会传入config，该对象和Filter是1对1的关系，可以给
	 * Filter预置参数（web.xml）。该对象和ServletConfig用法完全一样。
	 */
	@Override
	public void init(FilterConfig arg0) throws ServletException {
		System.out.println("初始化LogFilter");
	}
}
/* Tomcat 输出：
初始化LogFilter    <= LogFilter中的 init() 方法打印的
北京               <= GoulvFilter中的 init() 方法打印的
[2021-09-09 02:25:09,270] Artifact jsp6:war exploded: Artifact is deployed successfully
[2021-09-09 02:25:09,270] Artifact jsp6:war exploded: Deploy took 975 milliseconds
在前面记日志
在前面过滤敏感词     <= GoulvFilter中的 doFilter() 方法打印
北京
在后面过滤敏感词
在后面记日志
在前面记日志        //在找开网页时会请求一次“/”,但不知道为什么打印了两次？
在前面过滤敏感词
北京
在后面过滤敏感词
在后面记日志
 */