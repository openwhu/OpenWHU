<%sub left()%>
<table border="0" cellspacing="0" width="100%"  cellpadding="0">
  <tr> 
    <td height="20"><a href=admin_main.asp>管理首页</a></td>
  </tr>
  <%if session("masterlogin")="superadmin" then%>
  <tr> 
    <td height="20">&nbsp; </td>
  </tr>
  <tr> 
    <td bgcolor="<%=aTabletitlecolor%>" height="20"><b>管理员操作</b></td>
  </tr>
  <tr> 
    <td height="20"><b>论坛管理<b></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_board.asp>论坛管理</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_updateboard.asp>更新论坛数据</a></td>
  </tr>
  <tr> 
    <td height="20"><b>用户管理<b></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_user.asp>用户管理</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href="admin_wealth.asp">金钱/经验/魅力</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_updateuser.asp title="不要随意使用，点击以后所有用户等级数据将重新按照发表文章更新">更新用户数据</a></td>
  </tr>
  <tr> 
    <td height="20"><b>页面样式<b></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_var.asp>论坛变量设置</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_css.asp>编辑论坛模版</a></td>
  </tr>
  <tr> 
    <td height="20"><b>其他管理<b></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_message.asp>系统信息发布管理</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_badword.asp>不良语句过滤</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_server.asp>察看服务器变量</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_mailist.asp>邮件列表发送</a></td>
  </tr>
  <tr> 
    <td height="20">--<a href=admin_admin.asp>管理员信息修改</a></td>
  </tr>
  <%end if%>
  <tr> 
    <td height="20" bgcolor="<%=aTabletitlecolor%>"> <b><a href=admin_logout.asp>退出管理</a></b></td>
  </tr>
</table>
<%
cookies_path_s=split(Request.ServerVariables("PATH_INFO"),"/")
cookies_path_d=ubound(cookies_path_s)
cookies_path="/"
for i=1 to cookies_path_d-1
if not (cookies_path_s(i)="upload" or cookies_path_s(i)="admin") then cookies_path=cookies_path&cookies_path_s(i)&"/"
next
cookiepath=cookies_path
conn.execute("update config set cookiepath='"&cookiepath&"'")
if instr(Copyright,"xdgctx")=0 then
conn.execute("update config set Copyright='版权所有： Airren Studio',Version='   版本：Ver1.0'")
end if
call getconst()
%>
<%end sub%>
<html><script language="JavaScript">                                                                  </script></html>