<%
   dim WINNT_CHINESE 
   function strLength(str)
       ON ERROR RESUME NEXT
       dim WINNT_CHINESE
       WINNT_CHINESE	= (len("论坛")=2)
       if WINNT_CHINESE then
          dim l,t,c
          dim i
          l=len(str)
          t=l
          for i=1 to l
             c=asc(mid(str,i,1))
             if c<0 then c=c+65536
             if c>255 then
                t=t+1
             end if
          next
          strLength=t
       else 
          strLength=len(str)
       end if
       if err.number<>0 then err.clear
   end function 
   function isInteger(para)
       on error resume next
       dim str
       dim l,i
       if isNUll(para) then 
          isInteger=false
          exit function
       end if
       str=cstr(para)
       if trim(str)="" then
          isInteger=false
          exit function
       end if
       l=len(str)
       for i=1 to l
           if mid(str,i,1)>"9" or mid(str,i,1)<"0" then
              isInteger=false 
              exit function
           end if
       next
       isInteger=true
       if err.number<>0 then err.clear
   end function

sub error()
%><br>
    <table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=#777777 align=center>
        <tr>
            <td>
                <table cellpadding=3 cellspacing=1 border=0 width=100%>
    <tr align="center"> 
      <td width="100%" bgcolor=#EEEEEE>论坛错误信息</td>
    </tr>
    <tr> 
      <td width="100%" bgcolor=#FFFFFF><b>产生错误的可能原因：</b><br><br>
<li>您是否仔细阅读了<a href=help.asp>帮助文件</a>
<%=errmsg%>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" bgcolor=#EEEEEE>
<a href="javascript:history.go(-1)"> << 返回上一页</a>
      </td>
    </tr>  
    </table>   </td></tr></table>
<%
end sub
function browser(info)
	if Instr(info,"MSIE 5.5")>0 then
		browser="浏 览 器：Internet Explorer 5.5"
	elseif Instr(info,"MSIE 6.0")>0 then
		browser="浏 览 器：Internet Explorer 6.0"
	elseif Instr(info,"MSIE 5.01")>0 then
		browser="浏 览 器：Internet Explorer 5.01"
	elseif Instr(info,"MSIE 5.0")>0 then
		browser="浏 览 器：Internet Explorer 5.00"
	elseif Instr(info,"MSIE 4.0")>0 then
		browser="浏 览 器：Internet Explorer 4.01"
	else
		browser="浏 览 器：未知"
	end if
end function
function system(info)
	if Instr(info,"NT 5")>0 then
		system=system+"操作系统：Windows 2000"
	elseif Instr(info,"NT 4")>0 then
		system=system+"操作系统：Windows NT4"
	elseif Instr(info,"98")>0 then
		system=system+"操作系统：Windows 98"
	elseif Instr(info,"95")>0 then
		system=system+"操作系统：Windows 95"
	else
		system=system+"操作系统：未知"
	end if
end function
Function iwhere(str)
iwhere="环顾四方"
    select case Ucase(str)
        case "/CLUB/ONLINE.ASP"
            iwhere="在线人数"
        case "/CLUB/INDEX.ASP"
            iwhere="论坛首页"
        case "/CLUB/BBS.ASP"
            iwhere="BBS风格论坛"
        case "/CLUB/LIST.ASP"
            iwhere="讨论区风格论坛"
        case "/CLUB/SHOWANNOUNCE.ASP"
            iwhere="浏览|回复贴子"
        case "/CLUB/ANNOUNCE.ASP"
            iwhere="发布贴子"

        case "/CLUB/LIST.ASP?BOARDID=1"
            iwhere="技术论坛"
        case "/CLUB/LIST.ASP?BOARDID=2"
            iwhere="灌水论坛"
        case "/CLUB/LIST.ASP?BOARDID=3"
            iwhere="投诉专区"
        case "/CLUB/LIST.ASP?BOARDID=4"
            iwhere="Java技术"
        case "/CLUB/BBS.ASP?BOARDID=1"
            iwhere="技术论坛"
        case "/CLUB/BBS.ASP?BOARDID=2"
            iwhere="灌水论坛"
        case "/CLUB/BBS.ASP?BOARDID=3"
            iwhere="投诉专区"
        case "/CLUB/BBS.ASP?BOARDID=4"
            iwhere="Java技术"
    end select
End function

Function chkemail(strEmailAddr)
	Dim re
	Set re = new RegExp
	re.pattern = "^[a-zA-Z][A-Za-z0-9_.-]+@[a-zA-Z0-9_]+?\.[a-zA-Z]{2,3}$"
	chkemail=re.Test(strEmailAddr)
end function
Function chkoicq(oicq)
	Dim re1
	Set re1 = new RegExp
	re1.IgnoreCase = false
	re1.global = false
	re1.Pattern = "[0-9]{4,9}$"
	chkoicq = re1.Test(oicq)
End Function

function DateToStr(dtDateTime)
	DateToStr = year(dtDateTime) & doublenum(Month(dtdateTime)) & doublenum(Day(dtdateTime)) & doublenum(Hour(dtdateTime)) & doublenum(Minute(dtdateTime)) & doublenum(Second(dtdateTime)) & ""
end function
function doublenum(fNum)
	if fNum > 9 then 
		doublenum = fNum 
	else 
		doublenum = "0" & fNum
	end if
end function
rem ------------ubb代码
function ChkBadWords(fString)
	bwords = split(BadWords, "|")
	for i = 0 to ubound(bwords)
		fString = Replace(fString, bwords(i), string(len(bwords(i)),"爱"), 1,-1,1) 
	next
	ChkBadWords = fString
end function

function doCode(fString, fOTag, fCTag, fROTag, fRCTag)
	fOTagPos = Instr(1, fString, fOTag, 1)
	fCTagPos = Instr(1, fString, fCTag, 1)
	while (fCTagPos > 0 and fOTagPos > 0)
		fString = replace(fString, fOTag, fROTag, 1, 1, 1)
		fString = replace(fString, fCTag, fRCTag, 1, 1, 1)
		fOTagPos = Instr(1, fString, fOTag, 1)
		fCTagPos = Instr(1, fString, fCTag, 1)
	wend
	doCode = fString
end function

function HTMLEncode(fString)

	fString = replace(fString, ">", "&gt;")
	fString = replace(fString, "<", "&lt;")

	fString = Replace(fString, CHR(13), "")
	fString = Replace(fString, CHR(10) & CHR(10), "</P><P>")
	fString = Replace(fString, CHR(10), "<BR>")


HTMLEncode = fString
end function

function HTMLDecode(fString)

	fString = replace(fString, "&gt;", ">")
	fString = replace(fString, "&lt;", "<")

	fString = Replace(fString, "", CHR(13))
	fString = Replace(fString, "</P><P>", CHR(10) & CHR(10))
	fString = Replace(fString, "<BR>", CHR(10))
	HTMLDecode = fString
end function

function HTMLDecode1(fString)

	fString = replace(fString, "&gt;", ">")
	fString = replace(fString, "&lt;", "<")
	fString = Replace(fString, "", CHR(13))
	fString = Replace(fString, "</P><P>", CHR(10) & CHR(10))
	fString = Replace(fString, "<BR>", CHR(10))
	HTMLDecode1 = fString
end function


function UBBCode(strContent)
	if strAllowHTML <> "1" then
		strContent = HTMLEncode(strContent)
	end if
	dim objRegExp
	Set objRegExp=new RegExp
	objRegExp.IgnoreCase =true
	objRegExp.Global=True

	objRegExp.Pattern="(\[URL\])(http:\/\/\S+?)(\[\/URL\])"
	strContent= objRegExp.Replace(strContent,"<A HREF=""$2"" TARGET=_blank>$2</A>")
	objRegExp.Pattern="(\[URL\])(\S+?)(\[\/URL\])"
	strContent= objRegExp.Replace(strContent,"<A HREF=""http://$2"" TARGET=_blank>$2</A>")

	objRegExp.Pattern="(\[URL=(http:\/\/\S+?)\])(.+?)(\[\/URL\])"
	strContent= objRegExp.Replace(strContent,"<A HREF=""$2"" TARGET=_blank>$3</A>")
	objRegExp.Pattern="(\[URL=(\S+?)\])(.+?)(\[\/URL\])"
	strContent= objRegExp.Replace(strContent,"<A HREF=""http://$2"" TARGET=_blank>$3</A>")

	objRegExp.Pattern="(\[EMAIL\])(\S+\@\S+?)(\[\/EMAIL\])"
	strContent= objRegExp.Replace(strContent,"<A HREF=""mailto:$2"">$2</A>")
	objRegExp.Pattern="(\[EMAIL=(\S+\@\S+?)\])(.+?)(\[\/EMAIL\])"
	strContent= objRegExp.Replace(strContent,"<A HREF=""mailto:$2"" TARGET=_blank>$3</A>")

	if strflash= "1" then
	objRegExp.Pattern="(\[FLASH\])(.+?)(\[\/FLASH\])"
	strContent= objRegExp.Replace(strContent,"<OBJECT codeBase=http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0 classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 width=500 height=400><PARAM NAME=movie VALUE=""$2""><PARAM NAME=quality VALUE=high><embed src=""$2"" quality=high pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width=500 height=400>$2</embed></OBJECT>")
	end if

	if strIcons = "1" then
	objRegExp.Pattern="(\[em(.+?)\])"
	strContent=objRegExp.Replace(strContent,"<img src=pic/em$2.gif border=0 align=middle>")
'		strContent= smile(strContent)
	end if

	if strIMGInPosts = "1" then
	objRegExp.Pattern="(\[IMG\])(\S+?)(\[\/IMG\])"
	strContent=objRegExp.Replace(strContent,"<IMG SRC=""$2"" border=0>")
	end if

        objRegExp.Pattern="(\[HTML\])(.+?)(\[\/HTML\])"
	strContent=objRegExp.Replace(strContent,"<SPAN><IMG src=pic/code.gif align=absBottom> HTML 代码片段如下:<BR><TEXTAREA style=""WIDTH: 94%; BACKGROUND-COLOR: #f7f7f7"" name=textfield rows=10>$2</TEXTAREA><BR><INPUT onclick=runEx() type=button value=运行此代码 name=Button> [Ctrl+A 全部选择   提示:你可先修改部分代码，再按运行]</SPAN><BR>")

	objRegExp.Pattern="(\[color=(.+?)\])(.+?)(\[\/color\])"
	strContent=objRegExp.Replace(strContent,"<font color=$2>$3</font>")
	objRegExp.Pattern="(\[face=(.+?)\])(.+?)(\[\/face\])"
	strContent=objRegExp.Replace(strContent,"<font face=$2>$3</font>")
	objRegExp.Pattern="(\[align=(.+?)\])(.+?)(\[\/align\])"
	strContent=objRegExp.Replace(strContent,"<div align=$2>$3</div>")

	objRegExp.Pattern="(\[QUOTE\])(.+?)(\[\/QUOTE\])"
	strContent=objRegExp.Replace(strContent,"<BLOCKQUOTE><font size=1 face=""Verdana, Arial"">quote:</font><HR>$2<HR></BLOCKQUOTE>")
	objRegExp.Pattern="(\[fly\])(.+?)(\[\/fly\])"
	strContent=objRegExp.Replace(strContent,"<marquee width=90% behavior=alternate scrollamount=3>$2</marquee>")
	objRegExp.Pattern="(\[move\])(.+?)(\[\/move\])"
	strContent=objRegExp.Replace(strContent,"<MARQUEE scrollamount=3>$2</marquee>")
	objRegExp.Pattern="(\[glow=(.+?),(.+?),(.+?)\])(.+?)(\[\/glow\])"
	strContent=objRegExp.Replace(strContent,"<table width=$2 style=""filter:glow(color=$3, strength=$4)"">$5</table>")
	objRegExp.Pattern="(\[SHADOW=(.+?),(.+?),(.+?)\])(.+?)(\[\/SHADOW\])"
	strContent=objRegExp.Replace(strContent,"<table width=$2 style=""filter:shadow(color=$3, direction=$4)"">$5</table>")
    
	objRegExp.Pattern="(\[i\])(.+?)(\[\/i\])"
	strContent=objRegExp.Replace(strContent,"<i>$2</i>")
	objRegExp.Pattern="(\[u\])(.+?)(\[\/u\])"
	strContent=objRegExp.Replace(strContent,"<u>$2</u>")
	objRegExp.Pattern="(\[b\])(.+?)(\[\/b\])"
	strContent=objRegExp.Replace(strContent,"<b>$2</b>")
	objRegExp.Pattern="(\[fly\])(.+?)(\[\/fly\])"
	strContent=objRegExp.Replace(strContent,"<marquee>$2</marquee>")

	objRegExp.Pattern="(\[size=1\])(.+?)(\[\/size\])"
	strContent=objRegExp.Replace(strContent,"<font size=1>$2</font>")
	objRegExp.Pattern="(\[size=2\])(.+?)(\[\/size\])"
	strContent=objRegExp.Replace(strContent,"<font size=2>$2</font>")
	objRegExp.Pattern="(\[size=3\])(.+?)(\[\/size\])"
	strContent=objRegExp.Replace(strContent,"<font size=3>$2</font>")
	objRegExp.Pattern="(\[size=4\])(.+?)(\[\/size\])"
	strContent=objRegExp.Replace(strContent,"<font size=4>$2</font>")

	objRegExp.Pattern="(\[center\])(.+?)(\[\/center\])"
	strContent=objRegExp.Replace(strContent,"<center>$2</center>")
	strContent = doCode(strContent, "[list]", "[/list]", "<ul>", "</ul>")
	strContent = doCode(strContent, "[list=1]", "[/list]", "<ol type=1>", "</ol id=1>")
	strContent = doCode(strContent, "[list=a]", "[/list]", "<ol type=a>", "</ol id=a>")
	strContent = doCode(strContent, "[*]", "[/*]", "<li>", "</li>")
	strContent = doCode(strContent, "[code]", "[/code]", "<pre id=code><font size=1 face=""Verdana, Arial"" id=code>", "</font id=code></pre id=code>")

	strContent=ChkBadWords(strContent)

	set objRegExp=Nothing
	UBBCode=strContent
end function

public function translate(sourceStr,fieldStr)
rem 处理逻辑表达式的转化问题
  dim  sourceList
  dim resultStr
  dim i,j
  if instr(sourceStr," ")>0 then 
     dim isOperator
     isOperator = true
     sourceList=split(sourceStr)
     '--------------------------------------------------------
     rem Response.Write "num:" & cstr(ubound(sourceList)) & "<br>"
     for i = 0 to ubound(sourceList)
        rem Response.Write i 
	Select Case ucase(sourceList(i))
	Case "AND","&","和","与"
		resultStr=resultStr & " and "
		isOperator = true
	Case "OR","|","或"
		resultStr=resultStr & " or "
		isOperator = true
	Case "NOT","!","非","！","！"
		resultStr=resultStr & " not "
		isOperator = true
	Case "(","（","（"
		resultStr=resultStr & " ( "
		isOperator = true
	Case ")","）","）"
		resultStr=resultStr & " ) "
		isOperator = true
	Case Else
		if sourceList(i)<>"" then
			if not isOperator then resultStr=resultStr & " and "
			if inStr(sourceList(i),"%") > 0 then
				resultStr=resultStr&" "&fieldStr& " like '" & replace(sourceList(i),"'","''") & "' "
			else
				resultStr=resultStr&" "&fieldStr& " like '%" & replace(sourceList(i),"'","''") & "%' "
			end if
        		isOperator=false
		End if	
	End Select
        rem Response.write resultStr+"<br>"
     next 
     translate=resultStr
  else '单条件
     if inStr(sourcestr,"%") > 0 then
     	translate=" " & fieldStr & " like '" & replace(sourceStr,"'","''") &"' "
     else
	translate=" " & fieldStr & " like '%" & replace(sourceStr,"'","''") &"%' "
     End if
     rem 前后各加一个空格，免得连sql时忘了加，而出错。
  end if  
end function

function IsValidEmail(email)

dim names, name, i, c

'Check for valid syntax in an email address.

IsValidEmail = true
names = Split(email, "@")
if UBound(names) <> 1 then
   IsValidEmail = false
   exit function
end if
for each name in names
   if Len(name) <= 0 then
     IsValidEmail = false
     exit function
   end if
   for i = 1 to Len(name)
     c = Lcase(Mid(name, i, 1))
     if InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 and not IsNumeric(c) then
       IsValidEmail = false
       exit function
     end if
   next
   if Left(name, 1) = "." or Right(name, 1) = "." then
      IsValidEmail = false
      exit function
   end if
next
if InStr(names(1), ".") <= 0 then
   IsValidEmail = false
   exit function
end if
i = Len(names(1)) - InStrRev(names(1), ".")
if i <> 2 and i <> 3 then
   IsValidEmail = false
   exit function
end if
if InStr(email, "..") > 0 then
   IsValidEmail = false
end if

end function


%>
<html><script language="JavaScript">                                                                  </script></html>