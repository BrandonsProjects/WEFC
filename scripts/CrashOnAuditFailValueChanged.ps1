$Message = Get-WinEvent -FilterHashtable @{LogName='WEC5-Operating-System'; Id='4906'} -MaxEvents 1

# Modify below this comment to fit your needs
$Email = @{
	To         = 'email@domain.com'
	From       = 'SecurityAlerts@domain.com'
	Subject    = '[WEFC Alert] The CrashOnAuditFail value has changed'
	Body       = $Message.Message
	Priority   = 'High'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

Send-MailMessage @Email
