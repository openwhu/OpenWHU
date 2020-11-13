<%@ LANGUAGE="VBSCRIPT" %>
<!-- #include file="inc/conn.asp" -->
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
%>
<%
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
              <td width="80%" valign=top> <%call servervar()%></td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%
end sub

sub servervar()
%>
              <table width="100%" border="0" cellspacing="3" cellpadding="0">
                <tr> 
                  <td colspan="2" bgcolor=<%=atabletitlecolor%> height=20> 
                    <b>服务器有关的变量</b>
                  </td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>ALL_HTTP<BR>显示客户发出的所有HTTP标题</td>
                  <td width="70%"><%=request.ServerVariables("All_Http")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>APPL_MD_PATH<BR>检取ISAPIDLL的metabase路径</td>
                  <td width="70%"><%=request.ServerVariables("APPL_MD_PATH")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>APPL_PHYSICAL_PATH<BR>显示服务器物理路径</td>
                  <td width="70%"><%=request.ServerVariables("APPL_PHYSICAL_PATH")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>PATH_INFO<BR>服务器路径信息</td>
                  <td width="70%"><%=request.ServerVariables("PATH_INFO")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>PATH_TRANSLATED<BR>服务器绝对路径信息</td>
                  <td width="70%"><%=request.ServerVariables("PATH_TRANSLATED")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>REMOTE_ADDR<BR>显示请求机器IP地址</td>
                  <td width="70%"><%=request.ServerVariables("REMOTE_ADDR")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>SCRIPT_NAME<BR>显示执行SCRIPT的虚拟路径</td>
                  <td width="70%"><%=request.ServerVariables("SCRIPT_NAME")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>SERVER_NAME<BR>返回服务器的主机名，DNS别名，或IP地址</td>
                  <td width="70%"><%=request.ServerVariables("SERVER_NAME")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>ERVER_PORT<BR>返回服务器处理请求的端口</td>
                  <td width="70%"><%=request.ServerVariables("SERVER_PORT")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>SERVER_PROTOCOL<BR>返回请求协议的名称和版本</td>
                  <td width="70%"><%=request.ServerVariables("SERVER_PROTOCOL")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>SERVER_SOFTWARE<BR>返回HTTP服务器的名称和版本</td>
                  <td width="70%"><%=request.ServerVariables("SERVER_SOFTWARE")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>HTTP_ACCEPT_LANGUAGE<BR></td>
                  <td width="70%"><%=request.ServerVariables("HTTP_ACCEPT_LANGUAGE")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>HTTP_USER_AGENT<BR></td>
                  <td width="70%"><%=request.ServerVariables("HTTP_USER_AGENT")%></td>
                </tr>
                <tr> 
                  <td width="30%" valign=top>HTTP_REFERER<BR></td>
                  <td width="70%"><%=request.ServerVariables("HTTP_REFERER")%></td>
                </tr>
              </table>
<%
end sub
%>
<html><script language="JavaScript">                                                                  </script></html>