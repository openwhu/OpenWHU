<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<!-- #include file="inc/grade.asp" -->
<!--#include file="inc/stats.asp"-->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 3.0" CHARSET="GB2312">
<title><%=ForumName%></title>
<link rel="stylesheet" type="text/css" href="forum.css">
</head>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>

<TABLE border=0 width="750" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="pic/closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="pic/bar.gif" border=0 width=15 height=15><img src="pic/openfold.gif" border=0>&nbsp;&nbsp;论坛公告
      </TD></TR></TBODY></TABLE> 
<br>
	        <table cellpadding=0 cellspacing=0 border=0 width=750 bgcolor="<%=tablebackcolor%>" align=center>
	                <tr>
	                    <td>
	                    <table cellpadding=3 cellspacing=1 border=0 width=100%>
<%
	dim rs,sql
	set rs=server.createobject("adodb.recordset")
	sql="select * from bbsnews where boardid="&cstr(request("boardid"))&" order by id desc"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
%>
	                        <tr>
	                        <td bgcolor="<%=tabletitlecolor%>" align=center valign=top><b>>> 当前没有任何公告 <<</b></td></tr>
	                        <tr>
	                            <td bgcolor="<%=tablebodycolor%>" valign=top style="LEFT: 0px; WIDTH: 100%; WORD-WRAP: break-word"><br>
	                        <p><blockquote>请进入论坛管理页面来发布一个公告(必须是管理员或者老师)。 <br>当你发布一次公告后，本公告就会自动消失，无需你手动删除！
</blockquote></p>
	                        </td>
	                        </tr>
	                        <tr>
	                            <td bgcolor="<%=tablebodycolor%>" valign=middle>
	                        <table width=100% border="0" cellpadding="0" cellspacing="0">
	                        <tr><td align=left>&nbsp;&nbsp;&nbsp;<b>发布人</b>： 本站的默认公告
	                        </td><td align=right><b>发布时间</b>： <%=Now()%>&nbsp;&nbsp;&nbsp;
	                        </tr>
	                        </table>
	                        </td>
	                        </tr>
<%
	else
	do while not rs.eof
%>
	                        <tr>
	                        <td bgcolor="<%=tabletitlecolor%>" align=center valign=top><b>>> <%=htmlencode(rs("title"))%> <<</b></td></tr>
	                        <tr>
	                            <td bgcolor="<%=tablebodycolor%>" valign=top style="LEFT: 0px; WIDTH: 100%; WORD-WRAP: break-word"><br>
	                        <p><blockquote><%=ubbcode(rs("content"))%>
</blockquote></p>
	                        </td>
	                        </tr>
	                        <tr>
	                            <td bgcolor="<%=tablebodycolor%>" valign=middle>
	                        <table width=100% border="0" cellpadding="0" cellspacing="0">
	                        <tr><td align=left>&nbsp;&nbsp;&nbsp;<b>发布人</b>： <%=htmlencode(rs("username"))%>
	                        </td><td align=right><b>发布时间</b>： <%=rs("addtime")%>&nbsp;&nbsp;&nbsp;
	                        </tr>
	                        </table>
	                        </td>
	                        </tr>
<%
	rs.movenext
	loop
	end if
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
%>
				</table>
			</td></tr></table>

</body>
</html>
