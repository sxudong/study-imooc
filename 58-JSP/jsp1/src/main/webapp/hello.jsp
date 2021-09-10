<%@page pageEncoding="utf-8" %>
<!-- 1.先写HTML标签 -->
<!doctype html>
<html>
  <head>
	<meta chrest="utf-8">
	<title>第1个JSP</title>
  </head>
	<body>
	   <!-- 2.3 JSP声明 (在2.2处调用此方法) -->
	   <%!
	      public double hundred(double d) {
		   return d*100;
	   } %>
	   <ul>
		  <!-- 2.再写Java -->
		  <!-- 2.1 JSP脚本 -->
		  <% for(int i=0;i<20;i++) { %>
			  <!-- 2.2 JSP表达式 -->
			  <li><%=hundred(Math.random()) %></li>
		  <% } %>
	   </ul>
	   <!-- 静态包含。引入一个jsp，相当于将此jsp的内容复制到此处 -->
	   <%@ include file="time.jsp" %>
	   <!-- 动态包含。引入一个jsp，相当于将此jsp的内容复制到此处 -->
	   <jsp:include page="time.jsp" flush="true"></jsp:include>
  </body>
</html>