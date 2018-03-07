<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
	<%  request.setCharacterEncoding("utf-8"); 
	String msg =""; String prevP="<";String nextP=">";
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection con=null;Statement stmt =null;
	String uid= "";	//得到UID
	String mode = (String)session.getAttribute("MODE");
    if(mode==null ||( mode!=null && !mode.equals("MASTER"))){
    	session.setAttribute("MODE","VISITOR");
		response.sendRedirect("login.jsp");
	}
	int rowCount = 0; //获得ResultSet的总行数
	Integer pgno = 0;	//当前页号
	Integer pgcnt = 10;	//每页行数
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
		con=DriverManager.getConnection(connectString, "******", "******"); 
	    stmt=con.createStatement(); 

		String sql=String.format("select * from users  limit %d,%d; ",pgno*pgcnt,pgcnt); 
		ResultSet rs=stmt.executeQuery(sql); 
		table.append("<table class=\"masterIndex_table\"><tr><th>User ID</th><th>User Name</th>"+ "<th></th></tr>");
        while (rs.next()) {
          table.append(String.format(
          "<tr><td>%s</td><td>%s</td><td>%s</td></tr>",
          "<p class=\"user_id\" >" + rs.getString("uid")+"</p>",
          "<a class=\"index_article_title\" href='index.jsp?uid="+rs.getString("uid")+"'>"+rs.getString("uname")+"</a>",
          "<a class=\"article_command\" href='deleteUser.jsp?uid="+rs.getString("uid")+"'>封号</a>"	  ));
        }
		table.append("</table>"); 
		sql=String.format("select * from users limit %d,%d; ",(pgno+1)*pgcnt,pgcnt); 
		rs=stmt.executeQuery(sql); 
		if(!rs.next()){
			nextP="";
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
	<title>mBlog - Manager Page </title>
	<link rel="stylesheet" href="css/index.css" />
	<link rel="stylesheet" href="css/style.css" />
	<link rel="stylesheet" href="css/masterPage.css" />
	<link rel="stylesheet" href="css/album.css" />
</head> 
<body> 
	<div class="aboutMe">
		<h1>Manage Page</h1>
		<div id="managePage_tool_bar">
			<p><a href="login.jsp" class="menu">退出管理员模式</a></p>
			<div id="clear"></div>
		</div>
	</div>
	<div class="turn_page">
		<a href="index.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>"><%=prevP%></a>
		<a href="index.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>"><%=nextP%></a>
	</div>
	<div class="container"> 
		<h1> </h1> 
		<%=table%>
		
		<p><%=msg%></p> 
	</div> 
</body> 
</html>

