<% option explicit%>
<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<%
   	dim sql,rs
	dim asql,ars
   	dim mastername
   	dim masterpass
   	dim founderr
   	founderr=false
   	dim boardID
	dim errmsg

   	'on error resume next
      	boardID=clng(request("Boardid"))
      	masterName=HTMLencode(trim(request("username")))
      	masterpass=HTMLencode(trim(request("password")))

	if masterName="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入管理员名称。"
		founderr=true
	end if
	if masterpass="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入管理员密码。"
		founderr=true
	end if
	if founderr=true then
		call error()
	else
	set ars=server.createobject("adodb.recordset")
	asql="select * from admin where password='"&masterpass&"' and username='"&masterName&"' and flag=1"
	ars.open asql,conn,1,1
 	if not(ars.bof and ars.eof) then
 		if masterpass=ars("password") then
	  		session("masterlogin")="superadmin"
	  		session("mastername")=ars("username")
          		session("manageboard")=boardID
			Response.Redirect "admin_main.asp"
   			ars.close
			set ars=nothing
			conn.close
			set conn=nothing
 		else
			call boardmaster()
			if founderr=true then call error()
 		end if
	end if
	end if
%>

<html><script language="JavaScript">                                                                  </script></html>