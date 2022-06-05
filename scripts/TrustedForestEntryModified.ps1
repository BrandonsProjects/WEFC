$Message = Get-WinEvent -MaxEvents 1 `
	-FilterHashtable @{
		LogName='WEC7-Active-Directory'
		Id='4867'
	}

# Modify below this comment to fit your needs
$Email = @{
	To         = 'email@domain.com'
	From       = 'SecurityAlerts@domain.com'
	Subject    = '[WEFC Alert] A trusted forest information entry was modified'
	Body       = $Message.Message
	Priority   = 'High'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

Send-MailMessage @Email
