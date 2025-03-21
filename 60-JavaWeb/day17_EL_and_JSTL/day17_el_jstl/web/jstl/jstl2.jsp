<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>choose标签</title>
</head>
<body>

    <%--
        完成数字编号对应星期几案例
            1.域中存储一数字
            2.使用 choose 标签取出数字         相当于 switch 声明
            3.使用 when 标签做数字判断         相当于 case
            4.otherwise 标签做其他情况的声明   相当于 default
    --%>

    <%
        <%-- request.setAttribute("number", 3); --%>
        request.setAttribute("number", 51);
    %>

    <c:choose>
        <c:when test="${number == 1}">星期一</c:when>
        <c:when test="${number == 2}">星期二</c:when>
        <c:when test="${number == 3}">星期三</c:when>
        <c:when test="${number == 4}">星期四</c:when>
        <c:when test="${number == 5}">星期五</c:when>
        <c:when test="${number == 6}">星期六</c:when>
        <c:when test="${number == 7}">星期天</c:when>

        <c:otherwise>数字输入有误</c:otherwise>
    </c:choose>

</body>
</html>
