package web;

import javax.servlet.ServletRequestAttributeEvent;
import javax.servlet.ServletRequestAttributeListener;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;

public class MyListener implements ServletRequestListener, ServletRequestAttributeListener {

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

	//绑定数据相关的事件
	@Override
	public void attributeAdded(ServletRequestAttributeEvent arg0) {
		System.out.println("向request内添加一个值");
	}

	@Override
	public void attributeRemoved(ServletRequestAttributeEvent arg0) {

	}
	@Override
	public void attributeReplaced(ServletRequestAttributeEvent arg0) {

	}
}