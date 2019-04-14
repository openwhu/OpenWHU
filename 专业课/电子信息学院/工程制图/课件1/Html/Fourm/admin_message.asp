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

<%
		dim body
		dim rs,sql,sql1
        	set rs = server.CreateObject ("adodb.recordset")
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
          <td width="20%" valign=top height="276"> <%call left()%> </td>
          <td width="80%" valign=top height="276"> 
<%
	if Request("action")="add" then
		call savemsg()
	elseif request("action")="del" then
		call del()
	elseif request("action")="delall" then
		call delall()
	else
		call sendmsg()
	end if
%>
<p align=center><%=body%></p>
          </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%
end sub

sub savemsg()
	dim sendtime,sender
	sendtime=Now()
	sender="动网小精灵"
        sql1 = "select username from [user]"
        rs.Open sql1,conn,1,1
        do while not rs.EOF 

	sql="insert into message(incept,sender,title,content,sendtime,flag) values('"
   
   sql=sql&(rs("username"))&"','"
   sql=sql&(sender)&"','"
   sql=sql&(TRim(Request("title")))&"','"
   sql=sql&(Trim(Request("message")))&"','"
   sql=sql&(sendtime)&"','"
   sql=sql&(0)&"')"
   conn.Execute(sql)
		rs.MoveNext 
		Loop
		rs.Close
	body=body+"<br>"+"操作成功！请继续别的操作。"
end sub

sub sendmsg()
%>
              <table width="100%" border="0" cellspacing="3" cellpadding="0">
                <tr> 
                  <td colspan="2" bgcolor=<%=atabletitlecolor%> height="7"> 
                    <p><b>系统消息发布</b>：<br>
                      注意：这里您将向该论坛的所有注册用户发送短消息！</p>
                  </td>
                </tr>
            <form action="admin_message.asp?action=add" method=post>
                <tr> 
                  <td width="22%">消息标题</td>
                  <td width="78%"> 
                    <input type="text" name="title" size="50">
                  </td>
                </tr>
                <tr> 
                  <td width="22%" height="20" valign="top">
                    <p>消息内容</p>
                    <p>(<font color="<%=AlertFontColor%>">HTML代码支持</font>)</p>
                  </td>
                  <td width="78%" height="20"> 
                    <textarea name="message" cols="50 " rows="10"></textarea>
                  </td>
                </tr>
                <tr> 
                  <td width="22%" height="23" valign="top" align="center"> 
                    <div align="left"> </div>
                  </td>
                  <td width="78%" height="23"> 
                    <div align="center"> 
                      <input type="submit" name="Submit" value="发送消息">
                      <input type="reset" name="Submit2" value="重新填写">
                    </div>
                  </td>
                </tr>
            </form>
                <tr> 
                  <td colspan="2" bgcolor=<%=atabletitlecolor%> height="20"> 
                    <p><b>批量删除：
                  </td>
                </tr>
                <tr> 
                  <td colspan="2"> 
            <form action="admin_message.asp?action=del" method=post>
                      批量删除某用户短消息（主要用于删除系统批量信息：动网小精灵）：<br><input type="text" name="username" size="20">
			<input type="submit" name="Submit" value="提 交">
            </form>
			<a href=admin_message.asp?action=delall><font color=<%=AlertFontColor%>>删除所有用户短消息</font></a></a>
                  </td>
                </tr>
              </table>
<%
end sub

sub del()
	if request("username")="" then
		body=body+"<br>"+"请输入要批量删除的用户名。"
		exit sub
	end if
	sql="delete from message where sender='"&request("username")&"'"
	conn.Execute(sql)
	body=body+"<br>"+"操作成功！请继续别的操作。"
end sub

sub delall()
	sql="delete from message where id>0"
	conn.Execute(sql)
	body=body+"<br>"+"操作成功！请继续别的操作。"
end sub
%>