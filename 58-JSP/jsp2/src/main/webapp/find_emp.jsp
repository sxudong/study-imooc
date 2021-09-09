<%@page pageEncoding="UTF-8" import="entity.*,dao.*,java.util.*"%>
<!doctype html>
	<html>
		<head>
			<meta charest="utf-8">
			<title>查询员工</title>
		</head>
		<body>
			<table border="1px" cellspacing="0" width="40%">
				<tr>
					<th>编号</th>
					<th>姓名</th>
					<th>职位</th>
					<th>月薪</th>
				</tr>
				<%
					EmpDao dao = new EmpDaoImpl();
					List<Emp> list = dao.findAll();
					if(list != null){
						for(Emp e:list){
				%>
					<tr>
						<td><%=e.getEmpno() %></td>
						<td><%=e.getEname() %></td>
						<td><%=e.getJob() %></td>
						<td><%=e.getSal() %></td>
					</tr>
				<%		
						}
					}
				%>
			</table>
		</body>
	</html>