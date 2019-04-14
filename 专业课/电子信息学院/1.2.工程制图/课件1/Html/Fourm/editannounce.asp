<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<!--#include file="inc/code.asp"-->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/grade.asp"-->
<!--#include file="inc/form2.asp"-->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 3.0" CHARSET="GB2312">
<title><%=ForumName%>--贴子修改</title>
<link rel="stylesheet" type="text/css" href="forum.css">
</head>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>

<%
if membername="" then
  Errmsg=Errmsg+"<br>"+"<li>您没有<a href=login.asp>登录</a>，没有权限编辑贴子！"
  call error()
else
   	dim AnnounceID
   	dim RootID
   	dim BoardID
   	dim username
   	dim cname
   	cname=membername
   	dim rs
   	dim sql
   	dim rsBoard
   	dim boardsql,sel
   	dim con,content
   	dim olduser,oldpass

	if request("boardid")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定论坛版面。"
	elseif not isInteger(request("boardid")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的版面参数。"
	else
		boardid=request("boardid")
	end if
	if request("id")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定相关贴子。"
	elseif not isInteger(request("id")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		AnnounceID=request("id")
	end if
	if request("RootID")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定相关贴子。"
	elseif not isInteger(request("RootID")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		RootID=request("RootID")
	end if
	if founderr=true then
		call error()
		response.end
	end if
 
   	set rs=server.createobject("adodb.recordset")
	set rs_old = server.CreateObject ("adodb.recordset")
   	sql="select boardtype from board where boardID="&BoardID
   	rs.open sql,conn,1,1
   	boardtype=rs("boardtype")
   	rs.close
   	sql="select bbs1.username,bbs1.topic,bbs1.body,[user].userclass from bbs1,[user] where bbs1.username=[user].username and bbs1.AnnounceID="&AnnounceID
   	rs.open sql,conn,1,1
	topic=rs("topic")
   	con=rs("body")
	if rs("username")<>Trim(cname) then
	if memberclass=grade(19) and cint(rs("userclass"))=19 then
		response.write"<script language=Javascript>"
		response.write"alert('错误：同等级用户不能修改。');"
		response.write"location.href = 'javascript:history.back()'"
		response.write"</script>"
		set rs = nothing
   		response.end()
	elseif memberclass=grade(20) and cint(rs("userclass"))=20 then
		response.write"<script language=Javascript>"
		response.write"alert('错误：同等级用户不能修改。');"
		response.write"location.href = 'javascript:history.back()'"
		response.write"</script>"
		set rs = nothing
   		response.end()
	elseif memberclass=grade(19) and cint(rs("userclass"))=20 then
		response.write"<script language=Javascript>"
		response.write"alert('错误：不能修改等级比你高的用户贴子。');"
		response.write"location.href = 'javascript:history.back()'"
		response.write"</script>"
		set rs = nothing
   		response.end()
	elseif memberclass<>grade(19) and memberclass<>grade(20) then
 		response.write"<script language=Javascript>"
		response.write"alert('错误：您的等级不足以修改别人的贴子。');"
		response.write"location.href = 'javascript:history.back()'"
		response.write"</script>"
		set rs = nothing
   		response.end()
	else
		sql_old = "select username from [user] where username='"&rs("username")&"'"
		rs_old.Open sql_old,conn,1,1
		old_user = rs_old("username")
		rs_old.Close 
%>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="list.asp?boardid=<%=boardid%>&skin=<%=request("skin")%>"><%=boardtype%></a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;编辑贴子
      </TD></TR></TBODY></TABLE><br>
<%
	call showeditForm()
	end if
	else
		sql_old = "select username from [user] where username='"&rs("username")&"'"
		rs_old.Open sql_old,conn,1,1
		old_user = rs_old("username")
		rs_old.Close 
%>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="list.asp?boardid=<%=boardid%>&skin=<%=request("skin")%>"><%=boardtype%></a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;编辑贴子
      </TD></TR></TBODY></TABLE>  <br>
<%
	call showeditForm()
	end if
	set rs_old=nothing
	rs.Close
	set rs=nothing
	call endConnection()
end if
%>

</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>