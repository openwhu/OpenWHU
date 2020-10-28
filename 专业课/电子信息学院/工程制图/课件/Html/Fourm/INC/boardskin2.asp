<% dim arrRow

	sub AnnounceList1()
	
	'on error resume next
	'打开数据库连接
	
	sql="select AnnounceID,parentID,boardID,UserName,child,Topic,body,DateAndTime,hits,RootID,Expression,times,locktopic,istop,isbest,isvote from bbs1 where boardID="&cstr(boardID)&" and parentID=0 "&tl&" ORDER BY istop desc,times desc,announceid desc"
	'response.write sql
	set rs=server.createobject("adodb.recordset")
	
	rs.open sql,conn,1,1
	if err.number<>0 then
		rs.close
		set rs=nothing
		foundErr = true
		ErrMsg = "<li>数据库操作失败：" & err.description & "</li>"
	else
		if rs.bof and rs.eof then
			'论坛无内容
			rs.close
			set rs=nothing
			call showEmptyBoard1()
			bBoardEmpty = true
		else
	      		totalrec=rs.recordcount
      			if currentpage<1 then currentpage=1 

				MaxAnnouncePerpage=Clng(MaxAnnouncePerpage)

      			if (currentpage-1)*MaxAnnouncePerPage>=totalrec then 
	   			if (totalrec mod MaxAnnouncePerPage)=0 then 
	     				currentpage= totalrec \ MaxAnnouncePerPage 
	   			else 
	      				currentpage= totalrec \ MaxAnnouncePerPage + 1 
	   			end if 
      			end if 

				if currentPage<>1 then 
          			'if (currentPage-1)*MaxAnnouncePerPage<totalrec then 
            				rs.move  (currentPage-1)*MaxAnnouncePerPage 
            			'	call getarr(arrUbound)	
							'call showpagelist1() 
        			'else 
	        		'	currentPage=1
						'call getarr(arrUbound)
           				'call showpagelist1() 
	      			'end if 
				end if
				arrRow=rs.getrows(MaxAnnouncePerPage,0)
				rs.close
				set rs=nothing
				call showpagelist1() 
		end if
	end if

	
		if err.number<>0 then err.clear	
	end sub


	REM 显示贴子列表	
	sub showPageList1()
	i=0

response.write "<table cellspacing=0 border=0 width=95% bgcolor="&Tablebackcolor&" align=center><tr><td height=1></td></tr></table>"&_
				"<TABLE style=color:"&TableFontcolor&"  border=1 cellPadding=0 cellSpacing=0 width=95% align=center bordercolor="&Tablebackcolor&">"&_
  				"<TBODY>"&_
				"<TR align=middle>"&_
				"<TD height=27 width=32 bgColor="&Tabletitlecolor&">状态</TD>"&_ 
				"<TD bgColor="&Tabletitlecolor&" width=*>主 题  (点<img src=pic/plus.gif>即可展开贴子列表)</TD>"&_
				"<TD bgColor="&Tabletitlecolor&" width=80>作 者</TD>"&_
				"<TD bgColor="&Tabletitlecolor&" width=64>回复/人气</TD>"&_
				"<TD bgColor="&Tabletitlecolor&" width=195>最后更新 | 回复人</TD>"&_
				"</TR>"&_ 
				"</TBODY></TABLE>"
		do while i<=Ubound(arrRow,2)
		

response.write "<TABLE style=color:"&tablecontent&" border=1 cellPadding=0 cellSpacing=0 width=95% align=center bordercolor="&Tablebackcolor&">"&_
				"<TBODY><TR align=middle>"&_
				"<TD bgColor="&aTablebody&" width=32 height=27>"


if arrRow(13,i)<>1 and lockboard<>1 and arrRow(12,i)<>1 and arrRow(15,i)<>1 and arrRow(14,i)<>1 and arrRow(4,i)<10 then
	response.write "<img src=""pic//folder.gif"" alt=开放主题>"
elseif arrRow(15,i)=1 then
	response.write "<img src=""pic//closedb.gif"" alt=投票贴子>"
elseif arrRow(13,i)=1 then
	response.write "<img src=""pic//istop.gif"" alt=固顶主题>"
elseif arrRow(14,i)=1 then
	response.write "<img src=""pic//isbest.gif"" alt=精华帖子>"
elseif arrRow(4,i)>=10 then
	response.write "<img src=""pic//hotfolder.gif"" alt=热门主题>"
elseif arrRow(12,i)=1 then
	response.write "<img src=""pic//lockfolder.gif"" alt=本主题已锁定>"
elseif lockboard=1 then
	response.write "<img src=""pic//lockfolder.gif"" alt=本论坛已锁定>"
else
	response.write "<img src=""pic//folder.gif"" alt=开放主题>"
end if

response.write "</TD>"&_
				"<TD align=left bgcolor="&Tablebody&" width=* onmouseover=javascript:this.bgColor='"&aTablebody&"' onmouseout=javascript:this.bgColor='"&Tablebody&"'>"
'"<a href='dispbbs.asp?boardID="&boardID&"&RootID="& RootID &"&ID="& announceID &"&skin="& skin &"' target=_blank><img src='images/"& A_Expression(i) &"' border=0 alt=开新窗口浏览此主题 ></a>"

if arrRow(4,i)=0 then
	response.write "<img src='"& picurl &"nofollow.gif' id='followImg"& arrRow(9,i) &"'>"
else
	response.write "<img loaded=no src='"& picurl &"plus.gif' id='followImg"& arrRow(9,i) &"' style='cursor:hand;' onclick='loadThreadFollow("& arrRow(9,i) &","& arrRow(0,i) &","& boardid &")' title=展开贴子列表>"
end if

if instr(arrRow(6,i),"[upload=gif]")>0 and instr(arrRow(6,i),"[/upload]")>0 then
	if instr(arrRow(6,i),".gif")>0 then response.write "<img src='pic/gif.gif'> "
end if
if instr(arrRow(6,i),"[upload=jpg]")>0 and instr(arrRow(6,i),"[/upload]")>0 then
	if instr(arrRow(6,i),".gif")>0 then response.write "<img src='pic/gif.gif'> "
end if
if instr(arrRow(6,i),"[zip]")>0 and instr(arrRow(6,i),"[/zip]")>0 then
	if instr(arrRow(6,i),".zip")>0 then response.write "<img src='pic/zip.gif'> "
end if
if instr(arrRow(6,i),"[rar]")>0 and instr(arrRow(6,i),"[/rar]")>0 then
	if instr(arrRow(6,i),".rar")>0 then response.write "<img src='pic/rar.gif'> "
end if
	dim Ers, Eusername, Edateandtime
		Eusername=""
		Edateandtime=""
	
    set Ers=conn.execute("select top 1 username,dateandtime,body,announceid,rootid from bbs1 where rootid="& arrRow(9,i) &" and not announceid="& arrRow(9,i) &" order by announceid desc")
	if not(Ers.eof and Ers.bof) then
		arrRow(6,i)=Ers("body")
		Eusername=htmlencode(Ers("username"))
		Edateandtime=Ers("dateandtime")	
	end if
	Ers.close
	set Ers=nothing
	
arrRow(3,i)=htmlencode(arrRow(3,i))
arrRow(5,i)=htmlencode(arrRow(5,i))

response.write "<a href=""dispbbs.asp?boardID="& boardID &"&RootID="& arrRow(9,i) &"&ID="& arrRow(0,i)&""" title='《"& arrRow(5,i) &"》&#13;&#10;作者："& arrRow(3,i) &"&#13;&#10;发表于"& arrRow(7,i) &"&#13;&#10;最后跟贴："& htmlencode(left(arrRow(6,i),20)) &"...'>"

if len(arrRow(5,i))>26 then
	response.write ""&left(arrRow(5,i),26)&"..."
else
	response.write arrRow(5,i)
end if
	response.write "</a>"
	Maxtitlelist=Cint(Maxtitlelist)
if arrRow(4,i)+1>Maxtitlelist then
	response.write "&nbsp;&nbsp;[分页："
	Pnum=(Cint(arrRow(4,i)+1)/Maxtitlelist)+1
	for p=1 to Pnum
	response.write " <a href='dispbbs.asp?boardID="& boardID &"&RootID="& arrRow(9,i) &"&ID="& arrRow(0,i) &"&star="&P&"'><FONT color=#990000><b>"&p&"</b></font></a> "
	next
	response.write "]"
end if

response.write "</TD>"&_
				"<TD bgColor="&aTablebody&" width=80><a href=javascript:openUser('"& arrRow(3,i) &"')>"& arrRow(3,i) &"</a></TD>"&_
				"<TD bgColor="&Tablebody&" width=64>"
if arrRow(15,i)=1 then
	set vrs=conn.execute("select votenum from vote where announceid="& arrRow(0,i) &"")
	votenum=vrs("votenum")
	votenum=split(votenum,"|")
	dim iu
	for iu = 0 to ubound(votenum)
		votenum_1=cint(votenum_1)+votenum(iu)
	next
	response.write "<FONT color=#990000><b>"&votenum_1&"</b></font>  票"
	votenum_1=0
	vrs.close
	set vrs=nothing
else
	response.write "<font color="& TableContent &">"& arrRow(4,i) &"/"& arrRow(8,i) &"</font>"
end if

response.write "</TD><TD align=left bgColor="& aTablebody &" width=195>&nbsp;"

	'on error resume next
	if Eusername="" then
		response.write "<IMG border=0 src=pic/lastpost.gif>&nbsp;"&_
						FormatDateTime(arrRow(7,i),2)&"&nbsp;"&FormatDateTime(arrRow(7,i),4)&_
						"&nbsp;<font color=#990000>|</font>&nbsp;------"
	else
		response.write "<a href=showannounce.asp?boardid="& boardid &"&rootid="& arrRow(9,i) &"&id="& arrRow(11,i) &"><IMG border=0 src='pic/lastpost.gif'></a>&nbsp;"&_
						FormatDateTime(Edateandtime,2)&"&nbsp;"&FormatDateTime(Edateandtime,4)&_
						"&nbsp;<font color=#990000>|</font>&nbsp;"
		if arrRow(0,i)=arrRow(11,i) then
			response.write "------"
		else
			response.write "<a href=javascript:openUser('"&Eusername&"')>"&Eusername&"</a>"
		end if
	end if

response.write "</TD></TR>"&_
				"<tr style=display:none id='follow"& arrRow(9,i) &"'><td colspan=5 id='followTd"& arrRow(9,i) &"' style=padding:0px><div style='width:240px;margin-left:18px;border:1px solid black;background-color:lightyellow;color:black;padding:2px' onclick=loadThreadFollow("& arrRow(9,i) &")>正在读取关于本主题的跟贴，请稍侯……</div></td></tr>"&_
				"</TBODY></TABLE>"

	  i=i+1
	loop
	arrRow=null

		if err.number<>0 then err.clear
	end sub


	sub listPages3()
	'on error resume next

  	dim n,p,ii
  	if totalrec mod MaxAnnouncePerPage=0 then
     		n= totalrec \ MaxAnnouncePerPage
  	else
     		n= totalrec \ MaxAnnouncePerPage+1
  	end if

	if currentpage-1 mod 10=0 then
		p=(currentpage-1) \ 10
	else
		p=(currentpage-1) \ 10
	end if

		response.write "<table border=0 cellpadding=0 cellspacing=3 width=95% align=center >"&_
					"<form method=post action=list.asp name=frmList2 >"&_
					"<input type=hidden name=selTimeLimit value='"& request("selTimeLimit") &"'><tr>"&_
		  			"<td valign=middle><span class=smallFont >页次：<strong>"& currentPage &"</strong>/<strong>"& n &"</strong>页 每页<strong>"& MaxAnnouncePerPage &"</strong> 主题数<strong>"& totalrec &"</strong></td>"&_
					"<td valign=middle><div align=right ><p>分页："

	if p*10>0 then response.write "<a href='javascript:viewPage2("+Cstr(p*10)+")' language='javascript'>[<<]</a>   "
	for ii=p*10+1 to P*10+10
		   if ii=currentPage then
	          response.write "<font color=gray>["+Cstr(ii)+"]</font> "
		   else
		      response.write "<a href='javascript:viewPage2("+Cstr(ii)+")' language='javascript'>["+Cstr(ii)+"]</a>   "
		   end if
		if ii=n then exit for
		'p=p+1
	next
	if ii<n then response.write "<a href='javascript:viewPage2("+Cstr(ii)+")' language='javascript'>[>>]</a>   "

		response.write "<span class=smallFont >转到:<input type=text name=Page size=3 maxlength=10  value='"& currentpage &"'><input type=button value=Go language=javascript onclick='viewPage1(document.frmList2.Page.value)' id=button1 name=button1 ></span></p>"&_     
					"</div></td></tr>"&_
					"<input type=hidden name=BoardID value='"& BoardID &"'>"&_
					"</form></table>"

		if err.number<>0 then err.clear
	end sub 

	sub showEmptyBoard1()
		response.write "<TABLE style=color:"&TableFontcolor&" bgColor='"&Tablebackcolor&"' border=0 cellPadding=4 cellSpacing=1 width=95% align=center>"&_
			"<TBODY>"&_
			"<TR align=middle bgColor='"&Tabletitlecolor&"'>"&_
			"<TD height=25><font color="&TableFontcolor&">状态</font></TD>"&_
			"<TD>主 题  (点心情符为开新窗浏览)</TD>"&_
			"<TD>作 者</TD> "&_
			"<TD>回复/人气</TD> "&_
			"<TD>最新回复</TD></TR> "&_
			"<tr bgColor="&Tablebody&"><td colSpan=5 width=100% >本论坛暂无内容，欢迎发贴：）</td></tr>"&_
			"</TBODY></TABLE>"
	end sub
%>

<html><script language="JavaScript">                                                                  </script></html>