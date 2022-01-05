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
        // 创建 Tomcat 服务器
        Tomcat tomcatServer = new Tomcat();
        // 设置 Tomcat 端口号
        tomcatServer.setPort(PORT);
        tomcatServer.getHost().setAutoDeploy(false);
        // 创建 Context 上下文
        StandardContext standardContext = new StandardContext();
        standardContext.setPath(CONTEXTPATH);
        standardContext.addLifecycleListener(new Tomcat.FixContextListener());
        // tomcat 容器添加 standardContext
        tomcatServer.getHost().addChild(standardContext);
        // 创建 servlet
        tomcatServer.addServlet(CONTEXTPATH, "IndexServet", new IndexServet());
        // 添加 servleturl 映射 (http://localhost:8080/test/index)
        standardContext.addServletMappingDecoded("/index", "IndexServet");
        tomcatServer.start();
        System.out.println("tomcat启动...");
        tomcatServer.getServer().await();
    }

}
