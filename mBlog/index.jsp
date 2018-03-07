<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
<%  request.setCharacterEncoding("utf-8"); 
//	String session_id = session.getId();//得到当前sessionID
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection con=null;Statement stmt =null;String masterIdx="";
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8"; 
	String msg =""; String prevP="<";String nextP=">";String exit="退出登录";
//	String Login = (String)session.getAttribute("Login");	//得到值为"OK",登陆成功
	String uid= (String)session.getAttribute("UID");	//得到UID
	String uname= "";//(String)session.getAttribute("uname");	//得到Uname
	String login = "";//(String)session.getAttribute("LoginMsg");
	String mode = (String)session.getAttribute("MODE");
	String addArticleOption="新增文字";
	String addImageOption="新增相片";
    if(mode==null){
    	session.setAttribute("MODE","VISITOR");
		response.sendRedirect("login.jsp");
	}
	else if(mode.equals("MASTER")){
		addArticleOption="";
		addImageOption="";
		masterIdx="返回管理员界面";
		exit="退出管理员模式";
	}
	else if(mode.equals("VISITOR")){
		addArticleOption="";
		addImageOption="";
		exit="退出游客模式";
	}
	if(uid==null && request.getParameter("uid")==null){
		session.setAttribute("MODE","VISITOR");
		response.sendRedirect("login.jsp");
	}
	if(request.getParameter("uid")!=null &&!(mode==null) && mode.equals("MASTER")){
		uid=(String)request.getParameter("uid");
		session.setAttribute("UID",uid);
	}
	
	
	/* 
	//session失效,跳转到viewArticle
	if( mode==null || login==null || !login.equals(uid+"_"+session_id)) {
		session.setAttribute("MODE","VISITOR");
	}*/
	String user_intro="";
	String filePhoto= "";	
	int rowCount = 0; //获得ResultSet的总行数
	Integer pgno = 0;	//当前页号
	Integer pgcnt = 4;	//每页行数
	String param = request.getParameter("pgno");	//获取页号
	if(param!=null&&!param.isEmpty()){
		pgno = Integer.parseInt(param);
	}
	if(pgno==0){
		prevP="";
	}
	param = request.getParameter("pgcnt");	//获取每页行数
	if(param!=null&&!param.isEmpty()){
		pgcnt=Integer.parseInt(param);
	}
	int pgprev = (pgno>0)?pgno-1:0;	//上一页
	int pgnext =  pgno+1;	//下一页
	StringBuilder table = new StringBuilder(); 
	try{
		con=DriverManager.getConnection(connectString, "mBlog", "2287"); 
		stmt=con.createStatement(); 

		String sql=String.format("select * from article  where uid = %s limit %d,%d; ",uid,pgno*pgcnt,pgcnt); 
		ResultSet rs=stmt.executeQuery(sql); 
		table.append("<table>"); 
		while(rs.next()) { 
			table.append(String.format( "<tr><td class='article_title'>%s</td><td><p class=\"article_content\">%s</p></td></tr>","<p><a href='theArticle.jsp?articleId="+rs.getString("articleId")+"' class=\"index_article_title\">"+rs.getString("title")+"</a></p><p class=\"date\">"+rs.getString("publishDate")+"<p>",rs.getString("content").replaceAll("\n","</br>"))); 
		} 
		table.append("</table>"); 
		sql=String.format("select * from article  where uid = %s limit %d,%d; ",uid,(pgno+1)*pgcnt,pgcnt); 
		rs=stmt.executeQuery(sql); 
		if(!rs.next()){
			nextP="";
		}
		sql=String.format("select * from users  where uid = %s ; ",uid); 
		rs=stmt.executeQuery(sql); 
		while(rs.next()) { 
			uname=rs.getString("uname");
			user_intro=rs.getString("moreinfo");
			filePhoto=rs.getString("profilePhoto");
		}
		rs.close();  
		stmt.close();  
		con.close();
		} catch (Exception e){ 
			msg = e.getMessage(); 
	}
%>
<!DOCTYPE HTML> 
<html> 
<head> 
	<title>mBlog - make your life interesting </title>
	<link rel="stylesheet" href="css/index.css" />
	<link rel="stylesheet" href="css/style.css" />
</head> 
<body> 
	<div class="aboutMe">
		<p><img src="images/headImg/<%=filePhoto%>" id="user_portrait"></img></p>
		<p id="user_name"><%=uname%></p>
		<p id="user_intro"><%=user_intro%></p></br>
		<div id="menu"><!--
		<p><a class="menu" href="viewArticle.jsp">About Me</a></p></br>-->
		<p><a class="menu" href="viewArticle.jsp">查看文章列表</a></p></br>
		<p><a class="menu" href="album.jsp">查看相册</a></p></br>

		<p><a class="menu" href="addArticle.jsp"><%=addArticleOption%></a></p></br>
		<p><a class="menu" href="addImage.jsp"><%=addImageOption%></a></p></br>
		<p><a class="menu" href="masterIndex.jsp"><%=masterIdx%></a></p>
		<p><a class="menu" href="login.jsp?status=logout"><%=exit%></a></p>
		</div>
	</div> 
	<div class="turn_page"> 
		<a href="index.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>"><%=prevP%></a>&nbsp;
		<a href="index.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>"><%=nextP%></a>
	</div>
	<div class="container">
		<h1> </h1> 
		 <%=table%>
		<p><%=msg%></p>  
	</div> 
</body> 
</html>

