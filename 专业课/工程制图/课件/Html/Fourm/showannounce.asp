<!--#include file="conn.asp"-->
<!-- #include file="inc/char.asp" -->
<!-- #include file="inc/const.asp" -->
<%response.cookies("xdgctx")("stats")="浏览精华帖子"%>
<!--#include file="inc/code.asp"-->
<!--#include file="inc/grade.asp"--><html>
<head> 
<meta NAME="GENERATOR" Content="Microsoft FrontPage 3.0" CHARSET="GB2312">
<title><%=ForumName%>--浏览贴子</title>
<link rel="stylesheet" type="text/css" href="forum.css">
<script language="javascript">
function popwin3(path)
{		window.open(path,"","height=300,width=450,resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no");
}
</script></head>
<script language="JavaScript" src="inc/coolbuttons.js"></script>
<!--#include file="inc/theme.asp"--><body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="0" onkeydown='if(event.keyCode==13 && event.ctrlKey)frmAnnounce.submit()'> 
<br>
<%

	dim AnnounceID
	dim RootID
	dim BoardID
	dim cname
	dim rs
	dim sql
	dim FoundErr
	dim ErrMsg,con
	dim boardtype
	dim tabletitle
	dim tablefont
	dim strAllowForumCode
	dim strAllowHTML
	dim strIMGInPosts
	dim strIcons
	dim strflash
	dim Forumlogo
	FoundError=false

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
		AnnounceID=request("id")
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
	if founderr=true then
		call error()
	else
	cname=Session.Contents("UserName")
   	set rs=server.createobject("adodb.recordset")
	sql="update bbs1 set hits=hits+1 where announceID="&AnnounceID
   	rs.open sql,conn,3,3
   	sql="select bbs1.username,bbs1.topic,bbs1.body,bbs1.dateandtime,bbs1.layer,bbs1.orders,bbs1.parentid,bbs1.ip,bbs1.Expression,bbs1.signflag, "
	sql=sql & " [user].useremail,[user].homepage,[user].oicq,[user].sign,[user].article,[user].userclass,[user].face,[user].adddate,[user].width,[user].height, "
	sql=sql & " board.Tableback,board.Tabletitle,board.Tablebody,board.aTablebody,board.TableFont,board.TableContent,board.AlertFont, board.boardtype,board.strAllowForumCode,board.strAllowHTML,board.strIMGInPosts,board.strIcons,board.strflash,board.Forumlogo "
	sql=sql & " from bbs1,[user],board where bbs1.username=[user].username and  board.boardID="&BoardID&" and bbs1.boardid=board.boardid and bbs1.AnnounceID="&AnnounceID
   	rs.open sql,conn,1,1   
	if err.number<>0 then 
		Errmsg=Errmsg+"<br>"+"<li>数据库操作失败："&err.description
		founderror=true
	else
		if rs.eof and rs.bof  then
   			Errmsg=Errmsg+"<br>"+"<li>该贴子的内容找不到，或者该论坛没有此帖子"
			founderror=true
		else
		Tabletitle=trim(rs("Tabletitle"))
		TableFont=trim(rs("TableFont"))
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
    <TD valign=middle align=top> &nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
      &nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="list.asp?boardid=<%=boardid%>&skin=<%=request("skin")%>"><%=rs("boardtype")%></a> 
      <br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;<%=htmlencode(rs("Topic"))%> 
    </TD>
  </TR>
  </TBODY>
</TABLE>
<br>
<table cellpadding=0 cellspacing=0 border=0 width="95%" align=center>
  <tr> 
    <td align=right width=40 valign=bottom><a href="announce.asp?boardid=<%=boardid%>&skin=<%=request("skin")%>"> 
      <img src="<%=picurl%>newthread.gif" alt="发表一个新主题" border=0></a>&nbsp; </td>
    <td align=right width=40 valign=bottom> <a href="reannounce.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>"> 
      <img src="<%=picurl%>rethread.gif" alt="回复本主题" border=0></a>&nbsp; </td>
    <td valign=bottom align=right width=40> <a href="printpage.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>"> 
      <img src="<%=picurl%>printpage.gif" alt="显示可打印的版本" border=0></a>&nbsp; </td>
    <td valign=bottom align=right width=40> <a href="pag.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>"> 
      <img src="<%=picurl%>pag.gif" border=0 alt="把本贴打包邮递"></a>&nbsp; </td>
    <td valign=bottom align=right width=40> <a href="favadd.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>"> 
      <img src="<%=picurl%>fav_add.gif" border="0" alt="把本贴加入论坛收藏夹"></a>&nbsp; 
    </td>
    <td valign=bottom align=right width=40> <a href="sendpage.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>"> 
      <img src="<%=picurl%>emailtofriend.gif" border=0 alt="发送本页面给朋友"></a>&nbsp; 
    </td>
    <td align=right valign=bottom width=40> <a href="javascript:window.location.reload()"> 
      <img src="<%=picurl%>refresh.gif" alt="刷新本主题" border="0"></a>&nbsp;</td>
    <td align=right valign=bottom width=40> <a href="javascript:history.back(1)"> 
      <img src="<%=picurl%>back.gif" alt="后退请用此按钮，提高浏览速度" border="0"></a>&nbsp;</td>
    <td align=right valign=bottom width=40> <a href="help.asp"> <img src="<%=picurl%>help.gif" alt="有疑问请先看帮助" border="0"></a>&nbsp;</td>
    <td align=right width=* valign=middle>&nbsp; </td>
    <td align=center width=2 valign=middle> </td>
  </tr>
</table>
<br>
<table width="95%" border='0' cellspacing='1' cellpadding='5' align='center' bgcolor='#000000'>
  <tr bgcolor='#FFFFFF'> 
    <td width=20% valign=top> &nbsp;&nbsp;<img src=<%=rs("face")%> width=<%=rs("width")%> height=<%=rs("height")%>><br>
      &nbsp;&nbsp;<%=htmlencode(rs("username"))%> <br>
      <%
	select case rs("userclass")
	case user_level1 response.write "&nbsp;&nbsp;<img src="&picurl&""&level1_pic&">"
	case user_level2 response.write "&nbsp;&nbsp;<img src="&picurl&""&level2_pic&">"
	case user_level3 response.write "&nbsp;&nbsp;<img src="&picurl&""&level3_pic&">"
	case user_level4 response.write "&nbsp;&nbsp;<img src="&picurl&""&level4_pic&">"
	case user_level5 response.write "&nbsp;&nbsp;<img src="&picurl&""&level5_pic&">"
	case user_level6 response.write "&nbsp;&nbsp;<img src="&picurl&""&level6_pic&">"
	case user_level7 response.write "&nbsp;&nbsp;<img src="&picurl&""&level7_pic&">"
	case user_level8 response.write "&nbsp;&nbsp;<img src="&picurl&""&level8_pic&">"
	case user_level9 response.write "&nbsp;&nbsp;<img src="&picurl&""&level9_pic&">"
	case user_level10 response.write "&nbsp;&nbsp;<img src="&picurl&""&level10_pic&">"
	case user_level11 response.write "&nbsp;&nbsp;<img src="&picurl&""&level11_pic&">"
	case user_level12 response.write "&nbsp;&nbsp;<img src="&picurl&""&level12_pic&">"
	case user_level13 response.write "&nbsp;&nbsp;<img src="&picurl&""&level13_pic&">"
	case user_level14 response.write "&nbsp;&nbsp;<img src="&picurl&""&level14_pic&">"
	case user_level15 response.write "&nbsp;&nbsp;<img src="&picurl&""&level15_pic&">"
	case user_level16 response.write "&nbsp;&nbsp;<img src="&picurl&""&level16_pic&">"
	case user_level17 response.write "&nbsp;&nbsp;<img src="&picurl&""&level17_pic&">"
	case user_level18 response.write "&nbsp;&nbsp;<img src="&picurl&""&level18_pic&">"
	case user_level19 response.write "&nbsp;&nbsp;<img src="&picurl&""&level19_pic&">"
	case user_level20 response.write "&nbsp;&nbsp;<img src="&picurl&""&level20_pic&">"
	end select
%>
      &nbsp;&nbsp;用户等级：<%=rs("userclass")%><br>
      &nbsp;&nbsp;发表文章：<%=rs("article")%><br>
      &nbsp;&nbsp;注册时间：<br>
      &nbsp;&nbsp;<%=rs("adddate")%><br>
    </td>
    <td width=80% valign=top> &nbsp;&nbsp;&nbsp;<a href="javascript:openScript('messanger.asp?action=new&touser=<%=HTMLEncode(rs("username"))%>',420,320)"><img src="<%=picurl%>message.gif" border=0 alt="给<%=HTMLEncode(rs("username"))%>发送一个短消息"></a>&nbsp;&nbsp; 
      <a href="javascript:openScript('dispuser.asp?name=<%=HTMLEncode(rs("username"))%>',350,300)"><img src="<%=picurl%>profile.gif" border=0 alt="查看admin的个人资料"></a>&nbsp;&nbsp; 
      <%if rs("useremail")<>"" then%>
      <A href="mailto:<%=htmlencode(rs("useremail"))%>"><IMG alt="点击这里发送电邮给<%=HTMLEncode(rs("username"))%>" border=0 src="<%=picurl%>email.gif"></A>&nbsp;&nbsp; 
      <%end if%>
      <%if rs("homepage")<>"" then%>
      <A href="<%=htmlencode(rs("homepage"))%>" target=_blank><IMG alt="访问<%=HTMLEncode(rs("username"))%>的主页"  border=0 src="<%=picurl%>homepage.gif"></A>&nbsp;&nbsp; 
      <%end if%>
      <a href="showannounce.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>&reply=true&skin=<%=request("skin")%>"><img src="<%=picurl%>reply.gif" border=0 alt="引用回复这个贴子"></a>&nbsp;&nbsp; 
      <a href='queryResult.asp?type=7&name=<%=htmlencode(rs("username"))%>'><img src='<%=picurl%>find.gif' border=0 alt='搜索<%=htmlencode(rs("username"))%>发表过的所有文章'></a> 
      <hr size='1' width='95%'>
      <blockquote> 
        <%if instr(rs("Expression"),"face")>0 then%>
        <img src='images/<%=rs("Expression")%>'> 
        <%end if%>
        <%=ubbcode(rs("body"))%> 
        <%
if rs("signflag")=1 then
	if rs("sign")<>"" then
%>
        <p>------------------------<br>
          <%=ubbcode(rs("sign"))%> 
          <%
	end if
end if
%>
      </blockquote>
      <hr size='1' width='95%'>
      <%
	if request.cookies("xdgctx")("username")<>"" then
		if rs("username")=request.cookies("xdgctx")("username") or request.cookies("xdgctx")("userclass") = user_level19 or request.cookies("xdgctx")("userclass") = user_level20  then
%>
      <a href="editannounce.asp?boardid=<%=boardid%>&rootid=<%=rootid%>&id=<%=announceid%>&skin=<%=request("skin")%>"><img src="pic/edit.gif" border=0 alt="编辑这个贴子">编辑</a> 
      <%
		end if
	end if
%>
      &nbsp;&nbsp;&nbsp;发贴时间：<%=rs("Dateandtime")%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='pic/ip.gif' border=0 width=14 height=14 alt='<%if IpFlag=0 then%>已设置保密<%else%><%=rs("ip")%><%end if%>'> 
    </td>
  </tr>
</table>
<%
	rs.close
%>
<p align="right"><font color="#999999">本帖子版权属于原作者所有，转载请与原作者联 系并注明出处 - <%=CompanyName%> 
  </font><font color=green>[<%=HostURL%>]</font>
<p> 
  <%
   	sql="select AnnounceID,boardID,UserName,Topic,hits,length,RootID,layer,orders,Expression,dateandtime from bbs1 where boardid="&cstr(boardid)&" and rootid="&request("rootid")&" order by rootid desc,orders"
   	rs.open sql,conn,1,1
		response.write "<b>相关贴子</b>" 
		showlist()
	rs.close
   	sql="select body,topic,locktopic from bbs1 where AnnounceID="&AnnounceID
   	rs.open sql,conn,1,1
		topic=rs("topic")
   		con=rs("body")
%>
<hr size="1">
<!--#include file="inc/stats.asp"-->
<%
		if rs("locktopic")=1 then
		response.write "<p align=center>本贴子已被锁定，不能发表回复。"
		else
		call showReForm()
		end if
%>
<!--#include file="inc/Form1.asp"-->
<%  
		end if
 	end if
	rs.close
end if
	if Founderror=true then
		call error()
	end if
   rem ------显示跟随贴子------
   sub showlist()
       dim outtext
       dim bytestr
       response.write  "<ul>"
       dim layer
       layer=1
       do while not (rs.eof or err.number<>0)
          do while layer<> rs("layer")
             if rs("layer")> layer then
                outtext=outtext & "<ul>"
                layer=layer+1
             else 
                outtext=outtext &  "</ul>" & chr(13) & chr(10)
                layer=layer-1  
             end if
          loop
          outtext=outtext &  "<li>"
	  if instr(rs("Expression"),"face")>0 then
          outtext=outtext & "<img src=images/"&rs("Expression")&">"
	  end if
          outtext=outtext &  "<a href='ShowAnnounce.asp?boardID="&boardID&"&RootID="&cstr(rs("RootID"))&"&ID="&Cstr(rs("announceID"))&"&skin="&request("skin")&"'>"
          dim t       		         
	  if rs("Length")=0 then
	     t=" "
          else 
             t=" "
	  end if		   
          if rs("topic")<>"" then
          outtext=outtext & htmlencode(rs("Topic")+t)
	  else
	  outtext=outtext & "回复该主题贴子"
	  end if
          outtext=outtext & "</a> -- <font color='#E10071'>「作者：<a href=javascript:openScript('dispuser.asp?name="&htmlencode(rs("username"))&"',350,300) title='作者资料'><font color='#E10071'>" 
                    bytestr="("+cstr(rs("length"))
          if not WINNT_CHINESE then
             if rs("Length")-1=1 then
                bytestr=bytestr+" Byte)"
	     else
	        bytestr=bytestr+" Bytes)"
      	     end if
          else 
             bytestr=bytestr+"字)"
          end if

          outtext=outtext & HTMLEncode(rs("UserName"))
          outtext=outtext & "</font></a>」</font> [ID:"+cstr(rs("announceID"))+" 点击:"&rs("Hits")&" <font color=green><i>"&rs("dateandtime")&"</i></font>] "+bytestr+""+chr(13)+chr(10)
          if trim(rs("DateAndTime"))<>"" and isdate(rs("DateAndTime")) then
             if cbool(cdate(rs("DateAndTime"))>(date()-1))=true then
                outtext=outtext &  "<img src='images/new.gif'>"+chr(13)+chr(10)
             end if
          end if
          rs.movenext
          response.write outtext
          outtext=""
       loop
       if layer<>0 then 
          dim i 
          for i=1 to layer
              outtext=outtext & "</ul>"
          next 
       end if
       outtext=outtext & "</ul>"        
       response.write outtext
   end sub
   set rs=nothing
   call endConnection()
%>

</body>
</html>
