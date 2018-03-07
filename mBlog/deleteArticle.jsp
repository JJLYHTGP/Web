<%@ page language="java" import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8"%> 
<% request.setCharacterEncoding("utf-8");
	String mode= (String)session.getAttribute("MODE");
	if(mode==null){
		response.sendRedirect("login.jsp");
	} 
	else if(mode.equals("VISITOR")){
    	response.sendRedirect("viewArticle.jsp");	//跳转到页面;
	}
	String msg = ""; 
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";  
	String articleId= request.getParameter("articleId");
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection con = DriverManager.getConnection(connectString,"******","******"); 
	Statement stmt = con.createStatement(); 
	try{ 
		String sql="delete from article where articleId="+articleId+";";
		int cnt = stmt.executeUpdate(sql); 
		if(cnt>0){
			msg = "Delete Succeeded!";
			response.sendRedirect("viewArticle.jsp");	//跳转到页面
		}
		else{
				msg = "Delete Failed!";
		} 
		stmt.close(); 
		con.close(); 
	}catch (Exception e){ 
		msg = e.getMessage(); 
	} 
	System.out.println(msg);
%> 
<!DOCTYPE HTML> 
<html> 	
	<%=msg%> 
</html>