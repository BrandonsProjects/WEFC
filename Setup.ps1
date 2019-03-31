#Requires -RunAsAdministrator

# Creates the new directory where WEFC will live
If (!(Test-Path -Path 'C:\WEFC')) {New-item -Type Directory C:\WEFC}
Copy-Item -Path .\* -Destination C:\WEFC -Recurse

# Setting WinRM Service to automatic start and running quickconfig
Set-Service -Name WinRM -StartupType Automatic
winrm.cmd quickconfig -quiet

# Configures maximum log size of Forwarded Events to 1GB
wevtutil.exe sl forwardedevents /ms:1000000000

# Runs quickconfig for the Windows Event Collection
wecutil.exe qc -quiet

# Creates the WEFC subscription(s)
wecutil.exe cs "C:\WEFC\subscription config\usersandgroups.xml"
wecutil.exe cs "C:\WEFC\subscription config\system.xml"
wecutil.exe cs "C:\WEFC\subscription config\antimalware.xml"
wecutil.exe cs "C:\WEFC\subscription config\sysmon.xml"
wecutil.exe cs "C:\WEFC\subscription config\eventlog.xml"
wecutil.exe cs "C:\WEFC\subscription config\remoteaccess.xml"
#wecutil cs "C:\WEFC\subscription config\events_optional.xml"

# Creates scheduled tasks for alerting
schtasks.exe /create /tn "WEFC_User Creation_4720" /xml "C:\WEFC\task config\UserAccountCreationTask.xml"
schtasks.exe /create /tn "WEFC_User Deletion_4726" /xml "C:\WEFC\task config\UserAccountDeletionTask.xml"
schtasks.exe /create /tn "WEFC_User Added to Global Security Group_4728" /xml "C:\WEFC\task config\UserAddedToGlobalSecurityGroupTask.xml"
schtasks.exe /create /tn "WEFC_User Removed from Global Security Group_4729" /xml "C:\WEFC\task config\UserRemovedFromGlobalSecurityGroupTask.xml"
schtasks.exe /create /tn "WEFC_User Added to Local Security Group_4732" /xml "C:\WEFC\task config\UserAddedToLocalSecurityGroupTask.xml"
schtasks.exe /create /tn "WEFC_User Removed from Local Security Group_4733" /xml "C:\WEFC\task config\UserRemovedFromLocalSecurityGroupTask.xml"
schtasks.exe /create /tn "WEFC_User Account Locked Out_4740" /xml "C:\WEFC\task config\UserAccountLockedOutTask.xml"
schtasks.exe /create /tn "WEFC_User Added to Universal Security Group_4756" /xml "C:\WEFC\task config\UserAddedToUniversalSecurityGroupTask.xml"
schtasks.exe /create /tn "WEFC_User Removed from Universal Security Group_4757" /xml "C:\WEFC\task config\UserRemovedFromUniversalSecurityGroupTask.xml"

# Sets the Windows Event Collector Service startup type to automatic
Set-Service -Name WECSVC -StartupType "Automatic"
