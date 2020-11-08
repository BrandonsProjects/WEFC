$Message = Get-WinEvent -LogName WEC3-Account-Management | Where-Object {$_.Id -eq 4732} | Select-Object -First 1 | Select-Object -ExpandProperty Message

# Modify below this comment to fit your needs
$Email = @{
    To = 'email@domain.com'
    From = 'SecurityAlerts@domain.com'
    Subject = '[WEFC Alert] A user was added to a security-enabled local group'
    Body = $message
    Priority = 'High'
    SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

Send-MailMessage @Email
