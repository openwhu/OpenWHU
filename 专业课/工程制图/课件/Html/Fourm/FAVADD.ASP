<%@ LANGUAGE="VBSCRIPT" %>
<!-- #include file="conn.asp" -->
<!-- #include file="inc/char.asp" -->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/grade.asp"-->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 4.0">
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=<%=CharSet%>">
<title><%=ForumName%>--我的收藏</title>
<link rel="stylesheet" type="text/css" href="forum.css">
</head>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>
<%
	rem ----------------------
	rem ------主程序开始------
	rem ----------------------
	dim Founderr
	dim Errmsg
	dim boardid
	dim announceid
	dim rootid
	dim topic
	dim url
	Founderr=false
	set rs=server.createobject("adodb.recordset")
	if membername="" then
		Errmsg=Errmsg+"<br>"+"<li>您还没有<a href=reg.asp>登录</a>。"
		Founderr=true
	end if
	if request("boardid")="" then
		Errmsg=Errmsg+"<br>"+"<li>您没有指定版面名称。"
		Founderr=true
	else
		boardid=request("boardid")
	end if
	if request("id")="" then
		Errmsg=Errmsg+"<br>"+"<li>您没有指定贴子ID。"
		Founderr=true
	else
		announceid=request("id")
	end if
	if request("rootid")="" then
		Errmsg=Errmsg+"<br>"+"<li>您没有指定贴子ID。"
		Founderr=true
	else
		rootid=request("rootid")
	end if
	if founderr=true then
		call ErrMsg()
	else
		url="dispbbs.asp?"
		url=url+"boardid="+boardid+"&rootid="+rootid+"&id="+announceid
		call chkurl()
		if founderr=true then
			call ErrMsg()
		else
			call favadd()
			if founderr=true then
				call ErrMsg()
			else
				call success()
			end if
		end if
	end if

	sub chkurl()
		sql="select topic,rootid,announceid,boardid from bbs1 where announceid="&cstr(announceid)&" and rootid="&cstr(rootid)&" and boardid="&cstr(boardid)
		rs.open sql,conn,1,1
		if rs.eof and rs.bof then
			Errmsg=Errmsg+"<br>"+"<li>没有相关贴子。"
			Founderr=true
		else
			topic=rs("topic")
		end if
		rs.close
	end sub
	sub favadd()
		sql="select * from bookmark where url='"&trim(url)&"'"
		rs.open sql,conn,1,3
		if not rs.eof and not rs.bof then
			Errmsg=Errmsg+"<br>"+"<li>该贴子已经在收藏夹中。"
			Founderr=true
		else
		rs.addnew
		rs("username")=membername
		rs("topic")=topic
		rs("url")=url
		rs("addtime")=Now()
		rs.update
		end if
		rs.close
	end sub

	sub success()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=atabletitlecolor%>>成功：贴子收藏</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=tablebodycolor%>><b>本贴子已经收入您在论坛的<a href=favlist.asp>收藏夹</a></b><br><br>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=atabletitlecolor%>>
<a href="javascript:history.go(-1)"> << 返回上一页</a>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
	end sub

	set rs=nothing
	call endConnection() 
   	rem ----------------------
	rem ------主程序结束------
	rem ----------------------

%>

</body>
</html>
