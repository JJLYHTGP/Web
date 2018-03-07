<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%><%request.setCharacterEncoding("utf-8");
	Class.forName("com.mysql.jdbc.Driver");
	String session_id = session.getId();
	String msg="";
	String sql="";
	String find_blog="";
	String user_uid="";
	String user_uname="";
	Connection con=null;
	Statement stmt=null;
	ResultSet rs = null;
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	String status = request.getParameter("status");
	//退出登录，删除session的登录消息
	if(status != null && status.equals("logout")){
		session.removeAttribute("LoginMsg");
		session.setAttribute("MODE","VISITOR");
	}
	if(request.getMethod().equalsIgnoreCase("post")){
		//跳转到注册界面
		if(request.getParameter("reg")!=null){
    		response.sendRedirect("register.jsp");
  		}
  		//跳转到游客界面
  		else if(request.getParameter("visit")!=null){
  			session.removeAttribute("LoginMsg");
  			session.setAttribute("MODE","VISITOR");
  			con = DriverManager.getConnection(connectString,"******", "******");
			stmt = con.createStatement();
  			try{
  				user_uname=request.getParameter("BlogName");
				sql = "select uid from users where uname='"+user_uname+"';";
				rs = stmt.executeQuery(sql);
				while(rs.next()) {
					user_uid = rs.getString("uid");
				}
				stmt.close(); 
				con.close();
				//若存在Uid，跳转
				if(!(user_uid.equals(""))){
					session.setAttribute("UID",user_uid);	
					//session消息，博客UID	
					//session消息，此会话uid_session_id，可以用于与后续页面比较。
					response.sendRedirect("index.jsp");	//跳转到页面
				} else {
					msg = "该用户不存在！";
				}
			}catch(Exception e){
				msg = e.getMessage();
			}
  		}
  		else{
			con = DriverManager.getConnection(connectString,"******", "******");
			stmt = con.createStatement();
			String bokePwd = request.getParameter("num");
			String name = request.getParameter("name");
			if(name.equals("admin") & bokePwd.equals("123")){
				session.setAttribute("MODE","MASTER");
				//session消息，管理员模式
				response.sendRedirect("masterIndex.jsp");	//跳转到页面
			}else{
				try{
					sql = "select uid from users where uname='"+name+"' and upas='"+bokePwd+"';";
			 		rs = stmt.executeQuery(sql);
					while(rs.next()) {
						user_uid = rs.getString("uid");
					}	
					stmt.close(); con.close();
					//若存在Uid，跳转
					if(!(user_uid.equals(""))){
						session.setAttribute("MODE","USER");
						session.setAttribute("Login","OK");	
						//session消息，登陆成功
						session.setAttribute("UID",user_uid);	
						//session消息，博客UID
						session.setAttribute("uname",name);	
						//session消息，uname
						String LoginMsg = user_uid+"_"+session_id;
						session.setAttribute("LoginMsg",LoginMsg);	
						//session消息，此会话uid_session_id，可以用于与后续页面比较。
						response.sendRedirect("index.jsp");	//跳转到页面
					} else {
						msg = "用户名或密码错误！";
					}
				}catch(Exception e){
					msg = e.getMessage();
				}
			}//else
		}
	}
%><!DOCTYPE HTML>
<html>
<head>
<title>mBlog - make your life interesting </title>
<link rel="stylesheet" href="css/login.css" />
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
	<div id="title">
	<h1>mBlog</h1>
	<h2>Make your life interesting!</h2>
	</div>
	<div class="container">
		<div class="input_table">
		<form action="login.jsp" method="post" name="f">
			<input id="name" name="name" type="text" class="input_text  light" placeholder="User Name"/><br><br>
			<input id="num" name="num" type="password" class="input_text light" placeholder="Password"/><br><br>
			<div id="button_2">
			<input type="submit" name="sub" value="Sign in" class="input_button" id="signin_button"/>
			<input type="submit" name="reg" value="Register" class="input_button" id ="regis_button"/>
			</div>
		<!-- </form>
		<form action="login.jsp" method="post" name="f"> -->
			<input id="BlogName" name="BlogName" type="text" placeholder="Find Blog" class="input_text"/> 
			<input type="submit" name="visit" value="GO" class="input_button"/>
		</form>
		<p><%=msg%></p><!-- <%=request.getParameter("visit")%> -->
		</div>
	</div>
</body>
</html>
