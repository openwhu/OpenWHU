<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/email.asp" -->
<!--#include file="inc/grade.asp"-->
<HTML><HEAD><TITLE><%=ForumName%>--发送页面</TITLE>
<META content="text/html; charset=gb2312" http-equiv=Content-Type>
<link rel="stylesheet" type="text/css" href="forum.css">
<META content="Microsoft FrontPage 4.0" name=GENERATOR></HEAD>
<!-- #include file="inc/theme.asp" -->
<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="pic/closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="pic/bar.gif" border=0 width=15 height=15><img src="pic/openfold.gif" border=0>&nbsp;&nbsp;发送贴子</a>
      </TD></TR></TBODY></TABLE> 
<br>
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
	dim content
	dim postname
	dim incepts
	dim announce
    	foundErr = false
    	ErrMsg = ""
    	Rem ------获取参数(get or post的)------
    	Rem ------包括版面的ID和页次------
    	Call getInput()
    	call chkInput()

   	set rs=server.createobject("adodb.recordset")
    	if foundErr then
		call ErrMsg()
	else
		call showPage()
	end if

	sub showPage()
		'on error resume next
		if foundErr then
			call ErrMsg()
		else
			if request("action")="sendmail" then
				if IsValidEmail(trim(Request.Form("mail")))=false then
   					errmsg=errmsg+"<br>"+"<li>您的Email有错误。</li>"
   					founderr=true
				else
					email=trim(Request.Form("mail"))
				end if
				if request("postname")="" then
   					errmsg=errmsg+"<br>"+"<li>请输入您的姓名。</li>"
   					founderr=true
				else
					postname=request("postname")
				end if
				if request("incept")="" then
   					errmsg=errmsg+"<br>"+"<li>请输入收件人姓名。</li>"
   					founderr=true
				else
					incepts=request("incept")
				end if
				if request("content")="" then
   					errmsg=errmsg+"<br>"+"<li>邮件内容不能为空。</li>"
   					founderr=true
				else
					content=request("content")
				end if
				if founderr then
					call error()
				else
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
'		topic=rs("topic")
		topic="您的朋友"&postname&"给您发来了一个"&ForumName&"上的贴子"
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
	mailbody=mailbody &"<TABLE border=0 width='95%' align=center><TBODY><TR><TD>"
	mailbody=mailbody &""&incepts&"，您好：<br><br>"
	mailbody=mailbody &"您的朋友"&postname&"给您发来了一个"&ForumName&"--"&boardtype&"上的贴子<BR><br>"
	mailbody=mailbody &"标题是："&htmlencode(topic)&"<br><br>"
	mailbody=mailbody &""&htmlencode(content)&"<br><br>"
	mailbody=mailbody &"您可以到<a href=http://127.0.0.1/club/showannounce.asp?boardid="&boardid&"&rootid="&rootid&"&id="&Announceid&">"&topic&"</a>这里浏览这个贴子<br>"
	mailbody=mailbody &"<p align=center>"&ads2&"<br>"
	mailbody=mailbody &""&Copyright&"&nbsp;&nbsp;"&Version&""
	mailbody=mailbody &"</TD></TR></TBODY></TABLE>"
'	response.write mailbody
'	mailbody=""
	end sub

	sub pag()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
    <tr>
        <td>
        <table cellpadding=6 cellspacing=1 border=0 width=100%>
        
    <form action="sendpage.asp?action=sendmail&boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>" method=post>
    <tr>
    <td bgcolor=<%=atabletitlecolor%> valign=middle colspan=2 align=center>
    <b>发送邮件给朋友</b></td></tr>
    <tr>
    <td bgcolor=<%=tablebodycolor%> valign=middle colspan=2>
    <b>通过邮件发送本贴子给您的朋友。</b>　下列所有项必填，并请输入正确的邮件地址！
    <br>你可以添加一些自己的信息在下面的内容框内。至于这个贴子的主题和 URL 你可以不必写，因为本程序会在发送的 Email 中自动添加的！
        </td></tr>
    <tr>
    <td bgcolor=<%=tablebodycolor%>><b>您的姓名：</b></td>
    <td bgcolor=<%=tablebodycolor%>><input type=text size=40 name="postname"></td>
    </tr><tr>
    <td bgcolor=<%=tablebodycolor%>><b>您朋友的名字：</b></td>
    <td bgcolor=<%=tablebodycolor%>><input type=text size=40 name="incept"></td>
    </tr><tr>
    <td bgcolor=<%=tablebodycolor%>><b>您朋友的 Email：</b></td>
    <td bgcolor=<%=tablebodycolor%>><input type=text size=40 name="mail"></td>
    </tr><tr>
    <td bgcolor=<%=tablebodycolor%>><b>消息内容：</b></td>
    <td bgcolor=<%=tablebodycolor%>><textarea name="content" cols="55" rows="6">我想你对 '<%=ForumName%>' 的这个贴子内容会感兴趣的！请去看看！</textarea></td>
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
    <table cellpadding=0 cellspacing=0 border=0 width="95%" bgcolor=<%=atablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=atabletitlecolor%>>成功：发送页面</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=tablebodycolor%>>恭喜您，您的页面发送成功。
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

<html><script language="JavaScript">                                                                  </script></html>