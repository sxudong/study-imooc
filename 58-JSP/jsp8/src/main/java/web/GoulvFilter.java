package web;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class GoulvFilter implements Filter {
	//关闭tomcat时自动调用此方法
	@Override
	public void destroy() {
		System.out.println("销毁GuolvFilter");
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		System.out.println("在前面过滤敏感词");
		chain.doFilter(req, res);
		System.out.println("在后面过滤敏感词");
	}

	//定义一个成员变量，init接收附给成员变量，
	//doFilter()就可以使用了。
	@Override
	public void init(FilterConfig cfg) throws ServletException {
		System.out.println(
				cfg.getInitParameter("city"));
	}
}