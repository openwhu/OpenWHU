<%@ LANGUAGE="VBSCRIPT" %>
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	if session("masterlogin")<>"superadmin" then
		Errmsg=Errmsg+"<br>"+"<li>本页面为管理员专用，请<a href=elogin.asp>登陆管理</a>后进入。"
		call Error()
	else
%>
<!-- #include file="conn.asp" -->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<%
		call main()
	end if

	sub main()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td height="30"> 
      <table cellpadding=3 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center colspan="2">欢迎<b><%=session("mastername")%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              
          <td width="25%" valign=top> <%call left()%> </td>
              
          <td width="75%" valign=top>
<%
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
if request("save")="" then
		Set objCountFile = objFSO.OpenTextFile(Server.MapPath("forum.css"),1,True)
		If Not objCountFile.AtEndOfStream Then fdata = objCountFile.ReadAll
	else
		fdata=request("fdata")
		Set objCountFile=objFSO.CreateTextFile(Server.MapPath("forum.css"),True)
		objCountFile.Write fdata
	end if
	objCountFile.Close
	Set objCountFile=Nothing
	Set objFSO = Nothing
%> 
<form method=post>
            <table width="100%" border="0" cellspacing="3" cellpadding="0">
              <tr> 
                <td width="3%" height="23">&nbsp;</td>
                <td width="97%" height="23">论坛模板编辑：<br>
                  &nbsp;&nbsp;&nbsp;&nbsp;注意：文件将被保存在你安装目录下的<font color="<%=AlertfontColor%>">FORUM.CSS</font>里，如果您的空间不支持<font color="<%=AlertfontColor%>">FSO</font>，请直接编辑该文件！如果您对CSS的属性不了解，请不要随意编辑。</td>
              </tr>
              <tr> 
                <td width="3%">&nbsp; </td>
                <td width="97%"> 
                  <textarea name="fdata" cols="60" rows="20"><%=fdata%></textarea>
                </td>
              </tr>
              <tr> 
                <td width="3%">&nbsp;</td>
                <td width="97%">
                  <input type="reset" name="Reset" value="重新修改">
                  <input type="submit" name="save" value="提交修改"> 当前文件路径：<font color=<%=AlertfontColor%>><b><%=Server.MapPath("forum.css")%></b></font>
                </td>
              </tr>
            </table></form>
            <p>&nbsp;</p>
            </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%

end sub%>