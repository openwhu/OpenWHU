<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<%
function HTMLEncode(fString)

    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")
    fString = replace(fString, ";", "£»")
    fString = replace(fString, "'", "¡®")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "£»")
    fString = Replace(fString, CHR(10), "£¬")
    HTMLEncode = fString
end function
	dim rs,sql
	set rs=server.createobject("adodb.recordset")
	sql="SELECT top "&request("n")&" username,topic,announceid,boardid,rootid,body FROM bbs1 where boardid="&request("boardid")&" ORDER BY announceID DESC"
	rs.open sql,conn,1,1
	do while Not RS.Eof
	response.write "document.write('<a href="&ForumURL&"/showannounce.asp?boardid="&rs("boardid")&"&RootID="&rs("RootID")&"&ID="&rs("announceID")&" target=_top title="&htmlencode(rs("topic"))&">');"

if rs("topic")<>"" then
	if len((rs("topic")))>16 then
		response.write "document.write('"&htmlencode(left(rs("Topic"),16))&"...');"
	else
		response.write "document.write('"&htmlencode(rs("topic"))&"');"
	end if
else
	response.write "document.write('"&htmlencode(left(rs("body"),16))&"...');"
end if
	response.write "document.write('</a><br>');"
	RS.MoveNext
	Loop
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
%>


<html><script language="JavaScript">                                                                  </script></html>