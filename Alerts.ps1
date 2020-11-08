<#
NOTE: The scheduled tasks created from this script will generate alerts directly from the Windows Event Collector.
If the logs collected by this machine will be forwarded to a SIEM, these tasks may not be useful. If not, this 
provides a quick and easy way to get alerts for some important events happening on your network.

PREREQUISITES: Be sure to edit the alerting scripts in .\scripts\ will the email account and server that will be used.
#>

$input = Read-Host "STOP! Have you configured the scripts in .\scripts\ yet? (Y/N)"

If ($input.ToUpper() -eq 'Y') {
	schtasks.exe /create /tn "WEFC_User Creation_4720" /xml "C:\WEFC\task config\UserAccountCreationTask.xml"
	schtasks.exe /create /tn "WEFC_User Deletion_4726" /xml "C:\WEFC\task config\UserAccountDeletionTask.xml"
	schtasks.exe /create /tn "WEFC_User Added to Global Security Group_4728" /xml "C:\WEFC\task config\UserAddedToGlobalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Removed from Global Security Group_4729" /xml "C:\WEFC\task config\UserRemovedFromGlobalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Added to Local Security Group_4732" /xml "C:\WEFC\task config\UserAddedToLocalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Removed from Local Security Group_4733" /xml "C:\WEFC\task config\UserRemovedFromLocalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Account Locked Out_4740" /xml "C:\WEFC\task config\UserAccountLockedOutTask.xml"
	schtasks.exe /create /tn "WEFC_User Added to Universal Security Group_4756" /xml "C:\WEFC\task config\UserAddedToUniversalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Removed from Universal Security Group_4757" /xml "C:\WEFC\task config\UserRemovedFromUniversalSecurityGroupTask.xml"
} else {
	Write-Warning "Configure the scripts in .\scripts\ first before setting up alerts."
}
