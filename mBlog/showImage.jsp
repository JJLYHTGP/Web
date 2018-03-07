<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
	<%  request.setCharacterEncoding("utf-8");
	String mode= (String)session.getAttribute("MODE");
	String deleteOption="删除";
	String uid= (String)session.getAttribute("UID");	//得到UID
	String msg = ""; 
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";   
	String imageName =(String)request.getParameter("imgName");	//得到imgName
	
	String uname= (String)request.getParameter("uname");	//得到Uname
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection con = DriverManager.getConnection(connectString,"mBlog", "2287");
	Statement stmt = con.createStatement();
	stmt = con.createStatement(); 
	String content = "";
    if(mode==null || uid==null ){
		response.sendRedirect("login.jsp");
	}else{
    if(mode.equals("VISITOR")){
    	deleteOption="";
	} 
	
	try{ 
		String sql="select * from album where ImagePath='"+imageName+"';";   
		ResultSet rs = stmt.executeQuery(sql);
		if(rs.next()){
			content=rs.getString("ImageIntro").replaceAll("\n","</br>");
		}
		sql="select * from users where uid='"+uid+"';";   
		rs = stmt.executeQuery(sql);
		if(rs.next()){
			uname=rs.getString("uname");
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
	<title>mBlog - Image</title> 
		<link rel="stylesheet" href="css/viewArticle.css" />
		<link rel="stylesheet" href="css/style.css" />
		<link rel="stylesheet" href="css/add.css" />
		<link rel="stylesheet" href="css/show.css" />
</head> 
<body> 
	<h1 class="add_title" ><%=uname%>'s Image </h1>
	<div class="container"> 
		<div class="tool_bar_show">
		<a  class="article_command"  href='deleteImage.jsp?imgName=<%=imageName%>'><%=deleteOption%></a>
		<a  class="article_command"  href='index.jsp'>返回主页</a>
		<a  class="article_command"  href='album.jsp'>返回相册</a> 
		<div id="clear"></div>
		</div>
		<img class="showImage_image" src="images/albums/<%=imageName%>"/></br>
		<p class="article_content"><%=content%> </p>
		<%=msg%><br><br>
	</div> 
</body> 
</html>

