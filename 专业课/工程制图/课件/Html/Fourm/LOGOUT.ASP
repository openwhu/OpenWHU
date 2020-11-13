<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<%

	if request.cookies("xdgctx")("username")<>"" then
	activeuser="delete from online where username='"&membername&"'"
	Conn.Execute activeuser
	end if
	if session("userid")<>"" then
	activeuser="delete from online where id="&session("userid")
	Conn.Execute activeuser
	end if
	conn.close
	set conn=nothing
	Response.Cookies("xdgctx").path=cookiepath
	Response.Cookies("xdgctx")("username")=""
	Response.Cookies("xdgctx")("password")=""
	Response.Cookies("xdgctx")("userclass")=""
	session("userid")=""
	response.redirect("index.asp")
%>
