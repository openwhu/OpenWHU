<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<%
	rem ----------------------
	rem ------主程序开始------
	rem ----------------------
	dim announceid
	dim UserName
	dim userPassword
	dim useremail
	dim article
	dim Topic
	dim body
	dim FoundError
	dim ErrMsg
	dim dateTimeStr
	dim addAll
	dim newUser
	dim UserID
	dim ip
	dim Expression
	dim boardID
   	dim sql
   	dim rs
   	dim FoundUser
	dim boardtype
	dim signflag
	dim mailflag
	dim TIME_ADJUST
	dim lockboard
	dim skin
	dim votetype,vote,votenum

	rem ------获得asp文件参数------
	call getInput()

	rem -----检查版面ID的合法性------	
	dim boardRs
	set boardRs=conn.execute("select lockboard from board where boardid="&cstr(boardid))
	if boardRs.bof and boardRs.eof then
		Errmsg=ErrMsg+"<Br>"+"<li>你要加贴的版面不存在！"
		FoundError=true
	else
		lockboard=boardRs("lockboard")

	end if
	boardRs.close
	set boardRs=nothing
	if err.number<>0 then err.clear
	
	foundError=false
	ErrMsg=""

	rem -----检查user输入数据的合法性------	
	call chkData()	

	if foundError=true then
		response.write "<link rel=stylesheet type=text/css href=forum.css>"
  	       	call Error()
	else
		call checkUser()
		response.write "<html><head><title>"&ForumName&"--发表投票</title>"&_
		"<link rel=stylesheet type=text/css href=forum.css>"&_
		"<meta HTTP-EQUIV=Content-Type content=""text/html; charset=gb2312""></head>"&_
		"<body bgcolor=#ffffff alink=#333333 vlink=#333333 link=#333333 topmargin=0 leftmargin=0>"
%>
<!--#include file="inc/theme.asp"-->
<!--#include file="inc/grade.asp"-->
<%
	response.write "<TABLE border=0 width=95% align=center>"&_
				"<TBODY><TR>"&_
				"<TD vAlign=top width=30% ><img border=0 src='"&logo&"'></TD>"&_
				"<TD valign=middle align=top>　<img src='"&picurl&"closedfold.gif' border=0>&nbsp;&nbsp;<a href=index.asp>"& ForumName &"</a><br>"&_
				"　<img src='"&picurl&"bar.gif' border=0 width=15 height=15><img src='pic/openfold.gif' border=0>　发表新投票"&_
				"</TD></TR></TBODY></TABLE>"
		if foundError then
  	       		call Error()
		else
			call saveAnnounce()
			call savevote()
		end if
		
	end if
	
	set rs=nothing
	call endConnection()

	rem ----------------------
	rem ------主程序结束------
	rem ----------------------
	rem 检测用户输入数据合法性
	sub checkUser()
   	set rs=server.createobject("adodb.recordset")
   	sql="select username,userpassword,lockuser,userclass,article,userwealth,userep,usercp from [User] where username='"&replace(trim(username),"'","''")&"'"
   	rs.open sql,conn,1,3
   	if not rs.EOF then
        	FoundUser=True
   	end if
	if not FoundUser then
		Errmsg=ErrMsg+"<Br>"+"<li>本论坛只有<a href=reg.asp>注册用户</a>才能发言！"
		founderror=true
        elseif UserPassword<>rs("UserPassword") then
           	ErrMsg=ErrMsg+"<Br>"+"<li>您的密码不正确(可能该名字被他人占用了，请尝试用<a href=reg.asp>别的名字</a>)"
	       	foundError=true
	elseif rs("lockuser")=1 then
           	ErrMsg=ErrMsg+"<Br>"+"<li>该用户账号已被锁定，请和管理员联系。"
	       	foundError=true
       	else
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
			sql="update [user] set article=article+1,userWealth=userWealth+"&wealthAnnounce&",userEP=userEP+"&epAnnounce&",userCP=userCP+"&cpAnnounce&",userclass='"&userclass&"' where username='"&replace(trim(username),"'","''")&"'"
			conn.execute(sql)
		userclass=rs("userclass")
		Response.Cookies("xdgctx")("username") = UserName
		Response.Cookies("xdgctx")("password") = UserPassWord
		Response.Cookies("xdgctx")("userclass") = grade(userclass)
		rem 清除图片上传数的限制
		response.cookies("xdgctx")("upNum")=1
  		Response.Cookies("xdgctx").Expires = dateadd("d","365",date())
		Response.Cookies("xdgctx").path=cookiepath
		call activeuser()
         	rs.update

		if lockboard=1 then
			if rs("userclass")<>user_level9 then
				Errmsg=ErrMsg+"<Br>"+"<li>您没有权限在本版面发布贴子！"
				FoundError=true
			end if
		elseif lockboard=2 then
			if rs("userclass")<>user_level18 and rs("userclass")<>user_level19 and rs("userclass")<>user_level20 then
				Errmsg=ErrMsg+"<Br>"+"<li>您没有权限在本版面发布贴子！"
				FoundError=true
			end if
		end if
      	end if
    	rs.close
	end sub

	rem 保存贴子信息
	sub saveAnnounce()
        DateTimeStr=CSTR(NOW()+TIMEADJUST/24)
		Sql="insert into bbs1(Boardid,ParentID,Child,username,topic,body,DateAndTime,hits,length,rootid,layer,orders,ip,Expression,locktopic,signflag,emailflag,istop,isbest,isvote,times) values "&_
				"("&_
				boardid&",0,0,'"&_
				username&"','"&_
				topic&"','"&_
				body&"','"&_
				DateTimeStr&"',0,'"&_
				strlength(body)&"',0,1,0,'"&ip&"','"&_
				Expression&"',0,"&signflag&","&mailflag&",0,0,1,0)"
		conn.execute(sql)
		set rs=conn.execute("select top 1 announceid from bbs1 order by announceid desc")
        announceid=rs(0)
		sql="update bbs1 set rootid="&announceid&",times="&announceid&" where announceid="&announceid
		conn.execute(sql)
		if topic="" then
			Topic=cutStr(body,20)
		else
			Topic=cutStr(topic,20)
		end if
		sql="update board set lastpostuser='"&username&"',lastposttime='"&datetimestr&"',lastbbsnum=lastbbsnum+1,lasttopicnum=lasttopicnum+1,todaynum="&boardtoday(boardid)&",lastrootid="&announceid&",lasttopic='"&topic&"' where  boardid="&cstr(boardID)
		conn.execute(sql)
		conn.execute("update config set topicnum=topicnum+1,bbsnum=bbsnum+1,todayNum="&alltodays()&"")
  		if err.number<>0 then
	       	err.clear
			ErrMsg=ErrMsg+"<Br>"+"<li>数据库操作失败，请以后再试"&err.Description 
  	       	call Error()
		else
			response.write "<meta http-equiv=refresh content=""3;URL=dispbbs.asp?boardid="&boardid&"&rootid="&announceid&"&id="&announceid&"&star="&request("star")&""">"
	    	'response.redirect("list.asp?boardid="&boardid&"&skin="&skin&"")
    	end if
	end sub
	
	'今日帖子
	function boardtoday(boardid)
    	tmprs=conn.execute("Select count(announceid) from bbs1 Where year(dateandtime)=year(now()) and month(dateandtime)=month(now()) and day(dateandtime)=day(now()) and boardid="&boardid)
    	boardtoday=tmprs(0)
	set tmprs=nothing 
	if isnull(boardtoday) then boardtoday=0
	end function 
	function alltodays()
    	tmprs=conn.execute("Select count(announceid) from bbs1 Where year(dateandtime)=year(now()) and month(dateandtime)=month(now()) and day(dateandtime)=day(now())")
    	alltodays=tmprs(0)
	set tmprs=nothing
	if isnull(alltodays) then alltodays=0
	end function

	sub savevote()
		set vrs=server.createobject("adodb.recordset")
		sql="select * from vote"
		vrs.open sql,conn,1,3
		vrs.addnew
		vrs("announceid")=announceid
		vrs("vote")=vote
		vrs("votenum")=votenum
		vrs("votetype")=votetype
		vrs("voteuser")=username
		vrs.update
		vrs.close
		set vrs=nothing
  		if err.number<>0 then
	       		err.clear
			ErrMsg=ErrMsg+"<Br>"+"<li>数据库操作失败，请以后再试"&err.Description 
  	       		call Error()
		else
			call success()
    	end if
	end sub

	'更新用户在线资料
	sub activeuser()
	dim rsactiveusers,activeuser
	dim membername
	dim memberword
	dim memberclass
	membername=request.cookies("xdgctx")("username")
	memberword=request.cookies("xdgctx")("password")
	memberclass=request.cookies("xdgctx")("userclass")
	set rsactiveusers=server.createobject("adodb.recordset")
	activeuser="select * from online where username='"&membername&"'"
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
	conn.execute(activeuser)
	end if
	if session("userid")<>"" then
	activeuser="delete from online where id="&cstr(session("userid"))
	Conn.Execute activeuser
	end if
	rsactiveusers.close
	set rsactiveusers=nothing
	end sub

	rem ------获得asp文件参数------
	sub getInput()
	if request("boardid")="" then
		foundError=true
		Errmsg=Errmsg+"<br>"+"<li>请指定论坛版面。"
	elseif not isInteger(request("boardid")) then
		foundError=true
		Errmsg=Errmsg+"<br>"+"<li>非法的版面参数。"
	else
		boardID=request("boardID")
	end if
	IP=Request.ServerVariables("REMOTE_ADDR") 
	Expression=Checkstr(Request.Form("Expression")&".gif")
   	Topic=Checkstr(trim(request("subject")))
   	Body=Checkstr(trim(request(session("antry"))))
   	UserName=Checkstr(trim(request("username")))
   	boardtype=Checkstr(trim(request("boardtype")))
	signflag=Checkstr(trim(request("signflag")))
	mailflag=Checkstr(trim(request("emailflag")))
   	UserPassWord=Checkstr(trim(request("passwd")))
	votetype=Checkstr(request("votetype"))
	vote=Checkstr(trim(request("vote")))
	end sub

	rem -----检查user输入数据的合法性------	
	function chkData()
	if signflag="yes" then
		signflag=1
	else
		signflag=0
	end if
	if mailflag="yes" then
		mailflag=1
	else
		mailflag=0
	end if

	if UserName="" or strLength(UserName)>20 then
   		ErrMsg=ErrMsg+"<Br>"+"<li>请输入姓名(长度不能大于20)"
   		foundError=True
	elseif Trim(UserPassWord)="" or strLength(UserPassWord)>10 then
   		ErrMsg=ErrMsg+"<Br>"+"<li>请输入密码(长度不能大于10)"
   		foundError=True
	end if
	if Topic="" then
   		FoundError=True
   		if Len(ErrMsg)=0 then
      			ErrMsg=ErrMsg+"<Br>"+"<li>主题不应为空，禁止重复提交"
   		else
      			ErrMsg=ErrMsg+"<Br>"+"<li>主题不应为空，禁止重复提交"
   		end if
	elseif strLength(topic)>100 then
   		FoundError=True
   		if strLength(ErrMsg)=0 then
      			ErrMsg=ErrMsg+"<Br>"+"<li>主题长度不能超过100"
   		else
      			ErrMsg=ErrMsg+"<Br>"+"<li>主题长度不能超过100"
   		end if
			end if
	if strLength(body)>AnnounceMaxBytes then
   		ErrMsg=ErrMsg+"<Br>"+"<li>发言内容不得大于" & CSTR(AnnounceMaxBytes) & "bytes"
   		foundError=true
	end if
    	if body="" then
		ErrMsg=ErrMsg+"<Br>"+"<li>没有填写内容或重复提交"
   		foundError=true
      	end if
	session("antry")=""
	if vote="" then
		ErrMsg=ErrMsg+"<Br>"+"<li>请输入投票内容"
   		foundError=true
	else
		vote=split(vote,chr(13)&chr(10))
		for i = 0 to ubound(vote)
			vote_1=""&vote_1&""&vote(i)&"|"
			if i>8 then exit for
		next
		for j = 1 to i
			votenum=""&votenum&"0|"
		next
		votelen=len(vote_1)
		votenumlen=len(votenum)
		votenum=left(votenum,votenumlen-1)
		vote=left(vote_1,votelen-1)
	end if
	if err.number<>0 then err.clear
	end function

	sub success()
	response.write "<br><table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor="&atablebackcolor&" align=center>"&_
		"<tr><td><table cellpadding=3 cellspacing=1 border=0 width=""100%"">"&_
		"<tr align=center><td width=""100%"" bgcolor="&atabletitlecolor&">操作成功</td>"&_
		"</tr><tr><td width=""100%"" bgcolor="&tablebodycolor&">"&_
		"<FONT COLOR="&TableFontcolor&">本页面将在3秒后自动返回您所发表的帖子页面，<b>您可以选择以下操作：</b><br><br>"&_
		"<li><a href=index.asp>返回论坛首页</a>"&_
		"<li><a href=list.asp?boardid="&boardid&">"&boardtype&"</a>"&_
		"<li><a href=dispbbs.asp?boardid="&boardid&"&rootid="&announceid&"&id="&announceid&"&star="&request("star")&">发表的帖子</a>"&_
		"</td></tr></table></td></tr></table>"
	end sub
	Function Checkstr(str)
	str=replace(str,"'","''")
	Checkstr=str
	End Function
%>

</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>