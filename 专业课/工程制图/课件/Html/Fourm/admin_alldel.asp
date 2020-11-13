<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file="inc/char.asp"-->
<!--#include file="inc/grade.asp"-->
<HTML><HEAD><TITLE><%=ForumName%></TITLE>
<META content="text/html; charset=gb2312" http-equiv=Content-Type>
<link rel="stylesheet" type="text/css" href="forum.css">
<META content="Microsoft FrontPage 4.0" name=GENERATOR></HEAD>
<!--#include file="inc/theme.asp"-->
<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;批量删除</a>
      </TD></TR></TBODY></TABLE> 
<br>
<%
	dim rsactiveusers,activeuser
	dim membername
	dim memberword
	dim memberclass
	dim stats
	dim Errmsg
	dim Founderr
	dim Foundadmin
	dim sql,rs
	dim sql1,rs1
	dim id,boardid,rootid
	founderr=false
	Foundadmin=false
	errmsg=""
	membername=request.cookies("xdgctx")("username")
	memberword=request.cookies("xdgctx")("password")
	memberclass=request.cookies("xdgctx")("userclass")
	stats=request.cookies("xdgctx")("stats")
	if membername="" then
		Errmsg=Errmsg+"<br>"+"<li>您还没有登陆，不能进行操作。"
		Founderr=true
	end if
	if memberclass = grade(19) or memberclass = grade(20)  then
'判断用户身份是否合法
	set rsactiveusers=server.createobject("adodb.recordset")
	activeuser="select username,userpassword from [user] where username='"&membername&"' and userpassword='"&memberword&"'"
	rsactiveusers.open activeuser,conn,1,1
	if rsactiveusers.eof and rsactiveusers.bof then
		Errmsg=Errmsg+"<br>"+"<li>一般程序保护错误，您试图进行不合法的操作。<li>您的密码不正确，请<a href=login.asp>重新登陆</a>。"
		Founderr=true
	end if
	rsactiveusers.close

'判断是否管理员
	activeuser="select username,userpassword from [user] where userpassword='"&memberword&"' and username='"&memberName&"'"
	rsactiveusers.open activeuser,conn,1,1
 	if not(rsactiveusers.bof and rsactiveusers.eof) then
		if memberclass=grade(20) then
 		if memberword=rsactiveusers("userpassword") then
	  		session("masterlogin")="superadmin"
			Foundadmin=true
 		end if
		end if
	end if
	rsactiveusers.close

'判断斑竹身份
	if session("masterlogin")<>"superadmin" then
	'on error resume next
	activeuser="select boardmaster,boardid from board where boardid="&cstr(request("boardid"))
	rsactiveusers.open activeuser,conn,1,1
	if rsactiveusers.eof and rsactiveusers.bof then
		Errmsg=Errmsg+"<br>"+"<li>您选择的版面并不存在，请确认您的操作。"
		Founderr=true
	else
		if instr(rsactiveusers("boardmaster"),membername)>0 then
			session("manageboard")=rsactiveusers("boardid")
		else
			Errmsg=Errmsg+"<br>"+"<li>您的名单不在该版面斑竹列表中，请和管理员联系。"
			Founderr=true
		end if
	end if
	rsactiveusers.close
	end if
	set rsactiveusers=nothing
	if session("masterlogin")="superadmin" then
		if request("boardid")="" then
			founderr=true
			Errmsg=Errmsg+"<br>"+"<li>请指定论坛版面。"
		elseif not isInteger(request("boardid")) then
			founderr=true
			Errmsg=Errmsg+"<br>"+"<li>非法的版面参数。"
		else
			boardid=request("boardid")
		end if
	else
		boardid=session("manageboard")
	end if
	else
		Errmsg=Errmsg+"<br>"+"<li>您没有执行此操作的权限。"
		Founderr=true
	end if
	if founderr=true then
		call error()
	else
		if request("action")="del" then
			call del()
			call success()
		else
			call main()
		end if
	end if
	sub main()
%>
            <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=#777777 align=center>
            <tr><td>
            <table cellpadding=6 cellspacing=1 border=0 width=100%>
            <tr>
            <td bgcolor=#EEEEEE valign=middle colspan=2 align=center>
            <form action="admin_alldel.asp?action=del" method="post">
            <input type=hidden name="boardid" value="<%=boardid%>">
            <b>请输入您的详细资料以便进入删除模式[批量删除]</b></td></tr>
            <tr>
            <td bgcolor=#FFFFFF valign=middle colspan=2><font face="宋体" color=#333333><b>一旦您删除了文章，将不能够恢复！</b>
            <br>下面将删除您管理的论坛该用户的所有文章。如果您确定这样做，请仔细检查您输入的信息。</font></td>
            <tr>
            <td bgcolor=#FFFFFF valign=middle><font face="宋体" color=#333333>删除多少天以外的文章<br>例如：输入'灌水大王'，将删除用户灌水大王在该论坛的所有文章。</font></td>
            <td bgcolor=#FFFFFF valign=middle><input type=text name="username"></td></tr>
            <tr>
            <td bgcolor=#EEEEEE valign=middle colspan=2 align=center><input type=submit name="submit" value="提 交"></td></tr></form></table></td></tr></table>
            </table></td></tr></table>
<%
	end sub
	sub del()
		dim titlenum
		dim NewAnnounceNum,NewTopicNum
    		rs=conn.execute("Select Count(announceID) from bbs1 where boardid="&boardid&" and username='"&trim(request("username"))&"'") 
    		titlenum=rs(0) 
		if isnull(titlenum) then titlenum=0
		sql="delete from bbs1 where boardid="&boardid&" and  username='"&trim(request("username"))&"'"
		conn.Execute(sql)
		sql="update [user] set article=article-"&titlenum&" where username='"&trim(request("username"))&"'"
		conn.Execute(sql)
		sql="select count(announceid) from bbs1 where boardid="&boardid
		set rs=conn.Execute(sql)
		NewAnnounceNum=rs(0)
		sql="select count(announceid) from bbs1 where ParentID=0 and boardid="&boardid
		set rs=conn.Execute(sql)
		NewTopicNum=rs(0)
		sql="update board set lastbbsnum="&NewAnnounceNum&",lasttopicnum="&NewTopicNum&" where boardid="&boardid
		conn.execute(sql)
	end sub
	sub success()
%>
            <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=#777777 align=center>
            <tr><td>
            <table cellpadding=6 cellspacing=1 border=0 width=100%>
            <tr>
            <td bgcolor=#EEEEEE valign=middle colspan=2 align=center>
            删除成功，请<a href=list.asp?boardid=<%=request("boardid")%>>返回论坛</a></td></tr>
</table>
            </table></td></tr></table>
<%
	end sub
%>
</BODY></HTML> 

<html><script language="JavaScript">                                                                  </script></html>