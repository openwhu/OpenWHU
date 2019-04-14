<!-- #include file="conn.asp" -->
<!-- #include file="inc/const.asp" -->
<!-- #include file="inc/grade.asp" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="forum.css" rel=stylesheet>
<title><%=Forumname%>--帮助</title>
</head>

<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333">
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=#777777 align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=#EEEEEE><b><%=Forumname%>帮助文件</b></td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=#FFFFFF><blockquote>
<%if request("action")="" then%>
        <p align="center"><br>
        希望下面帮助信息对您有用</p>
        <p>常规帮助文件</p>
        <p>关于<a href=help.asp?action=message>短消息</a>的帮助</p>
        <p>关于<a href=help.asp?action=update>更改信息</a>的帮助</p>
        <p>关于<a href=help.asp?action=announce>发贴子</a>的帮助</p>
        <p>关于<a href=help.asp?action=edit>修改贴子</a>的帮助</p>
        <p>关于<a href=help.asp?action=forget>遗忘密码</a>的帮助</p>
        <p>关于<a href=help.asp?action=reg>用户注册</a>的帮助</p>
        <p>关于<a href=help.asp?action=online>在线用户</a>的帮助</p>
        <p>关于<a href=help.asp?action=ubb>UBB功能</a>的帮助</p>
        <p>关于<a href=help.asp?action=face>表情转换</a>的帮助</p>
        <p>关于<a href=help.asp?action=point>论坛积分</a>的帮助</p>
<%
elseif request("action")="message" then
	call message()
elseif request("action")="update" then
	call update()
elseif request("action")="announce" then
	call announce()
elseif request("action")="edit" then
	call edit()
elseif request("action")="forget" then
	call forget()
elseif request("action")="reg" then
	call reg()
elseif request("action")="online" then
	call online()
elseif request("action")="ubb" then
	call ubb()
elseif request("action")="face" then
	call face()
elseif request("action")="point" then
	call fpoint()
end if
%>
	</blockquote>
      </td>
    </tr>
    </table>   </td></tr></table>

</body>     
<%
sub message()
%>
        <p align="center"><br>
        <b>短信息帮助</b></p>
	<p>短信息功能也相当于留言，所不同的是他可以在用户登录社区的情况下即时收发消息，方便简洁，在DV3000版本中增加了即时收发、收件箱、发件箱、全部信息删除等操作。</p>
	<p><b>发送消息</b>：登录用户方能发送消息，一种是自己填写收件人名称（该用户必须是论坛注册用户）和完整的标题和内容，内容支持ubb格式；另外一种是在论坛中查看贴子的时候直接给作者发送消息，需要填写内容同上。发送消息后，该消息内容同时存入你的发件箱中。
	<p><b>收件箱</b>：登录论坛后点击上方短消息连接，列出所有已读和未读的消息及其标题、发件人，可以进行读取信息和全部删除操作。
	<p><b>发件箱</b>：登录论坛进入短消息页面，即可直接进入你的收件箱，这里保存你以前所发送过的消息标题及收件人，可以进行读取和全部删除操作。
	<p><b>新消息</b>：登录论坛后，每当有别人给你发送新的短消息，或者原来的消息还未读取，论坛都将自动弹出新消息提示框，直接点击后阅读。
	<p>查看<a href=help.asp>所有帮助文件</a>
<%
end sub

sub update()
%>
        <p align="center"><br>
        <b>更改个人信息帮助</b></p>
	<p>只有登录用户才能进行此项操作，原注册用户名不可修改，可以更新的信息如下：
	<p>密码：登录论坛所用
	<br>性别：将显示在你的资料和论坛中
	<br>定制论坛：所选择的论坛风格以后登录将自动载入
	<br>个性头像：所选择头像将在贴子中出现，可预览所有头像，可自行连接图片url
	<br>Email地址：必须填入正确合法的邮箱地址
	<br>个人主页：可选项
	<br>OICQ：可选项
	<br>个性签名：支持ubb，如果填入，将出现在文章的结尾
	<p>查看<a href=help.asp>所有帮助文件</a>
<%
end sub

sub announce()
%>
        <p align="center"><br>
        <b>发表贴子帮助</b></p>
        于新发贴子的帮助：</B>
<P>发起一个新主题，或是回复已有主题，你必须是注册用户。
<P><B>签名档:</B><BR>如果你选中“发贴时加上签名档”选项，你每次发贴时系统会在最后自动加上你的签名档。你可随时通过个人档案来修改你的签名档。签名档的调用是在阅读帖子时即时进行的，所以，如果你修改了签名档，你发的所有帖子（包括修改以前的）所附带的都是你的新签名档。
<P><B>帖子回复的Email通知:</B><BR>如果论坛管理员已把邮件功能打开，你可选中“有人回复你帖子时收到Email通知”，这样，如果有人回复你的主题，系统会自动Email通知你。
<P><B>注意:</B><BR>除了发起新贴时可以省去主题描述项外，你要确保填写所有项已成功发出帖子。<BR>
<P>点击“心情图释”（如果已经启用的话）将会弹出心情图释的图例以供选择；点击“论坛标签”，将会弹出标签图例以供选择使用。
<p>查看<a href=help.asp>所有帮助文件</a>
<%
end sub

sub edit()
%>
        <p align="center"><br>
        关于修改帖子的帮助</p>
        <p><b>您在发表帖子之后如果感到不满意，可以在登陆的情况下对您的帖子进行修改，方法同发表帖子！<br>
        <p>查看<a href=help.asp>所有帮助文件</a>
<%
end sub

sub forget()
%>
        <p align="center"><br><b>
        关于遗忘密码的帮助</b></p>
        <P>如果遗忘密码，你可要求系统将密码发往你注册时所登记的信箱里。
        <P>只要输入你注册的Email地址，系统会马上发送你的密码。其他人是无法就此得知你的密码的，因为系统是根据你所提供的用户名把密码发往你个人资料库中所记录的Email地址。</P>
        <p>查看<a href=help.asp>所有帮助文件</a> 
<%
end sub

sub reg()
%>
        <p align="center"><br><b>
       关于用户注册的帮助</b></p>
        <FONT face=宋体 color=#000000><B>关于用户注册的帮助：</B>
<P>你在注册前必须同意本论坛协议。在表明同意之前请认真阅读协议。
<P>如果论坛管理员要求电子邮件确认，你的密码将会通过Email发给你。此后，你可随时修改你的密码。选择密码时，请务必确保密码不容易被他人猜出，并且不少于5个字符。
<P>你必须提交一个形如you@yourdomain.com的有效Email地址以完成注册。
<P>其它项是可选的，但是，在你没有隐私顾虑的范围内，我们鼓励你尽可能地注册详细信息。论坛不允许垃圾邮件和兜售信息，你的所有注册信息将严格保密。
<P><B>签名档</B><BR>你可编辑有个人特色的签名档，这样在每次发贴子的时候你可选择加上。系统设定签名档不能超过三行（每行以回车键为准），并且可以使用论坛（UBB)标签，但禁止使用HTML标签。
<P><B>个性头像</B><BR>你可以使用自己喜欢的个性头像，但务必注意将您图片的完整url地址添入表格，并且符合系统规定的大小！
        <p>查看<a href=help.asp>所有帮助文件</a> 
<%
end sub

sub online()
%>
        <p align="center"><br><b>
       关于在线用户的帮助</b></p>
<P>在线名单列出了当前所有在线用户的名字和当前状态。你的状态随你的动作是随时更新的。
<P>在线的所有非注册用户都显示为“客人”。
<P>注意，如果你在20分钟之内没有任何动作，系统将会认为你自动离线，你需要重新登录。
        <p>查看<a href=help.asp>所有帮助文件</a> 

<%
end sub

sub ubb()
%>
        <p align="center"><br>
       <b> UBB标签帮助</b></p>
<p>论坛可以由管理员设置是否支持UBB标签，UBB标签就是不允许使用HTML语法的情况下，通过论坛的特殊转换程序，以至可以支持少量常用的、无危害性的HTML效果显示。以下为具体使用说明：
<p><font color=red>[B]</font><b>文字</b><font color=red>[/B]</font>：在文字的位置可以任意加入您需要的字符，显示为粗体效果。
<p><font color=red>[I]</font><i>文字</i><font color=red>[/I]</font>：在文字的位置可以任意加入您需要的字符，显示为斜体效果。
<p><font color=red>[U]</font><u>文字</u><font color=red>[/U]</font>：在文字的位置可以任意加入您需要的字符，显示为下划线效果。
<p><font color=red>[align=center]</font><div align=center>文字</div><font color=red>[/align]</font>：在文字的位置可以任意加入您需要的字符，center位置center表示居中，left表示居左，right表示居右。
<p><font color=red>[URL]</font><A HREF="http://127.0.0.1">http://127.0.0.1</A><font color=red>[/URL]</font>
<P><font color=red>[URL=http://127.0.0.1]</font><A HREF="http://127.0.0.1">动网先锋</A><font color=red>[/URL]</font>：有两种方法可以加入超级连接，可以连接具体地址或者文字连接。
<p><font color=red>[EMAIL]</font><A HREF="mailto:aspmaster@cmmail.com">aspmaster@cmmail.com</A><font color=red>[/EMAIL]</font>
<P><font color=red>[EMAIL=MAILTO:aspmaster@cmmail.com]</font><A HREF="mailto:aspmaster@cmmail.com">沙滩小子</A><font color=red>[/EMAIL]</font>：有两种方法可以加入邮件连接，可以连接具体地址或者文字连接。
<P><font color=red>[img]</font><img src=http://127.0.0.1/images/asp.gif><font color=red>[/img]</font>：在标签的中间插入图片地址可以实现插图效果。
<P><font color=red>[flash]</font>Flash连接地址<font color=red>[/Flash]</font>：在标签的中间插入Flash图片地址可以实现插入Flash。
<P><font color=red>[code]</font>文字<font color=red>[/code]</font>：在标签中写入文字可实现html中编号效果。
<P><font color=red>[quote]</font>引用<font color=red>[/quote]</font>：在标签的中间插入文字可以实现HTMl中引用文字效果。
<P><font color=red>[list]</font>文字<font color=red>[/list]</font> <font color=red>[list=a]</font>文字<font color=red>[/list]</font>  <font color=red>[list=1]</font>文字<font color=red>[/list]</font>：更改list属性标签，实现HTML目录效果。
<P><font color=red>[fly]</font>文字<font color=red>[/fly]</font>：在标签的中间插入文字可以实现文字飞翔效果，类似跑马灯。
<P><font color=red>[move]</font>文字<font color=red>[/move]</font>：在标签的中间插入文字可以实现文字移动效果，为来回飘动。
<P><font color=red>[glow=255,red,2]</font>文字<font color=red>[/glow]</font>：在标签的中间插入文字可以实现文字发光特效，glow内属性依次为宽度、颜色和边界大小。
<P><font color=red>[shadow=255,red,2]</font>文字<font color=red>[/shadow]</font>：在标签的中间插入文字可以实现文字阴影特效，shadow内属性依次为宽度、颜色和边界大小。
<P><font color=red>[color=颜色代码]</font>文字<font color=red>[/color]</font>：输入您的颜色代码，在标签的中间插入文字可以实现文字颜色改变。
<P><font color=red>[size=数字]</font>文字<font color=red>[/size]</font>：输入您的字体大小，在标签的中间插入文字可以实现文字大小改变。
<P><font color=red>[face=字体]</font>文字<font color=red>[/face]</font>：输入您需要的字体，在标签的中间插入文字可以实现文字字体转换。
        <p>查看<a href=help.asp>所有帮助文件</a> 
<%
end sub

sub face()
%>
        <p align="center"><br>
        表情转换帮助</p>
<p>代码&nbsp;&nbsp;&nbsp;&nbsp;转换后<p>
<%for e=1 to 9%>
                	[em0<%=e%>]&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/em0<%=e%>.gif" border=0><p>
<%next%>
<%for e=10 to 28%>
                	[em<%=e%>]&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/em<%=e%>.gif" border=0><p>
<%next%>
        <p>查看<a href=help.asp>所有帮助文件</a> 
<%
end sub

sub fpoint()
%>
        <p align="center"><br>
        论坛积分帮助</p>
<p>发表文章积分<font color=red>+1</font>
<p>主论坛回复文章积分<font color=red>+3</font>，次论坛<font color=red>+1</font>
<p><b>关于用户等级：</b>
<%
dim i
i=1
for i=1 to 17
%>
<p><%=grade(i)%>所需积分<%=point(i)%>
<%next%>
<p><%=grade(18)%>为老师或者管理员设定，可以进入特定版面。
<p><%=grade(19)%>为管理员设定，可以对论坛贴子进行管理。
<p><%=grade(20)%>总老师，拥有全部权限。
        <p>查看<a href=help.asp>所有帮助文件</a> 
<%
end sub
%>