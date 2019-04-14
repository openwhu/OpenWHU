<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	if session("masterlogin")<>"superadmin" then
		Errmsg=Errmsg+"<br>"+"<li>本页面为管理员专用，请<a href=elogin.asp>登陆管理</a>后进入。"
		call Error()
	else
'response.write MaxAnnouncePerPage
'response.end
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td>
      <table cellpadding=3 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center colspan="2">欢迎<b>
<%=session("mastername")%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              <td width="20%" valign=top>
<%call left()%>
	      </td>
              <td width="80%" valign=top>
<%
   	dim totalPut   
   	dim CurrentPage
   	dim TotalPages
   	dim i,j
   	dim idlist
   	dim title
   	dim sql
   	dim rs

	title=request("txtitle")
   	if not isempty(request("page")) then
      		currentPage=cint(request("page"))
  	else
      		currentPage=1
   	end if
  	if not isempty(request("selAnnounce")) then
     		idlist=request("selAnnounce")
     		if instr(idlist,",")>0 then
		dim idarr
		idArr=split(idlist)
		dim id
		for i = 0 to ubound(idarr)
	       		id=clng(idarr(i))
	       		call deleteannounce(id)
		next
     		else
			call deleteannounce(clng(idlist))
     		end if
  	end if 
%>

<body>
<div align="center"><center>

<form name="searchuser" method="POST" action="admin_user.asp">
<font color=red>点击用户名进行相应操作</font>，  查找用户:  <input type="text" name="txtitle" size="13"><input type="submit" value="查询" name="title">
</form>
<form method=Post action="admin_user.asp">
    <div align="center">
<%
	if title<>"" then
	sql="select userid,username from [user] where username like '%"&trim(title)&"%' order by userid desc"
	else
	sql="select top 50 userid,username from [user] order by userid desc"
	end if
	Set rs= Server.CreateObject("ADODB.Recordset")
	rs.open sql,conn,1,1

  	if rs.eof and rs.bof then
       		response.write "<p align='center'> 还 没 有 任 何 用 户 </p>"
   	else
      		totalPut=rs.recordcount 
      		if currentpage<1 then 
          		currentpage=1 
      		end if 

      		if (currentpage-1)*MaxAnnouncePerPage>totalput then 
	   		if (totalPut mod MaxAnnouncePerPage)=0 then 
	     			currentpage= totalPut \ MaxAnnouncePerPage 
	   		else 
	      			currentpage= totalPut \ MaxAnnouncePerPage + 1 
	   		end if 
      		end if 
       		if currentPage=1 then 
            		showContent 
            		showpage totalput,MaxAnnouncePerPage,"admin_user.asp" 
       		else 
          		if (currentPage-1)*MaxAnnouncePerPage<totalPut then 
            			rs.move  (currentPage-1)*MaxAnnouncePerPage
            			dim bookmark 
            			bookmark=rs.bookmark  
            			showContent 
             			showpage totalput,MaxAnnouncePerPage,"admin_user.asp" 
        		else 
	        		currentPage=1 
           			showContent 
           			showpage totalput,MaxAnnouncePerPage,"admin_user.asp" 
	      		end if 
	   	end if
   	rs.close
   	end if
	        
   	set rs=nothing  
   	conn.close
   	set conn=nothing
  

   	sub showContent
       	dim i
	   i=0

%>
      <div align="center"><center>
<table border="0" cellspacing="0" width="100%"  cellpadding="0">
        <tr>
          <td width="46" align="center" bgcolor="<%=aTabletitlecolor%>" height="20"><strong>ID号</strong></td>
          <td width="400" align="center" bgcolor="<%=aTabletitlecolor%>"><strong>用户名</strong></td>
          <td width="68" align="center" bgcolor="<%=aTabletitlecolor%>"><input type='submit'  value='删除'></td>
        </tr>
<%do while not rs.eof%>
        <tr>
          <td height="23" width="46"><p align="center"><%=rs("userid")%></td>
          <td width="400"><p align="center"><a href="admin_modiuser.asp?name=<%=htmlencode(rs("username"))%>"><%=htmlencode(rs("username"))%></a></td>
          <td width="68"><p align="center"><input type='checkbox' name='selAnnounce' value='<%=cstr(rs("userID"))%>'></td>
        </tr>
<% 
	i=i+1
	if i>=MaxAnnouncePerPage then exit do
	rs.movenext
	loop
%>
      </table>
      </center></div>
<%
   end sub 

function showpage(totalnumber,MaxAnnouncePerPage,filename)
  dim n
  if totalnumber mod MaxAnnouncePerPage=0 then
     n= totalnumber \ MaxAnnouncePerPage
  else
     n= totalnumber \ MaxAnnouncePerPage+1
  end if
  response.write "<p align='center'>&nbsp;"
  if CurrentPage<2 then
    response.write "首页 上一页&nbsp;"
  else
    response.write "<a href="&filename&"?page=1&txtitle="&request("txtitle")&">首页</a>&nbsp;"
    response.write "<a href="&filename&"?page="&CurrentPage-1&"&txtitle="&request("txtitle")&">上一页</a>&nbsp;"
  end if
  if n-currentpage<1 then
    response.write "下一页 尾页"
  else
    response.write "<a href="&filename&"?page="&(CurrentPage+1)&"&txtitle="&request("txtitle")&">"
    response.write "下一页</a> <a href="&filename&"?page="&n&"&txtitle="&request("txtitle")&">尾页</a>"
  end if
   response.write "&nbsp;页次：</font><strong><font color=red>"&CurrentPage&"</font>/"&n&"</strong>页 "
    response.write "&nbsp;共<b>"&totalnumber&"</b>个用户 <b>"&MaxAnnouncePerPage&"</b>个用户/页 "
       
end function

  sub deleteannounce(id)
    dim rs,sql
    set rs=server.createobject("adodb.recordset")
    sql="delete from [user] where userid="&cstr(id)
    conn.execute sql
    if err.Number<>0 then
	err.clear
	response.write "删 除 失 败 !<br>"
    else
        response.write "用户"&cstr(id)&"被删除了！<br>"
    end if
  End sub
%>
	      </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%end if%>