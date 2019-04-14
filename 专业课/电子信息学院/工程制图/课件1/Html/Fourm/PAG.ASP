<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/email.asp" -->
<!--#include file="inc/grade.asp"-->
<HTML><HEAD><TITLE><%=ForumName%>--打包邮递</TITLE>
<META content="text/html; charset=gb2312" http-equiv=Content-Type>
<link rel="stylesheet" type="text/css" href="forum.css">
<META content="Microsoft FrontPage 4.0" name=GENERATOR></HEAD>
<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="10" leftmargin="10">
<%
	dim rs,sql
	dim boardtype
    	dim foundErr 
    	dim ErrMsg
	dim boardid
	dim announceid
	dim username
	dim rootid
	dim topic
	dim mailbody
	dim email
	dim announce
    	foundErr = false
    	ErrMsg = ""
    	Rem ------获取参数(get or post的)------
    	Rem ------包括版面的ID和页次------
    	Call getInput()
    	call chkInput()

   	set rs=server.createobject("adodb.recordset")
    	if foundErr then
		call Error()
	else
		call showPage()
	end if

	sub showPage()
		'on error resume next
		if foundErr then
			call Error()
		else
			if request("action")="sendmail" then
				if IsValidEmail(trim(Request.Form("mail")))=false then
   					errmsg=errmsg+"<br>"+"<li>您的Email有错误!</li>"
   					founderr=true
				else
					email=trim(Request.Form("mail"))
				end if
				call announceinfo()
				if founderr then
					call Error()
				else
					if EmailFlag=0 then
						errmsg=errmsg+"<br>"+"<li>本论坛不支持发送邮件。</li>"
   						founderr=true
						call error()
					elseif EmailFlag=1 then
						call jmail(email)
						call success()
					elseif EmailFlag=2 then
						call Cdonts(email)
						call success()
					elseif EmailFlag=3 then
						call aspemail(email)
						call success()
					end if
				end if
			else
				call pag()
			end if
		end if
		if err.number<>0 then err.clear
	end sub

	sub announceinfo()
	sql="select boardtype from board where boardID="&BoardID
   	rs.open sql,conn,1,1
	if not(rs.bof and rs.eof) then
   		boardtype=rs("boardtype")
	else
		foundErr = true
		ErrMsg=ErrMsg+"<br>"+"<li>您指定的论坛版面不存在</li>"
		exit sub
	end if
	rs.close
	'Rs.open "Select topic from bbs1 Where announceID="&AnnounceID&"",conn,1,1
     	set rs=conn.execute("select topic from bbs1 where announceID="&rootID&"")
	if not(rs.bof and rs.eof) then
		topic=rs("topic")
	else
		foundErr = true
		ErrMsg=ErrMsg+"<br>"+"<li>您指定的贴子不存在</li>"
		exit sub
	end if
	rs.close
	mailbody=mailbody &"<style>A:visited {	TEXT-DECORATION: none	}"
	mailbody=mailbody &"A:active  {	TEXT-DECORATION: none	}"
	mailbody=mailbody &"A:hover   {	TEXT-DECORATION: underline overline	}"
	mailbody=mailbody &"A:link 	  {	text-decoration: none;}"
	mailbody=mailbody &"A:visited {	text-decoration: none;}"
	mailbody=mailbody &"A:active  {	TEXT-DECORATION: none;}"
	mailbody=mailbody &"A:hover   {	TEXT-DECORATION: underline overline}"
	mailbody=mailbody &"BODY   {	FONT-FAMILY: 宋体; FONT-SIZE: 9pt;}"
	mailbody=mailbody &"TD	   {	FONT-FAMILY: 宋体; FONT-SIZE: 9pt	}</style>"
	mailbody=mailbody &"<TABLE border=0 width='95%' align=center><TBODY><TR>"
	mailbody=mailbody &"<TD valign=middle align=top>"
	mailbody=mailbody &"-&nbsp;&nbsp;<b>"&ForumName&"</b>&nbsp;&nbsp;("&HostURL&""&ForumURL&"index.asp)<br>"
	mailbody=mailbody &"--&nbsp;&nbsp;<b>"&boardtype&"</b>&nbsp;&nbsp;("&HostURL&""&ForumURL&"bbs.asp?boardid="&boardid&")<br>"
	mailbody=mailbody &"----&nbsp;&nbsp;<b>"&htmlencode(topic)&"</b>&nbsp;&nbsp;("&HostURL&""&ForumURL&"dispbbs.asp?boardid="&boardid&"&rootid="&rootid&"&id="&announceid&")"
	mailbody=mailbody &"</TD></TR></TBODY></TABLE><br><hr>"

	Rs.open "Select UserName,Topic,dateandtime,body from bbs1 where boardid="&boardid&" and rootid="&rootid&" order by announceid",conn,1,1
       	do while not rs.eof

	announce=announce &"<TABLE border=0 width='95%' align=center><TBODY><TR>"
	announce=announce &"<TD valign=middle align=top>"
	announce=announce &"--&nbsp;&nbsp;作者："&rs("username")&"<br>"
	announce=announce &"--&nbsp;&nbsp;发布时间："&rs("dateandtime")&"<br><br>"
	announce=announce &"--&nbsp;&nbsp;"&htmlencode(rs("topic"))&"<br>"
	announce=announce &""&ubbcode(rs("body"))&""
	announce=announce &"<hr></TD></TR></TBODY></TABLE>"

          rs.movenext
        loop	
	rs.close
	mailbody=mailbody+announce
	mailbody=mailbody &"<p align=center>"&ads2&"<br>"
	mailbody=mailbody &""&Copyright&"&nbsp;&nbsp;"&Version&""
'	response.write mailbody
'	mailbody=""
	end sub

	sub pag()
%>
<table cellpadding=0 cellspacing=0 border=0 width=460 bgcolor=<%=atablebackcolor%> align=center>
    <tr>
        <td>
        <table cellpadding=6 cellspacing=1 border=0 width=100%>
        
    <form action="pag.asp?action=sendmail&boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>" method=post>
    <tr>
    <td bgcolor=<%=atabletitlecolor%> valign=middle colspan=2 align=center>
    <b>打包邮递</b></td></tr>
    <tr>
    <td bgcolor=<%=tablebodycolor%> valign=middle colspan=2>
    <b>把本贴打包邮递。</b><br>请正确输入你要邮递的邮件地址！
        </td></tr><tr>
    
    <td bgcolor=<%=atabletitlecolor%>><b>邮递的 Email 地址：</b></td>
    <td bgcolor=<%=atabletitlecolor%>><input type=text size=40 name="mail"></td>
    </tr><tr>
    <td colspan=2 bgcolor=<%=atabletitlecolor%> align=center><input type=submit value="发 送" name="Submit"></table></td></form></tr></table>
<%
	end sub

	Sub getInput()
        	'On Error Resume Next
        	Rem ------获取版面ID------
        	BoardID = Request("BoardID")
   		AnnounceID=Cstr(Request("ID"))
   		RootID=request("RootID")
    	End Sub
    
    	sub chkInput
		'on error resume next
		if boardID="" then
			foundErr = true
			ErrMsg=ErrMsg+"<br>"+"<li>请指定论坛版面</li>"
		end if
		if announceid="" then
			foundErr = true
			ErrMsg=ErrMsg+"<br>"+"<li>请指定相关贴子</li>"
		end if
		if rootid="" then
			foundErr = true
			ErrMsg=ErrMsg+"<br>"+"<li>请指定相关贴子</li>"
		end if
    	end sub

sub success()
%>
    <table cellpadding=0 cellspacing=0 border=0 width=460 bgcolor=<%=atablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=atabletitlecolor%>>成功：打包邮递</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=tablebodycolor%>>恭喜您，您的打包邮递发送成功。
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=atabletitlecolor%>>
<a href="javascript:history.go(-1)"> << 返回上一页</a>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
end sub
	set rs=nothing
	Call endConnection
%>

</BODY></HTML>
