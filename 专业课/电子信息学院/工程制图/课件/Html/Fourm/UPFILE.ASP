<!--#include FILE="upload.inc"-->
<!--#include FILE="conn.asp"-->
<!--#include FILE="inc/const.asp"-->
<html>
<head>
<title>文件上传</title>
</head>
<body  bgcolor=<%=Tablebodycolor%> >
<script>
parent.document.forms[0].Submit.disabled=false;
parent.document.forms[0].Submit2.disabled=false;
</script>
<%
if session("upface")="done" then
	response.write "<font size=2>您已经上传了头像</font>"
	response.end
end if

dim upload,file,formName,formPath,iCount,filename,fileExt
set upload=new upload_5xSoft ''建立上传对象




 formPath=upload.form("filepath")
 ''在目录后加(/)
 if right(formPath,1)<>"/" then formPath=formPath&"/" 


iCount=0
for each formName in upload.file ''列出所有上传了的文件
 set file=upload.file(formName)  ''生成一个文件对象
 if file.filesize<100 then
 	response.write "<font size=2>请先选择你要上传的图片　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</font>"
	response.end
 end if
 	
 if file.filesize>10000 then
 	response.write "<font size=2>图片大小超过了限制　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</font>"
	response.end
 end if

 fileExt=lcase(right(file.filename,4))

 if fileEXT<>".gif" and fileEXT<>".jpg" then
 	response.write "<font size=2>文件格式不对　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</font>"
	response.end
 end if 
 
 filename=formPath&year(now)&month(now)&day(now)&hour(now)&minute(now)&second(now)&file.FileName
 
 if file.FileSize>0 then         ''如果 FileSize > 0 说明有文件数据
  file.SaveAs Server.mappath(filename)   ''保存文件
'  response.write file.FilePath&file.FileName&" ("&file.FileSize&") => "&formPath&File.FileName&" 成功!<br>"
 response.write "<script>parent.document.forms[0].myface.value='"&FileName&"'</script>"
  iCount=iCount+1
 end if
 set file=nothing
next
set upload=nothing  ''删除此对象

session("upface")="done"

Htmend iCount&" 个文件上传结束!"

sub HtmEnd(Msg)
 set upload=nothing
 response.write "<font size=2>图片上传成功,请copy下边的图片连接,以备后用</font>"
 response.end
end sub


%>
</body>
</html>