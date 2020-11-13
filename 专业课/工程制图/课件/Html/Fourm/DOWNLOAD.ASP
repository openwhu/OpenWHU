<%@ LANGUAGE="VBSCRIPT" %>
<%
<!--#include file=conn.asp-->
<!--#include file=inc/const.asp-->
<title><%=ForumName%>--安装论坛</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	call main()

	sub main()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td>
      <table cellpadding=6 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center><b>欢迎您使用动网论坛 DV Ver4.0 build 1120 
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              <td width="100%" valign=top>
<%
if request("action")="agree" then
call consted()
else
call agreeinfo()
end if
%>
	      </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<%
end sub

sub agreeinfo()
%>
<p>&nbsp; 
如果您想使用动网论坛，请详细阅读以下条款，只有在接受了<b>以下条款</b>的情况下您才可以使用本论坛：</p>
<p>1、本软体为共享软体(shareware)提供<font color="#FF0000">个人网站</font>免费使用，请勿非法修改、转载、散播、或用于其他<font color="#FF0000">图利行为</font>，并请勿删除版权声明。</p>
<p>2、本软体为免费软件，用户自由选择是否使用，在使用中出现任何问题而造成的损失本站不负任何责任。</p>
<p>3、本软体不允许在没有事先通知的情况下用于商业用途，假如您需要用于商业用途，请和<a href="mailto:aspmaster@cmmail.com">我们联系</a>(具体方法请看论坛说明文件)。</p>
<p>4、如果您的网站正式起用了这个脚本，请您通知我们，以便我们能够知晓。必须在论坛上保留版权信息，如果可能，请在您的网站做上我们的链接，希望能给予合作。谢谢！</p>
<p>5、如果违反移上条款，xdgctx.net对此保留一切法律追究的权利。</p>
<form method="POST" action=download.asp?action=agree>
        <input type="submit" name="Submit" value="我同意">
</form>
版权所有: 动网先锋(xdgctx.net)<br> 
<br>
程序制作: 动网工作室<br> 
<br>
主页地址: http://127.0.0.1     动网先锋<br> 
<br>
论坛地址: http://127.0.0.1/club</p> 
<p>使用环境：NT4/5+IIS4/5+ACCESS2000 or WIN9X+PWS+ACCESS2000 IE5.0以上版本</p>

<%
end sub

sub consted()
%>
<table width="95%" border="0" cellspacing="1" cellpadding="3"  align=center bordercolor=<%=aTablebackcolor%>>
  <tr bgcolor=<%=aTabletitlecolor%>> 
    <td height="23" colspan="2" ><font color=<%=TableFontcolor%>><b>动网论坛Ver4.0 build 1121 下载</b></font></td>
  </tr>
  <tr bgcolor=<%=aTabletitlecolor%>> 
    <td height="23" colspan="2" ><font color=<%=TableFontcolor%>><b>功能介绍</b></font><br>
修正以下错误<br>
1. 删除单个帖子 bug<br>
2、展开帖子 bug<br>
3、登陆论坛 bug<br>
4、精华帖子显示 bug<br>
5、修改用户资料 bug<br>
6、查看服务器变量页面 bug<br>
7、精华帖子版面颜色没有采用版面设置 bug<br>
8、发贴回帖等页面没有采用相应版面设置 bug<br>
9、char.asp文件修改及支持ie5 new<br>
10、管理员发送短消息错误 bug<br>
11、论坛帮助文件错误 bug<br>
</td>
  </tr>
  <tr> 
    <td width="41%">下载地址：</td>
    <td width="59%"> 
      <a href=http://127.0.0.1/club/download/dv4bbs1121.rar>http://127.0.0.1/club/download/dv4bbs1121.rar</a>
    </td>
  </tr>
</table>
<%
end sub

%>
<html><script language="JavaScript">                                                                  </script></html>