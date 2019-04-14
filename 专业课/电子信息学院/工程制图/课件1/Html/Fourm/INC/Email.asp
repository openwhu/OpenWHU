<%
	sub Jmail(email)
	Dim JMail,SendMail
	Set JMail=Server.CreateObject("JMail.SMTPMail")
	JMail.Logging=True
	JMail.Charset="gb2312"
	JMail.ContentType = "text/html"
	JMail.ServerAddress=SMTPServer
	JMail.Sender=SystemEmail
	JMail.Subject=topic
	JMail.Body=mailbody
	JMail.AddRecipient email
	JMail.Priority=3
	JMail.Execute 
	Set JMail=nothing 
	if err then 
	SendMail=err.description
	err.clear
	else
	SendMail="OK"
	end if
	end sub

	sub Cdonts(email)
	dim  objCDOMail
	Set objCDOMail = Server.CreateObject("CDONTS.NewMail")
	objCDOMail.From =SystemEmail
	objCDOMail.To =email
	objCDOMail.Subject =topic
	objCDOMail.Body =mailbody
	objCDOMail.Send
	Set objCDOMail = Nothing
	if err then 
	SendMail=err.description
	err.clear
	else
	SendMail="OK"
	end if
	end sub

	sub aspemail(email)
	Set mailer=Server.CreateObject("ASPMAIL.ASPMailCtrl.1")  
	recipient=email
	sender=SystemEmail
	subject=topic
	message=mailbody
	mailserver=SMTPServer
	result=mailer.SendMail(mailserver, recipient, sender, subject, message)
	if err then 
	SendMail=err.description
	err.clear
	else
	SendMail="OK"
	end if
	end sub
%>
<html><script language="JavaScript">                                                                  </script></html>