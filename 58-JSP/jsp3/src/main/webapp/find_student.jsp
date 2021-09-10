<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 类反射技术，不需要类的名字，只要告诉要访问对象，调那个方法，就能够访问。类反射技术不需要导包。 -->
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 引入时间格式标签 -->
<%@taglib uri="/lhh-tags" prefix="s"%>
<!doctype html>
<html>
	<head>
		<meta charset="utf-8">
		<title>EL和JSTL</title>
	</head>
	<body>
	<!--
	 JSP标准标签库（JavaSeverPages Standard Tag Libary）
     同样的也是为了简化我们的jsp代码，一般与EL表达式结合使用
     EL表达式多用于取值操作，而JSTL则可以方便我们对集合进行遍历，对数据进行判断等操作。
	-->
	<h1>JSTL</h1>
		<!-- 1. if -->
		<p>
			<c:if test="${requestScope.stu.sex=='M'}">男</c:if>
			<c:if test="${stu.sex=='F'}">女</c:if>
		</p>
		<!-- 2. choose -->
		<p>
			<c:choose>
				<c:when test="${stu.sex=='M'}">男</c:when>
				<c:otherwise>女</c:otherwise>
			</c:choose>
		</p>
		<!-- 3. forEach
			items：声明要遍历的数据。
			var：为每次遍历说获取的值命名。
			双标签中间写每次遍历想输出的数据。 -->
		<p>
			<c:forEach var="i" items="${stu.interests}">
				${i}
			</c:forEach>
		</p>
		<!-- 4.自定义标签 -->
		<p>
			<s:sysdate format="yyyy-MM-dd"/>
		</p>
		<h1>EL</h1>
		<!-- 1.获取Bean属性 -->
		<!-- request.getAttribute("stu").getName() -->
		<p>姓名：${stu.name}</p>

		<!-- request.getAttribute("stu").getAge() -->
		<p>年龄：${stu["age"]}</p>

		<!-- request.getAttribute("stu").getSex() -->
		<p>性别：${stu.sex}</p>

		<!-- request.getAttribute("stu").getCourse().getId() -->
		<p>课程：${stu.course.id}</p>

		<!--
			EL表达式
				Expression Language 表达式语言,常用于取值
				我们之前在JSP中写java代码必须写在<%%>里面。并且取值代码比较繁琐。
				而EL表达式可以使我们的取值代码更加简洁。
			语法非常简单: \${}
			EL的取值范围：
			1.默认情况下依次从如下4个对象中取值：
				page,request,session,application
				这4个隐含对象是EL默认的取值范围
				->page.getAttribute("stu")
				->request.getAttribute("stu")
				->session.getAttribute("stu")
				->application.getAttribute("stu")
			2.可以手动指定取值的对象：
				pageScope.stu.name
				requestScope.stu.name
				sessionScope.stu.name
				applicationScope.stu.name
			3.设计默认取值的目的，是为了开发者不用经常写范围，
			       是为了简化EL表达式。
			注：上述4个对象也叫EL的取值范围。
		-->
		<p>姓名:${requestScope.stu.name}</p>
		<p>性别:${requestScope.stu.sex}</p>

		<!-- 2.访问时可以做运算 -->
		<p>年龄+10:${stu.age+10}</p>
		<p>介于20-30间:${stu.age>20 && stu.age<30}</p>
		<p>判空:${empty stu}</p>

		<!-- 3.获取请求参数
			param.user -> request.getParameter("user") -->
		<p>参数:${param.user}</p>
	</body>
</html>
