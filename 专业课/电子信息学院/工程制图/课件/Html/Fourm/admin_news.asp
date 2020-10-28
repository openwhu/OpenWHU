<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=inc/grade.asp-->
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
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
	dim Maxid
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
	activeuser="select username,userpassword from [user] where userpassword='"&trim(memberword)&"' and username='"&trim(membername)&"'"
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
	on error resume next
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
	else
		Errmsg=Errmsg+"<br>"+"<li>您没有执行此操作的权限。"
		Founderr=true
	end if
	if founderr=true then
		call error()
	else
	dim title
	dim content
	set rs=server.createobject("adodb.recordset")
	call main()
	set rs=nothing
	conn.close
	set conn=nothing
	sub main()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td>
      <table cellpadding=3 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center colspan="2">欢迎<b>
<%=htmlencode(membername)%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              <td width="20%" valign=top>
注意：各个版面老师可以在自己版面自由发布公告，管理员可以在所有版面发布，并对信息进行管理操作。
<br>
	      </td>
              <td width="80%" valign=top>
      		<table cellpadding=0 cellspacing=0 border=0 width=100% align=center>
		  <tr>
			<td width="100%" valign=top height=24 bgcolor=<%=aTableTitlecolor%>>

<font color=red>请完整填写信息</font>
		  </td></tr>
		</table>
<%
	if request("action")="new" then
		call savenews()
	elseif request("action")="manage" then
		call manage()
	elseif request("action")="edit" then
		call edit()
	elseif request("action")="del" then
		call del()
	elseif request("action")="update" then
		call update()
	else
		call news()
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

sub news()
%>
<form action="admin_news.asp?action=new" method=post name=FORM>
      		<table cellpadding=0 cellspacing=0 border=0 width=100% align=center>
		  <tr><td width="100%" valign=top height=24 colspan="2"><br>
<b><a href=admin_news.asp>论坛公告发布</a></b><%if session("masterlogin")="superadmin" then%>  |  <b><a href=admin_news.asp?action=manage>公告管理</a></b><%end if%><br><br>
		  </td></tr>
		  <tr><td width="20%" valign=top>
发布版面：
		  </td>
		  <td width="80%">
<%if session("masterlogin")="superadmin" then%>
<%
   sql="select boardid,boardtype from board"
   rs.open sql,conn,1,1
%>
<select name="boardid" size="1">
<option value="0">论坛首页</option>
<%
	do while not rs.eof
        response.write "<option value='"+CStr(rs("BoardID"))+"'>"+rs("Boardtype")+"</option>"+chr(13)+chr(10)
	rs.movenext
	loop
	rs.close
%>        
          </select>
<%else%>
<%
	sql="select boardtype from board where boardid="&session("manageboard")
	rs.open sql,conn,1,1
	boardtype=rs("boardtype")
%>
<select name="boardid" size="1">
<option value="<%=session("manageboard")%>"><%=boardtype%></option>
</select>
<%end if%>
		  </td></tr>
		  <tr><td width="20%" valign=top>
发布人：
		  </td>
		  <td width="80%"><input type=text name=username size=36></td></tr>
		  <tr><td width="20%" valign=top>
标题：
		  </td>
		  <td width="80%"><input type=text name=title size=36></td></tr>
		  <tr><td width="20%" valign=top>
内容：
		  </td>
		  <td width="80%"><textarea cols=35 rows=6 name="content"></textarea></td>
		  </tr>
		  <tr><td width="100%" valign=top colspan="2" align=center>
<input type=Submit value="发 送" name=Submit"> &nbsp; <input type="reset" name="Clear" value="清 除">
		  </td></tr>
		</table>
</form>
<%
end sub

sub savenews()
	if session("masterlogin")="superadmin" then
		boardid=request("boardid")
	else
		boardid=session("manageboard")
	end if
	if request("username")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入发布者。"
		founderr=true
	else
		username=request("username")
	end if
	if request("title")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入新闻标题。"
		founderr=true
	else
		title=request("title")
	end if
	if request("content")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入新闻内容。"
		founderr=true
	else
		content=request("content")
	end if
	if founderr=true then
		call error()
	else
		sql="select * from bbsnews"
		rs.open sql,conn,1,3
		rs.addnew
		rs("username")=username
		rs("title")=title
		rs("content")=content
		rs("addtime")=Now()
		rs("boardid")=boardid
		rs.update
		rs.close
		call success()
	end if
end sub

sub manage()
	if session("masterlogin")<>"superadmin" then
	exit sub
	end if
	sql="select * from bbsnews"
	rs.open sql,conn,1,1
%>
      		<table cellpadding=0 cellspacing=0 border=0 width=100% align=center>
		  <tr><td width="100%" valign=top height=24 colspan="2"><br>
<b><a href=admin_news.asp>论坛公告发布</a></b><%if session("masterlogin")="superadmin" then%>  |  <b>公告管理</b><%end if%><br>点击公告标题进行修改。<br><br>
		  </td></tr>
		  <tr><td width="80%" valign=top height=22>
标题
		  </td>
		  <td width="20%">
操作
		  </td></tr>
<%do while not rs.eof%>
		  <tr><td width="80%" valign=top height=22><a href=admin_news.asp?action=edit&id=<%=rs("id")%>&boardid=<%=rs("boardid")%>><%=rs("title")%></a>
		  </td>
		  <td width="20%"><a href=admin_news.asp?action=del&id=<%=rs("id")%>>删除</a>
		  </td></tr>
<%
	rs.movenext
	loop
	rs.close
end sub

sub edit()
%>
<form action="admin_news.asp?action=update&id=<%=request("id")%>" method=post>
      		<table cellpadding=0 cellspacing=0 border=0 width=100% align=center>
		  <tr><td width="100%" valign=top height=24 colspan="2"><br>
<b><a href=admin_news.asp>论坛公告发布</a></b><%if session("masterlogin")="superadmin" then%>  |  <b><a href=admin_news.asp?action=manage>公告管理</a></b><%end if%><br><br>
		  </td></tr>
		  <tr><td width="20%" valign=top>
发布版面：
		  </td>
		  <td width="80%">
<%
	dim sel
   	sql="select boardid,boardtype from board"
   	rs.open sql,conn,1,1
%>
<select name="boardid" size="1">
<option value="0" <%if request("boardid")=0 then%>selected<%end if%>>论坛首页</option>
<%
	do while not rs.eof
	if Cint(request("boardid"))=Cint(rs("boardid")) then
	sel="selected"
	else
	sel=""
	end if
        response.write "<option value='"+CStr(rs("BoardID"))+"' "&sel&">"+rs("Boardtype")+"</option>"+chr(13)+chr(10)
	rs.movenext
	loop
	rs.close
%>        
          </select>
		  </td></tr>
<%
	sql="select * from bbsnews where id="&cstr(request("id"))
	rs.open sql,conn,1,1
%>
		  <tr><td width="20%" valign=top>
发布人：
		  </td>
		  <td width="80%"><input type=text name=username size=36 value=<%=rs("username")%>></td></tr>
		  <tr><td width="20%" valign=top>
标题：
		  </td>
		  <td width="80%"><input type=text name=title size=36 value=<%=rs("title")%>></td></tr>
		  <tr><td width="20%" valign=top>
内容：
		  </td>
		  <td width="80%"><textarea cols=35 rows=6 name="content">
<%
	    content=replace(rs("content"),"<br>",chr(13))
            content=replace(content,"&nbsp;"," ")
            response.write ""&content&""
	    rs.close
%>
		  </textarea></td>
		  </tr>
		  <tr><td width="100%" valign=top colspan="2" align=center>
<input type=Submit value="修 改" name=Submit"> &nbsp; <input type="reset" name="Clear" value="清 除">
		  </td></tr>
		</table>
</form>
<%
end sub

sub update()
	if session("masterlogin")="superadmin" then
		boardid=request("boardid")
	else
		exit sub
	end if
	if request("username")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入发布者。"
		founderr=true
	else
		username=request("username")
	end if
	if request("title")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入新闻标题。"
		founderr=true
	else
		title=request("title")
	end if
	if request("content")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入新闻内容。"
		founderr=true
	else
		content=request("content")
	end if
	if founderr=true then
		call error()
	else
		sql="select * from bbsnews where id="&cstr(request("id"))
		rs.open sql,conn,1,3
		rs("username")=username
		rs("title")=title
		rs("content")=content
		rs("addtime")=Now()
		rs("boardid")=boardid
		rs.update
		rs.close
		call success()
	end if
end sub

sub del()
	sql="delete from bbsnews where id="&cstr(request("id"))
	conn.execute(sql)
	call success()
end sub

sub success()
%><br><br>
成功：新闻操作，您可以继续添加！
<%
end sub
end if
%>
