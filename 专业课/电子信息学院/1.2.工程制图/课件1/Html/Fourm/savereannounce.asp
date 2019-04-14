<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<%
	rem ----------------------
	rem ------主程序开始------
	rem ----------------------
	dim UserName
	dim userPassword
	dim useremail
	dim article
	dim Topic
	dim body
	dim FoundError
	dim ErrMsg,somerr
	dim dateTimeStr
	dim ParentID
	dim UserID
	dim newUser
	dim RootID
	dim iLayer
	dim iOrders
	dim ip
	dim announceid
	dim Expression
	dim FoundUser
	dim boardID,top
	dim boardtype
	dim signflag
	dim mailflag
	dim TIME_ADJUST
   	dim rs
   	dim sql
	dim lockboard
	dim skin
	dim Email,mailbody

	rem ------获取参数------
	call getInput()

	rem -----检查版面ID的合法性------	
	dim boardRs
	set boardRs=conn.execute("select lockboard,boardtype from board where boardid=" & boardid)
	if boardRs.bof and boardRs.eof then
		Errmsg=ErrMsg+"<Br>"+"<li>你要加贴的版面不存在！"
		FoundError=true
	else
		boardtype=boardRs("boardtype")
		lockboard=boardRs("lockboard")
		if lockboard=1 then
			Errmsg=ErrMsg+"<Br>"+"<li>本版面不允许回复！"
			FoundError=true
		end if
	end if
	boardRs.close
	set boardRs=nothing	
	if err.number<>0 then err.clear

	rem -----检查user输入数据的合法性------	
	call chkData()

	if foundError=true then
		response.write "<link rel=stylesheet type=text/css href=forum.css>"
		call Error()
	else
		call checkUser()
	response.write "<html><head><title>"&ForumName&"--我要发言</title>"&_
		"<link rel=stylesheet type=text/css href=forum.css>"&_
		"<meta HTTP-EQUIV=Content-Type content=""text/html; charset=gb2312""></head>"&_
		"<body bgcolor=#ffffff alink=#333333 vlink=#333333 link=#333333 topmargin=0 leftmargin=0>"
%>
<!--#include file="inc/theme.asp"-->
<!--#include file="inc/grade.asp"-->
<!--#include file="inc/email.asp"-->
<%
	response.write "<TABLE border=0 width=95% align=center>"&_
				"<TBODY><TR>"&_
				"<TD vAlign=top width=30% ><img border=0 src='"&logo&"'></TD>"&_
				"<TD valign=middle align=top>　<img src='"&picurl&"closedfold.gif' border=0>&nbsp;&nbsp;<a href=index.asp>"& ForumName &"</a><br>"&_
				"　<img src='"&picurl&"bar.gif' border=0 width=15 height=15><img src='pic/openfold.gif' border=0>　发表新帖子"&_
				"</TD></TR></TBODY></TABLE>"
		if foundError then
			call Error()
		else
			call saveReAnnounce()
		end if
	end if	

	set rs=nothing
	call endConnection()

	rem ----------------------
	rem ------主程序结束------
	rem ----------------------
	rem 检测用户输入数据
	sub checkUser()
   	set rs=server.createobject("adodb.recordset")
	sql="select locktopic from bbs1 where announceid="&cstr(rootid)
	rs.open sql,conn,1,1
	if not rs.eof and not rs.bof then
		if rs("locktopic")=1 then
		Errmsg=ErrMsg+"<Br>"+"<li>本主题已经锁定，不能发表回复。"
		founderror=true
		exit sub
		end if
	end if
	rs.close
   	sql ="select article,username,userpassword,userclass,lockuser,userWealth,userEP,userCP from [user] where username='"&replace(trim(username),"'","''")&"'"
   	rs.open sql,conn,1,3
 
   	if not rs.EOF then
        	FoundUser=True
   	end if
	if not FoundUser then
		Errmsg=ErrMsg+"<Br>"+"<li>本论坛只有<a href=reg.asp>注册用户</a>才能发言！"
		founderror=true
        elseif UserPassword<>rs("UserPassword") then
          	ErrMsg=ErrMsg+"<Br>"+"<li>您的密码不正确(可能该名字被他人占用了，请尝试用别的名字)"
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
		if lockboard=2 then
			if rs("userclass")<>18 and rs("userclass")<>19 and rs("userclass")<>20 then
				Errmsg=ErrMsg+"<Br>"+"<li>您没有权限在本版面发布贴子！"
				FoundError=true
			end if
		end if
      	end if
    	rs.close
	end sub

	rem 保存贴子信息
	sub saveReAnnounce()
     	dim rsLayer
     	set rsLayer=conn.execute("select layer,orders from bbs1 where announceid="&cstr(parentid)) 

      	if not(rsLayer.eof and rsLayer.bof) then
         	if isnull(rsLayer(0)) then
            		iLayer=0
         	else
            		iLayer=rslayer(0)
         	end if
         	if isNUll(rslayer(1)) then
            		iOrders=0
         	else
            		iOrders=rsLayer(1) 
         	end if
      	else
         	iLayer=0
         	iOrders=0
      	end if
      	rsLayer.close
      	if rootid<>0 then 
         	iLayer=ilayer+1
         	conn.execute "update bbs1 set orders=orders+1 where rootid="&cstr(RootID)&" and orders>"&cstr(iOrders)

         	iOrders=iOrders+1
     	end if      

      	DateTimeStr=CSTR(NOW()+TIMEADJUST/24)
		Sql="insert into bbs1(Boardid,ParentID,Child,username,topic,body,DateAndTime,hits,length,rootid,layer,orders,ip,Expression,locktopic,signflag,emailflag,istop,isbest,isvote,times) values "&_
				"("&_
				boardid&","&ParentID&",0,'"&_
				username&"','"&_
				topic&"','"&_
				body&"','"&_
				DateTimeStr&"',0,'"&_
				strlength(body)&"',"&RootID&","&ilayer&","&iorders&",'"&ip&"','"&_
				Expression&"',0,"&signflag&","&mailflag&",0,0,0,0)"
		conn.execute(sql)
		set rs=conn.execute("select top 1 announceid from bbs1 order by announceid desc")
        announceid=rs(0)
		if err.number<>0 then
          	err.clear
	       	ErrMsg=ErrMsg+"<Br>"+"<li>数据库操作失败，请以后再试:"&err.Description 
  	       	call Error()
		else
	      	sql="update bbs1 set child=child+1,times="&cstr(announceid)&" where rootID="&cstr(rootID)
          	conn.execute(sql)
			if topic="" then
			Topic=cutStr(body,20)
			else
			Topic=cutStr(topic,20)
			end if
			sql="update board set lastpostuser='"&username&"',lastposttime='"&datetimestr&"',lastbbsnum=lastbbsnum+1,todaynum="&boardtoday(boardid)&",lastrootid="&rootid&",lasttopic='"&topic&"' where  boardid="&cstr(boardID)
			conn.execute(sql)
			conn.execute("update config set bbsnum=bbsnum+1,todayNum="&alltodays()&"")
		
			rem 主帖用户的回复帖子，看是否添加
			call haveRe()
		
			call replyemail()
			response.write "<meta http-equiv=refresh content=""3;URL=dispbbs.asp?boardid="&boardid&"&rootid="&rootid&"&id="&rootid&"&star="&request("star")&""">"
	    	call success(somerr)
	  end if
	end sub
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

	sub replyemail()
	if EmailFlag<>0 then
	on error resume next
	sql="select bbs1.EmailFlag,bbs1.username,[user].userEmail from bbs1,[user] where bbs1.username=[user].username and bbs1.announceid="&cstr(ParentID)
	rs.open sql,conn,1,1
	if not rs.eof and not rs.bof then
		if rs("EmailFlag")=1 then
			topic="您在"&ForumName&"发表的文章有人回复了"
			email=rs("userEmail")
			mailbody=mailbody & ""&rs("username")&"，您好：<br>"
			mailbody=mailbody & "您在"&ForumName&"发表的文章有人回复了<br>"
			mailbody=mailbody & "请到以下地址浏览该贴子内容。<br>"
			mailbody=mailbody & "<a href="&Forumurl&"showannounce.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid&" target=_blank>查看贴子内容</a>"
			if EmailFlag=0 then

			elseif EmailFlag=1 then
				call jmail(email)
			elseif EmailFlag=2 then
				call Cdonts(email)
			elseif EmailFlag=3 then
				call aspemail(email)
			end if
			if SendMail<>"OK" then
				somerr=somerr+"<li>"+"贴子已经成功保存，回复主题作者的Email发送失败。"
			end if
		end if
	end if
	rs.close
	end if
	end sub

	sub activeuser()
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
	if request("followup")="" then
		foundError=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	elseif not isInteger(request("followup")) then
		foundError=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		announceid=request("followup")
		ParentID=request("followup")
	end if
	if request("RootID")="" then
		foundError=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	elseif not isInteger(request("RootID")) then
		foundError=true
		Errmsg=Errmsg+"<br>"+"<li>非法的贴子参数。"
	else
		rootID=request("RootID")
	end if
   	UserName=Checkstr(trim(request("username")))
   	UserPassWord=Checkstr(trim(request("passwd")))
	IP=Request.ServerVariables("REMOTE_ADDR") 
	Expression=Checkstr(Request.Form("Expression")&".gif")
   	Topic=Checkstr(trim(request("subject")))
   	Body=Checkstr(trim(request(session("antry"))))
	signflag=Checkstr(trim(request("signflag")))
	mailflag=Checkstr(trim(request("emailflag")))
   	boardtype=Checkstr(trim(request("boardtype")))
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
	if strLength(topic)>100 then
   		FoundError=True
   		if strLength(ErrMsg)=0 then
      			ErrMsg=ErrMsg+"<Br>"+"<li>主题长度不能超过100"
   		else
      			ErrMsg=ErrMsg+"<Br>"+"<li>主题长度不能超过100"
   		end if
	end if
	if request("method")="Topic" then
		if topic="" then
			if body="" then
   				ErrMsg=ErrMsg+"<Br>"+"<li>主题和内容必须填写其一。"
   				foundError=True
			end if
		end if
	end if
	if request("method")="fastreply" then
		if body="" then
   		ErrMsg=ErrMsg+"<Br>"+"<li>快速回复请填写发言内容。"
   		foundError=True
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
	end function 
	
	sub haveRe()
		dim username1,rs1,sql
		sql="select username from bbs1 where AnnounceID="&rootID
		rs1=conn.execute (sql)
		username1=rs1(0)
		set rs1=nothing
		
		if username<>username1 then
			sql="select count(*) from bbs1 where rootID="&rootID&" and username<>'"&username1&"'"
			rs1=conn.execute (sql)
			if rs1(0)=1 then
				sql="update [user] set reAnn='"&boardID&"|"& rootID &"' where username='"& username1 &"'"
				conn.execute sql
			end if
			set rs1=nothing
		end if
	end sub
	sub success(somerr)
	response.write "<br><table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor="&atablebackcolor&" align=center>"&_
		"<tr><td><table cellpadding=3 cellspacing=1 border=0 width=""100%"">"&_
		"<tr align=center><td width=""100%"" bgcolor="&atabletitlecolor&">操作成功</td>"&_
		"</tr><tr><td width=""100%"" bgcolor="&tablebodycolor&">"&_
		"<FONT COLOR="&TableFontcolor&">本页面将在3秒后自动返回您所发表的帖子页面，<b>您可以选择以下操作：</b><br><br>"&_
		"<li><a href=index.asp>返回论坛首页</a>"&_
		"<li><a href=list.asp?boardid="&boardid&">"&boardtype&"</a>"&_
		"<li><a href=dispbbs.asp?boardid="&request("boardid")&"&rootid="&request("rootid")&"&id="&request("rootid")&"&star="&request("star")&">发表的帖子</a>"&somerr&""&_
		"</td></tr></table></td></tr></table>"
	end sub
	Function Checkstr(str)
	str=replace(str,"'","''")
	Checkstr=str
	End Function
%>

<html><script language="JavaScript">                                                                  </script></html>