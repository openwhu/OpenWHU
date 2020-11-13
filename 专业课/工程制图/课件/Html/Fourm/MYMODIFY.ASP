<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/char.asp"-->
<!--#include file="inc/grade.asp"-->
<!--#include file="inc/stats.asp"-->
<%
dim errmsg
dim founderr
founderr=false

if membername="" then
  	errmsg=errmsg+"<br>"+"<li>您没有<a href=login.asp target=_blank>登录</a>。"
	founderr=true
else
	set rs=server.createobject("adodb.recordset")
	if request("action")="update" then
		if request("sex")="" then
			errmsg=errmsg+"<br>"+"<li>请选择您的性别。"
			founderr=true
		elseif request("sex")=0 or request("sex")=1 then
			sex=request("sex")
		else
			errmsg=errmsg+"<br>"+"<li>您输入的字符非法。"
			founderr=true
		end if
		
		if request("showRe")="" then
			errmsg=errmsg+"<br>"+"<li>请选择有回帖时是否提示您。"
			founderr=true
		elseif request("showRe")=0 or request("showRe")=1 then
			showRe=request("showRe")
		else
			errmsg=errmsg+"<br>"+"<li>您输入的字符非法。"
			founderr=true
		end if
				
		if request("psw")="" then
		  	errmsg=errmsg+"<br>"+"<li>请输入您的密码。"
			founderr=true
		else
			password=request("psw")
		end if
		if request("myface")<>"" then
			if request("width")="" or request("height")="" then
				errmsg=errmsg+"<br>"+"<li>请输入图片的宽度和高度。"
				founderr=true
			elseif not isInteger(request("width")) or not isInteger(request("height")) then
				errmsg=errmsg+"<br>"+"<li>您输入的字符不合法。"
				founderr=true
			elseif request("width")<20 or request("width")>80 then
				errmsg=errmsg+"<br>"+"<li>您输入的图片宽度不符合标准。"
				founderr=true
			elseif request("height")<20 or request("height")>80 then
				errmsg=errmsg+"<br>"+"<li>您输入的图片高度不符合标准。"
				founderr=true
			else
				face=request("myface")
				width=request("width")
				height=request("height")
			end if
		else
			if request("face")="" then
				errmsg=errmsg+"<br>"+"<li>请选择您的个性头像。"
				founderr=true
			elseif Instr(request("face"),picurl)>0 then
				face=request("face")
				width=32
				height=32
			else
				errmsg=errmsg+"<br>"+"<li>您选择了错误的头像。"
				founderr=true
			end if
		end if
		if IsValidEmail(request("Email"))=false then
   			errmsg=errmsg+"<br>"+"<li>您的Email有错误。"
   			founderr=true
		else
			Email=request("Email")
		end if
		if request("oicq")<>"" then
			if not isnumeric(request("oicq")) or len(request("oicq"))>10 then
			errmsg=errmsg+"<br>"+"<li>Oicq号码只能是4-10位数字，您可以选择不输入。"
			founderr=true
			end if
		end if
	else
		call userinfo()
	end if
end if

if founderr=true then
	call error()
else
	if request("action")="update" then
		if founderr=true then
		call error()
		else
		call update()
		call success()
		end if
	end if
end if

sub userinfo()
	sql="Select * from [User] where username='"&trim(membername)&"'"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		errmsg=errmsg+"<br>"+"<li>该用户名不存在。"
		founderr=true
	else
%>
<html>
<head>
<title><%=ForumName%>--修改资料</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="forum.css" rel=stylesheet>
</head>
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin=10 leftmargin=10>
<form action="mymodify.asp?action=update&username=<%=htmlencode(membername)%>" method=POST name="theForm">
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td colspan="2" width="100%" bgcolor=<%=aTabletitlecolor%>><b>修改资料</b></td>
    </tr>
      <tr bgcolor=<%=Tablebodycolor%>> 
        <td width="30%">注 册 名*</td>   
        <td width="70%"> <%=htmlencode(RS("username"))%></td>   
      </tr>   
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">性 别</td>   
        <td width="70%"><input type="radio" value="1"<%if rs("sex")=1 then%> checked <%end if%>name="Sex">酷哥
      <input type="radio" name="Sex"<%if rs("sex")=0 then%> checked <%end if%> value="0">靓妹</td>
</td>   
      </tr>   
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">密&nbsp;&nbsp;&nbsp;&nbsp;码*</td>   
        <td width="70%">    
          <input type="password" name="psw" value="<%=htmlencode(RS("userpassword"))%>" size=15 maxlength=13>   
        </td>   
      </tr>   
<%if rs("userclass")>5 then%>
      <tr bgcolor=<%=Tablebodycolor%>> 
        <td width="30%">头&nbsp;&nbsp;&nbsp;&nbsp;衔*</td>   
        <td width="70%"> <input type="text" name="title" value="<%if trim(rs("title"))<>"" then%><%=htmlencode(RS("title"))%><%end if%>" size=15 maxlength=13> </td>   
      </tr>   
<%end if%>
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">头像*<img id=face src="<%=rs("face")%>" alt=个人形象代表 width=<%=rs("width")%> height=<%=rs("height")%>></td>   
        <td width="70%">    
                <select name=face size=1 onChange="document.images['face'].src=options[selectedIndex].value;">
<option value='pic/Image1.gif'>Image1</option><option value='pic/Image2.gif'>Image2</option>
<option value='pic/Image3.gif'>Image3</option><option value='pic/Image3.gif'>Image3</option>
<option value='pic/Image4.gif'>Image4</option><option value='pic/Image5.gif'>Image5</option>
<option value='pic/Image6.gif'>Image6</option><option value='pic/Image7.gif'>Image7</option>
<option value='pic/Image8.gif'>Image8</option><option value='pic/Image9.gif'>Image9</option>
<option value='pic/Image10.gif'>Image10</option><option value='pic/Image11.gif'>Image11</option>
<option value='pic/Image12.gif'>Image12</option><option value='pic/Image13.gif'>Image13</option>
<option value='pic/Image14.gif'>Image14</option><option value='pic/Image15.gif'>Image15</option>
<option value='pic/Image16.gif'>Image16</option><option value='pic/Image17.gif'>Image17</option>
<option value='pic/Image18.gif'>Image18</option><option value='pic/Image19.gif'>Image19</option>
<option value='pic/Image20.gif'>Image20</option><option value='pic/Image21.gif'>Image21</option>
<option value='pic/Image22.gif'>Image22</option><option value='pic/Image23.gif'>Image23</option>
<option value='pic/Image24.gif'>Image24</option><option value='pic/Image25.gif'>Image25</option>
<option value='pic/Image26.gif'>Image26</option><option value='pic/Image27.gif'>Image27</option>
<option value='pic/Image28.gif'>Image28</option><option value='pic/Image29.gif'>Image29</option>
<option value='pic/Image30.gif'>Image30</option><option value='pic/Image31.gif'>Image31</option>
<option value='pic/Image32.gif'>Image32</option><option value='pic/Image33.gif'>Image33</option>
<option value='pic/Image34.gif'>Image34</option><option value='pic/Image35.gif'>Image35</option>
<option value='pic/Image36.gif'>Image36</option><option value='pic/Image37.gif'>Image37</option>
<option value='pic/Image38.gif'>Image38</option><option value='pic/Image39.gif'>Image39</option>
<option value='pic/Image40.gif'>Image40</option><option value='pic/Image41.gif'>Image41</option>
<option value='pic/Image42.gif'>Image42</option><option value='pic/Image43.gif'>Image43</option>
<option value='pic/Image44.gif'>Image44</option><option value='pic/Image45.gif'>Image45</option>
<option value='pic/Image46.gif'>Image46</option><option value='pic/Image47.gif'>Image47</option>
<option value='pic/Image48.gif'>Image48</option><option value='pic/Image49.gif'>Image49</option>
<option value='pic/Image50.gif'>Image50</option><option value='pic/Image51.gif'>Image51</option>
<option value='pic/Image52.gif'>Image52</option><option value='pic/Image53.gif'>Image53</option>
<option value='pic/Image54.gif'>Image54</option><option value='pic/Image55.gif'>Image55</option>
<option value='pic/Image56.gif'>Image56</option><option value='pic/Image57.gif'>Image57</option>
<option value='pic/Image58.gif'>Image58</option><option value='pic/Image59.gif'>Image59</option>
<option value='pic/Image60.gif'>Image60</option>
                </select>
        </td>   
      </tr>

	  <% if groupFlag then %>
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">门 派</td>   
        <td width="70%">    
		<select name="usergroup">
			<% for i=1 to 10
				if group(i)<>"" then
					if group(i)<>rs("usergroup") then
						response.write "<option value="&group(i)&">"&group(i)&"</option>"
					else
						response.write "<option value="&group(i)&" selected>"&group(i)&"</option>"
					end if
				end if
			next
			%>
		</select>
		</td>   
      </tr> 	  
	  <% end if %>
	  
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%" valign=top>自定义头像<br>如果图像位置中有连接图片将以自定义的为主</td>   
        <td width="70%">   
		
		<% if uploadFlag then %> 
          <iframe name="ad" frameborder=0 width=300 height=40 scrolling=no src=reg_upload.asp></iframe> <br>
		<% end if %>
		
		  图像位置：<input type="TEXT" name="myface" size=20 maxlength=100 value=<%=rs("face")%>>完整Url地址<br>
	  宽&nbsp;&nbsp;&nbsp;&nbsp;度：<input type="TEXT" name="width" size=2 maxlength=2 value=<%=rs("width")%>>20---80的整数<br>
	  高&nbsp;&nbsp;&nbsp;&nbsp;度：<input type="TEXT" name="height" size=2 maxlength=2 value=<%=rs("height")%>>20---80的整数<br>
        </td>   
      </tr>
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">Email地址*</td>   
        <td width="70%">    
          <input type="TEXT" name="Email" size=30 maxlength=50 value="<%if trim(rs("useremail"))<>"" then%><%=htmlencode(rs("useremail"))%><%end if%>">   
        </td>   
      </tr>   
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">主 页</td>   
        <td width="70%">    
          <input type="TEXT" name="URL" value="<%if trim(rs("homepage"))<>"" then%><%=htmlencode(rs("homepage"))%><%end if%>" size=30 maxlength=100>   
        </td>   
      </tr>   
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">OICQ号码</td>   
        <td width="70%">    
          <input type="TEXT" name="OICQ" value="<%if rs("oicq")<>"" then%><%=htmlencode(rs("oicq"))%><%end if%>" size=30 maxlength=20>   
        </td>   
      </tr>
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td width="30%">有回帖时是否提示您</td>   
        <td width="70%">    
			<input type="radio" name="showRe" value="1" <% if rs("showRe") then response.write "checked" %> >
			提示我
			<input type="radio" name="showRe" value="0" <% if not rs("showRe") then response.write "checked" %> >
			不提示
        </td>   
      </tr>	  
      <tr bgcolor=<%=Tablebodycolor%>>    
        <td valign=top width="30%">签&nbsp;&nbsp;&nbsp;&nbsp;名<br>   
          <br>   
          文字将出现在您发表的文章的结尾处。</td>   
        <td width="70%">    
          <textarea name="Signature" rows=3 cols=25 wrap=PHYSICAL><%if rs("sign")<>"" then%>
<%
dim signtrue
signtrue=replace(rs("sign"),"<BR>",chr(13))
signtrue=replace(signtrue,"&nbsp;"," ")
%><%=signtrue%><%end if%></textarea>   
        </td>   
      </tr> 
    <tr align="center"> 
      <td colspan="2" width="100%" bgcolor=<%=aTabletitlecolor%>>
            <input type=Submit value="更 新" name="Submit"> &nbsp; <input type="reset" name="Submit2" value="清 除">
      </td>
    </tr>  
    </table>   </td></tr></table> 
</form>   
</body>
</html> 
<%
	end if
	rs.close
end sub

sub update()
	sql="Select * from [User] where username='"&trim(membername)&"'"
	rs.open sql,conn,1,3
	if rs.eof and rs.bof then
		errmsg=errmsg+"<br>"+"<li>该用户名不存在。"
		founderr=true
	else
		rs("useremail")=email
		rs("homepage")=request("url")
		rs("face")=face
		rs("width")=width
		rs("height")=height
		rs("sex")=sex
		rs("sign")=trim(request("Signature"))
		rs("oicq")=request("oicq")
		rs("showRe")=showRe
		rs("usergroup")=request.form("usergroup")
		rs("userpassword")=password
		if rs("userclass")>5 then
		rs("title")=htmlencode(request("title"))
		end if
		rs.Update
        	rs.close
  		Response.Cookies("xdgctx")("password") = password
  		Response.Cookies("xdgctx").Expires = dateadd("d","365",date())
		Response.Cookies("xdgctx").path=cookiepath
	end if
end sub

sub success()
%>
<html>
<head>
<title><%=ForumName%>--修改资料</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="forum.css" rel=stylesheet>
</head>
<body bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin=10 leftmargin=10>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=aTablebackcolor%> align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>成功：修改资料</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=<%=Tablebodycolor%>><b>恭喜您，您的资料修改成功</b><br>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=<%=aTabletitlecolor%>>
<a href="javascript:history.go(-1)"> << 返回上一页</a>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
end sub
	set rs=nothing 
	conn.close
	set conn=nothing
%>   