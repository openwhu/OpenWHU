<%
	dim conn
	dim connstr
	dim db
	'更改数据库名字
	db="ljt2002.mdb"
	Set conn = Server.CreateObject("ADODB.Connection")
	connstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(""&db&"")
'如果你的服务器采用较老版本Access驱动，请用下面连接方法
'	connstr="driver={Microsoft Access Driver (*.mdb)};dbq=" & Server.MapPath(""&db&"")
	conn.Open connstr
  	sub endConnection()
      		conn.close
      		set conn=nothing
  	end sub
%>