<!--#include file=inc/grade.asp-->
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
	activeuser="select username,userpassword from [user] where userpassword='"&memberword&"' and username='"&membername&"'"
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

'获得所需参数
	if request("id")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定相关贴子。"
	elseif not isInteger(request("id")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		id=request("id")
	end if
	if request("rootid")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定相关贴子。"
	elseif not isInteger(request("rootid")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		rootid=request("rootid")
	end if
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
%>
<html><script language="JavaScript">                                                                  </script></html>