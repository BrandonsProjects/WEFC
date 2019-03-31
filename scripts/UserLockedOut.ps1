﻿$Message = Get-WinEvent -LogName ForwardedEvents | Where-Object {$_.Id -eq 4740} | Select-Object -First 1 | Select-Object -ExpandProperty Message

$Email = @{
    To = 'email@domain.com'
    From = 'SecurityAlerts@domain.com'
    Subject = 'A user account was locked out'
    Body = $message
    Priority = 'High'
    SmtpServer = 'mail.domain.com'
}

Send-MailMessage @Email
