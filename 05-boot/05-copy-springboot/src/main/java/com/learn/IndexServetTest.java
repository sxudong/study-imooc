package com.learn;

import org.apache.catalina.LifecycleException;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;

public class IndexServetTest {
    // 端口号
    private static int PORT = 8080;
    // 项目名称
    private static String CONTEXTPATH = "/test";

    /**
     * http://localhost:8080/test/index
     */
    public static void main(String[] args) throws LifecycleException {
        // 创建Tomcat服务器
        Tomcat tomcatServer = new Tomcat();
        // 设置Tomcat端口号
        tomcatServer.setPort(PORT);
        tomcatServer.getHost().setAutoDeploy(false);
        // 创建Context上下文
        StandardContext standardContext = new StandardContext();
        standardContext.setPath(CONTEXTPATH);
        standardContext.addLifecycleListener(new Tomcat.FixContextListener());
        // tomcat容器添加standardContext
        tomcatServer.getHost().addChild(standardContext);
        // 创建servlet
        tomcatServer.addServlet(CONTEXTPATH, "IndexServet", new IndexServet());
        // 添加 servleturl 映射 (http://localhost:8080/test/index)
        standardContext.addServletMappingDecoded("/index", "IndexServet");
        tomcatServer.start();
        System.out.println("tomcat启动...");
        tomcatServer.getServer().await();
    }

}
