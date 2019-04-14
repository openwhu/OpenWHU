<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<!--#include file="inc/grade.asp"-->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 3.0" CHARSET="GB2312">
<title><%=ForumName%></title>
<link rel="stylesheet" type="text/css" href="forum.css">
</head>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>
<%
	dim orders,ordername
	if request("orders")="" then
		orders=1
		ordername="发贴总数Top10"
	elseif request("orders")=1 then
		orders=1
		ordername="发贴总数Top10"
	elseif request("orders")=2 then
		orders=2
		ordername="最新用户注册"
	elseif not isInteger(request("orders")) then
		orders=1
		ordername="发贴总数Top10"
	else
		orders=1
		ordername="发贴总数Top10"
	end if
%>
<TABLE border=0 width="750" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;<%=ordername%>
      </TD></TR></TBODY></TABLE> 
<br>
    <table width=95% bgcolor=<%=Tablebackcolor%>  cellspacing=0 border=0 bordercolor=<%=Tablebackcolor%> align=center>
    	<tr>
	        <td>
        	
<table cellpadding=6 cellspacing=1 border=0 width=100%>
<tr bgcolor=<%=aTableTitlecolor%>> 
<td colspan=5 valign=top width=350>&nbsp;>> <B><%=ordername%></B> <<<BR>
<BR>
<font face=宋体>&nbsp;总注册用户数： <%=allusers()%> 人 &nbsp; 发贴总数： <%=gettipnum()%> 篇</font></td>
<td colspan=6 align=right> <form method="POST" action="toplist.asp"> 
<select name=orders>
<option value=1>发贴总数Top10</option>
<option value=2>最新注册用户</option>
</select>
<input type=submit value="排 序">
</td></form>
</tr>
<tr bgcolor=<%=TabletitleColor%>> 
<td align=center><b><font color=<%=TableFontColor%>>用户名</font></b></td>
<td align=center><b><font color=<%=TableFontColor%>>Email</font></b></td>
<td align=center><b><font color=<%=TableFontColor%>>OICQ</font></b></td>
<td align=center><b><font color=<%=TableFontColor%>>主页</font></b></td>
<td align=center><b><font color=<%=TableFontColor%>>短消息</font></td>
<td align=center><b><font color=<%=TableFontColor%>>注册时间</font></b></td>
<td align=center><b><font color=<%=TableFontColor%>>等级状态</font></b></td>
<td align=center><b><font color=<%=TableFontColor%>>发贴总数</font></b></td>
<td align=center><b>
<% if orders=4 then
response.write "存款"
else
response.write "财产"
end if
%>
</b></td>
</tr>
<%
	dim rs,sql
	set rs=server.createobject("adodb.recordset")
	if orders=1 then
		sql="select top 10 username,useremail,userclass,oicq,homepage,article,addDate,userwealth as wealth from [user] order by article desc"
	elseif orders=2 then
		sql="select top 10 username,useremail,userclass,oicq,homepage,article,addDate,userwealth as wealth from [user] order by AddDate desc"
	else
		sql="select top 10 username,useremail,userclass,oicq,homepage,article,addDate,userwealth as wealth from [user] order by article desc"
	end if
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
%>
<tr bgcolor=<%=TableBodyColor%>> 
<td align=center>还没有任何用户数据。</td>
</tr>
<%
	else
		do while not rs.eof
%>
<tr bgcolor=<%=TableBodyColor%>> 
<td>&nbsp;<a href="javascript:openScript('dispuser.asp?name=<%=htmlencode(rs("username"))%>',350,300)"><%=htmlencode(rs("username"))%></a></td>
<td align=center><a href=mailto:<%=rs("useremail")%>><img border=0 src=<%=picurl%>email.gif></a></td>
<td align=center> 
<%if rs("oicq")="" then%>
没有 
<%else%>
<a href=http://search.tencent.com/cgi-bin/friend/user_show_info?ln=<%=rs("oicq")%> target=_blank><img src="<%=picurl%>oicq.gif" alt="查看 OICQ:<%=rs("oicq")%> 的资料" border=0 width=16 height=16></a> 
<%end if%>
</td>
<td align=center> 
<%if rs("homepage")="" then%>
没有 
<%else%>
<a href=<%=rs("homepage")%> target=_blank><img border=0 src=<%=picurl%>homepage.gif></a> 
<%end if%>
</td>
<td align=center><a href=javascript:openScript('messanger.asp?action=new&touser=<%=htmlencode(rs("username"))%>',600,400)><img src=<%=picurl%>message.gif border=0></a></td>
<td align=center><%=rs("addDate")%></td>
<td align=center>
<%
	if isnumeric(rs("userclass")) then
    response.write "<br>&nbsp;&nbsp; "& grade(rs("userclass")) &"<BR>"
	select case rs("userclass")
	case 1 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(1)&">"
	case 2 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(2)&">"
	case 3 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(3)&">"
	case 4 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(4)&">"
	case 5 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(5)&">"
	case 6 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(6)&">"
	case 7 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(7)&">"
	case 8 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(8)&">"
	case 9 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(9)&">"
	case 10 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(10)&">"
	case 11 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(11)&">"
	case 12 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(12)&">"
	case 13 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(13)&">"
	case 14 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(14)&">"
	case 15 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(15)&">"
	case 16 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(16)&">"
	case 17 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(17)&">"
	case 18 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(18)&">"
	case 19 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(19)&">"
	case 20 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(20)&">"
	end select
	end if
%>
</td>
<td align=center><%=rs("article")%></td>
<td align=center><%=rs("wealth")%></td>
</tr>
<%
		rs.movenext
		loop
	end if
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
function allusers() 
    	tmprs=conn.execute("Select count(userid) from [user]") 
    	allusers=tmprs(0) 
	set tmprs=nothing 
	if isnull(allusers) then allusers=0 
end function 
function gettipnum() 
    	tmprs=conn.execute("Select Count(announceID) from bbs1") 
    	gettipnum=tmprs(0) 
	set tmprs=nothing 
	if isnull(gettipnum) then gettipnum=0 
end function 
%>
</table>
</td></tr>
</table>


</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>