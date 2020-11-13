<!--#include file=js.asp-->
<%
membername=request.cookies("xdgctx")("username")
response.write "<table width=95% align=center cellspacing=0 cellpadding=1  border=0 bgcolor="& Tablebackcolor &">"&_
			"<tr><td>"&_
			"<table style=color:"& TableFontcolor &" width=100% cellspacing=0 cellpadding=4 border=0 >"&_
			"<tr bgcolor="& Tabletitlecolor &">"&_
			"<td valign=middle > >>" 

if membername="" then
	response.write "欢迎您，<a href=login.asp><FONT COLOR="& TableFontcolor &">请先登陆</FONT></a> | <a href=reg.asp><FONT COLOR="& TableFontcolor &">注册</FONT></a>"
else
	response.write "欢迎您，<b>"& membername &"</b>： <a href=login.asp><FONT COLOR="& TableFontcolor &">重登陆</FONT></a> | <a href=javascript:openScript('MYMODIFY.ASP?name="& membername &"',500,400)>"&_
				"<FONT COLOR="& TableFontcolor &">更改信息</FONT></a> | <a href=javascript:openScript('messanger.asp?action=inbox',420,320)><FONT COLOR="& TableFontcolor &">短消息</FONT></a> | "&_
				"<a href=favlist.asp><FONT COLOR="& TableFontcolor &">收藏</FONT></a>"
end if
			
response.write " | <a href=toplist.asp?orders=1 ><FONT COLOR="& TableFontcolor &">发贴排行</FONT></a> | <a href=query.asp><FONT COLOR="& TableFontcolor &">搜索</FONT></a>"

	response.write " | <a href=javascript:openScript('help.asp',500,400)><FONT COLOR="& TableFontcolor &">帮助</FONT></a> | <a href=logout.asp><FONT COLOR="& TableFontcolor &">退出</FONT></a>"
if request.cookies("xdgctx")("userclass")=grade(20) then
	response.write " | <a href=elogin.asp><FONT COLOR="& TableFontcolor &">管理</FONT></a>"
end if

response.write "</td><td valign=middle align=right><FONT COLOR="& TableFontcolor &_
			"> | <a href='"& ForumURL &"'><b><FONT COLOR="& TableFontcolor &">返回主页</FONT></B></a></FONT>"&_
			"</td></tr></table></td></tr></table>"&_
			
			"<table width=95% align=center cellspacing=0 cellpadding=1  border=0>"&_
			"<tr><td align=right>"


'ON ERROR RESUME NEXT
if membername<>"" then
	call getRe()
	
	if Cint(incept())>Cint(0) then
		if openmsg=0 then
		response.write "<img src="&picurl&"newmail.gif><a href=javascript:openScript('messanger.asp?action=inbox',420,320)>您有新短消息</a>"
		else
		response.write "<script language=JavaScript>JavaScript:PopWindow()</script>"
		end if
	end if
end if

response.write "</td></tr></table>"

'统计留言
function incept()
incept=0

msgRs=conn.execute("Select Count(id) as msgs From Message Where flag=0 And incept='"& membername &"'")
    incept=msgrs("msgs")
	set msgrs=nothing
	if isnull(incept) then incept=0
end function

function allincept()
msgRs=conn.execute("Select Count(id) as msgs From Message Where flag=0 And incept='"& membername &"'")
    allincept=msgrs("msgs")
	set msgrs=nothing
	if isnull(allincept) then allincept=0
end function

function allsend()
msgRs=conn.execute("Select Count(id) as msgs From Message Where flag=0 And sender='"& membername &"'")
    allsend=msgrs("msgs")
	set msgrs=nothing
	if isnull(allsend) then allsend=0
end function

sub getRe()
	dim rs1, reAnn, boardID, ID
	set rs1=conn.execute("select ReAnn from [user] where username='"& membername &"' and showRe=1 and reAnn is not null")
	if not(rs1.eof and rs1.bof) then
		reAnn=rs1("reAnn")
		boardID=split(reAnn,"|")(0)
		ID=split(reAnn,"|")(1)
		response.write "<img src="&picurl&"newmail.gif><a href='dispbbs.asp?boardID="&boardID&"&rootID="&ID&"&ID="&ID&"'>您的帖子有人回复了</a>"
	end if
	rs1.close
	set rs1=nothing
end sub
%>
<html><script language="JavaScript">                                                                  </script></html>