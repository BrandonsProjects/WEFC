$Message = Get-WinEvent -FilterHashtable @{LogName='WEC3-Account-Management'; Id='4726'} -MaxEvents 1

# Modify below this comment to fit your needs
$Email = @{
	To = 'email@domain.com'
	From = 'SecurityAlerts@domain.com'
	Subject = '[WEFC Alert] A user account was deleted'
	Body = $Message.Message
	Priority = 'High'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

Send-MailMessage @Email
