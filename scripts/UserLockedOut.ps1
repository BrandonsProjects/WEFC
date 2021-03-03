$Message = Get-WinEvent -FilterHashtable @{LogName='WEC-Authentication'; Id='4740'} -MaxEvents 1

# Modify below this comment to fit your needs
$Email = @{
	To = 'email@domain.com'
	From = 'SecurityAlerts@domain.com'
	Subject = '[WEFC Alert] A user account was locked out'
	Body = $Message.Message
	Priority = 'High'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

Send-MailMessage @Email
