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
	wecutil.exe cs $item.FullName
}

# Sets the Windows Event Collector Service startup type to automatic
Set-Service -Name 'Wecsvc' -StartupType "Automatic"

# Fix for Windows Server 2019+ and Windows 10 1703+ with more than 3.5GB of RAM
# https://docs.microsoft.com/en-us/troubleshoot/windows-server/admin-development/events-not-forwarded-by-windows-server-collector#symptoms
# https://docs.microsoft.com/en-us/windows/application-management/svchost-service-refactoring

$OperatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty Caption
$MemoryCapacity = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
If(($OperatingSystem -notlike "*Windows Server 2016*") -and 
	($MemoryCapacity -gt "3.5")) {
	Start-Process cmd.exe -ArgumentList "/c netsh http delete urlacl url=http://+:5985/wsman/"
	Start-Process cmd.exe -ArgumentList "/c netsh http add urlacl url=http://+:5985/wsman/ sddl=D:(A;;GX;;;S-1-5-80-569256582-2953403351-2909559716-1301513147-412116970)(A;;GX;;;S-1-5-80-4059739203-877974739-1245631912-527174227-2996563517)"
	Start-Process cmd.exe -ArgumentList "/c netsh http delete urlacl url=https://+:5986/wsman/"
	Start-Process cmd.exe -ArgumentList "/c netsh http add urlacl url=https://+:5986/wsman/ sddl=D:(A;;GX;;;S-1-5-80-569256582-2953403351-2909559716-1301513147-412116970)(A;;GX;;;S-1-5-80-4059739203-877974739-1245631912-527174227-2996563517)"
	Restart-Service -Name 'Wecsvc'
}
