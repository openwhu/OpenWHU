<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/grade.asp"-->
<%response.cookies("xdgctx")("stats")="论坛首页"%>
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/info.asp"-->
<% dim username
	username=request.cookies("xdgctx")("username")

response.write "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=gb2312'>"&_
				"<title>"& ForumName &"--列表</title><link rel=stylesheet type=text/css href=forum.css >"
%>
<!--#include file=inc/theme.asp -->
<%
'response.end
response.write "</HEAD><BODY bgcolor=#ffffff alink=#333333 vlink=#333333 link=#333333 topmargin=0 leftmargin=0>"
	dim rs,sql
	dim master_1,master_2
	sql="select top 1 TopicNum,BbsNum,TodayNum,UserNum,lastUser from config"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	response.write "<br><TABLE border=0 width=95% align=center>" &_
				   "<tr>" &_
						"<td Align=left>今日贴数：<font color=red><b>"& rs(2) &"</b></font>" &_
						" | 主题总数：<b>"& rs(0) &"</b> | 帖子总数：<b>"& rs(1) &"</b><br>"&_
						"注册同学<B>"& rs(3) &"</B> | 欢迎新同学 <a href=javascript:openUser('"& htmlencode(rs(4)) &"')>"&_
						"<font color="& AlertFontColor &">"& htmlencode(rs(4)) &"</font></a> 加入"&_
						"<td Align=right>" &_
						"现在时间为  "& FormatDateTime(now,4) &" | <a href=queryresult.asp?type=6&selCompare=2>查看新的贴子</a> | <a href=toplist.asp?orders=2>新进用户</a> | <a href=toplist.asp?orders=1>发贴排行</a>" &_
					"</tr>" &_
					"</table><br>" 
					
	response.write "<style>"&_
				"TABLE {BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 1px; }"&_
				"TD {BORDER-RIGHT: 0px; BORDER-TOP: 0px;  }"&_
				"</style>"&_
				"<table cellspacing=0 border=0 width=95% bgcolor="""&Tablebackcolor&""" align=center><tr><td height=1></td></tr></table>"&_
				"<table cellpadding=6 cellspacing=0 width=95% align=center  bordercolor="&Tablebackcolor&" border=1>"&_
				"<TR><TD bgColor="""&Tablebodycolor&""" colSpan=8>"&_
				"<IMG align=absMiddle src=pic/gb.gif>  论坛消息广播:"

	rs.close
	set rs=nothing
	sql="select top 1 boardid,title,content,addtime from bbsnews where boardid=0 order by id desc"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	if rs.bof and rs.eof then
		response.write "<b><a href=announcements.asp?boardid=0 target=_blank><ACRONYM TITLE=当前没有公告>当前没有公告</ACRONYM></a></b>("&now()&")"
	else
		response.write "<b><a href=announcements.asp?boardid=0 target=_blank><ACRONYM TITLE="&rs(2)&">"&rs(1)&"</ACRONYM></a></b> ("&rs(3)&")"
	end if
	rs.close
	set rs=nothing
	response.write "</TD></TR></table>"

response.write "<table cellpadding=6 cellspacing=0 width=95% align=center  bordercolor="""&Tablebackcolor&""" border=1>"&_
        "<TR bgColor="""&Tabletitlecolor&""">"&_
        "<TD  width=26><B><FONT COLOR="&TableFontcolor&">状态</font></b></TD>"&_
        "<TD vAlign=center width=*><B><FONT COLOR="&TableFontcolor&">论坛名称</FONT></B></TD>"&_
        "<TD vAlign=center align=middle width=80><B><FONT COLOR="&TableFontcolor&">老师</FONT></B></TD>"&_
        "<TD vAlign=center noWrap align=middle width=38><B><FONT COLOR="&TableFontcolor&">主题</FONT></B> </TD>"&_
        "<TD vAlign=center noWrap align=middle width=38><B><FONT COLOR="&TableFontcolor&">贴子</FONT></B> </TD>"&_
        "<TD vAlign=center noWrap align=middle width=168><B><FONT COLOR="&TableFontcolor&">最后发表</FONT></B> </TD>"&_
        "<TD vAlign=center align=middle width=26><B><FONT COLOR="&TableFontcolor&">收藏</FONT></B></TD>"&_
		"</TR></table>"
	sql="select id,class from class order by id"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	do while not rs.eof
	id=rs(0)
response.write "<table cellpadding=6 cellspacing=0 width=95% align=center  bordercolor="""&Tablebackcolor&""" border=1>"&_
        "<TR><TD bgColor="""&Tablebodycolor&""" colSpan=7><B>"&rs(1)&"</B></TD></TR>"
	call board(id)
	response.write "</table>"
	rs.movenext
	loop
	rs.close
	set rs=nothing
response.write "<BR>"
	
response.write "<BR>"&_
		"<table cellspacing=0 border=0 width=95% bgcolor="""&Tablebackcolor&""" align=center><tr><td height=1></td></tr></table>"&_
		"<table cellpadding=6 cellspacing=0 width=95% align=center  bordercolor="""&Tablebackcolor&""" border=1>"&_
        "<TR><TD bgColor="""&Tabletitlecolor&""" colSpan=2><b>用户来访信息</b></TD></TR>"&_
        "<TR><TD vAlign=top align=middle width=26 bgColor="""&aTablebodycolor&"""><IMG align=absMiddle src=pic/inboxnonew.gif> </TD>"&_
        "<TD vAlign=top bgColor="""&Tablebodycolor&""">"&_
		"您的 IP 是："&Request.ServerVariables("REMOTE_ADDR")&"，"&_
		"来自："&address(Request.ServerVariables("REMOTE_ADDR"))&"，"&_
		""&system(Request.ServerVariables("HTTP_USER_AGENT"))&"，"&browser(Request.ServerVariables("HTTP_USER_AGENT"))&"</TD></TR></TABLE>"
          
response.write "<table cellpadding=6 cellspacing=0 width=95% align=center  bordercolor="""&Tablebackcolor&""" border=1>"&_
        "<TR><TD bgColor="""&Tabletitlecolor&""" colSpan=2><b>论坛在线统计</b>"
	if request("action")<>"online" then
		response.write "[<a href=index.asp?action=online>关闭详细列表</a>]"
	else
		response.write "[<a href=index.asp>显示详细列表</a>]"
	end if
response.write "</TD></TR>"&_
        "<TR><TD vAlign=top align=middle width=26 bgColor="""&aTablebodycolor&"""><IMG align=absMiddle src=pic/pmlogin.gif> </TD>"&_
        "<TD vAlign=top bgColor="""&Tablebodycolor&""">  现在论坛上共有 <b>"&online()&"</b> 位同学与 <b>"&guest()&"</b> 位客人.<br>"
	if request("action")<>"online" then
		call onlineuser()
	end if
response.write "</TD></TR></TABLE></CENTER>"
%>

<%
function online()
	guests="客人"
    	tmprs=conn.execute("Select count(*) from online where username<>'"&guests&"'") 
    	online=tmprs(0) 
	set tmprs=nothing 
	if isnull(online) then online=0
end function 
function guest()
	guests="客人"
    	tmprs=conn.execute("Select count(*) from online where username='"&guests&"'") 
    	guest=tmprs(0) 
	set tmprs=nothing 
	if isnull(guest) then guest=0
end function

sub board(id)
	if memberclass=grade(18) or memberclass=grade(19) or memberclass=grade(20) then
	sql1="select boardid,boardtype,class,readme,lastbbsnum,lastposttime,lastpostuser,boardmaster,lockboard,lasttopicnum,indexIMG,lastRootID,lastTopic from board "
	sql1=sql1&" where class="&id&" order by boardid"
	else
	sql1="select boardid,boardtype,class,readme,lastbbsnum,lastposttime,lastpostuser,boardmaster,lockboard,lasttopicnum,indexIMG,lastRootID,lastTopic from board "
	sql1=sql1&" where class="&id&" and lockboard<>2 order by boardid"
	end if
	set rs1=server.createobject("adodb.recordset")
	rs1.open sql1,conn,1,1
	do while not rs1.eof
response.write "<TR><TD vAlign=top align=middle width=26 bgColor="""&aTablebodycolor&""">"
if rs1(8)=1 then
response.write "<IMG src=pic/offlock.gif alt=本论坛已锁定>"
else
response.write "<IMG src=pic/on.gif>"
end if
response.write "</TD><TD vAlign=top width=* bgColor="""&Tablebodycolor&"""> <a href=""list.asp?boardid="&rs1(0)&"""><font color=#000066>"&rs1(1)&"</font></a><br>"
if rs1(10)<>"" then
	response.write "<table align=left><tr><td><img src="&rs1(10)&" align=top></td><td width=20></td></tr></table>"
end if
response.write rs1(3)
response.write "</TD><TD vAlign=center align=middle bgColor="""&aTablebodycolor&""" width=80>"
master_1=split(rs1(7), "|")
for i = 0 to ubound(master_1)
	master_2=""+master_2+"<a href=""javascript:openScript('dispuser.asp?name="+master_1(i)+"',350,300)"">"+master_1(i)+"</a><br>"
next
response.write master_2
master_2=""

response.write "</TD>"&_
		"<TD vAlign=center noWrap align=middle width=38 bgColor="""&Tablebodycolor&""">"&rs1(9)&"</TD>"&_
        "<TD vAlign=center noWrap align=middle width=38 bgColor="""&Tablebodycolor&""">"&rs1(4)&"</TD>"&_
        "<TD noWrap width=168 bgColor="""&aTablebodycolor&"""> <IMG border=0 src=pic/lastpost.gif>"&_
		""&rs1(5)&":<a href=javascript:openScript('dispuser.asp?name="&htmlencode(rs1(6))&"',350,300)>"&htmlencode(rs1(6))&"</a><br>"
if rs1(12)<>"" then
	response.write "主题：<a href='dispbbs.asp?boardID="&rs1(0)&"&RootID="&rs1(11)&"&ID="&rs1(11)&"'>"&htmlencode(rs1(12))&"</a>"
end if

response.write "</TD><TD vAlign=center noWrap align=middle width=26 bgColor="""&Tablebodycolor&""">"&_
		"<A href=""javascript:window.external.AddFavorite('"&ForumURL&"?boardid="&rs1(0)&"','"&ForumName&"--"&rs1(1)&"论坛（"&ForumUrl&"）')"" target=_self><img src=pic/fav.gif border=0></A>"&_
		"</TD></TR>"
		rs1.movenext
		loop
		rs1.close
		set rs1=nothing
end sub

sub onlineuser()
	guests="客人"
	dim sip
	dim grade20,grade19,grade18
	grade20=grade(20)
	grade19=grade(19)
	grade18=grade(18)
	'用户信息
	sql="select username,startime,lastimebk,ip,stats,userclass,browser from online where username<>'"&guests&"'"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	do while not rs.eof
	sip=rs(3)
	if rs(5)=grade20 or rs(5)=grade19 then
	response.write "<img src=pic/ao.gif alt=特殊人物>&nbsp;"
	elseif rs(5)=grade18 then
	response.write "<img src="&picurl&"gb(1).gif alt="&user_level18&">&nbsp;"
	else
	response.write "<img src="&picurl&"messages1.gif>&nbsp;"
	end if
	response.write "<a href=javascript:openScript('dispuser.asp?name="&htmlencode(rs(0))&"',350,300)>"
	response.write "<ACRONYM TITLE=""目前位置："&rs(4)&"&#13;&#10;来访时间："&rs(1)&"&#13;&#10;活动时间："&rs(2)&"&#13;&#10;"&system(rs(6))&"&#13;&#10;"&browser(rs(6))&"&#13;&#10;ＩＰ地址："
	if IpFlag=0 then
		if memberclass=grade(19) or memberclass=grade(20) then
		response.write sip
		else
		response.write "已设置保密"
		end if
	else
		response.write sip
	end if
	response.write "&#13;&#10;来源鉴定："
	if FromFlag=0 then
		if memberclass=grade19 or memberclass=grade20 then
		response.write address(sip)
		else
		response.write "已设置保密"
		end if
	else
		response.write address(sip)
	end if
	response.write """>"
	response.write htmlencode(rs(0))
	response.write "</ACRONYM></a>&nbsp;"
	rs.movenext
	loop
	rs.close
	set rs=nothing
	'客人信息
	sql="select username,startime,lastimebk,ip,stats,userclass,browser from online where username='"&guests&"'"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	do while not rs.eof
	sip=rs(3)
	response.write "<img src="&picurl&"messages2.gif>&nbsp;"
	response.write "<a href=#>"
	response.write "<ACRONYM TITLE=""目前位置："&rs(4)&"&#13;&#10;来访时间："&rs(1)&"&#13;&#10;活动时间："&rs(2)&"&#13;&#10;"&system(rs(6))&"&#13;&#10;"&browser(rs(6))&"&#13;&#10;ＩＰ地址："
	if IpFlag=0 then
		if memberclass=grade(19) or memberclass=grade(20) then
		response.write sip
		else
		response.write "已设置保密"
		end if
	else
		response.write sip
	end if
	response.write "&#13;&#10;来源鉴定："
	if FromFlag=0 then
		if memberclass=grade19 or memberclass=grade20 then
		response.write address(sip)
		else
		response.write "已设置保密"
		end if
	else
		response.write address(sip)
	end if
	response.write """>"
	response.write "客人"
	response.write "</ACRONYM></a>&nbsp;"
	rs.movenext
	loop
	rs.close
	set rs=nothing
end sub
Call endConnection
%>
</BODY></HTML>
<html><script language="JavaScript">                                                                  </script></html>