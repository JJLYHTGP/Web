<%@ page language="java" import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8"%> 
<%@ page import="java.io.*, java.util.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<% request.setCharacterEncoding("utf-8"); 
	String uid= (String)session.getAttribute("UID");	//得到UID
	String mode= (String)session.getAttribute("MODE");
	String msg = ""; 
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection con=null;Statement stmt =null;
	String connectString = "jdbc:mysql://123.207.47.128:3306/mblog" 
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";   
	String title = ""; 
	String content = ""; 
    if(uid==null || mode==null){
		response.sendRedirect("login.jsp");
	}
    else if(!mode.equals("USER")){
    	response.sendRedirect("index.jsp");	//跳转到页面;
	}
	else{
	if(request.getMethod().equalsIgnoreCase("post")){ 
	 	content = request.getParameter("content"); 
		con = DriverManager.getConnection(connectString,"******", "******"); 
		stmt = con.createStatement(); 
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
				content=fi.getString("utf-8");	//读得id
			}
			else {	//如果是文件
				DiskFileItem dfi = (DiskFileItem) fi;
				if (!dfi.getName().trim().equals("")) {	//getName()返回文件名称或空串
					//out.print("文件被上传到服务上的实际位置：");
					imageName=uid+"_"+FilenameUtils.getName(dfi.getName());
					String fileName=application.getRealPath("/images/albums")
							+ System.getProperty("file.separator")
							+ imageName;
					imageName=uid+"_"+FilenameUtils.getName(dfi.getName());
					imagePath=request.getContextPath()+"/file/"+imageName;
					//out.print(new File(fileName).getAbsolutePath());
					dfi.write(new File(fileName));
					//out.print("<p><a href='"+imagePath+"'>"+imageName+"</a></p>");
				} 
			}
			} 
		} 
		
		try{ 
			String fmt="insert into album(ImagePath,UserId,ImageIntro,ImagePublishDate) values('%s','%s','%s',now())"; 
			String sql = String.format(fmt,imageName,uid,content); 
			int cnt = stmt.executeUpdate(sql); 
			if(cnt>0){
				msg = "保存成功!"; 
				//保存同时瞬间跳转到列表  也可以跳转到
				response.sendRedirect("album.jsp");
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
			<title>mBlog - publish photo</title> 
					<link rel="stylesheet" href="css/viewArticle.css" />
		<link rel="stylesheet" href="css/style.css" />
		<link rel="stylesheet" href="css/add.css" />
		</head> 
	<body> 
		<h1 class="add_title">NEW PHOTO</h1>
		<div class="add_container"> 
			<div class="tool_bar">
				<a class="article_command" href='index.jsp'>返回主页</a>
				<a class="article_command" href='album.jsp'>返回相册</a> 
				<div id="clear"></div>
			</div>
			<form action="addImage.jsp" method="post" name="f" enctype="multipart/form-data"> 
				<div class="upload">图片: &nbsp;<input type="file" class="photo_upload" size=50 name="file" ></div>
				<p><textarea id="content" class="input_text" rows="7" cols="50" placeholder=" A brief introduction" type="text" name="content"></textarea></p>
				 
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