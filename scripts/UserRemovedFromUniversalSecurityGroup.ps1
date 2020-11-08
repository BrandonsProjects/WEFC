$Message = Get-WinEvent -LogName WEC3-Account-Management | Where-Object {$_.Id -eq 4757} | Select-Object -First 1 | Select-Object -ExpandProperty Message

# Modify below this comment to fit your needs
$Email = @{
    To = 'email@domain.com'
    From = 'SecurityAlerts@domain.com'
    Subject = '[WEFC Alert] A user was removed from a security-enabled universal group'
    Body = $message
    Priority = 'High'
    SmtpServer = 'mail.domain.com'
}
# Modify above this comment to fit your needs

if (($Message | Select-String -Pattern 'Admin') -or
    ($Message | Select-String -Pattern 'Operators') -or
    ($Message | Select-String -Pattern 'ADM_')) {

    Send-MailMessage @Email
}
