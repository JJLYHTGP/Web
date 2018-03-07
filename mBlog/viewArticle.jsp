<%@ page language="java" 
import="java.util.*,java.sql.*" 
contentType="text/html; charset=utf-8" %>
	<%  request.setCharacterEncoding("utf-8");
  String uid= (String)session.getAttribute("UID");
  String mode= (String)session.getAttribute("MODE");
  String addOption="新增";
  if(uid==null || mode==null){
    response.sendRedirect("login.jsp");
  } 
  else if(!mode.equals("USER")){
      addOption="";
  }
  Class.forName("com.mysql.jdbc.Driver"); 
  StringBuilder table = new StringBuilder();
  String msg = "";String prevP="<";String nextP=">";String uname="";
  String connectString = "jdbc:mysql://123.207.47.128:3306/mblog"
                    + "?autoReconnect=true&useUnicode=true"
                    + "&characterEncoding=UTF-8";
  Statement stmt = null;Connection con = null;
  ResultSet rs = null;String query = "";String sql = ""; 
  Integer pgno = 0;   //当前页号 
  Integer pgcnt = 4; //每页行数 
  String param = request.getParameter("pgno");
  query=(String)session.getAttribute("query");
    if(query==null){
      query="";
  }
  if(param != null && !param.isEmpty()){ 
    pgno = Integer.parseInt(param); 
  } 
  if(pgno==0){
     prevP="";
    }
  param = request.getParameter("pgcnt"); 
  if(param != null && !param.isEmpty()){ 
    pgcnt = Integer.parseInt(param); 
  } 
  int pgprev = (pgno>0)?pgno-1:0; 
  int pgnext = pgno+1; 

  
//  String LoginMsg=(String)session.getAttribute("LoginMsg");   
  
  
	 if(uid!=null && mode!=null){	
	try {
        con = DriverManager.getConnection(connectString,
                            "****", "****");
        stmt = con.createStatement();
        sql="select * from article where uid = "+uid;
        if (request.getMethod().equalsIgnoreCase("post")){
        	query = request.getParameter("query");
        	session.setAttribute("query",query);
        }
        sql="select * from article  where uid = "+uid+" and title like '%"+query+"%'"+String.format(" limit %d,%d;",pgno*pgcnt,pgcnt);
        rs = stmt.executeQuery(sql);
        
        if(mode.equals("VISITOR")){
        	table.append("<table>");
        	while (rs.next()) {
				/*
        		table.append(String.format(
          		"<tr><td>%s</td><td>%s</td></tr>",
          		rs.getString("articleId"),
          		"<a href='theArticle.jsp?articleId="+rs.getString("articleId")+"'>"+rs.getString("title")+"</a>"));
				*/
				table.append(String.format( "<tr><td class='article_title'>%s</td><td><p class=\"article_content\">%s</p></td></tr>","<p><a href='theArticle.jsp?articleId="+rs.getString("articleId")+"' class=\"index_article_title\">"+rs.getString("title")+"</a></p><p class=\"date\">"+rs.getString("publishDate")+"</p>","<p>"+rs.getString("content").replaceAll("\n","</br>")+"</p>")); 
	        }
			
          

    	}
    	else{
    		table.append("<table>");
        	while (rs.next()) {
        	if(mode.equals("MASTER")){
				
        		table.append(String.format(
          		"<tr><td>%s</td><td>%s</td><td>%s</td></tr>",
          		rs.getString("articleId"),
          		"<a href='theArticle.jsp?articleId="+rs.getString("articleId")+"'>"+rs.getString("title")+"</a>",
          		"<a href='deleteArticle.jsp?articleId="+rs.getString("articleId")+"'>删除</a>" ));
				
				
        	}else{
				/*
        		table.append(String.format(
          		"<tr><td>%s</td><td>%s</td><td>%s %s</td></tr>",
          		rs.getString("articleId"),
          		"<a href='theArticle.jsp?articleId="+rs.getString("articleId")+"'>"+rs.getString("title")+"</a>",
         		"<a href='updateArticle.jsp?articleId="+rs.getString("articleId")+"'>修改</a>",
          		"<a href='deleteArticle.jsp?articleId="+rs.getString("articleId")+"'>删除</a>" ) );
				*/
				table.append(String.format( 
				"<tr><td class='article_title'>%s</td><td><p class=\"article_content\">%s</p></td></tr>",
				"<p><a href='theArticle.jsp?articleId="+rs.getString("articleId")+"' class=\"index_article_title\">"+rs.getString("title")+"</a></p><p class=\"date\">"+rs.getString("publishDate")+"<p><a class='article_command' href='updateArticle.jsp?articleId="+rs.getString("articleId")+"'>修改</a><a class='article_command' href='deleteArticle.jsp?articleId="+rs.getString("articleId")+"'>删除</a>",
				rs.getString("content").replaceAll("\n","</br>"))); 
	        
	        }
	    }
    	}  
        table.append("</table>");
        sql=String.format("select * from article  where uid = %s limit %d,%d; ",uid,(pgno+1)*pgcnt,pgcnt); 
        rs=stmt.executeQuery(sql); 
        if(!rs.next()){
          nextP="";
        }
        sql=String.format("select * from users  where uid = %s  ",uid); 
        rs=stmt.executeQuery(sql); 
        if(rs.next()){
          uname=rs.getString("uname");
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        msg = e.getMessage();
        out.print(msg);
    }
}
%>
<!DOCTYPE HTML> 
<html> 
<head> 
	<title> </title> 
	<link rel="stylesheet" href="css/viewArticle.css" />
	<link rel="stylesheet" href="css/style.css" />
</head> 
<body> 
	<div class="container"> 
		<h1><%=uname%>'s Articles</h1> 
		
		<div id="addOrReturnDiv"> 
			<a class="article_command" href="addArticle.jsp"><%=addOption%></a> 
			<a class="article_command" href='index.jsp'>返回主页</a>
			<div id="clear"></div>
		</div> 
		
		<form action="viewArticle.jsp" method="post">
	  	    <input class="input_text" type="text" name="query" placeholder="搜索关键字" value="<%=query%>"></input>
	  	    <input type="submit" name="submit" class="search_button" value="搜索"></input>
	    </form>
        <br><br>
		<%=table%> 
		<div class="turn_page">
		<a class="viewArticle_left" href="viewArticle.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>"><%=prevP%></a>
		<a class="viewArticle_right" href="viewArticle.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>"><%=nextP%></a>
		</div>
		<br><br> 
		<br><br> 
		<%=msg%>
	</div> 
</body> 
</html>

