<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/char.asp"-->
<!--#include file="inc/email.asp"-->
<!--#include file="inc/grade.asp"-->
<html>

<head>
<title><%=ForumName%>--密码遗忘</title>
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
&nbsp;&nbsp;<img src="pic/closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="pic/bar.gif" border=0 width=15 height=15><img src="pic/openfold.gif" border=0>&nbsp;&nbsp;取回密码</a>
      </TD></TR></TBODY></TABLE> 
<br>
<%
	if request("action")="getpass" then
	dim email
	dim founderr
	dim errmsg
	dim rs,sql
	founderr=false
	if request("email")="" then
		Errmsg=Errmsg+"<br>"+"<li>请确认输入邮件地址。"
		founderr=true
	else
		email=request("email")
		set rs=server.createobject("adodb.recordset")
		sql="select username,userpassword,useremail from [user] where useremail='"&email&"'"
		rs.open sql,conn,1,1
		if rs.eof and rs.bof then
		Errmsg=Errmsg+"<br>"+"<li>论坛中并无使用该邮件地址用户，请确认输入是否正确。"
		founderr=true
		else
		'on error resume next
			topic="您在"&ForumName&"的注册资料"
			mailbody="您在"&ForumName&"的用户名是："&rs("username")&"<br>密码是："&rs("userpassword")&"<br>请注意保管好您的密码，以防再次丢失，多谢您对<a href=http://127.0.0.1>动网先锋</a>的支持！"
			if EmailFlag=0 then
				errmsg=errmsg+"<br>"+"<li>本论坛不支持发送邮件。</li>"
   				founderr=true
				call error()
			elseif EmailFlag=1 then
				call jmail(email)
				call success()
			elseif EmailFlag=2 then
				call Cdonts(email)
				call success()
			elseif EmailFlag=3 then
				call aspemail(email)
				call success()
			end if
		end if

	end if
	if founderr=true then
		call error()
	end if
	else
%>
<form action="lostpass.asp?action=getpass" method="post"> 
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
    <tr>    
        <td>
        <table cellpadding=6 cellspacing=1 border=0 width=100%>

    <tr>
    <td bgcolor=<%=aTabletitlecolor%> valign=middle colspan=2 align=center>
    <b>取回密码</b></font></td></tr>
    <tr>
    <td bgcolor=<%=Tablebodycolor%> valign=middle>请输入您的Email地址</td>
    <td bgcolor=<%=Tablebodycolor%> valign=middle><INPUT name=email type=text> &nbsp; 请确认您在注册资料中输入了Email地址</td></tr>
    <tr>
    <td bgcolor=<%=aTabletitlecolor%> valign=middle colspan=2 align=center><input type=submit name="submit" value="提 交"></td></tr></table></td></tr></table>
</form>
<%
end if
sub success()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>成功：取回密码</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=Tablebodycolor%>><b>恭喜您，您成功取回密码，请到您的邮箱收取密码。</b><br>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>
<a href="javascript:history.go(-1)"> << 返回上一页</a>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
end sub
%>

</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>