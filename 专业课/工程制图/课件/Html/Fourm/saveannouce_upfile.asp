<!--#include FILE="upload.inc"-->
<!--#include FILE="conn.asp"-->
<!--#include FILE="inc/const.asp"-->
<html>
<head>
<title>文件上传</title>
</head>
<body bgcolor=<%=Tablebodycolor%> leftmargin="5" topmargin="3" >
<script>
parent.document.forms[0].Submit.disabled=false;
parent.document.forms[0].Submit2.disabled=false;
</script>
<%
dim upNum
upNum=request.cookies("xdgctx")("upNum")
if upNum>3 then
 	response.write "<font size=2>一次只能上传三个文件！</font>"
	response.end
end if

response.write "<FONT color=red>"&upNum&"</font>"
dim upload,file,formName,formPath,iCount,filename,fileExt
set upload=new upload_5xSoft ''建立上传对象




 formPath=upload.form("filepath")
 ''在目录后加(/)
 if right(formPath,1)<>"/" then formPath=formPath&"/" 


iCount=0
for each formName in upload.file ''列出所有上传了的文件
 set file=upload.file(formName)  ''生成一个文件对象
 if file.filesize<100 then
 	response.write "<font size=2>请先选择你要上传的文件　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</font>"
	response.end
 end if
 	
 if file.filesize>100000 then
 	response.write "<font size=2>文件大小超过了限制 100K　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</font>"
	response.end
 end if

 fileExt=lcase(right(file.filename,4))

 if fileEXT<>".gif" and fileEXT<>".jpg" and fileEXT<>".zip" and fileEXT<>".rar" then
 	response.write "<font size=2>文件格式不正确　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</font>"
	response.end
 end if 

 randomize
 ranNum=int(90000*rnd)+10000
 filename=formPath&year(now)&month(now)&day(now)&hour(now)&minute(now)&second(now)&ranNum&fileExt
 
' filename=formPath&year(now)&month(now)&day(now)&hour(now)&minute(now)&second(now)&file.FileName
 
 if file.FileSize>0 then         ''如果 FileSize > 0 说明有文件数据
  file.SaveAs Server.mappath(FileName)   ''保存文件
'  response.write file.FilePath&file.FileName&" ("&file.FileSize&") => "&formPath&File.FileName&" 成功!<br>"
 	if fileEXT=".gif" then
 	response.write "<script>parent.frmAnnounce."&session("antry")&".value+='[upload=gif]"&FileName&"[/upload]'</script>"
 	elseif fileEXT=".jpg" then
 	response.write "<script>parent.frmAnnounce."&session("antry")&".value+='[upload=jpg]"&FileName&"[/upload]'</script>"
 	elseif fileEXT=".zip" then
 	response.write "<script>parent.frmAnnounce."&session("antry")&".value+='[zip]"&FileName&"[/zip]'</script>"
 	elseif fileEXT=".rar" then
 	response.write "<script>parent.frmAnnounce."&session("antry")&".value+='[rar]"&FileName&"[/rar]'</script>"
 	end if
 iCount=iCount+1
 end if
 set file=nothing
next
set upload=nothing  ''删除此对象

Htmend iCount&" 个文件上传结束!"

sub HtmEnd(Msg)
 set upload=nothing
 if upNum="" then upNum=1
 response.cookies("xdgctx")("upNum")=upNum+1
 response.write "<font size=2>文件上传成功 [ <a href=# onclick=history.go(-1)>继续上传</a> ]</font>"
 response.end
end sub


%>
</body>
</html>