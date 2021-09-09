<!-- 
 pageEncoding：设置该文件的编码。
 contentType：告诉浏览器输出的内容的格式。
-->
<%@page pageEncoding="utf-8"
	contentType="text/html"
	import="java.util.*,java.text.*"%>
<!-- 当前JSP是被其他JSP引入的，
	它只是其他JSP的局部代码。 -->
<%
	Date date = new Date();
	SimpleDateFormat sdf = 
			new SimpleDateFormat("HH:mm:ss");
	String now = sdf.format(date);
%>
<p><%=now %></p>