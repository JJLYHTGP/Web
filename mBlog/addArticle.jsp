<%@ page language="java" import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8"%> 
<% request.setCharacterEncoding("utf-8"); Class.forName("com.mysql.jdbc.Driver"); 
	String mode= (String)session.getAttribute("MODE");
	String uid= (String)session.getAttribute("UID");	//得到UID
	String msg = ""; Connection con=null;Statement stmt =null;
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";   
	String title = ""; 
	String content = ""; 
	if(uid==null || mode==null){
		response.sendRedirect("login.jsp");
	}
    else if(!mode.equals("USER")){
    	response.sendRedirect("viewArticle.jsp");	//跳转到页面;
	} 
	else {
	if(request.getMethod().equalsIgnoreCase("post")){ 
	 	title = request.getParameter("title"); 
	 	content = request.getParameter("content"); 
		con = DriverManager.getConnection(connectString,"****", "****"); 
		stmt = con.createStatement(); 
		try{ 
			String fmt="insert into article(uid,title,content,publishDate) values('%s','%s','%s',now())"; 
			String sql = String.format(fmt,uid,title,content); 
			int cnt = stmt.executeUpdate(sql); 
			if(cnt>0){
				msg = "保存成功!"; 
				//保存同时瞬间跳转到列表  也可以跳转到
				response.sendRedirect("viewArticle.jsp");	//跳转到页面
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
		<title>mBlog - publish article</title> 
		<link rel="stylesheet" href="css/viewArticle.css" />
		<link rel="stylesheet" href="css/style.css" />
		<link rel="stylesheet" href="css/add.css" />
		</head> 
	<body> 
		<h1 class="add_title">NEW ARTICLE</h1>
		<div class="add_container"> 
			<div class="tool_bar">
			<a class="article_command" href='index.jsp'>返回主页</a>
			<a class="article_command" href='viewArticle.jsp'>返回文章列表</a> 
			<div id="clear"></div>
			</div>
			<form action="addArticle.jsp" method="post" name="f"> 
				<textarea id="title" class="input_text" rows="1" cols="20" placeholder="Title" name="title"  type="text"> </textarea> </br></br>
				<textarea id="content" class="input_text" rows="10" cols="50" placeholder="content" type="text" name="content"> </textarea></br>
				<input id="publish_button" type="submit" class="input_button" name="sub" value="PUBLISH"/>
				<input type="hidden" name="uid" value="<%=uid%>">
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