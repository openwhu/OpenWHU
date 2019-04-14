<%@ LANGUAGE="VBSCRIPT" %>
<!-- #include file="conn.asp" -->
<!-- #include file="inc/char.asp" -->
<!--#include file="inc/stats.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/code.asp"-->
<!--#include file="inc/grade.asp"-->
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 4.0">
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=gb2312">
<title><%=ForumName%>--我要发言</title>
<link rel="stylesheet" type="text/css" href="forum.css">
<script language="javascript">
function popwin3(path)
{		window.open(path,"","height=300,width=450,resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no");
}
</script>
</head>
<script language="JavaScript" src="inc/coolbuttons.js"></script>
<!--#include file="inc/theme.asp"-->
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0" onkeydown='if(event.keyCode==13 && event.ctrlKey)frmAnnounce.submit()'>
<br>
<%
	rem ----------------------
	rem ------主程序开始------
	rem ----------------------

	dim boardID
   	dim rs,sql
	dim boardtype
	dim tableback
	dim tabletitle
	dim tablebody
	dim atablebody
	dim tablefont
	dim tablecontent
	dim alertfont
	dim strAllowForumCode
	dim strAllowHTML
	dim strIMGInPosts
	dim strIcons
	dim strflash
	dim Forumlogo
   	boardid=0
   	if not (isNUll(request("boardid")) or isEmpty(request("boardid")) or (request("BoardID")="") ) then
      		boardid=request("boardid")
   	end if

   	set rs=server.createobject("adodb.recordset")
	if boardID>0 then
		set rs=conn.execute("select boardtype,Tableback,Tabletitle,Tablebody,aTablebody,TableFont,TableContent,AlertFont,strAllowForumCode,strAllowHTML,strIMGInPosts,strIcons,strflash,Forumlogo from board where boardid="&cstr(boardid))
		if err then 
			Errmsg=ErrMsg+"<Br>"+"<li>数据库操作发生错误！"
			FoundError=true
		else
			if not (rs.eof and rs.bof) then 
   			boardtype=rs("boardtype")
			Tableback=trim(rs("Tableback"))
			Tabletitle=trim(rs("Tabletitle"))
			Tablebody=trim(rs("Tablebody"))
			aTablebody=trim(rs("aTablebody"))
			TableFont=trim(rs("TableFont"))
			TableContent=trim(rs("TableContent"))
			AlertFont=trim(rs("AlertFont"))
			strAllowForumCode=rs("strAllowForumCode")
			strAllowHTML=rs("strAllowHTML")
			strIMGInPosts=rs("strIMGInPosts")
			strIcons=rs("strIcons")
			strflash=rs("strflash")
			Forumlogo=rs("Forumlogo")
%>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="list.asp?boardid=<%=boardid%>&skin=<%=request("skin")%>"><%=boardtype%></a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;发表新贴子
      </TD></TR></TBODY></TABLE> 
<br>
				<!--#include file="inc/Form.asp"-->
<%
				call showForm()
			else
				if err.number<>0 then
					Errmsg=ErrMsg+"<Br>"+"<li>数据库操作发生错误！"
					FoundError=true
					err.clear
				else
					Errmsg=ErrMsg+"<Br>"+"<li>不存在的版面！"
					FoundError=true
				end if
			end if          
			rs.close
		end if
		set rs=nothing
	else
		Errmsg=ErrMsg+"<Br>"+"<li>未指定所需参数！"
		FoundError=true
	end if
	call endConnection()
	if founderror=true then
		call error()
	end if

   	rem ----------------------
	rem ------主程序结束------
	rem ----------------------

%>


</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>