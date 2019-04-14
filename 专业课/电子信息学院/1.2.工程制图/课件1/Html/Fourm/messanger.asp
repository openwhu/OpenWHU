<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/char.asp"-->
<html>
<head>
<title><%=ForumName%>--短消息</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="forum.css" rel=stylesheet>
</head>
<body bgcolor="<%=Tablebodycolor%>" alink="#333333" vlink="#333333" link="#333333" topmargin=10 leftmargin=10>
<%
	dim errmsg
	dim founderr
	founderr=false
	dim msg
	set rs=server.createobject("adodb.recordset")

if membername="" then
  	errmsg=errmsg+"<br>"+"<li>您没有<a href=login.asp target=_blank>登录</a>。"
	founderr=true
else

end if

if founderr=true then
	call error()
else
	if request("action")="inbox" then
	call inbox()
	elseif request("action")="outbox" then
	call outbox()
	elseif request("action")="new" then
	call sendmsg()
	elseif request("action")="read" or request("action")="outread" then
	call read()
	elseif request("action")="delete" then
	call delete()
	elseif request("action")="deleteall" then
	call deleteall()
	elseif request("action")="send" then
	call savemsg()
	elseif request("action")="newmsg" then
	call newmsg()
	else
	call error()
	end if
end if


'收件箱
sub inbox()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
            <tr>
                <td bgcolor=<%=aTabletitlecolor%> align=center colspan=3><font face="宋体" color=#333333><b>欢迎使用您的收件箱，<%=membername%></b></td>
            </tr>
            <tr>
                <td bgcolor=<%=Tablebodycolor%> valign=middle align=center colspan=3><a href="messanger.asp?action=inbox"><img src="<%=picurl%>inboxpm.gif" border=0 alt="收件箱"></a> &nbsp; <a href="messanger.asp?action=outbox"><img src="<%=picurl%>outboxpm.gif" border=0 alt="发件箱"></a> &nbsp; <a href="messanger.asp?action=new"><img src="<%=picurl%>newpm.gif" border=0 alt="发送消息"></a></td>
            </tr>
            <tr>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle><font face="宋体" color=#333333><b>来自</b></td>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle><font face="宋体" color=#333333><b>主题</b></td>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle><font face="宋体" color=#333333><b>已读</b></td>
            </tr>
<%
	sql="select * from message where (delR=0 or delR is null) and incept='"&trim(membername)&"' order by flag,sendtime desc"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
%>
                <tr>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle colspan=3><font face="宋体" color=#333333>您还没有新留言噢：）</td>
                </tr>
<%else%>
<%do while not rs.eof%>
                <tr>
                    <td bgcolor=<%=Tablebodycolor%> align=center valign=middle><font face="宋体" color=#333333><%=htmlencode(rs("sender"))%></td>
                    <td bgcolor=<%=Tablebodycolor%> align=left valign=middle><font face="宋体" color=#333333><a href="messanger.asp?action=read&id=<%=rs("id")%>"><%=htmlencode(rs("title"))%></a></td>
                    <td bgcolor=<%=Tablebodycolor%> align=center valign=middle><font face="宋体" color="#333333"><%if rs("flag")=0 then%><font color=red><b>否</b></font><%else%>是<%end if%></font></td>
                </tr>
<%
	rs.movenext
	loop
	end if
	rs.close
%>
                <tr>
                <td bgcolor=<%=aTabletitlecolor%> align=center valign=middle colspan=3><font face="宋体" color=#333333><a href="messanger.asp?action=deleteall">删除所有的短消息</a></td>
                </tr>
                </table></td></tr></table>
<%
end sub


'发件箱
sub outbox()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
                
            <tr>
                <td bgcolor=<%=aTabletitlecolor%> align=center colspan=2><font face="宋体" color=#333333><b>欢迎使用短消息发送，<%=membername%></b></td>
            </tr>
            <tr>
                <td bgcolor=<%=Tablebodycolor%> valign=middle align=center colspan=3><a href="messanger.asp?action=inbox"><img src="<%=picurl%>inboxpm.gif" border=0 alt="收件箱"></a> &nbsp; <a href="messanger.asp?action=outbox"><img src="<%=picurl%>outboxpm.gif" border=0 alt="发件箱"></a> &nbsp; <a href="messanger.asp?action=new"><img src="<%=picurl%>newpm.gif" border=0 alt="发送消息"></a></td>
            </tr>
            <tr>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle width=20%><font face="宋体" color=#333333><b>收件人</b></td>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle><font face="宋体" color=#333333><b>标题</b></td>
            </tr>
<%
	sql="select * from message where (delS=0 or delS is null) and sender='"&trim(membername)&"' order by sendtime desc"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
%>
                <tr>
                <td bgcolor=<%=Tablebodycolor%> align=center valign=middle colspan=2><font face="宋体" color=#333333>您还没有给别人发过信息呢~~</td>
                </tr>
<%else%>
<%do while not rs.eof%>
                <tr>
                    <td bgcolor=<%=Tablebodycolor%> align=center valign=middle width=20%><font face="宋体" color=#333333><%=htmlencode(rs("incept"))%></td>
                    <td bgcolor=<%=Tablebodycolor%> align=left valign=middle><font face="宋体" color=#333333><a href="messanger.asp?action=outread&id=<%=rs("id")%>"><%=htmlencode(rs("title"))%></a></td>
                </tr>
<%
	rs.movenext
	loop
	end if
	rs.close
%>                
                <tr>
                <td bgcolor=<%=aTabletitlecolor%> align=center valign=middle colspan=2><font face="宋体" color=#333333><a href="messanger.asp?action=deleteall">删除所有的短消息</a></td>
                </tr>
                </table></td></tr></table>
<%
end sub


'发送信息
sub sendmsg()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
                
            <tr>
                <td bgcolor=<%=aTabletitlecolor%> align=center colspan=3><font face="宋体" color=#333333><b>发送短消息</b></td>
            </tr>
            <tr>
                <td bgcolor=<%=Tablebodycolor%> valign=middle align=center colspan=3><a href="messanger.asp?action=inbox"><img src="<%=picurl%>inboxpm.gif" border=0 alt="收件箱"></a> &nbsp; <a href="messanger.asp?action=outbox"><img src="<%=picurl%>outboxpm.gif" border=0 alt="发件箱"></a> &nbsp; <a href="messanger.asp?action=new"><img src="<%=picurl%>newpm.gif" border=0 alt="发送消息"></a></td>
            </tr>
            <tr>
            <td bgcolor=<%=aTabletitlecolor%> colspan=2 align=center>
            <form action="messanger.asp" method=post name=FORM>
            <input type=hidden name="action" value="send">
            <font face="宋体" color=#333333><b>请完整输入下列信息</b></td>
            </tr>
            <tr>
            <td bgcolor=<%=Tablebodycolor%> valign=middle><font face="宋体" color=#333333><b>收件人：</b></font></td>
            <td bgcolor=<%=Tablebodycolor%> valign=middle><input type=text name="touser" value="<%=request("touser")%>" size=20></a></td></tr>
            <tr>
            <td bgcolor=<%=Tablebodycolor%> valign=top width=30%><font face="宋体" color=#333333><b>标题：</b></font></td>
            <td bgcolor=<%=Tablebodycolor%> valign=middle><input type=text name="title" size=36 maxlength=80></td>
            </tr>
            <tr>
            <td bgcolor=<%=Tablebodycolor%> valign=top width=30%><font face="宋体" color=#333333><b>内容：</b></td>
            <td bgcolor=<%=Tablebodycolor%> valign=middle><textarea cols=35 rows=6 name="message"></textarea></td>
            </tr>
            <tr>
            <td bgcolor=<%=aTabletitlecolor%> valign=middle colspan=2 align=center>
            <input type=Submit value="发 送" name=Submit"> &nbsp; <input type="reset" name="Clear" value="清 除">
            </td></form></tr>
            </table></td></tr></table>
<%
end sub


'读取信息
sub read()
%>
<%
   	sql="update message set flag=1 where ID="&cstr(request("id"))
   	rs.open sql,conn,1,3
	sql="select * from message where incept='"&membername&"' and id="&cstr(request("id"))
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		errmsg=errmsg+"<br>"+"<li>你是不是跑到别人的信箱啦、或者该信息已经删除。"
		founderr=true
	end if
	if founderr=true then
		call error()
	else
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
                
            <tr>
                <td bgcolor=<%=aTabletitlecolor%> align=center colspan=3><font face="宋体" color=#333333><b>欢迎使用短消息接收，<%=membername%></b></td>
            </tr>
            <tr>
                <td bgcolor=<%=Tablebodycolor%> valign=middle align=center colspan=3><a href="messanger.asp?action=delete&id=<%=rs("id")%>"><img src="<%=picurl%>deletepm.gif" border=0 alt="删除消息"></a> &nbsp; <a href="messanger.asp?action=inbox"><img src="<%=picurl%>inboxpm.gif" border=0 alt="收件箱"></a> &nbsp; <a href="messanger.asp?action=outbox"><img src="<%=picurl%>outboxpm.gif" border=0 alt="发件箱"></a> &nbsp;<a href="messanger.asp?action=new"><img src="<%=picurl%>newpm.gif" border=0 alt="发送消息"></a> &nbsp;<a href="messanger.asp?action=new&touser=<%=htmlencode(rs("sender"))%>"><img src="<%=picurl%>replypm.gif" border=0 alt="回复消息"></a></td>
            </tr>
                <tr>
                    <td bgcolor=<%=aTabletitlecolor%> valign=middle align=center><font face="宋体" color=#333333>
<%if request("action")="outread" then%>
                    在<b><%=rs("sendtime")%></b>，您发送此消息给<b><%=htmlencode(rs("incept"))%></b>！
<%else%>
		    在<b><%=rs("sendtime")%></b>，<b><%=htmlencode(rs("sender"))%></b>给您发送的消息！
<%end if%></font></td>
                </tr>
                <tr>
                    <td bgcolor=<%=Tablebodycolor%> valign=top align=left><font face="宋体" color=#333333>
                    <b>消息标题：<%=htmlencode(rs("title"))%></b><p>
                    <%if rs("sender")="动网小精灵" then%>
                    <%=rs("content")%>
                    <%else%>
                    <%=ubbcode(rs("content"))%>
                    <%end if%>
		    </td>
                </tr>
                </table></td></tr></table>
<%end if%>
<%
end sub

sub savemsg()
	if request("touser")="" then
		errmsg=errmsg+"<br>"+"<li>您忘记填写发送对象了吧。"
		founderr=true
	else
		incept=request("touser")
	end if
	if request("title")="" then
		errmsg=errmsg+"<br>"+"<li>您还没有填写标题呀。"
		founderr=true
	else
		title=request("title")
	end if
	if request("message")="" then
		errmsg=errmsg+"<br>"+"<li>内容是必须要填写的噢。"
		founderr=true
	else
		message=request("message")
	end if
	if founderr=true then
		call error()
	else
		sql="select * from [user] where username='"&incept&"'"
		rs.open sql,conn,1,1
		if rs.eof and rs.bof then
			errmsg=errmsg+"<br>"+"<li>论坛没有这个用户，看看你的发送对象写对了嘛？"
			founderr=true
		end if
		rs.close
		if founderr=true then
			call error()
		else
		sql="select * from message where (id is null)"
		rs.open sql,conn,1,3
		rs.addnew
		rs("incept")=incept
		rs("sender")=membername
		rs("title")=title
		rs("content")=message
		rs("sendtime")=Now()
		rs("flag")=0
		rs.update
		msg=msg+"<br>"+"<li><b>恭喜您，发送短信息成功。</b><br>发送的消息同时保存在您的发件箱。"
		call success()
		rs.close
		end if
	end if
end sub

sub delete()
	sql="delete from message where incept='"&membername&"' and id="&cstr(request("id"))
	conn.execute sql
    	if err.Number<>0 then
	err.clear
	errmsg=errmsg+"<br>"+"<li>删 除 失 败 ！"
	founderr=true
	call error()
    	else
	msg=msg+"<br>"+"<li>短信息成功删除！"
	call success()
    	end if
end sub

sub deleteall()
	sql="update message set delS=1 where sender='"&membername&"'"
	conn.execute sql
	
	sql="update message set delR=1 where incept='"&membername&"'"
	conn.execute sql

	sql="delete from message where delS=1 and delR=1"
	conn.execute sql
    	if err.Number<>0 then
	err.clear
	errmsg=errmsg+"<br>"+"<li>删 除 失 败 ！"
	founderr=true
	call error()
    	else
	msg=msg+"<br>"+"<li>短信息全部成功删除！"
	call success()
    	end if
end sub

sub success()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>成功：短信息</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=Tablebodycolor%>><%=msg%>
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

sub newmsg()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>短消息通知</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=Tablebodycolor%> align=center><br>
<font face="宋体" color="#333333"><a href=messanger.asp?action=inbox><img src="<%=picurl%>newmail.gif" border=0>有新的短消息</a><br>
                <br>
                <a href=messanger.asp?action=inbox>按此查看</a><br><br>
                </font>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>><%=Copyright%>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
end sub
set rs=nothing
conn.close
set conn=nothing
%>

</body>
</html>