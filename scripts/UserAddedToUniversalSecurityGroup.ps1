$Message = Get-WinEvent -FilterHashtable @{LogName='WEC3-Account-Management'; Id='4756'} -MaxEvents 1

# Modify below this comment to fit your needs
$Email = @{
	To = 'email@domain.com'
	From = 'SecurityAlerts@domain.com'
	Subject = '[WEFC Alert] A user was added to a security-enabled universal group'
	Body = $Message.Message
	Priority = 'High'
	SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

if (($Message | Select-String -Pattern 'Admin') -or
	($Message | Select-String -Pattern 'Operators') -or
	($Message | Select-String -Pattern 'ADM_')) {

	Send-MailMessage @Email
}
