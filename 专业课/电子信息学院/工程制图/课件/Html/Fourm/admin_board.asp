<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="conn.asp"-->
<!-- #include file="inc/const.asp" -->
<!--#include file=inc/char.asp-->
<!--#include file=admin_left.asp-->
<title><%=ForumName%>--管理页面</title>
<link rel="stylesheet" type="text/css" href="forum.css">

<BODY bgcolor="#ffffff" alink="#333333" vlink="#333333" link="#333333" topmargin="20">
<%
	dim str

	if session("masterlogin")<>"superadmin" then
		Errmsg=Errmsg+"<br>"+"<li>本页面为管理员专用，请<a href=elogin.asp>登陆管理</a>后进入。"
		call Error()
	else
		dim Errmsg
		dim Founderr
		call main()
		conn.close
		set conn=nothing
	end if

	sub main()
%>
<table cellpadding=0 cellspacing=0 border=0 width=95% bgcolor=<%=atablebackcolor%> align=center>
  <tr>
    <td>
      <table cellpadding=3 cellspacing=1 border=0 width=100%>
        <tr bgcolor='<%=aTabletitlecolor%>'>
        <td align=center colspan="2">欢迎<b>
<%=session("mastername")%></b>进入管理页面
        </td>
        </tr>
            <tr bgcolor=<%=tablebodycolor%>>
              
          <td width="20%" valign=top> 
            <%call left()%>
            </td>
              
          <td width="80%" valign=top> 
            <table width="100%" border="0" cellspacing="3" cellpadding="0">
              <tr>
                <td>1．注意事项： 在下面，您将看到目前所有的论坛分类。您可以编辑论坛分类名或是增加一个新的论坛到这个分类中。 也可以编辑或删除目前存在的论坛。您可以对目前的分类重新进行排列。 
                   <p><font color=<%=AlertFontColor%>>2.特别注意</font>：删除论坛同时将删除该论坛下所有帖子！删除分类同时删除下属论坛和其中贴子！ 操作时请完整填写表单信息。
                </td>
              </tr>
              <tr>
              <td>
              <p align=cetner><b><a href=admin_board.asp>论坛管理</a> | <a href="admin_board.asp?action=addclass">新建论坛分类</a></p>
              </td>
              <tr>
            </table>
<%
if Request("action") = "add" then
	call add()
elseif Request("action") = "edit" then
	call edit()
elseif request("action") = "savenew" then
	call savenew()
elseif request("action") = "savedit" then
	call savedit()
elseif request("action") = "del" then
	call del()
elseif request("action") = "orders" then
	call orders()
elseif request("action") = "updateorders" then
	call updateorders()
elseif request("action") = "addclass" then
	call addclass()
elseif request("action") = "saveclass" then
	call saveclass()
elseif request("action") = "del1" then
	call del1()
else
	call boardinfo()
end if
end sub

sub add()
%>
 <form action ="admin_board.asp?action=savenew" method=post>
<%
	set rs = server.CreateObject ("Adodb.recordset")
	sql="select boardid from board"
	rs.open sql,conn,1,1
	boardnum=rs.recordcount
	rs.close
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr bgcolor=<%=aTableTitlecolor%>> 
<td width="52%" height=22><b>字段名称：</b> </td>
<td width="48%"><b>变量值：</b> </td>
</tr>
<tr> 
<td width="52%">论坛序号（注意不能和别的论坛序号相同）</td>
<td width="48%"> 
<input type="text" name="boardid" size="24" value=<%=boardnum+1%>>
</td>
</tr>
<tr> 
<td width="52%">论坛名</td>
<td width="48%"> 
<input type="text" name="boardtype" size="24">
</td>
</tr>
<tr> 
<td width="52%">所属类别</td>
<td width="48%"> 
<select name=class>
<%
	sql = "select * from class"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
	response.write "<option value=>请先添加类别"
	else
	do while not rs.EOF
%>
<option value=<%=rs("id")%>><%=rs("class")%> 
<%
	rs.MoveNext 
	loop
	end if
	rs.Close 
%>
</select>
</td>
</tr>
<tr> 
<td width="52%">版面说明</td>
<td width="48%"> 
<input type="text" name="readme" size="24">
</td>
</tr>
<tr> 
<td width="52%">斑竹(多斑竹添加请用|分隔，如：沙滩小子|wodeail)：</td>
<td width="48%"> 
<input type="text" name="boardmaster" size="24">
</td>
</tr>
<tr> 
<td width="52%">锁定版面(0开放，1锁定，2特定用户开放)</td>
<td width="48%"> 
<select name="lockboard">
<option value="0" selected>0 
<option value="1">1 
<option value="2">2 
</select>
</td>
</tr>
<tr> 
<td width="52%">版面表格边框颜色</td>
<td width="48%"> 
<input type="text" name="Tableback" size="24" value="<%=tablebackcolor%>">
</td>
</tr>
<tr> 
<td width="52%">版面标题表格颜色</td>
<td width="48%"> 
<input type="text" name="Tabletitle" size="24" value="<%=tabletitlecolor%>">
</td>
</tr>
<tr> 
<td width="52%">版面内容表格颜色1</td>
<td width="48%"> 
<input type="text" name="Tablebody" size="24" value="<%=tablebodycolor%>">
</td>
</tr>
<tr> 
<td width="52%">版面内容表格颜色2，颜色1和颜色2在bbs风格中互相穿插排列</td>
<td width="48%"> 
<input type="text" name="aTablebody" size="24" value="#FFFFFF">
</td>
</tr>
<tr> 
<td width="52%">版面标题表格字体颜色</td>
<td width="48%"> 
<input type="text" name="TableFont" size="24" value="<%=tableFontcolor%>">
</td>
</tr>
<tr> 
<td width="52%">版面内容表格字体颜色</td>
<td width="48%"> 
<input type="text" name="TableContent" size="24" value="<%=tableContentcolor%>">
</td>
</tr>
<tr> 
<td width="52%">提醒语句颜色</td>
<td width="48%"> 
<input type="text" name="AlertFont" size="24" value="<%=AlertFontcolor%>">
</td>
</tr>
<tr> 
<td width="52%">论坛Logo地址</td>
<td width="48%"> 
<input type="text" name="Logo" size="35" value="<%=logo%>">
</td>
</tr>
<tr> 
<td width="52%">首页显示论坛图片</td>
<td width="48%"> 
<input type="text" name="indexIMG" size="35" value="">
</td>
</tr>
<tr> 
<td width="52%">UBB标签</td>
<td width="48%"> 
<select name="strAllowForumCode">
<option value="0">不使用 
<option value="1" selected>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">HTML标签</td>
<td width="48%"> 
<select name="strAllowHTML">
<option value="0" selected>不使用 
<option value="1">使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">贴图标签</td>
<td width="48%"> 
<select name="strIMGInPosts">
<option value="0">不使用 
<option value="1" selected>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">Flash标签</td>
<td width="48%"> 
<select name="strflash">
<option value="0">不使用 
<option value="1" selected>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">表情标签</td>
<td width="48%"> 
<select name="strIcons">
<option value="0">不使用 
<option value="1" selected>使用 
</select>
</td>
</tr>
<tr bgcolor="<%=atabletitlecolor%>"> 
<td width="52%">&nbsp;</td>
<td width="48%"> 
<input type="submit" name="Submit" value="添加论坛">
</td>
</tr>
</table>
</form>
<%
end sub

sub edit()
%>
 <form action ="admin_board.asp?action=savedit" method=post>           
<%
set rs_c= server.CreateObject ("adodb.recordset")
sql = "select * from class"
rs_c.open sql,conn,1,1
set rs= server.CreateObject ("adodb.recordset")
sql = "select * from board where boardid="+CSTr(request("editid"))
rs.open sql,conn,1,1
%>            
<input type='hidden' name=editid value='<%=Request("editid")%>'>
            
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr bgcolor=<%=aTableTitleColor%>> 
<td width="52%" height=22><b>字段名称：</b> </td>
<td width="48%"> 
<div align="center"><b>变量值：</b></div>
</td>
</tr>
<tr> 
<td width="52%">论坛序号（注意不能和别的论坛序号相同）</td>
<td width="48%"> 
<input type="text" name="newboardid" size="3"  value = '<%=rs("boardid")%>'>
</td>
</tr>
<tr> 
<td width="52%">论坛名</td>
<td width="48%"> 
<input type="text" name="boardtype" size="24"  value = '<%=rs("boardtype")%>'>
</td>
</tr>
<tr> 
<td width="52%">所属类别</td>
<td width="48%"> 
<select name=class>
<% do while not rs_c.EOF%>
<option value=<%=rs_c("id")%> <% if rs("class") = rs_c("id") then%> selected <%end if%>><%=rs_c("class")%> 
<%
rs_c.MoveNext 
loop
rs_c.Close 
%>
</select>
</td>
</tr>
<tr> 
<td width="52%">版面说明</td>
<td width="48%"> 
<input type="text" name="readme" size="24" value='<%=rs("readme")%>'>
</td>
</tr>
<tr> 
<td width="52%">斑竹(多斑竹添加请用|分隔，如：沙滩小子|wodeail)：</td>
<td width="48%"> 
<input type="text" name="boardmaster" size="24"  value='<%=rs("boardmaster")%>'>
</td>
</tr>
<tr> 
<td width="52%">锁定版面(0开放，1锁定，2特定用户开放)</font></td>
<td width="48%"> 
<select name="lockboard">
<option value="0" <%if rs("lockboard")=0 then%>selected<%end if%>>0 
<option value="1" <%if rs("lockboard")=1 then%>selected<%end if%>>1 
<option value="2" <%if rs("lockboard")=2 then%>selected<%end if%>>2 
</select>
</td>
</tr>
<tr> 
<td width="52%">版面表格边框颜色</td>
<td width="48%"> 
<input type="text" name="Tableback" size="24"  value='<%=rs("Tableback")%>'>
</td>
</tr>
<tr> 
<td width="52%">版面标题表格颜色</td>
<td width="48%"> 
<input type="text" name="Tabletitle" size="24"  value='<%=rs("Tabletitle")%>'>
</td>
</tr>
<tr> 
<td width="52%">版面内容表格颜色1</td>
<td width="48%"> 
<input type="text" name="Tablebody" size="24"  value='<%=rs("Tablebody")%>'>
</td>
</tr>
<tr > 
<td width="52%">版面内容表格颜色2，颜色1和颜色2在bbs风格中互相穿插排列</td>
<td width="48%"> 
<input type="text" name="aTablebody" size="24"  value='<%=rs("aTablebody")%>'>
</td>
</tr>
<tr> 
<td width="52%">版面标题表格字体颜色</td>
<td width="48%"> 
<input type="text" name="TableFont" size="24"  value='<%=rs("Tablefont")%>'>
</td>
</tr>
<tr> 
<td width="52%">版面内容表格字体颜色</td>
<td width="48%"> 
<input type="text" name="TableContent" size="24"  value='<%=rs("TableContent")%>'>
</td>
</tr>
<tr> 
<td width="52%">提醒语句颜色</td>
<td width="48%"> 
<input type="text" name="AlertFont" size="24"  value='<%=rs("AlertFont")%>'>
</td>
</tr>
<tr> 
<td width="52%">论坛Logo地址</td>
<td width="48%"> 
<input type="text" name="Logo" size="35" value="<%=rs("forumLogo")%>">
</td>
</tr>
<tr> 
<td width="52%">首页显示论坛图片</td>
<td width="48%">
<input type="text" name="indexIMG" size="35" value="<%=rs("indexIMG")%>">
</td>
</tr>
<tr> 
<td width="52%">UBB标签</td>
<td width="48%"> 
<select name="strAllowForumCode">
<option value="0" <%if rs("strallowForumCode")=0 then%>selected<%end if%>>不使用 
<option value="1" <%if rs("strallowForumCode")=1 then%>selected<%end if%>>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">HTML标签</td>
<td width="48%"> 
<select name="strAllowHTML">
<option value="0" <%if rs("strallowHTML")=0 then%>selected<%end if%>>不使用 
<option value="1" <%if rs("strallowHTML")=1 then%>selected<%end if%>>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">贴图标签</td>
<td width="48%"> 
<select name="strIMGInPosts">
<option value="0" <%if rs("strIMGInPosts")=0 then%>selected<%end if%>>不使用 
<option value="1" <%if rs("strIMGInPosts")=1 then%>selected<%end if%>>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">Flash标签</td>
<td width="48%"> 
<select name="strflash">
<option value="0" <%if rs("strflash")=0 then%>selected<%end if%>>不使用 
<option value="1" <%if rs("strflash")=1 then%>selected<%end if%>>使用 
</select>
</td>
</tr>
<tr> 
<td width="52%">表情标签</td>
<td width="48%"> 
<select name="strIcons">
<option value="0" <%if rs("strIcons")=0 then%>selected<%end if%>>不使用 
<option value="1" <%if rs("strIcons")=1 then%>selected<%end if%>>使用 
</select>
</td>
</tr>
<tr bgcolor=<%=aTableTitleColor%>> 
<td width="52%">&nbsp;</td>
<td width="48%"> 
<input type="submit" name="Submit" value="提交">
</td>
</tr>
</table>
</form>
<%
rs.close
end sub

sub boardinfo()
	    set rs_1 = server.CreateObject ("adodb.recordset")
            set rs_2 = server.CreateObject ("adodb.recordset")
            sql_2 = "select * from class order by id"
            rs_2.Open sql_2,conn,1,1
	    do while not rs_2.Eof
%>
            <table width="100%" border="0" cellspacing="3" cellpadding="0">
              <tr bgcolor="<%=aTableTitleColor%>">

                <td height="21"><%=rs_2("id")%>,分类名：<b><%=rs_2("class")%></b>    <a href="admin_board.asp?action=add">新增论坛</a> | <a href=admin_board.asp?action=orders&id=<%=rs_2("id")%>>分类排序修改</a> | <a href=admin_board.asp?action=del1&id=<%=rs_2("id")%>>删除分类</a></td>
              </tr>
            </table>
<%
            sql_1 = "select boardid,boardtype,readme from board where class="&rs_2("id")&" order by boardid"
            rs_1.Open sql_1,conn,1,1
            do while not rs_1.EOF 
            %>
            <table width="100%" border="0" cellspacing="3" cellpadding="0">
              <tr> 
                <td height="18"><%=rs_1("boardid")%>,论坛名：<%=rs_1("boardtype")%></td>
              </tr>
              <tr>
                <td height="18">论坛简介：<%=rs_1("readme")%></td>
              </tr>
              <tr>
                <td height="15"><a href="admin_board.asp?action=edit&editid=<%=rs_1("boardid")%>">编辑此论坛</a> | <a href="admin_board.asp?action=del&boardid=<%=rs_1("boardid")%>">删除此论坛</a></td>
              </tr>
            </table>
<hr color=black height=1 width="70%" align=left>
<%
		  rs_1.MoveNext
		  loop
                  rs_1.Close 
        rs_2.MoveNext 
        Loop
        rs_2.Close
%>
          </td>
            </tr>
        </table>      
        </td>
       </tr>
</table>
<%
end sub

sub savenew()
	set rs = server.CreateObject ("adodb.recordset")
	if request("boardtype")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入论坛名称。"
		Founderr=true
	end if
	if request("class")="" then
		Errmsg=Errmsg+"<br>"+"<li>请选择论坛分类。"
		Founderr=true
	end if
	if request("boardmaster")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入老师姓名。"
		Founderr=true
	end if
	if request("readme")="" then
		Errmsg=Errmsg+"<br>"+"<li>请输入论坛说明。"
		Founderr=true
	end if
	if request("lockboard")="" then
		Errmsg=Errmsg+"<br>"+"<li>请选择论坛开放状态。"
		Founderr=true
	end if
	if founderr=true then
	response.write ""&Errmsg&""
	else
		dim boardid
		sql="select boardid from board where boardid="+cstr(request("boardid"))
		rs.open sql,conn,1,1
		if not rs.eof and not rs.bof then
			response.write "您不能指定和别的论坛一样的序号。"
			exit sub
		else
			boardid=request("boardid")
		end if
		rs.close
	sql = "select * from board"
	rs.Open sql,conn,1,3
	rs.AddNew
	rs("boardid") = Request("boardid")
	rs("boardtype") = Request.Form ("boardtype")
	rs("class") = Request.Form  ("class")
	rs("boardmaster") = Request("boardmaster")
	rs("readme") = Request("readme")
	rs("lockboard") = Request("lockboard")
	rs("Tableback") = Request("Tableback")
	rs("Tabletitle") = Request("Tabletitle")
	rs("Tablebody") = Request("Tablebody")
	rs("aTablebody") = Request("aTablebody")
	rs("TableFont") = Request("TableFont")
	rs("TableContent") = Request("TableContent")
	rs("AlertFont") = Request("AlertFont")
	rs("Forumlogo") = Request("Logo")
	rs("indexIMG")=request.form("indexIMG")
	rs("strAllowForumCode") = Request("strAllowForumCode")
	rs("strAllowHTML") = Request("strAllowHTML")
	rs("strIMGInPosts") = Request("strIMGInPosts")
	rs("strIcons") = Request("strIcons")
	rs("strflash") = Request("strflash")
	rs("lastpostuser") ="未知"
	rs("lastposttime") = now()
	rs("lasttopicnum") = 0 
	rs("lastbbsnum") = 0 
	rs("lasttopicnum") = 0 
	rs.Update 
	rs.Close 
	call addmaster(Request("boardmaster"))
	response.write "<p>论坛添加成功！<br><br>"&str
	end if
end sub

sub savedit()
	dim newboardid
	set rs = server.CreateObject ("adodb.recordset")
	if request("newboardid")=request("editid") then
		newboardid=request("newboardid")
	else
		sql="select boardid from board where boardid="+cstr(request("newboardid"))
		rs.open sql,conn,1,1
		if not rs.eof and not rs.bof then
			response.write "您不能指定和别的论坛一样的序号。"
			exit sub
		else
			newboardid=request("newboardid")
		end if
		rs.close
	end if
	sql = "select * from board where boardid="+Cstr(request("editid"))
	rs.Open sql,conn,1,3
	rs("boardid") = Request.Form ("newboardid")
	rs("boardtype") = Request.Form ("boardtype")
	rs("class") = Request.Form  ("class")
	rs("boardmaster") = Request("boardmaster")
	rs("readme") = Request("readme")
	rs("lockboard") = Trim(Request("lockboard"))
	rs("Tableback") = Request("Tableback")
	rs("Tabletitle") = Request("Tabletitle")
	rs("Tablebody") = Request("Tablebody")
	rs("aTablebody") = Request("aTablebody")
	rs("TableFont") = Request("TableFont")
	rs("TableContent") = Request("TableContent")
	rs("AlertFont") = Request("AlertFont")
	rs("Forumlogo") = Request("Logo")
	rs("indexIMG")=request.form("indexIMG")
	rs("strAllowForumCode") = Request("strAllowForumCode")
	rs("strAllowHTML") = Request("strAllowHTML")
	rs("strIMGInPosts") = Request("strIMGInPosts")
	rs("strIcons") = Request("strIcons")
	rs("strflash") = Request("strflash")
	rs.Update 
	if request("newboardid")<>request("editid") then
	conn.execute("update bbs1 set boardid="&Request.Form ("newboardid")&" where boardid="+Cstr(request("editid")))
	end if
	rs.Close
	call addmaster(Request("boardmaster"))
	response.write "<p>论坛修改成功！<br><br>"&str
	sql="update bbs1 set boardid="&newboardid&" where boardid="+Cstr(request("editid"))
	conn.execute(sql)
end sub

sub del()
	set rs = server.CreateObject ("adodb.recordset")
	sql = "delete from board where boardid="+Cstr(Request("boardid"))
	conn.execute(sql)
	sql = "delete from bbs1 where boardid="+cstr(Request("boardid"))
	conn.execute(sql)
	response.write "<p>论坛修改成功！"
end sub

sub del1()
	set rs = server.CreateObject ("adodb.recordset")
	sql = "delete from class where id="+Cstr(Request("id"))
	conn.execute(sql)
	sql = "delete from board where class="+Cstr(Request("id"))
	conn.execute(sql)
	sql="select boardid from board where class="+Cstr(Request("id"))
	rs.open sql,conn,1,1
	do while not rs.eof
	sql_1 = "delete from bbs1 where boardid="+cstr(rs("boardid"))
	conn.execute(sql_1)
	rs.movenext
	loop
	rs.close
	response.write "<p>分类删除成功！"
end sub

sub orders()
%><br>
            <table width="95%" border="0" cellspacing="3" cellpadding="0" align=center>
              <tr> 
                <td height="22"><b>论坛分类重新排序修改</b><br>
注意：请在相应论坛分类的排序表单内输入相应的排列序号，注意不能和别的论坛分类有相同的排列序号。
		</td>
              </tr>
	      <tr>
		<td>
<%
	set rs = server.CreateObject ("Adodb.recordset")
	sql="select * from class where id="&cstr(request("id"))
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		response.write "没有找到相应的论坛分类。"
	else
		response.write "<form action=admin_board.asp?action=updateorders method=post>"
		response.write "<input type=text name=classname size=25 value="&rs("class")&">"
		response.write "  <input type=text name=newid size=2 value="&rs("id")&">"
		response.write "<input type=hidden name=id value="&request("id")&">"
		response.write "<input type=submit name=Submit value=修改></form>"
	end if
	rs.close
%>
		</td>
	      </tr>
            </table>
<%
end sub

sub updateorders()
	dim newid
	set rs = server.CreateObject ("Adodb.recordset")
	if request("newid")=request("id") then
		sql="update class set class='"&request("classname")&"' where id="&cstr(request("id"))
		conn.execute(sql)
		response.write "<p align=center>更新成功！</p>"
	else
	sql="select * from class where id="&cstr(request("newid"))
	rs.open sql,conn,1,1
	if not rs.eof and not rs.bof then
		response.write "您输入的序号和其他分类序号相同，请重新输入。"
	else
		sql="update class set id="&request("newid")&",class='"&request("classname")&"' where id="&cstr(request("id"))
		conn.execute(sql)
		sql="update board set class="&request("newid")&" where class="&cstr(request("id"))
		conn.execute(sql)
		response.write "<p align=center>更新成功！</p>"
	end if
	end if
end sub

sub addclass()
	set rs = server.CreateObject ("Adodb.recordset")
	sql="select id from class"
	rs.open sql,conn,1,1
	classnum=rs.recordcount
	rs.close
%>
            <table width="95%" border="0" cellspacing="3" cellpadding="0" align=center>
              <tr> 
                <td height="22" bgcolor=<%=aTableTitleColor%>><b>添加新的论坛分类</b><br>
注意：请完整填写以下表单信息，注意不能和别的论坛分类有相同的排列序号。
		</td>
              </tr>
<form action=admin_board.asp?action=saveclass method=post>
	      <tr>
		<td>分类名：<input name=classname type=text size=25>  序号：
<input name=id type=text size=2 value=<%=classnum+1%>>   
<input type=submit name=Submit value=添加>
		</td>
	      </tr>
</form>
	    </table>
<%
end sub

sub saveclass()
	set rs = server.CreateObject ("Adodb.recordset")
	if request("id")="" or request("classname")="" then
		response.write "您输入的序号和原来的相同，不必更新啦：）"
	else
	sql="select * from class where id="&cstr(request("id"))
	rs.open sql,conn,1,1
	if not rs.eof and not rs.bof then
		response.write "您输入的序号和其他分类序号相同，请重新输入。"
	else
		sql="insert into class(id,class) values("&request("id")&",'"&request("classname")&"')"
		conn.execute(sql)
		response.write "<p align=center>更新成功！</p>"
	end if
	end if
end sub

sub delclass()

end sub

sub addmaster(s)
	dim arr,i,rs,sql,pw
	randomize
	pw=Cint(rnd*9000)+1000
	if instr(s,"|")<>0 and instr(s,"|")<len(s) then
		arr=split(s,"|")
		set rs=server.createobject("adodb.recordset")
		for i=0 to Ubound(arr)
			sql="select username,userpassword,userclass from [user] where username='"& arr(i) &"'"
			rs.open sql,conn,1,3
			if rs.eof and rs.bof then
				rs.addnew
				rs("username")=arr(i)
				rs("userpassword")=pw
				rs("userclass")=19
				rs.update
				str=str&"你添加了以下用户：<b>" &arr(i) &"</b> 密码：<b>"& pw &"</b><br><br>"
			end if
			rs.close
		next
		set rs=nothing
	else
		set rs=server.createobject("adodb.recordset")
		sql="select username,userpassword,userclass from [user] where username='"& s &"'"
		rs.open sql,conn,1,3
		if rs.eof and rs.bof then
			rs.addnew
			rs("username")=s
			rs("userpassword")=pw
			rs("userclass")=19
			rs.update
			rs.close
			str=str&"你添加了以下用户：<b>" &s &"</b> 密码：<b>"& pw &"</b><br><br>"
		end if
		set rs=nothing
	end if
end sub
%>