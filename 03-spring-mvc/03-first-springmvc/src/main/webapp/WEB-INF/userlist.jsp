<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
</head>
<h2>This is SpringMVC demo page</h2>
<body>
<c:forEach items="${users}" var="user" >
    <c:out value="${user.username}"/><br/>
    <c:out value="${user.age}"/><br/>
</c:forEach>
</body>
</html>