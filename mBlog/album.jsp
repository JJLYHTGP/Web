<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
<%  request.setCharacterEncoding("utf-8"); 
 	String uid= (String)session.getAttribute("UID");	//得到UID
	String mode= (String)session.getAttribute("MODE");
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection con=null;Statement stmt =null;
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8"; 
	String filePhoto="";
    String addOption="上传图片";String user_intro = "";String uname="";
    Integer pgno = 0;	//当前页号
	Integer pgcnt = 20;	//每页行数
	String param = request.getParameter("pgno");	//获取页号
	int pgprev = (pgno>0)?pgno-1:0;	//上一页
	int pgnext =  pgno+1;	//下一页
	StringBuilder table = new StringBuilder(); 
	StringBuilder ulList = new StringBuilder();
	StringBuilder imageLarge = new StringBuilder(); 
	//String session_id = session.getId();//得到当前sessionID
	String msg =""; String prevP="<";String nextP=">";
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
    if(uid==null || mode==null){
		response.sendRedirect("login.jsp");
	}else if(!mode.equals("USER")){
    	addOption="";
	}
	if(mode!=null){
//	String Login = (String)session.getAttribute("Login");	//得到值为"OK",登陆成功
	
	//String mode = (String)session.getAttribute("MODE");
	//String uname= (String)session.getAttribute("uname");	//得到Uname
	//String login=(String)session.getAttribute("LoginMsg");
	
	
	//session失效, 跳转到viewAlbum
	//if( login==null || !login.equals(uid+"_"+session_id)) {
	//	response.sendRedirect("viewAlbum.jsp?uid="+uid);
	//}
	try{
		con=DriverManager.getConnection(connectString, "******", "******"); 
		stmt=con.createStatement(); 
		
		String sql=String.format("select * from users  where uid = %s ; ",uid); 
		ResultSet rs=stmt.executeQuery(sql); 
		while(rs.next()) { 
			uname=rs.getString("uname");
			user_intro=rs.getString("moreinfo");
			filePhoto=rs.getString("profilePhoto");
		}

		//sql=String.format("select * from album  where UserId = %s limit %d,%d; ",uid,pgno*pgcnt,pgcnt); 
		sql=String.format("select * from album  where UserId = %s",uid); 
		rs=stmt.executeQuery(sql); 
		table.append("<table>"); 
		ulList.append("<ul>");
		int i=0;
		while(rs.next()) {
			i++;
			table.append(String.format( "<tr><td>%s</td><td>%s</td></tr>",rs.getString("ImagePath"),rs.getString("ImageId"))); 
			ulList.append(String.format(
			"<li><a href=\"showImage.jsp?imgName="+rs.getString("ImagePath")+"&uname="+uname+"\" class=\"view\" id=\"tab1\"><img src=\"images/albums/"+rs.getString("ImagePath")+"\"/></a></li>"));
			
		} 
		table.append("</table>"); 
		ulList.append("</ul>");
		sql=String.format("select * from album  where UserId = %s limit %d,%d; ",uid,(pgno+1)*pgcnt,pgcnt); 
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
	
}
%>
<!DOCTYPE HTML> 
<head>
<title>mBlog - album </title>
	<link rel="stylesheet" href="css/style.css" />
	<link rel="stylesheet" href="css/album.css" />
</head>
    <body>
		<div class="aboutMe">
		<h1><%=uname%>'s Album</h1>
		<p><img src="images/headImg/<%=filePhoto%>" id="user_portrait"></img></p>
		<p id="user_intro"><%=user_intro%></p></br>
		<!--<p>table<%=table%></p>-->
		<div id="addOrReturnDiv">
			<a class="article_command" href="addImage.jsp"><%=addOption%></a>
			<a class="article_command" href="index.jsp">返回主页</a>
			<div id="clear"></div>
		</div>
		</div>
	<div class="container">
        <!--<div id="wrapper">-->
			<%=ulList%>
            <div id="images">
                <%=imageLarge%> 
            </div>
			<div class="clear"></div>
        <!--</div>-->
	</div>
	<!--<div class="turn_page">
		<a id="viewAlbum_left" href="album.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>"><%=prevP%></a>
		<a id="viewAlbum_right" href="album.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>"><%=nextP%></a>
		</div>-->
    </body>
</html>