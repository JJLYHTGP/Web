<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
<%  request.setCharacterEncoding("utf-8"); 
//	String session_id = session.getId();//得到当前sessionID
	Class.forName("com.mysql.jdbc.Driver"); String msg="";
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8"; 
	try{
		Connection con = DriverManager.getConnection(connectString,"mBlog", "2287");
		Statement stmt = con.createStatement();  
		stmt.close();  
		con.close();
		} catch (Exception e){ 
			msg = e.getMessage(); 
	}
%>
<!DOCTYPE HTML> 
<html> 
<head> 
	
</head> 
<body> 
	
	<p><%=msg%></p>  
	
</body> 
</html>

