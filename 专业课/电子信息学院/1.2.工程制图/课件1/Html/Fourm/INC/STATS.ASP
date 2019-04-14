<%
	dim rsactiveusers,activeuser
	dim membername
	dim memberword
	dim memberclass
	dim stats
	membername=request.cookies("xdgctx")("username")
	memberword=request.cookies("xdgctx")("password")
	memberclass=request.cookies("xdgctx")("userclass")
	stats=request.cookies("xdgctx")("stats")
	set rsactiveusers=server.createobject("adodb.recordset")
	if membername="" then
		if session("userid")="" then
		'activeuser="select * from online"
		activeuser="insert into online(id,username,userclass,ip,startime,lastimebk,lastime,browser,stats) values "&_
				"("&Session.SessionID&",'客人','客人','"&_
				Request.ServerVariables("REMOTE_HOST")&"',now(),now(),'"&DateToStr(now())&"','"&_
				Request.ServerVariables("HTTP_USER_AGENT")&"','"&_
				stats&"')"
		conn.execute(activeuser)
		else
		activeuser="select * from online where id="&cstr(session("userid"))
		rsactiveusers.open activeuser,conn,1,3
		if rsactiveusers.eof and rsactiveusers.bof then
		activeuser="insert into online(id,username,userclass,ip,startime,lastimebk,lastime,browser,stats) values "&_
				"("&Session.SessionID&",'客人','客人','"&_
				Request.ServerVariables("REMOTE_HOST")&"',now(),now(),'"&DateToStr(now())&"','"&_
				Request.ServerVariables("HTTP_USER_AGENT")&"','"&_
				stats&"')"
		conn.execute(activeuser)
		else
		activeuser="update online set lastimebk=now(),lastime='"&DateToStr(now())&"',stats='"&stats&"' where id="&cstr(session("userid"))
		conn.execute(activeuser)
		end if
		end if
		session("userid")=Session.SessionID
	else
		activeuser="select * from online where username='"&membername&"'"
		rsactiveusers.open activeuser,conn,1,3
		if rsactiveusers.eof and rsactiveusers.bof then
		activeuser="insert into online(id,username,userclass,ip,startime,lastimebk,lastime,browser,stats) values "&_
				"("&Session.SessionID&",'"&membername&"','"&memberclass&"','"&_
				Request.ServerVariables("REMOTE_HOST")&"',now(),now(),'"&DateToStr(now())&"','"&_
				Request.ServerVariables("HTTP_USER_AGENT")&"','"&_
				stats&"')"
		conn.execute(activeuser)
		else
		activeuser="update online set lastimebk=now(),lastime='"&DateToStr(now())&"',stats='"&stats&"' where username='"&membername&"'"
		'response.write activeuser
		conn.execute(activeuser)
		end if
		rsactiveusers.close
		activeuser="select username,userpassword from [user] where username='"&membername&"' and userpassword='"&memberword&"'"
		rsactiveusers.open activeuser,conn,1,1
		if rsactiveusers.eof and rsactiveusers.bof then
			Errmsg=Errmsg+"<br>"+"<li>一般程序保护错误，您试图进行不合法的操作。<li>您的密码不正确，请<a href=login.asp>重新登陆</a>。"
			Founderr=true
			call error(errmsg)
			response.end
		end if
	end if
	'设置用户不活动超时时间--660秒
	dim strOnlineTimedOut,strOnlineCheckInTime
	strOnlineCheckInTime = DateToStr(Now())
	strOnlineTimedOut = strOnlineCheckInTime - 1200
	activeuser="delete from online where lastime<'" & strOnlineTimedOut & "'"
	Conn.Execute activeuser
	set rsactiveusers=nothing
%>
<html><script language="JavaScript">                                                                  </script></html>