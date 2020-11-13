<%Response.Expires=0%>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<link rel="stylesheet" type="text/css" href="forum.css">
<%
if Request("action") = "del" then
%>
<%
set rs = server.CreateObject ("adodb.recordset")
sql = "select * from board where boardid="+Cstr(Request("boardid"))
rs.open sql,conn,1,3
rs.delete
rs.close
'set rs_1 = server.CreateObject ("adodb.recordset")
'sql_1 = "select * from bbs1 where boardid="+cstr(Request("boardid"))
'rs_1.open sql_1,conn,1,3
'rs_1.delete
'rs_1.close
call success()
'elseif Request(action") then 
end if

%>
<%if Request("edittype") = "edit" then
set rs = server.CreateObject ("adodb.recordset")
sql = "select * from board where boardid="+Cstr(request("editid"))
rs.Open sql,conn,1,3
'if Request.Form ("boardid") = "" then 
'errmsg = errmsg + "<br>" + "<li> 论坛的id号不能为空！</li>"
'call error()
'else
rs("boardid") = Request("boardid")
'end if
rs("boardtype") = Request.Form ("boardtype")
rs("class") = Request.Form  ("class")
rs("boardmaster") = Request("boardmaster")
rs("readme") = Request("readme")
rs("masterpwd") = Request("password")
rs("boardmaster1") = Request("boardmast1")
rs("masterpwd1") = Request("password1")
rs("boardmaster2") = Request("boardmast2")
rs("masterpwd2") = Request("password2")
rs("lockboard") = Trim(Request("lockboard"))
rs("boardskin") = Trim(Request("boardskin"))
rs("Tableback") = Request("Tableback")
rs("Tabletitle") = Request("Tabletitle")
rs("Tablebody") = Request("Tablebody")
rs("aTablebody") = Request("aTablebody")
rs("TableFont") = Request("TableFont")
rs("TableContent") = Request("TableContent")
rs("AlertFont") = Request("AlertFont")
rs.Update 
rs.Close 
set conn = nothing
call success()
end if
%>
<%if Request("dotype") = "addnewboard" then
set rs = server.CreateObject ("adodb.recordset")
sql = "select * from board where (boardid=null)"
rs.Open sql,conn,1,3
rs.AddNew
'if Request.Form ("boardid") = "" then 
'errmsg = errmsg + "<br>" + "<li> 论坛的id号不能为空！</li>"
'call error()
'else
rs("boardid") = Request("boardid")
'end if
rs("boardtype") = Request.Form ("boardtype")
rs("class") = Request.Form  ("class")
rs("boardmaster") = Request("boardmaster")
rs("readme") = Request("readme")
rs("masterpwd") = Request("password")
rs("boardmaster1") = Request("boardmast1")
rs("masterpwd1") = Request("password1")
rs("boardmaster2") = Request("boardmast2")
rs("masterpwd2") = Request("password2")
rs("lockboard") = Trim(Request("lockboard"))
rs("boardskin") = Trim(Request("boardskin"))
rs("Tableback") = Request("Tableback")
rs("Tabletitle") = Request("Tabletitle")
rs("Tablebody") = Request("Tablebody")
rs("aTablebody") = Request("aTablebody")
rs("TableFont") = Request("TableFont")
rs("TableContent") = Request("TableContent")
rs("AlertFont") = Request("AlertFont")
'rs("lastitle")= "无"
rs("lastpostuser") ="未知"
rs("lastposttime") = now()
rs("lastbbsnum") = 0 
rs.Update 
rs.Close 
set conn = nothing
call success()
end if
sub success()
%> 
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>成功：论坛操作</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=Tablebodycolor%>><li><b>数据库更新成功！</b><br>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>
<a href="admin_board.asp"> << 返回新闻管理</a>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
end sub
%>
<html><script language="JavaScript">                                                                  </script></html>