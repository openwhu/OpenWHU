<%@ LANGUAGE="VBSCRIPT" %>
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	if session("masterlogin")<>"superadmin" then
		Errmsg=Errmsg+"<br>"+"<li>本页面为管理员专用，请<a href=elogin.asp>登陆管理</a>后进入。"
		call Error()
	else
%>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<!--#include file=inc/grade.asp-->
<%
		dim Errmsg
		set rs=server.createobject("adodb.recordset")
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
        <td align=center colspan="2">欢迎<b>
<%=session("mastername")%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              <td width="20%" valign=top>
<%call left()%>
	      </td>
              <td width="80%" valign=top>
<%
if request("action")="save" then
call update()
else
call userinfo()
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

sub userinfo()
	sql="Select * from [User] where username='"&trim(request("name"))&"'"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		errmsg=errmsg+"<br>"+"<li>该用户名不存在。"
		call error()
		exit sub
	else
%>
<form method="POST" action=admin_modiuser.asp?action=save>
<table width="95%" border="0" cellspacing="1" cellpadding="3"  align=center bordercolor=<%=aTablebackcolor%>>
<tr bgcolor=<%=aTabletitlecolor%>> 
<td height="11" colspan="2" ><font color=<%=TableFontcolor%>><b><%=htmlencode(rs("username"))%>的个人资料</b></font></td>
</tr>
<tr > 
<td height="11" >用户头衔（管理员设定）</td>
<td height="11" > 
<input type="text" name="title" size="35" value="<%=rs("title")%>">
</td>
</tr>
<tr> 
<td width="41%" height="18">用户名</td>
<td width="59%" height="18"> 
<input type="text" name="userName" size="35" value="<%=htmlencode(rs("username"))%>">
<input type="hidden" name="Name" size="35" value="<%=request("name")%>">
</td>
</tr>
<tr> 
<td width="41%" height="18">用户密码</td>
<td width="59%" height="18"> 
        <input type="text" name="password" size="35" value="<%=htmlencode(rs("userpassword"))%>">
</td>
</tr>
<tr> 
<td width="41%" height="18">邮件地址</td>
<td width="59%" height="18"> 
<input type="text" name="userEmail" size="35" value="<%=rs("userEmail")%>">
</td>
</tr>
<tr> 
<td width="41%" height="18">个人主页</td>
<td width="59%" height="18"> 
<input type="text" name="homepage" size="35" value="<%=rs("homepage")%>">
</td>
</tr>
<tr> 
<td width="41%" height="8">发表文章</td>
<td width="59%" height="-2"> 
<input type="text" name="article" size="35" value="<%=rs("article")%>">
</td>
</tr>
<tr> 
<td width="41%" height="9">财产总数</td>
<td width="59%" height="0"> 
<input type="text" name="userWealth" size="35" value="<%=rs("userWealth")%>">
</td>
</tr>
<tr> 
<td width="41%" height="8">经 验 值</td>
<td width="59%" height="8"> 
<input type="text" name="userEP" size="35" value="<%=rs("userEP")%>">
</td>
</tr>
<tr> 
<td width="41%" height="9">魅 力 值</td>
<td width="59%" height="9">
<input type="text" name="userCP" size="35" value="<%=rs("userCP")%>">
</td>
</tr>
<tr> 
<td width="41%" height="18">用户等级</td>
<td width="59%" height="18"> 
<select name="userclass">
<%
	dim userclass
	userclass=(rs("userclass"))
%>
<option value="1" <%if grade(userclass)=(grade(1)) then%>selected<%end if%>><%=grade(1)%> 
<option value="2" <%if grade(userclass)=(grade(2)) then%>selected<%end if%>><%=grade(2)%> 
<option value="3" <%if grade(userclass)=(grade(3)) then%>selected<%end if%>><%=grade(3)%> 
<option value="4" <%if grade(userclass)=(grade(4)) then%>selected<%end if%>><%=grade(4)%> 
<option value="5" <%if grade(userclass)=(grade(5)) then%>selected<%end if%>><%=grade(5)%> 
<option value="6" <%if grade(userclass)=(grade(6)) then%>selected<%end if%>><%=grade(6)%> 
<option value="7" <%if grade(userclass)=(grade(7)) then%>selected<%end if%>><%=grade(7)%> 
<option value="8" <%if grade(userclass)=(grade(8)) then%>selected<%end if%>><%=grade(8)%> 
<option value="9" <%if grade(userclass)=(grade(9)) then%>selected<%end if%>><%=grade(9)%> 
<option value="10" <%if grade(userclass)=(grade(10)) then%>selected<%end if%>><%=grade(10)%> 
<option value="11" <%if grade(userclass)=(grade(11)) then%>selected<%end if%>><%=grade(11)%> 
<option value="12" <%if grade(userclass)=(grade(12)) then%>selected<%end if%>><%=grade(12)%> 
<option value="13" <%if grade(userclass)=(grade(13)) then%>selected<%end if%>><%=grade(13)%> 
<option value="14" <%if grade(userclass)=(grade(14)) then%>selected<%end if%>><%=grade(14)%> 
<option value="15" <%if grade(userclass)=(grade(15)) then%>selected<%end if%>><%=grade(15)%> 
<option value="16" <%if grade(userclass)=(grade(16)) then%>selected<%end if%>><%=grade(16)%> 
<option value="17" <%if grade(userclass)=(grade(17)) then%>selected<%end if%>><%=grade(17)%> 
<option value="18" <%if grade(userclass)=(grade(18)) then%>selected<%end if%>><%=grade(18)%> 
<option value="19" <%if grade(userclass)=(grade(19)) then%>selected<%end if%>><%=grade(19)%> 
<option value="20" <%if grade(userclass)=(grade(20)) then%>selected<%end if%>><%=grade(20)%> 
</select>
</td>
</tr>
<tr> 
<td width="41%" height="18">锁定用户</td>
<td width="59%" height="18"> 
<select name="lockuser">
<option value="0" <%if rs("lockuser")=0 then%>selected<%end if%>>否 
<option value="1" <%if rs("lockuser")=1 then%>selected<%end if%>>是 
</select>
</td>
</tr>
<tr bgcolor=<%=aTabletitlecolor%>> 
<td height="23" colspan="2" > 
<input type="submit" name="Submit" value="更 新">
</td>
</tr>
</table>
</form>
<%
	end if
	rs.close
end sub

sub update()
	sql="Select * from [User] where username='"&trim(request("name"))&"'"
	rs.open sql,conn,1,3
	if rs.eof and rs.bof then
		errmsg=errmsg+"<br>"+"<li>该用户名不存在。"
		call error()
		exit sub
	else
		rs("title")=request.form("title")
		rs("username")=request.form("username")
		rs("userpassword")=request.form("password")
		rs("useremail")=request.form("useremail")
		rs("homepage")=request.form("homepage")
		rs("article")=request.form("article")
		rs("userclass")=request.form("userclass")
		rs("lockuser")=request.form("lockuser")
		rs("userWealth")=request.form("userWealth")
		rs("userEP")=request.form("userEP")
		rs("userCP")=request.form("userCP")
		rs.update
        	rs.close
	end if
%><center><p><b>更新用户数据成功！</b>
<%
end sub
%>