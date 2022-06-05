$Message = Get-WinEvent -MaxEvents 1 `
	-FilterHashtable @{
		LogName='WEC3-Account-Management'
		Id='4757'
	}

# Modify below this comment to fit your needs
$Email = @{
	To         = 'email@domain.com'
	From       = 'SecurityAlerts@domain.com'
	Subject    = '[WEFC Alert] A user was removed from a security-enabled universal group'
	Body       = $Message.Message
	Priority   = 'Normal'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

if ($Message | Select-String -Pattern 'Admin','Operators','ADM_') {
	Send-MailMessage @Email
}
