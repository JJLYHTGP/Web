<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
	<%  request.setCharacterEncoding("utf-8"); 
	String msg = ""; Class.forName("com.mysql.jdbc.Driver"); 
	Connection con=null;Statement stmt =null;
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";   
	String articleId=(String)request.getParameter("articleId");	//得到articleID
	String uid= (String)session.getAttribute("UID");	//得到UID
	String mode= (String)session.getAttribute("MODE");
	String updateOption="修改";String deleteOption="删除";
	String title = ""; 
	String content = "";
	if(uid==null || mode==null){
		response.sendRedirect("login.jsp");
	}else{
    if(!mode.equals("USER")){
    	updateOption="";
	}
	if(mode.equals("VISITOR")){
		deleteOption="";
	}
	con = DriverManager.getConnection(connectString,"mBlog", "2287");
	stmt = con.createStatement();
	stmt = con.createStatement(); 
	
	try{ 
		String sql="select * from article where articleId='"+articleId+"';";   
		ResultSet rs = stmt.executeQuery(sql);
		if(rs.next()){
			title=rs.getString("title");
			//content=rs.getString("content");
			content=rs.getString("content").replaceAll("\n","</br>");

		/*	content.replace(/\n/g,"<br/>");
			content.replace(/\s/g,"&nbsp;");*/
		}
		stmt.close(); 
		con.close(); 
	}catch (Exception e){ 
		msg = e.getMessage(); 
	}
}
%>
<!DOCTYPE HTML> 
<html> 
<head> 
	<title> </title> 
	<link rel="stylesheet" href="css/theArticle.css" />
</head> 
<body> 
	<div class="container"> 
		<h1><%=title%></h1> 
		<div class="command">
		<a class="article_command" href='updateArticle.jsp?articleId=<%=articleId%>'><%=updateOption%></a>
		<a class="article_command" href='deleteArticle.jsp?articleId=<%=articleId%>'><span><%=deleteOption%></span></a>
		<a class="article_command" href='index.jsp'><span>返回主页</span></a>
		<a class="article_command" href='viewArticle.jsp'><span>返回文章列表</span></a> 
		<div id="clear"></div>
		</div>
		<p class="content"><%=content%> <p>
		<%=msg%><br><br>
	</div> 
</body> 
</html>

