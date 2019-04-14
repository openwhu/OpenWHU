<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<!--#include file="inc/grade.asp"-->
<%
	dim rs,sql
	dim boardid,boardtype,announceid_1
    dim foundErr,ErrMsg
	dim username,rootid,topic,topic_1
	dim star,totalrec,p
	dim tableback,tabletitle,tablebody,atablebody
	dim tablefont,tablecontent,alertfont
	dim strAllowForumCode,strAllowHTML,strIMGInPosts
	dim strIcons,strflash,Forumlogo
	dim bgcolor,abgcolor,namestyle
	dim istop,isvote
	dim guestlist,onlineUserList
	dim arrrow
	dim grade18,grade19,grade20
	grade18=grade(18)
	grade19=grade(19)
	grade20=grade(20)
	membername=request.cookies("xdgctx")("username")
	memberclass=request.cookies("xdgctx")("userclass")

    	foundErr = false
    	ErrMsg = ""
	if memberclass = grade18 or memberclass = grade19 or memberclass = grade20 then
		guestlist=""
	else
		guestlist=" lockboard<>2 and "
	end if

    Rem ------包括版面的ID和页次------
    call chkInput()

  	sql="select boardtype,boardskin,Tableback,Tabletitle,Tablebody,aTablebody,TableFont,TableContent,AlertFont,strAllowForumCode,strAllowHTML,strIMGInPosts,strIcons,strflash,Forumlogo from board where "&guestlist&" boardID="&cstr(boardid)
   	set rs=server.createobject("adodb.recordset")
 	rs.open sql,conn,1,1
 	if not(rs.bof and rs.eof) then
		arrRow=rs.getrows
		rs.close : set rs=nothing
		boardtype=arrRow(0,0)
		boardskin=arrRow(1,0)
		Tablebackcolor=arrRow(2,0)
		Tabletitlecolor=arrRow(3,0)
		Tablebody=arrRow(4,0)
		aTablebody=arrRow(5,0)
		TableFontcolor=arrRow(6,0)
		TableContent=arrRow(7,0)
		AlertFont=arrRow(8,0)
		strAllowForumCode=arrRow(9,0)
		strAllowHTML=arrRow(10,0)
		strIMGInPosts=arrRow(11,0)
		strIcons=arrRow(12,0)
		strflash=arrRow(13,0)
		Forumlogo=arrRow(14,0)
	else
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>您选择的版面不存在或者您没有权限察看该版面。"
	end if
	
    conn.execute("update bbs1 set hits=hits+1 where announceID="&AnnounceID_1&"")
	sql="select topic,istop,isbest,username from bbs1 where announceID="&rootID&""
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	if not(rs.bof and rs.eof) then
		arrRow=rs.getrows
		rs.close : set rs=nothing
		topic_1=arrRow(0,0)
		istop=arrRow(1,0)
		isbest=arrRow(2,0)
		username=arrRow(3,0)
		if username=membername and membername<>"" then call readRe()
	else
		foundErr = true
		ErrMsg=ErrMsg+"<br>"+"<li>您指定的贴子不存在</li>"
	end if
	response.write "<html><head>"&_
				"<meta NAME=GENERATOR Content=""Microsoft FrontPage 3.0"" CHARSET=GB2312>"&_
				"<title>"&ForumName&"--浏览贴子</title>"&_
				"<link rel=stylesheet type=text/css href=forum.css></head>"&_
				"<body bgcolor=#ffffff alink=#333333 vlink=#333333 link=#333333 topmargin=0 onkeydown=""if(event.keyCode==13 && event.ctrlKey)frmAnnounce.submit()"">"
%>
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/theme.asp"-->
<%
	response.write "<br>"
    if foundErr then
		call error()
	else
		call showPage()
	end if

	sub showPage()
		'on error resume next
		if foundErr then
			call error()
		else
			call subOnline()
			call announceinfo()
			call listpage()
			if founderr then call error()
		end if
		if err.number<>0 then err.clear
	end sub

	sub announceinfo()
	response.write "<TABLE border=0 width=""95%"" align=center><TBODY><TR>"&_
			"<TD vAlign=top width=""30%""></TD>"&_
			"<TD valign=middle align=top> &nbsp;&nbsp;<img src=pic/closedfold.gif border=0>&nbsp;&nbsp;<a href=index.asp>"&ForumName&"</a><br>"&_
			"&nbsp;&nbsp;<img src=pic/bar.gif border=0 width=15 height=15><img src=pic/closedfold.gif border=0>&nbsp;&nbsp;"&_
			"<a href=list.asp?boardid="&boardid&">"&boardtype&"</a>"&_ 
			"<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=pic/bar.gif border=0 width=15 height=15><img src=pic/openfold.gif border=0>&nbsp;&nbsp;"&htmlencode(topic_1)&""&_ 
			"<a name=top></a></TD></TR></TBODY></TABLE><br>"

	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" align=center>"&_
			"<tr><td align=center width=* valign=middle>&nbsp;</td>"&_
			"<td align=right width=40 valign=bottom> <a href=announce.asp?boardid="&boardid&">"&_ 
			"<img src=pic/newthread.gif alt=发表一个新主题 border=0></a>&nbsp; </td>"&_
			"<td align=right width=40 valign=bottom> <a href=reannounce.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid_1&">"&_ 
			"<img src=pic/rethread.gif alt=回复本主题 border=0></a>&nbsp; </td>"&_
			"<td valign=bottom align=right width=40> <a href=printpage.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid_1&">"&_ 
			"<img src=pic/printpage.gif alt=显示可打印的版本 border=0></a>&nbsp; </td>"&_
			"<td valign=bottom align=right width=40> <a href=pag.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid_1&">"&_
			"<img src=pic/pag.gif border=0 alt=把本贴打包邮递></a>&nbsp; </td>"&_
			"<td valign=bottom align=right width=40> <a href=favadd.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid_1&">"&_
			"<IMG SRC=pic/fav_add.gif BORDER=0 alt=把本贴加入论坛收藏夹></a>&nbsp; "&_
			"</td><td valign=bottom align=right width=40> <a href=sendpage.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid_1&">"&_
			"<img src=pic/emailtofriend.gif border=0 alt=发送本页面给朋友></a>&nbsp; "&_
			"</td><td align=right valign=bottom width=40> <a href=javascript:window.location.reload()>"&_ 
			"<img src=pic/refresh.gif alt=刷新本主题 border=0></a>&nbsp;</td>"&_
			"<td align=right valign=bottom width=40> <a href=javascript:history.back(1)>"&_
			"<img src=pic/back.gif alt=后退请用此按钮，提高浏览速度 border=0></a>&nbsp;</td>"&_
			"<td align=right valign=bottom width=40> <a href=help.asp> <img src=pic/help.gif alt=有疑问请先看帮助 border=0></a>&nbsp;</td>"&_
			"</tr></table>"
	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" bgcolor=#FFFFFF align=center>"&_
			"<tr> <td height=1> </td></tr></table>"

	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" bgcolor="&Tablebackcolor&" align=center>"&_
			"<tr><td height=1> </td></tr></table>"

	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" align=center><tr> "&_
			"<td bgcolor="&Tablebackcolor&" valign=middle width=1 height=24> </td>"&_
			"<td bgcolor="&Tabletitlecolor&" colspan=2 align=left valign=middle width=*>"&_ 
			"<table cellpadding=0 cellspacing=1 border=0 width=""100%"">"&_
			"<tr><td bgcolor="&Tabletitlecolor&" align=left valign=middle><font color="&TableFontcolor&">"&_
            "&nbsp;<b>* 贴子主题</B>： "&htmlencode(topic_1)&"</font> </td></tr>"&_
			"</table></td><td bgcolor="&Tablebackcolor&" valign=middle width=1 height=24> </td>"&_
			"</tr></table>"&_
			"<table cellpadding=0 cellspacing=0 border=0 width=""95%"" bgcolor="&Tablebackcolor&" align=center>"&_
			"<tr> <td height=1> </td></tr></table>"

	sql="Select B.AnnounceID,B.boardID,B.UserName,B.Topic,B.dateandtime,B.body,B.Expression,B.ip,B.rootid,B.signflag,B.isbest,B.isvote,U.username,U.useremail,U.homepage,U.oicq,U.sign,U.userclass,U.title,U.width,U.height,U.article,U.face,U.addDate,U.userWealth,U.userEP,U.userCP from bbs1 B inner join [user] U on U.username=B.username where B.boardid="&boardid&" and B.rootid="&rootid&" order by announceid"
	'response.write sql
	'response.end
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	if not(rs.eof and rs.bof) then
      		totalrec=rs.recordcount 
      		if star<1 then 
          		star=1 
      		end if 
			Maxtitlelist=cint(Maxtitlelist)
      		if (star-1)*Maxtitlelist>totalrec then 
	   		if (totalrec mod Maxtitlelist)=0 then 
	     			star= totalrec \ Maxtitlelist
	   		else 
	      			star= totalrec \ Maxtitlelist + 1 
	   		end if 
      		end if 
			
       		if star=1 then 
				call showannounce()
       		else 
          		if (star-1)*Maxtitlelist<totalrec then
            			rs.move  (star-1)*Maxtitlelist
				call showannounce()
        		else 
	        		star=1 
				call showannounce()
	      		end if 
	   		end if 
	end if
	end sub

	sub showannounce()
	arrRow=rs.getrows
	rs.close : set rs=nothing
	dim i
	i=0
	for k=0 to Ubound(arrRow,2)
	Announceid=arrRow(0,i)
	boardid=arrRow(1,i)
	username=arrRow(2,i)
	topic=arrRow(3,i)
	dateandtime=arrRow(4,i)
	body=arrRow(5,i)
	Expression=arrRow(6,i)
	ip=arrRow(7,i)
	rootid=arrRow(8,i)
	signflag=arrRow(9,i)
	isbest=arrRow(10,i)
	isvote=arrRow(11,i)
	username=arrRow(12,i)
	useremail=arrRow(13,i)
	homepage=arrRow(14,i)
	oicq=arrRow(15,i)
	sign=arrRow(16,i)
	userclass=arrRow(17,i)
	title=arrRow(18,i)
	width=arrRow(19,i)
	uheight=arrRow(20,i)
	article=arrRow(21,i)
	face=arrRow(22,i)
	addtime=arrRow(23,i)
	userWealth=arrRow(24,i)
	userEP=arrRow(25,i)
	userCP=arrRow(26,i)
	if isnumeric(userclass) then
	if userclass=18 then
	namestyle="filter:glow(color=green,strength=2)"
	elseif userclass=19 then
	namestyle="filter:glow(color=#660099,strength=2)"
	elseif userclass=20 then
	namestyle="filter:glow(color=#FF3333,strength=2)"
	else
	namestyle="filter:glow(color=#798AB7,strength=2)"
	end if
	end if
	if isbgcolor(i)=false then
		bgcolor=tablebody
		abgcolor=atablebody
	else
		bgcolor=atablebody
		abgcolor=tablebody
	end if
	'response.write height
	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" align=center>"&_
		"<tr><td bgcolor="&Tablebackcolor&" valign=middle width=1 height=24> </td>"&_
		"<td bgcolor="&bgcolor&">"&_ 
		"<table width=""100%"" cellpadding=4 cellspacing=0><tr>"&_ 
        "<td bgcolor="&bgcolor&" valign=top width=""20%"" rowspan=2><img src="""" width=0 height=4><BR><table width=""100%"" cellpadding=4 cellspacing=0 style="&namestyle&"><tr><td>"&_
        "&nbsp;"&isOnline(username)&"  &nbsp;<a name="&announceid&"><B>"&htmlencode(username)&"</B></a></td></tr></table>"
	if TitleFlag and title<>"" then response.write "　头衔："&htmlencode(title)&"<br>"
	response.write "&nbsp;&nbsp;<img src="&face&" width="&width&" height="&uheight&"><br>"

	if isnumeric(userclass) then
	select case userclass
	case 1 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(1)&">"
	case 2 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(2)&">"
	case 3 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(3)&">"
	case 4 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(4)&">"
	case 5 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(5)&">"
	case 6 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(6)&">"
	case 7 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(7)&">"
	case 8 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(8)&">"
	case 9 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(9)&">"
	case 10 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(10)&">"
	case 11 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(11)&">"
	case 12 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(12)&">"
	case 13 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(13)&">"
	case 14 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(14)&">"
	case 15 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(15)&">"
	case 16 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(16)&">"
	case 17 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(17)&">"
	case 18 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(18)&">"
	case 19 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(19)&">"
	case 20 response.write "&nbsp;&nbsp;<img src=pic/"&gradepic(20)&">"
	end select
    response.write "<br>&nbsp;&nbsp;用户等级: "& grade(userclass) &"<BR>"
	end if
	
	response.write "　用户财产："&userWealth&"<br>"&_
							"　用户经验："&userEP&"<br>"&_
							"　用户魅力："&userCP&"<br>"
	response.write "&nbsp;&nbsp;注册日期: "& year(addtime) &"-"& month(addtime) &"-"& day(addtime)
	response.write "<BR> &nbsp;&nbsp;发表文章: "&article&" <img src="""" width=0 height=4><BR></td>"&_
			"<td bgcolor="&bgcolor&" width=1 height=100% rowspan=2>"&_ 
            "<table width=1 height=""100%"" cellpadding=0 cellspacing=0 bgcolor="&Tabletitlecolor&">"&_
            "<tr><td width=1></td></tr></table></td>"&_
			"<td bgcolor="&bgcolor&" valign=top width=* height=""95%""><img src="""" width=0 height=4><BR>"&_
            "&nbsp; <a href=javascript:openScript('messanger.asp?action=new&touser="&HTMLEncode(username)&"',420,320)>"&_
			"<img src=pic/message.gif border=0 alt=给"&HTMLEncode(username)&"发送一个短消息></a>&nbsp;"&_
            "<a href=javascript:openScript('dispuser.asp?name="&HTMLEncode(username)&"',350,300)>"&_
			"<img src=pic/profile.gif border=0 alt=查看"&HTMLEncode(username)&"的个人资料></a>&nbsp;"&_
            "<a href=queryResult.asp?type=2&txtuser="&HTMLEncode(username)&"&selBoard="&cstr(boardid)&" target=_blank><img src=pic/find.gif border=0 alt=搜索"&HTMLEncode(username)&"在"&boardtype&"的所有贴子></a>&nbsp; "

	if useremail<>"" then
		response.write "<A href='mailto:"& htmlencode(useremail) &"'><IMG alt='点击这里发送电邮给"& HTMLEncode(username) &"' border=0 src='pic/email.gif'></A>&nbsp;" 
    end if
	if oicq<>"" then
	on error resume next
	Dim T,Start,Length,PicURL_1
	T=GetURL("http://search.tencent.com/cgi-bin/friend/oicq_find?oicq_no="&oicq&"") 
	Start=Instr(1,T,"ShowResult("+chr(34)) 
	Start=Instr(Start,T,"http://") 
	Length=Instr(Start,T,chr(34)+","+chr(34))-Start 
	PicURL_1=Mid(T,Start,Length) 
	response.write "<a href=http://search.tencent.com/cgi-bin/friend/user_show_info?ln="&oicq&" target=_blank title="""&htmlencode(username)&"["&oicq&"]的QQ情况""><img src="&PicURL_1&" width=16 height=16 border=0>OICQ</a>&nbsp;"
	end if
	if homepage<>"" then
		response.write "<A href='"& htmlencode(homepage) &"' target=_blank><IMG alt='访问"& HTMLEncode(username) &"的主页'  border=0 src='pic/homepage.gif'></A>&nbsp; "
	end if

	response.write "<a href=reannounce.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid&"&reply=true>"&_
			"<img src=pic/reply.gif border=0 alt=引用回复这个贴子></a>&nbsp; "&_
            "<BR><hr width=""100%"" size=1 color=#777777>"&_
            "<table cellpadding=0 cellspacing=0 width=""95%"" style=""TABLE-LAYOUT: fixed"">"&_
            "<tr><td width=32 align=left valign=top>"
	if instr(Expression,"face")>0 then
		response.write "<img src='images/"& Expression &"' border=0 alt=发贴心情>"
	end if
	response.write "&nbsp;</td><td style=""LEFT: 0px; WIDTH: 100%; WORD-WRAP: break-word"">"&_
			"<font face=宋体 color=#333333>" 
	response.write "<b>"& htmlencode(topic) &"</b><br>"& ubbcode(body) 
if not isnull(isvote) and cint(isvote)=1 and announceid=rootid then
	set vrs=conn.execute("select vote,votenum,votetype,voteuser from vote where announceid="&announceid&"")

	vote=split(vrs("vote"),"|")
	votenum=split(vrs("votenum"),"|")
	response.write "<table border=0 cellpadding=0 cellspacing=3 width=""95%"" align=center><tr>"
	response.write "<td colSpan=2>以下为投票内容：</td></tr>"
	response.write "<form action=postvote.asp?boardid="&boardid&"&announceid="&announceid&"&action="&vrs("votetype")&" method=POST>"
	for m = 0 to ubound(vote)
	if cint(vrs("votetype"))=0 then
		vote_1=""&vote_1&""&m+1&".  <input type=radio name=postvote value="""&m&""">"&vote(m)&"<br>"
	else
		vote_1=""&vote_1&""&m+1&".  <input type=checkbox name=postvote_"&m&" value="""&m&""">"&vote(m)&"<br>"
	end if
	next
	response.write "<tr><td width=""60%"">"&vote_1&"</td>"
	vote_1=""
	for m = 0 to ubound(votenum)
		votenum_1=""&votenum_1&"票数：<font color=#990000><b>"&votenum(m)&"</b></font><br>"
	next
	response.write "<td width=""40%"" valign=top><span style=""LINE-HEIGHT: 200%;"">"&votenum_1&"</span></td></tr>"
	votenum_1=""
	if membername="" then
	response.write "<tr><td colSpan=2><br><font color=#990000>您还没有登陆，不能进行投票。</font></td>"
	else
	if instr(vrs("voteuser"),membername)>0 then
	response.write "<tr><td colSpan=2><br><font color=#990000>您已经投过票了，请看结果吧。</font></td>"
	else
	response.write "<tr><td colSpan=2><br><input type=submit name=Submit value='投 票'></td>"
	end if
	end if
	response.write "</form>"
	response.write "</tr></table>"
	set vrs=nothing
end if
if signflag=1 then
	if sign<>"" then
		response.write "<p>------------------------<br>"& ubbcode(sign)
	end if
end if
	response.write "</font> </td><td width=16> </td></tr></table></td></tr><tr>"&_ 
			"<td class=bottomline bgcolor="&bgcolor&" valign=bottom> "&_
            "<hr width=100% size=1 color=#777777>"&_
            "<table width=100% cellpadding=0 cellspacing=0><tr><td align=left valign=bottom> "
	if membername<>"" then
		if username=membername or memberclass = grade19 or memberclass = grade20  then
			response.write "&nbsp; <a href=editannounce.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid&"><img src=pic/edit.gif border=0 alt=编辑这个贴子></a>"
		end if
	end if
	response.write "</td><td align=left valign=bottom> 发贴时间： "&dateandtime&" </td>"&_
			"<td align=left valign=bottom> <img src=pic/ip.gif border=0 width=13 height=15 alt="""">  " 
	if IpFlag=0 then
		if memberclass=grade19 or memberclass=grade20 then
		response.write ip
		else
        	response.write getip(ip)
		end if
	else
		response.write ip 
        end if
	response.write "</td><td align=right nowarp valign=bottom width=110>"
	if memberclass=grade19 or memberclass=grade20 then
		if announceid<>rootid then				
		response.write "<a href=admin_postings.asp?action=dele&boardID="&boardID&"&ID="&announceID&"&rootid="&rootID&"&username="&server.URLencode(username)&" title=注意：本操作将删除单个贴子，不能恢复><img src=PIC/delete.gif border=0></a> "
		end if
		response.write "<a href=admin_postings.asp?action=copy&boardID="&boardID&"&ID="&announceID&"&rootid="&rootID&" title=复制单个贴子到别的版面><img src=PIC/copy.gif border=0></a>  "
		if isbest=0 then
			response.write "<a href=admin_postings.asp?action=isbest&boardID="&boardID&"&ID="&announceID&"&rootid="&rootID&" title=将单个贴子加入精华><img src=PIC/jing.gif border=0></a>" 
		else
			response.write "<a href=admin_postings.asp?action=nobest&boardID="&boardID&"&ID="&announceID&"&rootid="&rootID&" title=解除本贴子精华状态><img src=PIC/jing.gif border=0></a>" 
		end if
	end if
	response.write "</td><td align=right valign=bottom width=4> </td></tr></table>"&_
			"<img src="""" width=0 height=4><BR></td></tr></table></td>"&_
			"<td bgcolor="&Tablebackcolor&" valign=middle width=1 height=24> </td></tr></table>"
	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" bgcolor="&Tablebackcolor&" align=center>"&_
			"<tr><td height=1> </td></tr></table>"
	 	i=i+1
	 	if k>=Maxtitlelist then exit for
		next
		arrRow=null
	end sub

	sub listpage()
  	dim n
  	if totalrec mod Maxtitlelist=0 then
     		n= totalrec \ Maxtitlelist
  	else
     		n= totalrec \ Maxtitlelist+1
  	end if
	response.write "<table border=0 cellpadding=0 cellspacing=3 width=""95%"" align=center>"&_
			"<tr><td valign=middle nowrap>"&_
			"<span class=smallFont>页次：<strong>"&star&"</strong>/<strong>"&n&"</strong>页"&_
			"每页<strong>"&Maxtitlelist&"</strong> 本主题贴数<strong>"&totalrec&"</strong></td>"&_
			"<td valign=middle nowrap><div align=right><p>分页： "
	   for p=1 to n
	       if p=int(star) then
	          response.write "<font color=gray>[<b>"+Cstr(p)+"</b>]</font> "
		   else
		      response.write "<a href='dispbbs.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid_1&"&star="+Cstr(p)+"&skin="&request("skin")&"'>[<b>"+Cstr(p)+"</b>]</a>   "
		   end if
	next
	response.write "</p></div></td></tr></table>"
	response.write "<table cellpadding=0 cellspacing=0 border=0 width=""95%"" align=center>"&_
			"<tr bgcolor="&Tabletitlecolor&"><td align=left width=90% valign=middle> <font color="&TableFontcolor&">&nbsp;<b>*快速回复</b>："&htmlencode(topic_1)&"</font></td>"&_
			"<td width=10% align=right valign=middle height=24> <a href=#top><img src=pic/gotop.gif border=0>顶端</a>&nbsp;</td></tr></table>"
%>
<!--#include file="inc/code.asp"-->
<%
	response.write "<TABLE cellSpacing=1 cellPadding=1 width=""95%"" border=0 align=center>"&_
			"<TBODY> <TR bgColor="&tablebackcolor&"><TD vAlign=top colSpan=3> "&_
			"<TABLE cellSpacing=0 cellPadding=3 width=""100%"" bgColor="&tabletitlecolor&" border=0>"&_
			"<form action=SaveReAnnounce.asp?method=fastreply&boardID="&boardid&" method=POST  name=frmAnnounce onSubmit=submitonce(this)>"&_
			"<input type=hidden name=followup value="&AnnounceID_1&">"&_
			"<input type=hidden name=rootID value="&RootID&">"&_
			"<INPUT TYPE=hidden name=boardtype value="&htmlencode(boardtype)&">"&_
			"<TBODY><TR bgColor="&tablebody&"><TD noWrap width=175>你的用户名:</TD>"&_
            "<TD><INPUT maxLength=25 size=15 value="""&membername&""" name=username>"&_
            "&nbsp;&nbsp; <A href=reg.asp>还没注册?</A> 密码:"&_ 
            "<INPUT type=password maxLength=13 size=15 value="""&memberword&""" name=passwd>"&_
            "&nbsp;&nbsp; <A href=lostpass.asp>忘记密码?</A> </TD></TR>"&_
			"<TR bgColor="&atablebody&"> <TD vAlign=top noWrap><b>内容</b><br>"&_
            "<br>在此论坛中<br><li>HTML标签： "
	if strAllowHTML=0 then
		response.write "不可用 "
	else
		response.write "允许 "
	end if
	response.write "<li>UBB标签： "
	if strAllowForumCode=0 then
		response.write "不可用 "
	else
		response.write "允许"
	end if
	response.write "<li>贴图标签： "
	if strIcons=0 then
		response.write "不可用"
	else
		response.write "允许"
	end if
	response.write "<li>Flash标签："
	if strflash=0 then
		response.write "不可用"
	else
		response.write "允许"
	end if
	response.write "<li>表情字符转换："
	if strIMGInPosts=0 then
		response.write "不可用"
	else
		response.write "允许"
	end if
	response.write "<li>上传图片："
	if Uploadpic=0 then
		response.write "不可用"
	else
		response.write "允许"
	end if
	response.write "<li>最多"&AnnounceMaxBytes\1024&"KB </TD><TD> "&_
			"<TEXTAREA name="&session("antry")&" cols=70 rows=9 wrap=VIRTUAL title=可以使用Ctrl+Enter直接提交贴子></TEXTAREA>"&_
            "</TD></TR><TR bgColor="&tablebody&"><TD noWrap>"&_ 
			"<INPUT type=checkbox value=yes name=emailflag>"&_
            "邮件回复 <INPUT type=checkbox CHECKED value=yes name=signflag>"&_
            "显示签名 </TD><TD width=""100%""> "&_
            "<input type=Submit value=OK!发表我的回应帖子 name=Submit>"&_
            "&nbsp;<input type=reset name=Clear value=清空内容！>"&_
            "[<font color="&alertfont&">Ctrl+Enter直接提交贴子</font>] </TD>"&_
			"</TR></FORM></TBODY></TABLE></TD></TR> </TBODY> </TABLE>"
	if err.number<>0 then err.clear
	end sub

   	sub chkInput
		'on error resume next
	if request("boardid")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定论坛版面。"
	elseif not isInteger(request("boardid")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的版面参数。"
	else
		boardid=request("boardid")
	end if
	if request("id")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定相关贴子。"
	elseif not isInteger(request("id")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		AnnounceID_1=request("id")
	end if
	if request("RootID")="" then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>请指定相关贴子。"
	elseif not isInteger(request("RootID")) then
		founderr=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		RootID=request("RootID")
	end if
	if request("star")="" then
		star=1
	elseif not isInteger(request("star")) then
		star=1
	else
		star=request("star")
	end if
    	end sub

	function isbgcolor(num)
	n=num mod 2
	if n=1 then
		isbgcolor=true
	else
		isbgcolor=false
	end if
	end function

	set rs=nothing
	Call endConnection()
	response.write "<p> "
	if memberclass=grade19 or memberclass=grade20 then
		response.write "<TABLE cellSpacing=0 cellPadding=0 width=""95%"" border=0 align=center>"&_
				"<tr valign=center> <td width =100% align=right> "&_
				"<a href=admin_postings.asp?action=lock&boardID="&boardID&"&ID="&announceID_1&"&rootid="&rootID&" title=锁定本主题>锁定</a> "&_
				"  | <a href=admin_postings.asp?action=unlock&boardID="&boardID&"&ID="&announceID_1&"&rootid="&rootID&" title=将本主题解开锁定>解锁</a>"&_
				"  | <a href=admin_postings.asp?action=delete&boardID="&boardID&"&ID="&announceID_1&"&rootid="&rootID&"&username="&server.urlencode(username)&" title=注意：本操作将删除本主题所有贴子，不能恢复>删除</a>"&_ 
				"  | <a href=admin_postings.asp?action=move&boardID="&boardID&"&ID="&announceID_1&"&rootid="&rootID&" title=移动主题>移动</a>  |  "
	if istop=0 then
		response.write "<a href=admin_postings.asp?action=istop&boardID="&boardID&"&ID="&announceID_1&"&rootid="&rootID&" title=将本主题固顶>固顶</a>"
	else
		response.write "<a href=admin_postings.asp?action=notop&boardID="&boardID&"&ID="&announceID_1&"&rootid="&rootID&" title=将本主题固顶状态解除>解固</a>"
	end if
	response.write "  | <a href=""admin_news.asp?boardid="&boardid&""">发布公告</a>  | <a href=""admin_alldel.asp?boardid="&boardid&""">批量删除</a>"
	response.write "</td></tr></table>"
	end if 

sub readRe()
	dim rs1,ID
	set rs1=conn.execute("select reAnn from [user] where username='"&membername&"' and reAnn is not null")
	if not (rs1.eof and rs1.bof) then
		ID=split(rs1("reAnn"),"|")(1)
		if ID=rootID then
			conn.execute ("update [user] set reAnn=null where username='"&membername&"'")
		end if
	end if
	rs1.close
	set rs1=nothing
end sub

sub subOnline
	sql="select username from online"
	set rs=server.createobject("adodb.recordset")
	rs.open sql,conn,1,1
	onlineUserList=rs.getstring(2,,,chr(13))
	onlineUserList=chr(13)&onlineUserList
	rs.close
	set rs=nothing
end sub

function isOnline(username)
	if instr(onlineUserList,chr(13)&username&chr(13))>0 then
		isonline="<img src=pic/online1.gif alt=在线，有人找我吗？>"
	else
		isonline="<img src=pic/offline1.gif alt=掉线，给我留言吧！>"
	end if
end function

Function GetURL(url) 
on error resume next
Set Retrieval = CreateObject("Microsoft.XMLHTTP") 
With Retrieval 
.Open "GET", url, False, "", "" 
.Send 
GetURL = .ResponseText 
End With 
Set Retrieval = Nothing 
End Function 
Function GetIp(IP)
ips=Split(ip,".")
GetIp=ips(0)&"."&ips(1)&".*.*"
end Function
%>
</BODY>
</HTML>
<html><script language="JavaScript">                                                                  </script></html>