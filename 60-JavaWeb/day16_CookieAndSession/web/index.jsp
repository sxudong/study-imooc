<%--
  Created by IntelliJ IDEA.
  User: fqy
  Date: 2018/6/8
  Time: 14:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
  </head>
  <body>


      <!--在tomcat启动时控制台中打印的 Using CATALINA_BASE:   "C:\Users\Aaron\AppData\Local\JetBrains\IntelliJIdea2021.2\tomcat\17324711-1c5b-4283-9093-e855f6613e05"
      \work\Catalina\localhost\ 目录下查看 转换后的 index_jsp.java-->
      <%
        System.out.println("hello jsp");
        int i = 5;

        String contextPath = request.getContextPath();
        out.print(contextPath);
      %>

      <%!
        int i = 3;
      %>
      <%= "hello" %>


      System.out.println("hello jsp");
      <h1>hi~ jsp!</h1>

      <% response.getWriter().write("response....."); %>
  </body>
</html>
