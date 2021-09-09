package web;

import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;

/**
 * 监听
 */
public class MyListener implements ServletRequestListener{

	//tomcat销毁request前自动调用此方法
	@Override
	public void requestDestroyed(ServletRequestEvent arg0) {
		System.out.println("销毁request");

	}

	//tomcat创建request后自动调用此方法
	@Override
	public void requestInitialized(ServletRequestEvent e) {
		System.out.println("创建request");
		System.out.println(e.getServletRequest());
	}
}
/* Tomcat输出：
创建request
org.apache.catalina.connector.RequestFacade@1cec8501
在前面记日志
在前面过滤敏感词
查询资费
在后面过滤敏感词
在后面记日志
销毁request
 */