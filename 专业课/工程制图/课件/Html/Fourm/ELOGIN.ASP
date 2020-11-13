<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<html>

<head>
<title><%=ForumName%>--管理登陆</title>
<link rel="stylesheet" href="forum.CSS">

</head>
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333">
<div align="center"><center>

<form method="POST" action="echklogin.asp">
      <table cellpadding=0 cellspacing=0 border=0 width=45% bgcolor=<%=atablebackcolor%> align=center>
        <tr>
          <td><table cellpadding=3 cellspacing=1 border=0 width=100%>
            <tr>
              <td colspan="2" height="22" bgcolor=<%=atabletitlecolor%> align=center>
管理员登陆
	      </td>
            </tr>
            <tr bgcolor=<%=tablebodycolor%>>
                      
                <td width="33%" align="right" height="30">管理员：</td>
              <td width="67%"><input name="username" maxlength="20" size="20"> </td>
            </tr>
            <tr bgcolor=<%=tablebodycolor%>>
                      <td width="33%" align="right" height="30">密 码：</td>
              <td width="67%"><input type="password" name="password" maxlength="16" size="20"> </td>
            </tr>
            <tr>
              <td colspan="2" height="15" bgcolor=<%=atabletitlecolor%> align=center>
                  <input type="submit" name="Submit" value="确 定"> 
          &nbsp; 
                  <input type="reset" name="Submit2" value="重 写">
	      </td>
            </tr>
          </table>
          </td>
        </tr>
      </table>
    </form>
</center></div>
<%
conn.close
set conn=nothing
%>

</body>
</html>