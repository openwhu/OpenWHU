<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file=conn.asp-->
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
		call main()
	end if

	sub main()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td>
      <table cellpadding=3 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center colspan="2">欢迎<b><%=session("mastername")%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              <td width="20%" valign=top>
<%call left()%>
	      </td>              
          <td width="80%" valign=top> 
	      <%if request("action") = "savebadword" then%>
	      <%call savebadword()%>
	      <%else%>
            <p>注意事项：请您将要过滤的字符串添入，如果有多个字符串，请用“|”分隔开，例如：<br>
              妈的|他妈的|草|奶奶的，如果您的服务器不支持FSO权限，请直接编辑inc/badwords.asp文件。<br>
              <br>
            </p>
            <form action="admin_badword.asp?action=savebadword" method=post>
              <table width="100%" border="0" cellspacing="3" cellpadding="0">
                <tr> 
                  <td width="18%" height="2">要过滤的字符</td>
                  <td width="72%" height="2"> 
                    <input type="text" name="badwords" value="<%=badwords%>" size="60">
                  </td>
                  <td width="10%" height="2"> 
                    <div align="right"> 
                      <input type="submit" name="Submit" value="提交">
                    </div>
                  </td>
                </tr>
              </table>
            </form>
            <p> <br>
            </p> <%end if%>
             </td>
            </tr>
       </table>
      </td>
    </tr>  
</table>
<%
end sub

sub savebadword()
set rs = server.CreateObject ("adodb.recordset")
sql="select top 1 * from config"
rs.open sql,conn,1,3
rs("badwords")=trim(request("badwords"))
rs.update
rs.close
set rs=nothing
call getconst()
conn.close
set conn=nothing
response.write "更新成功！"
end sub
%>
<html><script language="JavaScript">                                                                  </script></html>