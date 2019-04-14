<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!-- #include file="inc/info.asp" -->
<!-- #include file="inc/grade.asp" -->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 3.0" CHARSET="GB2312">
<title><%=ForumName%></title>
<link rel="stylesheet" type="text/css" href="forum.css">
<script language="javascript">
     function viewPage2(ipage){
        document.frmList2.Page.value=ipage
        document.frmList2.submit()        
     }
     function viewPage1(ipage){
        document.frmList2.Page.value=ipage
        document.frmList2.submit()        
     }

</script>
</head>
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<%
	dim membername
	dim memberword
	dim memberclass
	membername=request.cookies("xdgctx")("username")
	memberword=request.cookies("xdgctx")("password")
	memberclass=request.cookies("xdgctx")("userclass")
%>
<!--#include file="inc/theme.asp"-->
<br>

<%
    	Rem ----------------------
    	Rem ------主程序开始------
    	Rem ----------------------
   	dim sql,rs
	dim Ers,Esql
   	dim boardtype
   	dim master_1,master_2
   	dim username,cname
    	dim foundErr 
    	dim ErrMsg
    	dim bBoardEmpty
	dim boardid
	dim timeLimited,limitime,tl
	dim totalrec
	dim n,i,RowCount
	dim p
	dim currentpage
    	dim announceIDRange1
    	dim announceIDRange2
	dim skin
	dim tablebackcolor,tabletitlecolor,tablebody,atablebody
	dim tablefont,tablecontent,alertfont,Forumlogo
	dim strAllowForumCode,strAllowHTML,strIMGInPosts,strIcons,strflash
	dim grade18,grade19,grade20,todaynum
	dim arrRow1
	dim guestlist
    	foundErr = false
    	ErrMsg = ""
    	selStr = "()"
	grade18=grade(18)
	grade19=grade(19)
	grade20=grade(20)
	if memberclass = grade18 or memberclass = grade19 or memberclass = grade(20) then
		guestlist=""
	else
		guestlist=" lockboard<>2 and "
	end if

    	Rem ------获取参数(get or post的)------
    	Rem ------包括版面的ID和页次------
	set rs=server.createobject("adodb.recordset")
	set iprs=server.createobject("adodb.recordset")
    	Call getInput()
    	call chkInput()
	'显示版头
	call boardinfo(boardid)
    	if foundErr then
		call error(errmsg)
	else
	'显示版头
		call boardtop(boardid)
		call AnnounceList1()
		call listPages3()
		call boardlist()
		if founderr=true then call error(errmsg)
	if err.number<>0 then err.clear
	end if

	sub boardinfo(boardid)
  	sql="select boardtype,lockboard,boardmaster,boardskin,Tableback,Tabletitle,Tablebody,aTablebody,TableContent,AlertFont,Forumlogo,TableFont,strAllowForumCode,strAllowHTML,strIMGInPosts,strIcons,strflash,todaynum from board where "&guestlist&" boardID="&cstr(boardid)
	set rs=server.createobject("adodb.recordset")
 	rs.open sql,conn,1,1
 	if not(rs.bof and rs.eof) then
		arrRow=rs.getrows
		rs.close : set rs=nothing
    		boardtype=arrRow(0,0)
		lockboard=arrRow(1,0)
		Tablebackcolor=arrRow(4,0)
		Tabletitlecolor=arrRow(5,0)
		Tablebody=arrRow(6,0)
		aTablebody=arrRow(7,0)
		TableFontcolor=arrRow(11,0)
		TableContent=arrRow(8,0)
		Forumlogo=arrRow(10,0)
		AlertFont=arrRow(9,0)
		strAllowForumCode=arrRow(12,0)
		strAllowHTML=arrRow(13,0)
		strIMGInPosts=arrRow(14,0)
		strIcons=arrRow(15,0)
		strflash=arrRow(16,0)
		todaynum=arrRow(17,0)
		boardmaster=arrRow(2,0)
		arrRow=null
		if trim(boardmaster)<>"" then
			master_1=split(boardmaster, "|")
			for i = 0 to ubound(master_1)
			master_2=""+master_2+"<a href=""javascript:openUser('"+master_1(i)+"')"">"+master_1(i)+"</a>&nbsp;"
			next
		else
			master_2="无老师"
		end if
	else
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>您选择的版面不存在或者您没有权限察看该版面。"
		exit sub
	end if
	end sub
	REM 显示版面信息---Headinfo
	sub boardtop(boardid)
	call activeuser()

	response.write "<TABLE border=0 width=95% align=center>"&_
				"<TBODY><TR>"&_
				"<TD vAlign=top width=30% ></TD>"&_
				"<TD valign=middle align=top>　<img src='"&picurl&"closedfold.gif' border=0>&nbsp;&nbsp;<a href=index.asp>"& ForumName &"</a><br>"&_
				"　<img src='"&picurl&"bar.gif' border=0 width=15 height=15><img src='pic/openfold.gif' border=0>　<a href='list.asp?boardid="&boardid &"'>"& boardtype &"</a>"&_
				"</TD></TR></TBODY></TABLE><br>"&_
				"<TABLE cellSpacing=0 cellPadding=0 width=95% border=0 align=center>"&_
				"<TBODY><tr>"&_
				"<td align=center width=34 valign=middle> <img src='pic/gb.gif' border=0 alt=本分论坛的公告！不可不看！！ width=20 height=17>"&_ 
				"</td><td valign=middle align=left>"

	sql="select top 1 title,content,addtime from bbsnews where boardid="&boardid&"  order by id desc"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	if rs.bof and rs.eof then
		response.write "<b><a href='announcements.asp?boardid="& boardid &"' target=_blank><ACRONYM TITLE='当前没有公告'>当前没有公告</ACRONYM></a></b> ("& now() &")"
	else
		response.write "<b><a href='announcements.asp?boardid="& boardid &"' target=_blank><ACRONYM TITLE='"& rs("content") &"'>"& rs("title") &"</ACRONYM></a></b> ("& rs("addtime") &")"
	end if
	rs.close
	set rs=nothing


	response.write "</td><td align=right valign=middle><p>"&_
				"<form action=list.asp method=get>"&_
				"<A href=javascript:JM_setTarget() value='' id=globalTarget></a>"&_
				"<input type=hidden name="& boardid &" value="& boardid &">"&_
				"<select name=selTimeLimit>"&_
				"<option value=all>查看所有的主题"&_
				"<option value=1>查看一天内的主题"&_
				"<option value=2>查看两天内的主题"&_
				"<option value=7>查看一星期内的主题"&_
				"<option value=15>查看半个月内的主题"&_
				"<option value=30>查看一个月内的主题"&_
				"<option value=60>查看两个月内的主题"&_
				"<option value=180>查看半年内的主题"&_
				"</select>"&_
				"<input type=submit value=go>"&_
				"</form></p></td></tr>"&_
				"<TR bgColor="& Tablebody &">"&_
				"<TD vAlign=top align=middle><IMG src='pic/pmlogin.gif'> </TD>"&_
				"<TD vAlign=top colSpan=2> 目前"& boardtype &"上共有 <b>"& online() &"</b> 位同学与 <b>"& guest() &"</b>"&_
				" 位客人.今日贴子 <font color=red><b>"& todaynum &"</b></font> "


if request.querystring("action")<>"online" then
	response.write "[<a href=list.asp?boardid="&boardid&"&action=online>关闭详细列表</a>]<br>"
	call onlineuser()
else
	response.write "[<a href=list.asp>显示详细列表</a>]<br>"
end if


response.write "</TD></TR></TBODY></TABLE><br>"&_
			"<table cellpadding=0 cellspacing=0 border=0 width=95% align=center><tr>"&_
			"<td align=center width=2 valign=middle> </td>"&_
			"<td align=left valign=middle> <a href='announce.asp?boardid="& boardid &"'>"&_
			"<img src='pic/post.gif' border=0 alt='发新帖'></a>"&_
			"&nbsp;&nbsp;<a href='vote.asp?boardid="&boardid&"'>"&_
			"<img src='pic/newpoll.gif' border=0 alt='发起新投票'></a></td>"&_
			"<td align=right> <a href='list.asp?boardID="& boardid &"&amp;page=1&skin="& skin &"'>"&_
			"<img src='pic/refresh_1.gif' border=0 alt='刷新'></a>"

response.write "　 <b><a href='list.asp?boardid="& boardid &"'>帖子列表</a>　 "&_
			"论坛老师</b>："& master_2 &"</td></tr></table>"
	end sub

	sub boardlist()

response.write "<table border=0 cellpadding=0 cellspacing=3 width=95% align=center>"&_
			"<form action=list.asp method=get><tr>"&_
			"<td valign=middle nowrap> <div align=right>"&_
			"<select name='boardid' onchange='javascript:submit()'>"&_
			"<option value=''>跳转论坛<option value=''>"

	dim rs1,sql1
	sql="select id,class from class order by id"
	set rs=server.createobject("adodb.recordset")
	set rs1=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	if not(rs.eof and rs.bof) then
	arrRow=rs.getRows
	rs.close : set rs=nothing

	for i=0 to Ubound(arrRow,2)
	response.write "<option value='1'>>>&nbsp;"& arrRow(1,i) &" <<"

		sql1="select boardid,boardtype from board where "&guestlist&" class="& arrRow(0,i)&" order by boardid"
		set rs1=server.createobject("adodb.recordset")
		rs1.open sql1,conn,1,1
		if rs1.eof and rs1.bof then
			rs1.close : set rs1=nothing
			response.write "<option value=''>没有论坛"
		else
			arrRow1=rs1.getrows
			rs1.close : set rs1=nothing
			for ii=0 to Ubound(arrRow1,2)
				response.write "<option value='"& arrRow1(0,ii) &"'>"& arrRow1(1,ii)
			next
			arrRow1=null
		end if

	response.write "<option value=''>"

	next
	arrRow=null
	end if

	response.write "</select><div></td></tr></form></table>"

	response.write "<table cellspacing=0 cellpadding=0 width=95% align=center bgcolor="& Tablebackcolor &" border=0>"&_
				"<tr><td><table cellspacing=1 cellpadding=3 width=100% border=0><tr bgcolor="& Tabletitlecolor &">"&_
				"<td width=80% ><font color="& TableFontcolor &"><b>　-=> "& ForumName &"图例</b></font></td>"&_
				"<td noWrap width=20% align=right><font color="& TableFontcolor &">所有时间均为 - 北京时间 &nbsp;</td>"&_
				"</tr><tr><td colspan=3 bgcolor="& Tablebody &">"&_
				"<table cellspacing=4 cellpadding=0 width=92% border=0 align=center>"&_
				"<tr><td><img src=pic/folder.gif> 开放的主题</td>"&_
				"<td><img src=pic/hotfolder.gif> 回复超过10贴</td>"&_
				"<td><img src=pic/lockfolder.gif> 锁定的主题</td>"&_
				"<td><img src=pic/istop.gif> 固定顶端的主题 </td>"&_
				"<td> <img src=pic/isbest.gif> 精华帖子 </td>"&_
				"</tr><tr><td width=100% colspan=5>"

if strAllowHTML=0 then
	response.write "HTML标签：<font color=#990000>OFF</font>."
else
	response.write "HTML标签：<font color=#003399>ON</font>."
end if

if strAllowForumCode=0 then
	response.write " UBB标签：<font color=#990000>OFF</font>."
else
	response.write " UBB标签：<font color=#003399>ON</font>."
end if

if strIcons=0 then
	response.write " 贴图标签：<font color=#990000>OFF</font>."
else
	response.write " 贴图标签：<font color=#003399>ON</font>."
end if

if strflash=0 then
	response.write " Flash标签：<font color=#990000>OFF</font>."
else
	response.write " Flash标签：<font color=#003399>ON</font>."
end if

if strIMGInPosts=0 then
	response.write " 表情字符转换：<font color=#990000>OFF</font>."
else
	response.write " 表情字符转换：<font color=#003399>ON</font>."
end if

if Uploadpic<>1 then
	response.write " 上传图片：<font color=#990000>OFF</font>."
else
	response.write " 上传图片：<font color=#003399>ON</font>."
end if

if not UploadFlag then
	response.write " 头像上传：<font color=#990000>OFF</font>."
else
	response.write " 头像上传：<font color=#003399>ON</font>."
end if

if not titleFlag then
	response.write " 用户头衔：<font color=#990000>OFF</font>."
else
	response.write " 用户头衔：<font color=#003399>ON</font>."
end if

response.write "</td></tr></table></td></tr></table></td></tr></table><BR>"
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
	if rs.eof and rs.bof then
	rs.close
	else
	arrRow=rs.getRows
	rs.close
	for i=0 to Ubound(arrRow,2)
		if instr(arrRow(4,i),boardtype)>0 then
		sip=arrRow(3,i)
		if arrRow(5,i)=grade20 or arrRow(5,i)=grade19 then
			response.write "<img src=pic/ao.gif alt=特殊人物>&nbsp;"
		elseif arrRow(5,i)=grade18 then
			response.write "<img src="&picurl&"gb(1).gif alt="&user_level18&">&nbsp;"
		else
		response.write "<img src="&picurl&"messages1.gif>&nbsp;"
		end if
		
		arrRow(0,i)=htmlencode(arrRow(0,i))
		response.write "<a href=javascript:openUser('"&arrRow(0,i)&"')>"
		response.write "<ACRONYM TITLE=""目前位置："&arrRow(4,i)&"&#13;&#10;来访时间："&arrRow(1,i)&"&#13;&#10;活动时间："&arrRow(2,i)&"&#13;&#10;"&system(arrRow(6,i))&"&#13;&#10;"&browser(arrRow(6,i))&"&#13;&#10;ＩＰ地址："
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
		response.write """>"&arrRow(0,i)&"</ACRONYM></a>&nbsp;"
		end if
	next
	arrRow=null
	end if


	if guestuser=1 then
	'客人信息
	sql="select username,startime,lastimebk,ip,stats,userclass,browser from online where username='"&guests&"'"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		rs.close
	else
		arrRow=rs.getrows
		rs.close
		for i=0 to Ubound(arrRow,2)
			if instr(arrRow(4,i),boardtype)>0 then
				sip=arrRow(3,i)
				response.write "<img src="&picurl&"messages2.gif>&nbsp;"
				response.write "<a href=#>"
				response.write "<ACRONYM TITLE=""目前位置："&arrRow(4,i)&"&#13;&#10;来访时间："&arrRow(1,i)&"&#13;&#10;活动时间："&arrRow(2,i)&"&#13;&#10;"&system(arrRow(6,i))&"&#13;&#10;"&browser(arrRow(6,i))&"&#13;&#10;ＩＰ地址："
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
				response.write """>客人</ACRONYM></a>&nbsp;"
			end if
		next
	arrRow=null
	end if
	end if
end sub

	sub AnnounceList1()	
	'on error resume next

	sql="select bbs1.AnnounceID,bbs1.parentID,bbs1.boardID,bbs1.UserName,bbs1.child,bbs1.Topic,bbs1.body,bbs1.DateAndTime,bbs1.hits,bbs1.RootID,bbs1.Expression,bbs1.times,bbs1.locktopic,bbs1.istop,bbs1.isbest,board.lockboard from bbs1,board where bbs1.boardid=board.boardid and bbs1.boardID="&cstr(boardID)&" and bbs1.isbest=1 "&tl&" ORDER BY bbs1.times desc,bbs1.announceid desc"
	rs.open sql,conn,1,1
	if err.number<>0 then
		foundErr = true
		ErrMsg = "<li>数据库操作失败：" & err.description & "</li>"
	else
		if rs.bof and rs.eof then
			'论坛无内容
			call showEmptyBoard1()
			bBoardEmpty = true
		else
	      		totalrec=rs.recordcount 
      			if currentpage<1 then 
          			currentpage=1 
      			end if 

      			if (currentpage-1)*MaxAnnouncePerPage>totalrec then 
	   			if (totalrec mod MaxAnnouncePerPage)=0 then 
	     				currentpage= totalrec \ MaxAnnouncePerPage 
	   			else 
	      				currentpage= totalrec \ MaxAnnouncePerPage + 1 
	   			end if 
      			end if 
       			if currentPage=1 then 
            			call showpagelist1() 
       			else 
          			if (currentPage-1)*MaxAnnouncePerPage<totalrec then 
            				rs.move  (currentPage-1)*MaxAnnouncePerPage 
            				call showpagelist1() 
        			else 
	        			currentPage=1 
           				call showpagelist1() 
	      			end if 
	   		end if 
		end if
	end if				
		if err.number<>0 then err.clear	
	end sub

	REM 显示贴子列表	
	sub showPageList1()
	i=0
%>
            <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=Tablebackcolor%> align=center>
            <tr><td height=1>
		</td>
            </tr>
            </table>
<TABLE bgColor="<%=Tablebackcolor%>" border=0 cellPadding=0 cellSpacing=0 width="95%" align=center>
  <TBODY>
  <TR>
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle height=27 bgColor="<%=Tabletitlecolor%>" width=32><font color=<%=TableFontcolor%>>状态</font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=365><font color=<%=TableFontcolor%>>主 题  (点<img src=<%=picurl%>plus.gif>即可展开贴子列表)</font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=80><font color=<%=TableFontcolor%>>作 者 </font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=64><font color=<%=TableFontcolor%>>回复/人气</font></TD>
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td> 
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=195><font color=<%=TableFontcolor%>>最后更新 | 回复人</font></TD>
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td></TR> 
</TBODY></TABLE>
            <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=Tablebackcolor%> align=center>
            <tr><td height=1>
		</td>
            </tr>
            </table>
<%
       do while not rs.eof
%>
<TABLE bgColor="<%=Tablebackcolor%>" border=0 cellPadding=0 cellSpacing=0 width="95%" align=center>
  <TBODY>
  <TR> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=aTablebodycolor%>" width=32 height=27><font color="<%=TableContent%>">
<%
if rs("istop")=1 then
	response.write "<img src="""&picurl&"/istop.gif"" alt=固顶主题>"
else
	if rs("lockboard")=1 then
		response.write "<img src="""&picurl&"/lockfolder.gif"" alt=本论坛已锁定>"
	else
		if rs("child")>=10 then
			response.write "<img src="""&picurl&"/hotfolder.gif"" alt=热门主题>"
		else
			response.write "<img src="""&picurl&"/folder.gif"" alt=开放主题>"
		end if
	end if
end if
%></font>
    </TD> 
    <td bgcolor="<%=Tablebackcolor%>" valign=middle width=1></td>
    <TD bgcolor="<%=Tablebodycolor%>" width="365" onmouseover="javascript:this.bgColor='<%=aTablebodycolor%>';this.style.cursor='default';" onmouseout="javascript:this.bgColor='<%=Tablebodycolor%>';"><font color=<%=TableContent%>>
<!--<a href='dispbbs.asp?boardID=<%=boardID%>&RootID=<%=rs("RootID")%>&ID=<%=rs("announceID")%>&skin=<%=skin%>' target=_blank><img src='images/<%=rs("Expression")%>' border=0 alt="开新窗口浏览此主题"></a>-->
<img src="<%=picurl%>nofollow.gif" id="followImg<%=rs("rootid")%>">
<a href='showannounce.asp?boardID=<%=boardID%>&RootID=<%=rs("RootID")%>&ID=<%=rs("announceID")%>&skin=<%=skin%>' title="《<%=htmlencode(rs("topic"))%>》&#13;&#10;作者：<%=htmlencode(rs("username"))%>&#13;&#10;发表于<%=rs("dateandtime")%>">
<%
if len(rs("topic"))>26 then
	response.write ""&htmlencode(left(rs("topic"),26))&"..."
else
	response.write htmlencode(rs("topic"))
end if
	response.write "</a>"
%></font>
    </TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=aTablebodycolor%>" width=80><font color=<%=TableContent%>><a href=javascript:openScript('dispuser.asp?name=<%=htmlencode(rs("username"))%>',350,300)><%=htmlencode(rs("username"))%></a></font></TD> 
    <td bgcolor=<%=Tableback%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tablebodycolor%>" width=64><font color=<%=TableContent%>><%=rs("child")%>/<%=rs("hits")%></font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD bgColor=<%=aTablebodycolor%> width=195>  <font color=<%=TableContent%>>
&nbsp;<IMG border=0 src="<%=picurl%>lastpost.gif">
<%
	response.write ""&FormatDateTime(rs("dateandtime"),2)&"&nbsp;"&FormatDateTime(rs("dateandtime"),4)&""
	response.write "&nbsp;<font color=#990000>|</font>&nbsp;"
	response.write "<a href=javascript:openScript('dispuser.asp?name="&htmlencode(rs("username"))&"',350,300)>"&htmlencode(rs("username"))&"</a>"
%>
</FONT></TD>
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td></TR> 
</TBODY></TABLE>
            <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=Tablebackcolor%>  align=center>
            <tr><td height=1>
		</td>
            </tr>
            </table>
<%
	  i=i+1
	  if i>=MaxAnnouncePerPage then exit do
          rs.movenext
        loop
	rs.close
		if err.number<>0 then err.clear
	end sub

	sub listPages3()
	'on error resume next

  	dim n
  	if totalrec mod MaxAnnouncePerPage=0 then
     		n= totalrec \ MaxAnnouncePerPage
  	else
     		n= totalrec \ MaxAnnouncePerPage+1
  	end if
%>
<table border="0" cellpadding="0" cellspacing="3" width="95%" align="center">
<form method="post" action="elist.asp" name="frmList2">
        <input type=hidden name="selTimeLimit" value="<%=request("selTimeLimit")%>">
        <input type=hidden name="skin" value="<%=skin%>">
  <tr>
    <td valign="middle" nowrap><span class="smallFont">页次：<strong><%=currentPage%></strong>/<strong><%=n%></strong>页 每页<strong><%=MaxAnnouncePerPage%></strong> 主题数<strong><%=totalrec%></strong></td>
    <td valign="middle" nowrap>
      <div align="right"><p>分页：
<%
	   for p=1 to n
	   if p<10 then
	       if p=currentPage then
	          response.write "["+Cstr(p)+"] "
		   else
		      response.write "<a href='javascript:viewPage2("+Cstr(p)+")' language='javascript'>["+Cstr(p)+"]</a>   "
		   end if
		end if
	next
%>
<span class="smallFont">转到:<input type="text" name="Page" size=3 maxlength=10  value="<%=currentpage%>"><input type="button" value="Go" language="javascript" onclick="viewPage1(document.frmList2.Page.value)" id="button1" name="button1"></span></p>      
      </div>    
    </td>
  </tr>
<input type="hidden" name="BoardID" value="<%=BoardID%>">
</form>
</table>

<%		if err.number<>0 then err.clear
	end sub 

	sub showEmptyBoard1()
%>
<TABLE bgColor='<%=Tablebackcolor%>' border=0 cellPadding=4 cellSpacing=1 width="95%" align=center>
  <TBODY>
  <TR bgColor='<%=Tabletitlecolor%>'>
    <TD align=middle noWrap height=25><font color=<%=TableFontcolor%>>状态</font></TD> 
    <TD align=middle noWrap><font color=<%=TableFontcolor%>>主 题  (点心情符为开新窗浏览)</font></TD> 
    <TD align=middle noWrap><font color=<%=TableFontcolor%>>作 者 </font></TD> 
    <TD align=middle noWrap><font color=<%=TableFontcolor%>>回复/人气</font></TD> 
    <TD align=middle noWrap><font color=<%=TableFontcolor%>>最新回复</font></TD></TR> 
  <tr bgColor="<%=Tablebodycolor%>"><td colSpan=5 vAlign=center width="100%">本精华版面暂无内容，欢迎发贴：）</td></tr>
</TBODY></TABLE>
<%
	rs.close
	end sub

	function online()
	guests="客人"
    	tmprs=conn.execute("Select count(id) from online where username<>'"&guests&"'") 
    	online=tmprs(0) 
	set tmprs=nothing 
	if isnull(online) then online=0
	end function 

	function guest()
	guests="客人"
    	tmprs=conn.execute("Select count(id) from online where username='"&guests&"'") 
    	guest=tmprs(0) 
	set tmprs=nothing 
	if isnull(guest) then guest=0
	end function 

	Sub getInput()
        	'On Error Resume Next
        	Rem ------获取版面ID------
        	BoardID = Request("BoardID")
        	Rem ------获取页次------
        	currentPage=request("page")
    	End Sub
    
    	sub chkInput
		'on error resume next
		if BoardID="" then
			BoardID=1
		elseif not isInteger(BoardID) then
			BoardID=1
		else
			BoardID=clng(BoardID)
			if err then
				BoardID=1
				err.clear
			end if
		end if
		if currentpage="" then
			currentpage=1
		elseif not isInteger(currentpage) then
			currentpage=1
		else
			currentpage=clng(currentpage)
			if err then
				currentpage=1
				err.clear
			end if
		end if
		if request("selTimeLimit")="all" then
			tl=""
		elseif request("selTimeLimit")="" then
			tl=""
		else
			limitime=request("selTimeLimit")
			tl=" and dateandtime>=#"&cstr(cdate(now()-limitime))&"# "
		end if
    	end sub

	sub activeuser()
	dim rsactiveusers,activeuser
	
	if membername="" then
		if session("userid")="" then
		'activeuser="select * from online"
		activeuser="insert into online(id,username,userclass,ip,startime,lastimebk,lastime,browser,stats) values "&_
				"("&Session.SessionID&",'客人','客人','"&_
				Request.ServerVariables("REMOTE_HOST")&"',now(),now(),'"&DateToStr(now())&"','"&_
				Request.ServerVariables("HTTP_USER_AGENT")&"','"&_
				boardtype&"')"
		conn.execute(activeuser)
		else
		activeuser="select * from online where id="&cstr(session("userid"))
		set rsactiveusers=server.createobject("adodb.recordset")
		rsactiveusers.open activeuser,conn,1,3
		if rsactiveusers.eof and rsactiveusers.bof then
		activeuser="insert into online(id,username,userclass,ip,startime,lastimebk,lastime,browser,stats) values "&_
				"("&Session.SessionID&",'客人','客人','"&_
				Request.ServerVariables("REMOTE_HOST")&"',now(),now(),'"&DateToStr(now())&"','"&_
				Request.ServerVariables("HTTP_USER_AGENT")&"','"&_
				boardtype&"')"
		conn.execute(activeuser)
		else
		activeuser="update online set lastimebk=now(),lastime='"&DateToStr(now())&"',stats='"&boardtype&"' where id="&cstr(session("userid"))
		conn.execute(activeuser)
		end if
		end if
		session("userid")=Session.SessionID
		set rsactiveusers=nothing
	else
		activeuser="select username from online where username='"&membername&"'"
		set rsactiveusers=server.createobject("adodb.recordset")
		rsactiveusers.open activeuser,conn,1,3
		if rsactiveusers.eof and rsactiveusers.bof then
		activeuser="insert into online(id,username,userclass,ip,startime,lastimebk,lastime,browser,stats) values "&_
				"("&Session.SessionID&",'"&membername&"','"&memberclass&"','"&_
				Request.ServerVariables("REMOTE_HOST")&"',now(),now(),'"&DateToStr(now())&"','"&_
				Request.ServerVariables("HTTP_USER_AGENT")&"','"&_
				boardtype&"')"
		conn.execute(activeuser)
		else
		activeuser="update online set lastimebk=now(),lastime='"&DateToStr(now())&"',stats='"&boardtype&"' where username='"&membername&"'"
		'response.write activeuser
		conn.execute(activeuser)
		end if
		rsactiveusers.close
		activeuser="select username,userpassword from [user] where username='"&membername&"' and userpassword='"&memberword&"'"
		rsactiveusers.open activeuser,conn,1,1
		if rsactiveusers.eof and rsactiveusers.bof then
			rsactiveusers.close
			set rsactiveusers=nothing
			Errmsg=Errmsg+"<br>"+"<li>一般程序保护错误，您试图进行不合法的操作。<li>您的密码不正确，请<a href=login.asp>重新登陆</a>。"
			Founderr=true
			call error(errmsg)
			response.end
		end if
		rsactiveusers.close
	end if
	set rsactiveusers=nothing
	'设置用户不活动超时时间--660秒
	dim strOnlineTimedOut,strOnlineCheckInTime
	strOnlineCheckInTime = DateToStr(Now())
	strOnlineTimedOut = strOnlineCheckInTime - 1200
	activeuser="delete from online where lastime<'" & strOnlineTimedOut & "'"
	Conn.Execute activeuser
	
	end sub
	set rs=nothing
	Call endConnection
%>

<IFRAME HEIGHT="0" WIDTH="0" SRC="" NAME="hiddenframe" id="hiddenframe"></IFRAME>
</body>
</html>
