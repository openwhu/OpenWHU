<!--#include file="conn.asp"-->
<!--#include file="inc/char.asp" -->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/grade.asp"-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title><%=ForumName%>--查询结果</title>
<link rel="stylesheet" type="text/css" href="forum.css">
</head>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0">
<br>
<%
	'on error resume next
	dim timelimited
	dim bid
	dim topic
	dim strcompare
	dim rs,sql
	dim itype
	dim announceid
	dim currentpage
	dim searchname
	dim totalrec
	dim guestlist
	dim grade18,grade19,grade20
	grade18=grade(18)
	grade19=grade(19)
	grade20=grade(20)
	itype=request("type")
	strCompare=request("selCompare")
	topic=trim(request("txtTopic"))
	announceid=trim(request("aid"))
	if isempty(request("page")) or isNull(request("page")) or (request("page")="")  then
		currentPage=1
	else
		if isInteger(request("page")) then
			currentPage=cint(request("page"))
        	else
			currentPage=1
        	end if
        	if err.number<>0 then 
			err.clear
            		currentPage=1
        	end if
	end if
	if memberclass = grade18 or memberclass = grade19 or memberclass = grade20 then
		guestlist=""
	else
		guestlist=" board.lockboard<>2 and "
	end if
	if request("selBoard")<>"" then bID=request("selBoard")
	
	if bID<>"" then
		call chkIntRequest()
	end if

	sub chkIntRequest()
	MaxAnnouncePerPage=20
		if not isInteger(bid)  then
			Response.Write "版面ID必须是整数"
			call endConnection()
			Response.End 
		end if
	end sub
	set rs=server.createobject("adodb.recordset")
	select case itype
	case 1
	if request("txtTopic")<>"" then sql="select bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where (" & translate(topic,"topic") & ") and "&guestlist&" bbs1.boardID="&cstr(bid)&" and bbs1.boardid=board.boardid ORDER BY bbs1.announceID desc"
	searchname="按主题查询"
	case 2
	if request("txtuser")<>"" then sql="select bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where bbs1.username like '%"&trim(request("txtuser"))&"%' and "&guestlist&" bbs1.boardID="&cstr(bid)&" and bbs1.boardid=board.boardid ORDER BY bbs1.announceID desc"
	searchname="按用户名查询"
	case 3
	if request("txtCon")<>"" then sql="select bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where bbs1.body like '%"&trim(request("txtCon"))&"%' and "&guestlist&" bbs1.boardID="&cstr(bid)&" and bbs1.boardid=board.boardid ORDER BY bbs1.announceID desc"
	searchname="按内容查询"
	case 4
	if request("aid")<>"" then sql="select bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where bbs1.announceID "&request("selCompare")&cstr(request("aid"))&" and "&guestlist&" bbs1.boardID="&cstr(bid)&" and bbs1.boardid=board.boardid ORDER BY bbs1.announceID desc"
	searchname="按贴子ID查询"
	case 5
					dim tl
					tl=1
					timeLimited=request("selTimeLimit")
					if timeLimited="一天" then tl=1
					if timeLimited="一周" then tl=7
					if timeLimited="一月" then tl=30
					if timeLimited="一年" then tl=365
	sql="select bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where dateandtime>=#"&cstr(cdate(now()-tl))&"# and "&guestlist&" bbs1.boardid="&cstr(bid)&" and bbs1.boardid=board.boardid order by bbs1.announceid desc"
	searchname="按日期查询"
	case 6
		select case cstr(strcompare)
			case "1"
		sql="select top 10 bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where "&guestlist&" bbs1.boardid=board.boardid order by bbs1.hits desc"
		searchname="按点击查询"
			case "2"
		sql="select top 50 bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where "&guestlist&" bbs1.boardid=board.boardid order by bbs1.announceid desc"
		searchname="最新贴子查询"
		end select
	case 7
	if request("name")<>"" then sql="select bbs1.locktopic,bbs1.boardid,bbs1.rootid,bbs1.announceid,bbs1.body,bbs1.Expression,bbs1.topic,bbs1.username,bbs1.child,bbs1.hits,bbs1.dateandtime,board.lockboard from bbs1,board where bbs1.username like '%"&trim(request("name"))&"%' and "&guestlist&" bbs1.boardid=board.boardid ORDER BY bbs1.announceID desc"
	searchname="用户发表文章查询"
	end select
	if sql="" then
		Errmsg=Errmsg+"<br>"+"<li>请指定查询条件。"
		call error()
		response.end
	end if
%>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;<a href=query.asp>论坛搜索</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;<%=searchname%>
      </TD></TR></TBODY></TABLE> 
<br>
<%
	rs.open sql,conn,1,1

	if err.number<>0 then 
		Errmsg=Errmsg+"<br>"+"<li>数据库出错，查询失败。"
		call error()
		err.clear
	else
		if rs.eof and rs.bof then
		Errmsg=Errmsg+"<br>"+"<li>没有找到您要查询的内容。"
		call error()
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
            			call searchinfo()
       			else 
          			if (currentPage-1)*MaxAnnouncePerPage<totalrec then 
            				rs.move  (currentPage-1)*MaxAnnouncePerPage 
            				call searchinfo()
        			else 
	        			currentPage=1 
           				call searchinfo()
	      			end if 
	   		end if 
			call listPages3()
		end if
	end if
	set rs=nothing
	call endConnection()

	sub searchinfo()
%>
            <table cellpadding=0 cellspacing=0 border=0 width=95% align=center>
            <tr><td>共查询到<font color=<%=AlertFontColor%>><%=totalrec%></font>个结果
		</td>
            </tr>
            </table>
            <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=Tablebackcolor%> align=center>
            <tr><td height=1>
		</td>
            </tr>
            </table>
<TABLE bgColor="<%=Tablebackcolor%>" border=0 cellPadding=0 cellSpacing=0 width="95%" align=center>
  <TBODY>
  <TR>
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle height=25 bgColor="<%=Tabletitlecolor%>" width=32><font color=<%=TableFontcolor%>>状态</font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=*><font color=<%=TableFontcolor%>>主 题  (点心情符为开新窗浏览)</font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=80><font color=<%=TableFontcolor%>>作 者 </font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=64><font color=<%=TableFontcolor%>>回复/人气</font></TD>
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td> 
    <TD align=middle bgColor="<%=Tabletitlecolor%>" width=195><font color=<%=TableFontcolor%>>作者 | 发表时间</font></TD>
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
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1 height=24></td>
    <TD align=middle bgColor="<%=Tablebodycolor%>" width=32><font color=<%=TableContentcolor%>>
<%if rs("locktopic")=1 then%><img src=<%=picurl%>lockfolder.gif alt="本主题已锁定"><%else%><%if rs("child")>=10 then%><img src=<%=picurl%>hotfolder.gif><%else%><img src=<%=picurl%>folder.gif><%end if%><%end if%></font>
    </TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD bgColor=<%=Tablebodycolor%> width=*><font color=<%=TableContentcolor%>><a href='dispbbs.asp?boardID=<%=rs("boardID")%>&RootID=<%=rs("RootID")%>&ID=<%=rs("announceID")%>' target=_blank><img src='images/<%if instr(rs("Expression"),"face")>0 then%><%=rs("Expression")%><%else%>face1.gif<%end if%>' border=0 alt="开新窗口浏览此主题"></a> <a href='dispbbs.asp?boardID=<%=rs("boardID")%>&RootID=<%=rs("RootID")%>&ID=<%=rs("announceID")%>'><%if rs("topic")="" then%><%=left(htmlencode(rs("body")),26)%>...<%else%><%=htmlencode(rs("topic"))%><%end if%></a></font>    </TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tablebodycolor%>"  width=80><font color=<%=TableContentcolor%>><a href=javascript:openScript('dispuser.asp?name=<%=htmlencode(rs("username"))%>',350,300)><%=htmlencode(rs("username"))%></a></font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD align=middle bgColor="<%=Tablebodycolor%>" width=64><font color=<%=TableContentcolor%>><%=rs("child")%>/<%=rs("hits")%></font></TD> 
    <td bgcolor=<%=Tablebackcolor%> valign=middle width=1></td>
    <TD bgColor=<%=Tablebodycolor%> width=195><font color=<%=TableContentcolor%>>  <IMG border=0 src="<%=picurl%>lastpost.gif">
<%=FormatDateTime(rs("dateandtime"),2)%>&nbsp;<%=FormatDateTime(rs("dateandtime"),4)%>
&nbsp;<font color=#990000>|</font>&nbsp;
<a href=javascript:openScript('dispuser.asp?name=<%=htmlencode(rs("username"))%>',350,300)><%=htmlencode(rs("username"))%></a>
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
   <script language="Javascript">
	function viewPage(ipage){
        document.frmList2.Page.value=ipage
        document.frmList2.submit() 
	}
		
   </script>
<table border="0" cellpadding="0" cellspacing="3" width="95%" align="center">
<form method="post" action="queryresult.asp" name="frmList2">
<input type=hidden name=type value="<%=itype%>">
<input type=hidden name=txtTopic value="<%=request("txtTopic")%>">
<input type=hidden name=selBoard value="<%=bID%>">
<input type=hidden name=txtUser value="<%=request("txtuser")%>">
<input type="hidden" name="txtCon" value="<%=request("txtCon")%>">
<input type=hidden name=selCompare value="<%=strCompare%>">
<input type="hidden" name="aID" value="<%=announceid%>">
<input type="hidden" name="name" value="<%=request("name")%>">
<input type=hidden name="selTimeLimit" value="<%=request("selTimeLimit")%>">
  <tr>
    <td valign="middle" nowrap><span class="smallFont">页次：<strong><%=currentPage%></strong>/<strong><%=n%></strong>页 每页<strong><%=MaxAnnouncePerPage%></strong> 总贴数<strong><%=totalrec%></strong></td>
    <td valign="middle" nowrap>
      <div align="right"><p>分页：
<%
	   for p=1 to n
	   if p<10 then
	       if p=currentPage then
	          response.write "["+Cstr(p)+"] "
		   else
		      response.write "<a href='javascript:viewPage("+Cstr(p)+")' language='javascript'>["+Cstr(p)+"]</a>   "
		   end if
		end if
	next
%>
<span class="smallFont">转到:<input type="text" name="Page" size=3 maxlength=10  value="<%=currentpage%>"><input type="button" value="Go" language="javascript" onclick="viewPage(document.frmList2.Page.value)" id="button1" name="button1"></span></p>      
      </div>    
    </td>
  </tr>
<input type="hidden" name="BoardID" value="<%=BoardID%>">
</form>
</table>

<%		if err.number<>0 then err.clear
	end sub 
%>

<html><script language="JavaScript">                                                                  </script></html>