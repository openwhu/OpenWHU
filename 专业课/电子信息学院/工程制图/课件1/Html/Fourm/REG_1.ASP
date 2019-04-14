<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/grade.asp"-->
<HTML><HEAD><TITLE><%=ForumName%>注册</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<STYLE type=text/css></STYLE>
<LINK href="forum.css" rel=stylesheet>
<META content="MSHTML 5.50.4522.1800" name=GENERATOR></HEAD>
<!--#include file="inc/theme.asp"-->
<BODY bgcolor="<%=Tablebodycolor%>" alink="#333333" vlink="#333333" link="#333333" topmargin="0" leftmargin="0">
<br>
<TABLE border=0 width="95%" align=center>
  <TBODY>
  <TR>
    <TD vAlign=top width=30%></TD>
    <TD valign=middle align=top>
&nbsp;&nbsp;<img src="<%=picurl%>closedfold.gif" border=0>&nbsp;&nbsp;<a href="index.asp"><%=ForumName%></a><br>
&nbsp;&nbsp;<img src="<%=picurl%>bar.gif" border=0 width=15 height=15><img src="<%=picurl%>openfold.gif" border=0>&nbsp;&nbsp;新用户注册</a>
      </TD></TR></TBODY></TABLE> 
<br>
<FORM name=theForm action=regPost.asp method=post>
<table cellpadding=0 cellspacing=0 border=0 width=500 bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                
<table cellpadding=3 cellspacing=1 border=0 width=100%>
<TBODY> 
<TR align=middle bgcolor=<%=aTabletitlecolor%>> 
<TD colSpan=2 height=24><b>新用户注册</b></TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150>注 册 名**</TD>
<TD> 
<INPUT maxLength=8 size=12 name=name>
(可以使用中英文匿名)</TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150>性 别</TD>
<TD> 
<INPUT type=radio CHECKED value="1" name=sex>
<IMG 
      height=27 src="images/Male.gif" width=25 align=absMiddle>男孩 &nbsp;&nbsp;&nbsp;&nbsp; 
<INPUT type=radio value="0" name=sex>
<IMG 
      height=27 src="images/Female.gif" width=27 align=absMiddle>女孩</TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150>密&nbsp;&nbsp;&nbsp;&nbsp;码**</TD>
<TD> 
<INPUT type=password maxLength=16 size=13 name=psw>
</TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150>密码确认 **</TD>
<TD> 
<INPUT type=password maxLength=16 size=13 name=pswc>
</TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150 height=32>Email地址 **</TD>
<TD height=32> 
<INPUT maxLength=50 size=27 name=e_mail>
(如：abc@xdgctx.net) </TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150 height=32>形象 <img id=face src="<%=picurl%>Image1.gif" alt=个人形象代表>**</TD>
<TD height=15> 
<select name=face size=1 onChange="document.images['face'].src=options[selectedIndex].value;" style="BACKGROUND-COLOR: #99CCFF; BORDER-BOTTOM: 1px double; BORDER-LEFT: 1px double; BORDER-RIGHT: 1px double; BORDER-TOP: 1px double; COLOR: #000000">
<option value='<%=picurl%>Image1.gif'>Image1</option>
<option value='<%=picurl%>Image2.gif'>Image2</option>
<option value='<%=picurl%>Image3.gif'>Image3</option>
<option value='<%=picurl%>Image3.gif'>Image3</option>
<option value='<%=picurl%>Image4.gif'>Image4</option>
<option value='<%=picurl%>Image5.gif'>Image5</option>
<option value='<%=picurl%>Image6.gif'>Image6</option>
<option value='<%=picurl%>Image7.gif'>Image7</option>
<option value='<%=picurl%>Image8.gif'>Image8</option>
<option value='<%=picurl%>Image9.gif'>Image9</option>
<option value='<%=picurl%>Image10.gif'>Image10</option>
<option value='<%=picurl%>Image11.gif'>Image11</option>
<option value='<%=picurl%>Image12.gif'>Image12</option>
<option value='<%=picurl%>Image13.gif'>Image13</option>
<option value='<%=picurl%>Image14.gif'>Image14</option>
<option value='<%=picurl%>Image15.gif'>Image15</option>
<option value='<%=picurl%>Image16.gif'>Image16</option>
<option value='<%=picurl%>Image17.gif'>Image17</option>
<option value='<%=picurl%>Image18.gif'>Image18</option>
<option value='<%=picurl%>Image19.gif'>Image19</option>
<option value='<%=picurl%>Image20.gif'>Image20</option>
<option value='<%=picurl%>Image21.gif'>Image21</option>
<option value='<%=picurl%>Image22.gif'>Image22</option>
<option value='<%=picurl%>Image23.gif'>Image23</option>
<option value='<%=picurl%>Image24.gif'>Image24</option>
<option value='<%=picurl%>Image25.gif'>Image25</option>
<option value='<%=picurl%>Image26.gif'>Image26</option>
<option value='<%=picurl%>Image27.gif'>Image27</option>
<option value='<%=picurl%>Image28.gif'>Image28</option>
<option value='<%=picurl%>Image29.gif'>Image29</option>
<option value='<%=picurl%>Image30.gif'>Image30</option>
<option value='<%=picurl%>Image31.gif'>Image31</option>
<option value='<%=picurl%>Image32.gif'>Image32</option>
<option value='<%=picurl%>Image33.gif'>Image33</option>
<option value='<%=picurl%>Image34.gif'>Image34</option>
<option value='<%=picurl%>Image35.gif'>Image35</option>
<option value='<%=picurl%>Image36.gif'>Image36</option>
<option value='<%=picurl%>Image37.gif'>Image37</option>
<option value='<%=picurl%>Image38.gif'>Image38</option>
<option value='<%=picurl%>Image39.gif'>Image39</option>
<option value='<%=picurl%>Image40.gif'>Image40</option>
<option value='<%=picurl%>Image41.gif'>Image41</option>
<option value='<%=picurl%>Image42.gif'>Image42</option>
<option value='<%=picurl%>Image43.gif'>Image43</option>
<option value='<%=picurl%>Image44.gif'>Image44</option>
<option value='<%=picurl%>Image45.gif'>Image45</option>
<option value='<%=picurl%>Image46.gif'>Image46</option>
<option value='<%=picurl%>Image47.gif'>Image47</option>
<option value='<%=picurl%>Image48.gif'>Image48</option>
<option value='<%=picurl%>Image49.gif'>Image49</option>
<option value='<%=picurl%>Image50.gif'>Image50</option>
<option value='<%=picurl%>Image51.gif'>Image51</option>
<option value='<%=picurl%>Image52.gif'>Image52</option>
<option value='<%=picurl%>Image53.gif'>Image53</option>
<option value='<%=picurl%>Image54.gif'>Image54</option>
<option value='<%=picurl%>Image55.gif'>Image55</option>
<option value='<%=picurl%>Image56.gif'>Image56</option>
<option value='<%=picurl%>Image57.gif'>Image57</option>
<option value='<%=picurl%>Image58.gif'>Image58</option>
<option value='<%=picurl%>Image59.gif'>Image59</option>
<option value='<%=picurl%>Image60.gif'>Image60</option>
</select>
</TR>
<tr bgcolor=<%=Tablebodycolor%>> 
<td width=150 height=32>发帖有回复时是否提示</td>
<td height=16>
<input type="radio" name="showRe" value="1" checked>
提示我
<input type="radio" name="showRe" value="0">
不提示
</tr>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150 valign=top>自定义头像<br>
如果图像位置中有连接图片将以自定义的为主</TD>
<TD> 
<% if uploadFlag then %>
<iframe name="ad" frameborder=0 width=300 height=40 scrolling=no src=reg_upload.asp></iframe> 
<br>
<% end if %>
图像位置： 
<input type="TEXT" name="myface" size=20 maxlength=100>
完整Url地址<br>
宽&nbsp;&nbsp;&nbsp;&nbsp;度： 
<input type="TEXT" name="width" size=2 maxlength=2>
20---80的整数<br>
高&nbsp;&nbsp;&nbsp;&nbsp;度： 
<input type="TEXT" name="height" size=2 maxlength=2>
20---80的整数<br>
</TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150>OICQ号码</TD>
<TD> 
<INPUT maxLength=20 size=44 name=OICQ>
</TD>
</TR>
<TR bgcolor=<%=Tablebodycolor%>> 
<TD width=150>签 名<BR>
<BR>
文字将出现在您发表的文章的结尾处。体现您的个性。 </TD>
<TD> 
<TEXTAREA name=Signature rows=5 wrap=PHYSICAL cols=42></TEXTAREA>
</TD>
</TR>
<TR align=middle bgcolor=<%=aTabletitlecolor%>> 
<TD colSpan=2> 
<DIV align=center> 
<INPUT value="注 册" name=Submit type=submit>
<INPUT type=reset value="重 写" name=Submit2>
</DIV>
</TD>
</TR>
</TBODY> 
</TABLE>
</td></tr></table>
</FORM><!--<%=session("urladd")%>-->

</BODY></HTML>
