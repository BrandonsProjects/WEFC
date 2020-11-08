#Requires -RunAsAdministrator

# Creates the new directory where WEFC will live
If (!(Test-Path -Path "$env:SystemDrive\WEFC")) {
	New-item -Type 'Directory' "$env:SystemDrive\WEFC"
	Copy-Item -Path '.\*' -Destination "$env:SystemDrive\WEFC" -Recurse
}

# Configures custom event channels
Stop-Service -Name 'Wecsvc'
Copy-Item -Path "$env:SystemDrive\WEFC\windows-event-channels\CustomEventChannels.*" -Destination "$env:SystemRoot\System32\"
If (Test-Path -Path "$env:SystemRoot\System32\CustomEventChannels.man") {
	wevtutil.exe im C:\windows\system32\CustomEventChannels.man
}

# Reconfigures maximum log size of the custom event channels
$xml = wevtutil.exe el | Select-String -Pattern "WEC"
foreach ($subscription in $xml) {
	wevtutil.exe sl $subscription /ms:4194304
}

# Setting WinRM Service to automatic start and running quickconfig
Set-Service -Name 'WinRM' -StartupType 'Automatic'
winrm.cmd quickconfig -quiet

# Runs quickconfig for the Windows Event Collection
wecutil.exe qc -quiet

# Creates the WEFC subscription(s)
$subscriptions = Get-ChildItem -Path "$env:SystemDrive\WEFC\subscriptions\" -File -Filter "*.xml"
foreach ($item in $subscriptions) {
    wecutil.exe cs "$item.FullName"
}

# Sets the Windows Event Collector Service startup type to automatic
Set-Service -Name WECSVC -StartupType "Automatic"
