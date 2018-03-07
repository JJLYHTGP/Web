<%@ page language="java" import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8"%> 
<% request.setCharacterEncoding("utf-8");
	String mode= (String)session.getAttribute("MODE");
	String msg = ""; String title = ""; 
	Class.forName("com.mysql.jdbc.Driver"); 
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";   
	String articleId=(String) request.getParameter("articleId");
	String content = "";Connection con=null;Statement stmt =null;
    if(mode==null){
		response.sendRedirect("login.jsp");
	}
    else if(!mode.equals("USER")){
    	response.sendRedirect("viewArticle.jsp");	//跳转到页面;
	}else{  
	articleId=(String) request.getParameter("articleId");	
	//得到articleID
	con = DriverManager.getConnection(connectString,"mBlog", "2287");
	stmt = con.createStatement();
	
	try{ 
		String sql="select * from article where articleId='"+articleId+"';";   
		ResultSet rs = stmt.executeQuery(sql);
		if(rs.next()){
			title=rs.getString("title");
			content=rs.getString("content");
		}
		stmt.close(); 
		con.close(); 
	}catch (Exception e){ 
		msg = e.getMessage(); 
	}
	if(request.getMethod().equalsIgnoreCase("post")){
		con = DriverManager.getConnection(connectString,"mBlog", "2287");
		stmt = con.createStatement(); 
	 	title = request.getParameter("title"); 
	 	content = request.getParameter("content"); 
	 	articleId=(String) request.getParameter("articleId");
		try{ 
			String fmt="update article set title='%s',content='%s',publishDate=now() where  articleId='%s'"; 
			String sql = String.format(fmt,title,content,articleId); 
			int cnt = stmt.executeUpdate(sql); 
			if(cnt>0){
				msg = "修改成功!"; 
				//保存同时瞬间跳转到列表  也可以跳转到
				response.sendRedirect("viewArticle.jsp");	//跳转到页面
			}
			else{
				msg = "修改不成功!";
			}
			stmt.close(); 
			con.close(); 
			}catch (Exception e){ 
				msg = e.getMessage(); 
		} 
	} 
}
%> 
<!DOCTYPE HTML> 
	<html> 
		<head> 
		<title>mBlog - update article</title> 

		<link rel="stylesheet" href="css/viewArticle.css" />
		<link rel="stylesheet" href="css/style.css" />
		<link rel="stylesheet" href="css/add.css" />
		 
		</head> 
		<!--
	<body> 
		<div class="container"> 
			<p>
			<form action="updateArticle.jsp" method="post" name="f"> 
				<input type="submit" name="sub" value=" 保存"/> 
				<input type="hidden" name="articleId" value=" <%=articleId%>"/> 
				题目:<textarea id="title" name="title" type="text"><%=title%></textarea> 
				文章:<textarea id="content" type="text" name="content"><%=content%></textarea>
				 
			</form> 
			</p>
			<a href='index.jsp'>返回主页</a>
			<a href='viewArticle.jsp'>返回文章列表</a> 
		</div> 
	</body> -->
	<body> 
		<h1 class="add_title">UPDATE ARTICLE</h1>
		<div class="add_container"> 
			<div class="tool_bar">
			<a class="article_command" href='index.jsp'>返回主页</a>
			<a class="article_command" href='viewArticle.jsp'>返回文章列表</a> 
			<div id="clear"></div>
			</div>
			<form action="updateArticle.jsp" method="post" name="f"> 
				<input type="hidden" name="articleId" value=" <%=articleId%>"/>
				<textarea id="title" class="input_text" rows="1" cols="20" placeholder="Title" name="title"  type="text"> <%=title%></textarea> </br></br>
				<textarea id="content" class="input_text" rows="10" cols="50" placeholder="content" type="text" name="content"><%=content%> </textarea></br>
				<input id="publish_button" type="submit" class="input_button" name="sub" value="PUBLISH"/>
			</form> 
			<%=msg%> 
		</div> 
			<p id="time">
				<script type="text/javascript">  
					//动态显示  
					setInterval("document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);  
                </script>  
			</p>
	</body> 
</html>