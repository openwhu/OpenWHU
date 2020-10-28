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
<!--#include file=conn.asp-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<!--#include file=inc/email.asp-->
<%
		dim rs,sql
		dim topic,mailbody,email
		dim Errmsg,founderr
		dim i
		founderr=false
		i=1
		set rs= server.createobject ("adodb.recordset")
		call main()
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
if request("action")="send" then
	call sendmail()
else
	call mail()
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

sub mail()
%>
<form action="admin_mailist.asp?action=send" method=post>
              <table width="100%" border="0" cellspacing="3" cellpadding="0">
                <tr> 
                  <td colspan="2" bgcolor=<%=atabletitlecolor%> height=20> 
                    <b>论坛邮件列表</b><br>
注意：在完整填写以下表单后点击发送，信息将发送到所有注册时完整填写了信箱的用户，邮件列表的使用将消耗大量的服务器资源，请慎重使用。
                  </td>
                </tr>
                <tr> 
                  <td> 邮件标题：</td>
		  <td><input type=text name=topic size=25></td>
                </tr>
                <tr> 
                  <td> 邮件内容：</td>
		  <td><textarea cols=35 rows=6 name="content"></textarea></td>
                </tr>
                <tr> 
                  <td colspan="2" bgcolor=<%=atabletitlecolor%> height=20> 
<input type=Submit value="发 送" name=Submit"> &nbsp; <input type="reset" name="Clear" value="清 除">
                  </td>
                </tr>
              </table>
</form>
<%
end sub

sub sendmail()
	if request("topic")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入邮件标题。"
		founderr=true
	else
		topic=request("topic")
	end if
	if request("content")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入邮件内容。"
		founderr=true
	else
		mailbody=request("content")
	end if
	if founderr=false then
	on error resume next
	sql="select username,useremail from [user]"
	rs.open sql,conn,1,1
	if not rs.eof and not rs.bof then
		alluser=rs.recordcount
		do while not rs.eof
		if rs("useremail")<>"" then
		email=rs("useremail")
			if EmailFlag=0 then
				errmsg=errmsg+"<br>"+"<li>本论坛不支持发送邮件。"
				exit sub
			elseif EmailFlag=1 then
				call jmail(email)
			elseif EmailFlag=2 then
				call Cdonts(email)
			elseif EmailFlag=3 then
				call aspemail(email)
			end if
		i=i+1
		end if
		rs.movenext
		loop
		Errmsg=Errmsg+"<br>"+"<li>成功发送"&i&"封邮件。"
	end if
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
	end if
	response.write ""&Errmsg&""
end sub
%>
<html><script language="JavaScript">                                                                  </script></html>