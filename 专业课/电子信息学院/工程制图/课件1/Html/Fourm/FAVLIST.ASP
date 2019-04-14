<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<!--#include file="inc/grade.asp"-->
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

<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;您的收藏夹
      </TD></TR></TBODY></TABLE> 
<br>
	        <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor="<%=tablebackcolor%>" align=center>
	                <tr>
	                    <td>
	                    <table cellpadding=3 cellspacing=1 border=0 width=100%>
<%
	dim founderr
	dim errmsg
	dim rs,sql
	set rs=server.createobject("adodb.recordset")
	founderr=false
	if membername="" then
		Errmsg=Errmsg+"<br>"+"<li>您还没有<a href=login.asp>登陆论坛</a>，不能查看收藏。如果您还没有<a href=reg.asp>注册</a>，请先<a href=reg.asp>注册</a>！"
		Founderr=true
	end if
	if Founderr=true then
		call error()
	else
		if request("action")="delete" then
			call delete()
		else
			call favlist()
		end if
		if Founderr=true then call error()
	end if
%>
				</table>
			</td></tr>
</table>
<%
	sub favlist()
	sql="select * from bookmark where username='"&membername&"' order by id desc"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		Errmsg=Errmsg+"<br>"+"<li>您的收藏夹还没有收藏，您可以收藏论坛指定贴子，当收藏中有数据后，本信息将自动删除！"
		Founderr=true
	else
%>
	                        <tr>
	                        <td bgcolor="<%=tabletitlecolor%>" align=center valign=top colspan="3"><b><font color=<%=TableFontColor%>>>> 您的收藏夹 <<</font></b></td></tr>
  <tr bgcolor="<%=tablebodycolor%>">
    <td width="70%">标题</td>
    <td width="20%">时间</td>
    <td width="10%">操作</td>
  </tr>
<%
	do while not rs.eof
%>
  <tr bgcolor="<%=tablebodycolor%>">
    <td width="70%"><a href="<%=rs("url")%>"><%=htmlencode(rs("topic"))%></a></td>
    <td width="20%"><%=rs("addtime")%></td>
    <td width="10%"><a href="favlist.asp?action=delete&id=<%=rs("id")%>"><img src="pic/a_delete.gif" border=0></a></td>
  </tr>
<%
	rs.movenext
	loop
	end if
	rs.close
	end sub

	sub error()
%>
	                        <tr>
	                        <td bgcolor="<%=tabletitlecolor%>" align=center valign=top><b><font color=<%=TableFontColor%>>> 错误信息 <<</font></b></td></tr>
	                        <tr>
	                            <td bgcolor="<%=tablebodycolor%>" valign=top style="LEFT: 0px; WIDTH: 100%; WORD-WRAP: break-word"><br>
	                        <p><blockquote><%=errmsg%>
</blockquote></p>
	                        </td>
	                        </tr>
<%
	end sub

	sub delete()
	sql="delete from bookmark where username='"&membername&"' and id="&cstr(request("id"))
	conn.execute sql
%>
	                        <tr>
	                        <td bgcolor="<%=tabletitlecolor%>" align=center valign=top><b><font color=<%=TableFontColor%>>> 操作成功 <<</font></b></td></tr>
	                        <tr>
	                            <td bgcolor="<%=tablebodycolor%>" valign=top style="LEFT: 0px; WIDTH: 100%; WORD-WRAP: break-word"><br>
	                        <p><blockquote>已删除您的收藏夹中相应纪录，<a href="javascript:history.go(-1)">返回收藏</a>。
</blockquote></p>
	                        </td>
	                        </tr>
<%
	end sub

	set rs=nothing
	conn.close
	set conn=nothing
%>

</body>
</html>
