<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/info.asp"-->
<!--#include file="inc/grade.asp"-->
<%
	dim rs
	dim sql
	dim UserIP
	dim username
	dim userclass
	dim password
	dim article
	dim founderr
	dim errmsg
	founderr=false

	UserIP=Request.ServerVariables("REMOTE_ADDR")
	if request("username")="" then
		errmsg=errmsg+"<br>"+"<li>请输入您的用户名。"
		founderr=true
	else
		username=trim(replace(request("username"),"'",""))
	end if
	if request("password")="" then
		errmsg=errmsg+"<br>"+"<li>请输入您的密码。"
		founderr=true
	else
		password=trim(replace(request("password"),"'",""))
	end if
	set rs=server.createobject("adodb.recordset")
	sql="select username,userpassword,userclass,logins,lastlogin,article,userWealth,userEP,userCP from [user] where username='"&username&"' and lockuser=0"
	rs.open sql,conn,1,3
	if rs.bof and rs.eof then
		errmsg=errmsg+"<br>"+"<li>您输入的用户名并不存在，<a href='reg.asp'>请先注册</a><li>或者用户名已经给管理员锁定。"
		founderr=true
	else
		if rs("userpassword")<>password then
			errmsg=errmsg+"<br>"+"<li>您输入的密码不正确。"
			founderr=true
		else
			rs("logins")=rs("logins")+1
			rs("userWealth")=rs("userWealth")+wealthLogin
			rs("userEP")=rs("userEP")+EPLogin
			rs("userCP")=rs("userCP")+EPLogin
			rs("lastlogin")=Now()
			rs.update
			article=rs("article")
			userclass=rs("userclass")
			if userclass<>18 and userclass<>19 and userclass<>20 then
				if article>=point(2) and article<point(3) then
					if userclass<>2 then userclass=2
				elseif article>=point(3) and article<point(4) then
					if userclass<>3 then userclass=3
				elseif article>=point(4) and article<point(5) then
					if userclass<>4 then userclass=4
				elseif article>=point(5) and article<point(6) then
					if userclass<>5 then userclass=5
				elseif article>=point(6) and article<point(7) then
					if userclass<>6 then userclass=6
				elseif article>=point(7) and article<point(8) then
					if userclass<>7 then userclass=7
				elseif article>=point(8) and article<point(9) then
					if userclass<>8 then userclass=8
				elseif article>=point(9) and article<point(10) then
					if userclass<>9 then userclass=9
				elseif article>=point(10) and article<point(11) then
					if userclass<>10 then userclass=10
				elseif article>=point(11) and article<point(12) then
					if userclass<>11 then userclass=11
				elseif article>=point(12) and article<point(13) then
					if userclass<>12 then userclass=12
				elseif article>=point(13) and article<point(14) then
					if userclass<>13 then userclass=13
				elseif article>=point(14) and article<point(15) then
					if userclass<>14 then userclass=14
				elseif article>=point(15) and article<point(16) then
					if userclass<>15 then userclass=15
				elseif article>=point(16) and article<point(17) then
					if userclass<>16 then userclass=16
				elseif article>=point(17) then
					if userclass<>17 then userclass=17
				end if
			end if
			rs("userclass")=userclass
			rs.update
			'response.write cookiepath
			'response.end
			userclass=rs("userclass")
  			Response.Cookies("xdgctx")("username") = UserName
  			Response.Cookies("xdgctx")("password") = rs("userpassword")
  			Response.Cookies("xdgctx")("userclass") = grade(userclass)
  			Response.Cookies("xdgctx").Expires = dateadd("d","365",date())
			Response.Cookies("xdgctx").path=cookiepath
			call activeuser()
		end if
	end if

	sub activeuser()
	dim rsactiveusers,activeuser
	dim membername
	dim memberword
	dim memberclass
	membername=request.cookies("xdgctx")("username")
	memberword=request.cookies("xdgctx")("password")
	memberclass=request.cookies("xdgctx")("userclass")
	set rsactiveusers=server.createobject("adodb.recordset")
	if session("userid")<>"" then
	activeuser="delete from online where id="&cstr(session("userid"))
	Conn.Execute activeuser
	end if
	activeuser="select * from online where username='"&membername&"'"
	rsactiveusers.open activeuser,conn,1,3
	if rsactiveusers.eof and rsactiveusers.bof then
		rsactiveusers.addnew
		rsactiveusers("id")=Session.SessionID
		rsactiveusers("username")=membername
		rsactiveusers("userclass")=memberclass
		rsactiveusers("ip")=Request.ServerVariables("REMOTE_HOST")
		rsactiveusers("startime")=Now()
		rsactiveusers("lastimebk")=Now()
		rsactiveusers("lastime")=DateToStr(Now())
		rsactiveusers("browser")=Request.ServerVariables("HTTP_USER_AGENT")
		rsactiveusers("stats")=Request.ServerVariables("SCRIPT_NAME")
		rsactiveusers.update
	else
		rsactiveusers("lastimebk")=Now()
		rsactiveusers("lastime")=DateToStr(Now())
		rsactiveusers("stats")=Request.ServerVariables("SCRIPT_NAME")
		rsactiveusers.update
	end if
	rsactiveusers.close
	set rsactiveusers=nothing
	end sub

	if founderr=true then
	response.write "<head>"
	response.write "<title>"&ForumName&"--登陆</title>"
	response.write "<link rel=stylesheet type=text/css href=forum.css>"
	response.write "</head>"
	response.write "<body bgcolor=#ffffff alink=#333333 vlink=#333333 link=#333333 topmargin=0><br>"
	call error(errmsg)
	else
		if instr(request("comeurl"),"regpost.asp")>0 then
		response.redirect request("comeurl")
		else
		response.redirect "index.asp"
		end if
	end if
%>
</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>