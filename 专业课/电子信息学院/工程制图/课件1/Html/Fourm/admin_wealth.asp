<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file=conn.asp-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<!--#include file=inc/grade.asp-->
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	if session("masterlogin")<>"superadmin" then
		Errmsg=Errmsg+"<br>"+"<li>本页面为管理员专用，请<a href=elogin.asp>登陆管理</a>后进入。"
		call Error()
	else
		call main()
		set rs=nothing
		conn.close
		set conn=nothing
	end if

	sub main()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td>
      <table cellpadding=3 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center colspan="2">欢迎<b><%=session("mastername")%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              <td width="20%" valign=top>
<%call left()%>
	      </td>
              <td width="80%" valign=top>
<%
if request("action")="save" then
call savegrade()
call getconst()
else
call grade()
end if
%>
	      </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%
end sub

sub grade()
set rs = server.CreateObject ("adodb.recordset")
sql="select top 1 * from config"
rs.open sql,conn,1,1
%>
<form method="POST" action=admin_wealth.asp?action=save>
<table width="95%" border="0" cellspacing="1" cellpadding="3"  align=center bordercolor=<%=aTablebackcolor%>>
<tr bgcolor=<%=aTabletitlecolor%>> 
<td height="23" colspan="2" ><font color=<%=TableFontcolor%>><b>用户金钱设定</b></font></td>
</tr>
<tr> 
<td width="30%">注册金钱数</td>
<td width="70%"> 
<input type="text" name="wealthReg" size="35" value="<%=rs("wealthReg")%>">
</td>
</tr>
<tr> 
<td width="30%">登陆增加金钱</td>
<td width="70%"> 
<input type="text" name="wealthLogin" size="35" value="<%=rs("wealthLogin")%>">
</td>
</tr>
<tr> 
<td width="30%">发帖增加金钱</td>
<td width="70%"> 
<input type="text" name="wealthAnnounce" size="35" value="<%=rs("wealthAnnounce")%>">
</td>
</tr>
<tr> 
<td width="30%">跟帖增加金钱</td>
<td width="70%"> 
<input type="text" name="wealthReannounce" size="35" value="<%=rs("wealthReannounce")%>">
</td>
</tr>
<tr> 
<td width="30%">删帖减少金钱</td>
<td width="70%"> 
<input type="text" name="wealthDel" size="35" value="<%=rs("wealthDel")%>">
</td>
</tr>
<tr bgcolor=<%=aTabletitlecolor%>> 
<td height="23" colspan="2" ><font color=<%=TableFontcolor%>><b>用户经验设定</b></font></td>
</tr>
<tr> 
<td width="30%">注册经验值</td>
<td width="70%"> 
<input type="text" name="epReg" size="35" value="<%=rs("epReg")%>">
</td>
</tr>
<tr> 
<td width="30%">登陆增加经验值</td>
<td width="70%"> 
<input type="text" name="epLogin" size="35" value="<%=rs("epLogin")%>">
</td>
</tr>
<tr> 
<td width="30%">发帖增加经验值</td>
<td width="70%"> 
<input type="text" name="epAnnounce" size="35" value="<%=rs("epAnnounce")%>">
</td>
</tr>
<tr> 
<td width="30%">跟帖增加经验值</td>
<td width="70%"> 
<input type="text" name="epReannounce" size="35" value="<%=rs("epReannounce")%>">
</td>
</tr>
<tr> 
<td width="30%">删帖减少经验值</td>
<td width="70%"> 
<input type="text" name="epDel" size="35" value="<%=rs("epDel")%>">
</td>
</tr>
<tr bgcolor=<%=aTabletitlecolor%>> 
<td height="23" colspan="2" ><font color=<%=TableFontcolor%>><b>用户魅力设定</b></font></td>
</tr>
<tr> 
<td width="30%">注册经验值</td>
<td width="70%"> 
<input type="text" name="cpReg" size="35" value="<%=rs("cpReg")%>">
</td>
</tr>
<tr> 
<td width="30%">登陆增加经验值</td>
<td width="70%"> 
<input type="text" name="cpLogin" size="35" value="<%=rs("cpLogin")%>">
</td>
</tr>
<tr> 
<td width="30%">发帖增加经验值</td>
<td width="70%"> 
<input type="text" name="cpAnnounce" size="35" value="<%=rs("cpAnnounce")%>">
</td>
</tr>
<tr> 
<td width="30%">跟帖增加经验值</td>
<td width="70%"> 
<input type="text" name="cpReannounce" size="35" value="<%=rs("cpReannounce")%>">
</td>
</tr>
<tr> 
<td width="30%">删帖减少经验值</td>
<td width="70%"> 
<input type="text" name="cpDel" size="35" value="<%=rs("cpDel")%>">
</td>
</tr>
<tr bgcolor=<%=aTabletitlecolor%>> 
<td width="30%">&nbsp;</td>
<td width="70%"> 
<div align="center"> 
<input type="submit" name="Submit" value="提 交">
</div>
</td>
</tr>
</table>
</form>
<%
rs.close
end sub

sub savegrade()
set rs = server.CreateObject ("adodb.recordset")
sql = "select top 1 * from config"
rs.Open sql,conn,1,3

rs("wealthReg")=request.form("wealthReg")
rs("wealthLogin")=request.form("wealthLogin")
rs("wealthAnnounce")=request.form("wealthAnnounce")
rs("wealthReannounce")=request.form("wealthReannounce")
rs("wealthDel")=request.form("wealthDel")
rs("epReg")=request.form("epReg")
rs("epLogin")=request.form("epLogin")
rs("epAnnounce")=request.form("epAnnounce")
rs("epReannounce")=request.form("epReannounce")
rs("epDel")=request.form("epDel")

rs("cpReg")=request.form("cpReg")
rs("cpLogin")=request.form("cpLogin")
rs("cpAnnounce")=request.form("cpAnnounce")
rs("cpReannounce")=request.form("cpReannounce")
rs("cpDel")=request.form("cpDel")
rs.Update
rs.Close
%>
<center><p><b>设置成功！</b>
<%
end sub
%>