$Message = Get-WinEvent -LogName ForwardedEvents | Where-Object {$_.Id -eq 4757} | Select-Object -First 1 | Select-Object -ExpandProperty Message

$Email = @{
    To = 'email@domain.com'
    From = 'SecurityAlerts@domain.com'
    Subject = 'A user was removed from a security-enabled universal group'
    Body = $message
    Priority = 'High'
    SmtpServer = 'mail.domain.com'
}

if (($Message | Select-String -Pattern 'Administrators') -or
    ($Message | Select-String -Pattern 'Domain Admins') -or
    ($Message | Select-String -Pattern 'Schema Admins') -or
    ($Message | Select-String -Pattern 'Enterprise Admins') -or
    ($Message | Select-String -Pattern 'Print Operators') -or
    ($Message | Select-String -Pattern 'Server Operators') -or
    ($Message | Select-String -Pattern 'Backup Operators')) {

    Send-MailMessage @Email
}
