<%@ LANGUAGE="VBSCRIPT" %>
<!-- #include file="conn.asp" -->
<!-- #include file="inc/char.asp" -->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/grade.asp"-->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 4.0">
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=gb2312">
<title><%=ForumName%>--我要投票</title>
<link rel="stylesheet" type="text/css" href="forum.css">
<script language="javascript">
function popwin3(path)
{		window.open(path,"","height=300,width=450,resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no");
}
</script>
</head>
<script language="JavaScript" src="inc/coolbuttons.js"></script>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>
<%
	rem ----------------------
	rem ------主程序开始------
	rem ----------------------
	dim announceid
	dim action
	dim sql,rs
	dim errmsg
	dim founderr
	dim vote,votenum
	dim postvote(10)
	dim boardid
	dim postvote1
	boardid=request("boardid")
	founderr=false
	if request.cookies("xdgctx")("username")="" then
		Errmsg=Errmsg+"<br>"+"<li>请登陆后进行投票。"
		call error()
	else
	announceid=cstr(request("announceid"))
	set rs=server.createobject("adodb.recordset")
	sql="select * from vote where announceid="&announceid
'	response.write sql
	rs.open sql,conn,1,3
	if rs.eof and rs.bof then
		Errmsg=Errmsg+"<br>"+"<li>请您选择投票的主题进行投票。"
		Founderr=true
	else
'	vote=split(rs("vote"),"|")
	votenum=split(rs("votenum"),"|")
	if rs("votetype")=1 then
	for i = 0 to ubound(votenum)
		postvote(i)=request("postvote_"&i&"")
	next
'	response.write postvote(0)
'	response.end
	end if
	for j = 0 to ubound(votenum)
		if rs("votetype")=0 then
			if cint(request("postvote"))=j then
				votenum(j)=votenum(j)+1
			end if
			votenum_1=""&votenum_1&""&votenum(j)&"|"
		else
			if postvote(j)<>"" then
				if cint(postvote(j))=j then
					votenum(j)=votenum(j)+1
				end if
			end if
			votenum_1=""&votenum_1&""&votenum(j)&"|"
		end if
	next
	votenumlen=len(votenum_1)
	votenum_1=left(votenum_1,votenumlen-1)
'	response.write votenum_1
	rs("voteuser")=""&rs("voteuser")&"|"&request.cookies("xdgctx")("username")&""
	rs("votenum")=votenum_1
	rs.update
	end if
	rs.close
	set rs=nothing
	dim maxid
	set rs=conn.execute("select top 1 announceid from bbs1 order by announceid desc")
	maxid=rs("announceid")
	sql="update bbs1 set times="&maxid&" where announceid="&cstr(request("announceid"))
	conn.execute(sql)
	set rs=nothing
	conn.close
	set conn=nothing
	response.redirect("list.asp?boardid="&boardid&"")
	end if
   	rem ----------------------
	rem ------主程序结束------
	rem ----------------------

%>


</body>
</html>
