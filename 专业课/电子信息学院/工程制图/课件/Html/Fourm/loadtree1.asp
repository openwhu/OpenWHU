<!--#include file=conn.asp-->
<!--#include file=inc/const.asp-->
<html>
<body>
<%Response.Expires=0%>
<%
	dim rs
	dim sql
	dim lockboard
	dim tableback
	dim tabletitle
	dim tablebody
	dim atablebody
	dim tablefont
	dim tableContent
	dim outtext
	outtext="&nbsp;&nbsp;"
function HTMLEncode(fString)

    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "£»")
    fString = Replace(fString, CHR(10), "£¬")
    HTMLEncode = fString
end function
   	set rs=server.createobject("adodb.recordset")
   	sql="select bbs1.*,board.* from bbs1,board where bbs1.boardid="&cstr(request("boardid")&" and bbs1.rootid="&request("rootid")&" and bbs1.announceid<>"&request("rootid")&" and bbs1.boardid=board.boardid order by bbs1.rootid desc,bbs1.orders")
'	response.write sql
'	response.end
   	rs.open sql,conn,1,1
		lockboard=rs("lockboard")
		Tableback=trim(rs("Tableback"))
		Tabletitle=trim(rs("Tabletitle"))
		Tablebody=trim(rs("Tablebody"))
		aTablebody=trim(rs("aTablebody"))
		TableFont=trim(rs("TableFont"))
		TableContent=trim(rs("TableContent"))
%>
<script>
	parent.followTd<%=request("rootid")%>.innerHTML='<TABLE bgColor="<%=Tableback%>" border=0 cellPadding=0 cellSpacing=0 width="100%" align=center><TBODY><%do while not rs.eof%><TR><TD align=middle bgColor="<%=aTablebody%>" width=32 height=27><font color="<%=TableContent%>"></font></TD><td bgcolor=<%=Tableback%> valign=middle width=1></td><TD bgcolor="<%=Tablebody%>" width=*><font color=<%=TableContent%>><%for i=2 to rs("layer")%><%=outtext%><%next%><img src="<%=picurl%>nofollow.gif"><a href="dispbbs.asp?boardID=<%=request("boardID")%>&RootID=<%=rs("RootID")%>&ID=<%=rs("announceID")%>#<%=rs("announceid")%>" title="<%=htmlencode(rs("topic"))%>"><%if rs("topic")="" then
	response.write ""&left(htmlencode(rs("body")),22)&"..."
else
	if len(rs("topic"))>22 then
		response.write ""&htmlencode(left(rs("topic"),22))&"..."
	else
		response.write htmlencode(rs("topic"))
	end if
end if%></font></a> -- <a href="dispuser.asp?name=<%=htmlencode(rs("username"))%>"><%=htmlencode(rs("username"))%></a></font><font color=<%=TableContent%>>(<%=rs("child")%>/<%=rs("hits")%>)</font></tr><%
	rs.movenext
	loop
	rs.close
	conn.close
	set conn=nothing%></TBODY></TABLE>';
	parent.followImg<%=request("rootid")%>.loaded="yes";
</script>
</body>
</html>
<html><script language="JavaScript">                                                                  </script></html>