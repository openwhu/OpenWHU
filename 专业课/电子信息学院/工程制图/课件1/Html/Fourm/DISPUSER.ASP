<!--#include file="conn.asp"-->
<!--#include file="inc/char.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/grade.asp"-->
<%
Response.Expires=0
dim username
cname=membername
username=trim(request("name"))
FoundError=false
strIcons = 1
strflash= 1
strIMGInPosts = 1
if username="" then
   	ErrMsg=Errmsg+"<br>"+"请输入姓名"
	founderror=true
else
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title><%=ForumName%>--<%=htmlencode(cname)%>查询个人资料</title>
<meta name="GENERATOR" content="Microsoft FrontPage 3.0">
<link rel="stylesheet" type="text/css" href="forum.css">
</head>
<body leftmargin="20" topmargin="20" rightmargin="20" bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333">
<%
   set rs=server.createobject("adodb.recordset")
   sql="select * from [User] where username='"&UserName&"'"
   rs.open sql,conn,1,1
   if err.number<>0 then 
      ErrMsg=Errmsg+"<br>"+"<li>数据库操作失败："&err.description
      founderror=true
   end if
      if rs.eof and rs.bof then
         ErrMsg=Errmsg+"<br>"+"<li>您查询的名字不存在"
	 founderror=true
      else
%>
    <table cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#777777 align=center>
        <tr>
            <td>
                
<table cellpadding=3 cellspacing=1 border=0 width=100%>
<tr bgcolor=#EEEEEE> 
<td align=center height=22 colspan="2"> <%=htmlencode(cname)%>查询个人资料</td>
</tr>
<tr bgcolor=#FFFFFF> 
<td align=center height=22 colspan="2"> <font color="#0000A0"><strong><%=htmlencode(username)%>的资料</strong><font color=red>(登陆社区<%=rs("logins")%>次)</font></td>
</tr>
<% if TitleFlag and rs("title")<>"" then %>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>头 衔：</strong></td>
<td width="70%" height="22"> <%= rs("title") %> </td>
</tr>
<% end if %>
<% if GroupFlag then %>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="10"><strong>门 派：</strong></td>
<td width="70%" height="-2"> <%= rs("usergroup") %> </td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="11"><b>财 产：</b></td>
<td width="70%" height="0"><%= rs("userWealth") %></td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><b>经验值：</b></td>
<td width="70%" height="22"><%= rs("userEP") %></td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><b>魅力值：</b></td>
<td width="70%" height="22"><%= rs("userCP") %></td>
</tr>
<% end if %>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>性 别：</strong></td>
<td width="70%" height="22"> 
<%if rs("sex")=0 then   
    response.write("靓妹")   
else   
    response.write("酷哥")   
end if   
%>
</td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>发表文章数：</strong></td>
<td width="70%" height="22"><%=rs("article")%></td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>E_Mail：</strong></td>
<td width="70%" height="22"> 
<%if trim(rs("useremail"))<>"" then%>
<a href="mailto:<%=htmlencode(rs("useremail"))%>"><%=htmlencode(rs("useremail"))%></a> 
<%end if%>
</td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>OICQ：</strong></td>
<td width="70%" height="22"> 
<%if rs("oicq")<>"" then%>
<%=htmlencode(rs("oicq"))%> 
<%end if%>
</td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>主 页：</strong></td>
<td width="70%" height="22"> 
<%if trim(rs("homepage"))<>"" then%>
<a href="<%=htmlencode(rs("homepage"))%>"
    target="_blank"><%=htmlencode(rs("homepage"))%></a> 
<%end if%>
</td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>签 名：</strong></td>
<td width="70%" height="22"> 
<%if rs("sign")<>"" then%>
<%=ubbcode(rs("sign"))%> 
<%end if%>
</td>
</tr>
<tr bgcolor=#FFFFFF> 
<td width="30%" align="right" height="22"><strong>社区等级：</strong></font></td>
<td width="70%" height="22"><%=grade(rs("userclass"))%></td>
</tr>
<tr bgcolor=#EEEEEE> 
<td align=center height=22 colspan="2"> <a href="messanger.asp?action=new&touser=<%=htmlencode(username)%>">给他留言</a></td>
</tr>
</table>
</td></tr></table>
<%end if%>
</body>
</html>
<%end if

if founderror=true then
	call error()
end if
rs.close
set rs=nothing
call endConnection()
%>