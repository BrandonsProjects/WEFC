$Message = Get-WinEvent -MaxEvents 1 `
	-FilterHashtable @{
		LogName='WEC3-Account-Management'
		Id='5376'
	}

# Modify below this comment to fit your needs
$Email = @{
	To         = 'email@domain.com'
	From       = 'SecurityAlerts@domain.com'
	Subject    = '[WEFC Alert] Credential Manager credentials were backed up'
	Body       = $Message.Message
	Priority   = 'High'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

Send-MailMessage @Email
