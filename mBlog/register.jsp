<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*, java.util.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<% request.setCharacterEncoding("utf-8");
	String msg = "";Class.forName("com.mysql.jdbc.Driver");
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog"
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String username = "";
	String password1 = "";
	String password2 = "";
	String moreinfo = "";
	String fmt="",sql="";
	int cnt=0;
	if(request.getMethod().equalsIgnoreCase("post")){
	 	username = request.getParameter("name");
	 	password1 = request.getParameter("password1");
	 	password2 = request.getParameter("password2");
	 	moreinfo = request.getParameter("moreinfo");

			Connection con = DriverManager.getConnection(connectString,"******", "******");
			Statement stmt = con.createStatement();
			String imagePath="";
			String imageName="";
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			if (isMultipart) {
				FileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				List items = upload.parseRequest(request);
				for (int i = 0; i < items.size()-1; i++) {
					FileItem fi = (FileItem) items.get(i);
					if (fi.isFormField()) {	//如果是表单字段
						if(cnt==0){
							username=fi.getString("utf-8");	//读得id
							cnt+=2;
						}
						//else if(cnt==1){
						//	username=fi.getString("utf-8");	//读得id
						//	cnt++;
						//}
						else if(cnt==2){
							password1=fi.getString("utf-8");	//读得id
							cnt++;
						}
						else if(cnt==3){
							password2=fi.getString("utf-8");	//读得id
							cnt++;
						}
						else if(cnt==4){
							moreinfo=fi.getString("utf-8");	//读得id
							cnt++;
						}

					}
					else
					{	//如果是文件
						DiskFileItem dfi = (DiskFileItem) fi;
						if (!dfi.getName().trim().equals("")) {	//getName()返回文件名称或空串
							//out.print("文件被上传到服务上的实际位置：");
							imageName = FilenameUtils.getName(dfi.getName());
							String fileName = application.getRealPath("/images/headImg")
									+ System.getProperty("file.separator")
									+ imageName;
							imageName = FilenameUtils.getName(dfi.getName());
							imagePath = request.getContextPath()+"/file/"+imageName;
							//out.print(new File(fileName).getAbsolutePath());
							dfi.write(new File(fileName));
							//out.print("<p><a href='"+imagePath+"'>"+imageName+"</a></p>");
					}
				}
			}
		}
		if(password2==null){
			msg = "请输入所有信息！";
		}
		else if(password1!=null && password2!=null && password1.equals(password2)){
			try{
				fmt="select * from users where uname='%s';";
				sql = String.format(fmt,username);
				ResultSet rs = stmt.executeQuery(sql);
				if(!rs.next()){
					fmt="insert into users(uname,upas,profilePhoto,moreinfo) values('%s','%s','%s','%s')";
					sql = String.format(fmt,username,password1,imageName,moreinfo);
					cnt = stmt.executeUpdate(sql);
					if(cnt>0){
						msg = "注册成功!";
						response.sendRedirect("login.jsp");	//跳转到登陆页面
					}
				}else{
					msg = "该用户名已存在！";
				}
				stmt.close();
				con.close();
				}catch (Exception e){
					msg = e.getMessage();
			}
		}
	 	else{
	 		msg = "两次输入的密码不一致，请重新输入！";
	 	}


	}
%>
<!DOCTYPE HTML>
<html>
		<head>
			<title>用户注册</title>
			<link rel="stylesheet" href="css/register.css" />
			<link rel="stylesheet" href="css/style.css" />
		</head>
	<body>
		<div id="title">
		<h1>mBlog</h1>
		<h2>Make your life interesting!</h2>
		</div>
		<div class="container">
			<div class="input_table">
			<!--<%=username%></br></br><%=password1%></br></br><%=password2%></br></br><%=moreinfo%>-->
			<form name="register" action="register.jsp" method="POST" enctype="multipart/form-data">
				<input type="text" name="name" value="<%=username%>" id="username" class="input_text light" placeholder="Name"/><br><br>
				<input type="password" name="password1" value="<%=password1%>" id="userpsw" class="input_text light" placeholder="Password(length 6 - 20 )："/><br><br>
				<input type="password" name="password2" value="<%=password2%>" id="confirm" class="input_text light" placeholder="Confirm Again"/><br><br>
				<textarea type="text" name="moreinfo" id="more" placeholder="Introduction" class="input_text  light"><%=moreinfo%></textarea><br><br>
				<span class="input_text  light">
				上传头像<input type="file" name="file" size=24/><br><br>
				</span>
				<input type="submit" name="sub" value="注册" id="regis_button" class="input_button"/><br><br>
		    </form>
			<p><%=msg%></p>
			<div class="back">
				<a href='login.jsp' > < 返回登录</a>
				<div id="clear"></div>
			</div>
			</div>
		</div>
	</body>
</html>
