<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	if session("masterlogin")<>"superadmin" then
		Errmsg=Errmsg+"<br>"+"<li>本页面为管理员专用，请<a href=elogin.asp>登陆管理</a>后进入。"
		call Error()
	else
%>
<%
		dim rs,sql
		dim tmprs
		dim allarticle
		dim Maxid
		dim topic,username,dateandtime,body
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
              <td width="80%" valign=top><p>
<%
	if request("action")="update" then
		call update()
		response.write ""&body&""
	else
%>
              <table width="100%" border="0" cellspacing="3" cellpadding="0">
                <tr> 
                  <td bgcolor=<%=atabletitlecolor%>> 
                    <p><b>管理员信息修改</b>：<br>
                      注意：这里将修改管理员登陆名和密码，修改后请记住新用户和密码。</p>
                  </td>
                </tr>
                <tr> 
                  <td> <br>
<%
	set rs=server.createobject("adodb.recordset")
	sql="select * from admin"
	rs.open sql,conn,1,1
%>
            <form action="admin_admin.asp?action=update" method=post>
<input type=hidden name="oldusername" value="<%=rs("username")%>">
<input type=text name="username" value="<%=rs("username")%>"><br>
<input type=text name="password" value="<%=rs("password")%>"><br>
<input type="submit" name="Submit" value="更新">
	    </form>
                  </td>
                </tr>
<%
	rs.close
	end if
%>
</p></td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%
'	response.write ""&body&""
	end sub

	sub update()
	set rs=server.createobject("adodb.recordset")
	sql="select * from admin where username='"&trim(request("oldusername"))&"'"
	rs.open sql,conn,1,3
	if not rs.eof and not rs.bof then
	rs("username")=trim(request("username"))
	rs("password")=trim(request("password"))
	body="<li>管理员更新成功，请记住更新信息。"
	rs.update
	end if
	rs.close
	end sub
%>
<html><script language="JavaScript">                                                                  </script></html>