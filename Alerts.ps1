<#
NOTE: The scheduled tasks created from this script will generate alerts directly from the Windows Event Collector.
If the logs collected by this machine will be forwarded to a SIEM, these tasks may not be useful. If not, this 
provides a quick and easy way to get alerts for some important events happening on your network.

PREREQUISITES: Be sure to edit the alerting scripts in .\scripts\ will the email account and server that will be used.
#>

do {
	$answer = Read-Host 'STOP! Have you configured the scripts in .\scripts\ yet? (Y/N)'
} while (($answer.ToUpper() -ne 'Y') -or ($answer.ToUpper() -ne 'N'))

If ($answer.ToUpper() -eq 'Y') {
	schtasks.exe /create /tn "WEFC_Security Log File Cleared_1102" /xml "C:\WEFC\task config\SecurityLogClearedTask.xml"
	schtasks.exe /create /tn "WEFC_Administrator recovered system from CrashOnAuditFail_4621" /xml "C:\WEFC\task config\Administrator-CrashOnAuditFailTask.xml"
	schtasks.exe /create /tn "WEFC_A replay attack was detected_4649" /xml "C:\WEFC\task config\ReplayAttackDetectedTask.xml"
	schtasks.exe /create /tn "WEFC_A new trust was created to a domain_4706" /xml "C:\WEFC\task config\NewTrustCreatedTask.xml"
	schtasks.exe /create /tn "WEFC_A trust to a domain was removed_4707" /xml "C:\WEFC\task config\DomainTrustRemovedTask.xml"
	schtasks.exe /create /tn "WEFC_Kerberos Policy was changed_4713" /xml "C:\WEFC\task config\KerberosPolicyChangedTask.xml"
	schtasks.exe /create /tn "WEFC_Trusted domain information was modified_4716" /xml "C:\WEFC\task config\TrustedDomainInformationModifiedTask.xml"
	schtasks.exe /create /tn "WEFC_User Creation_4720" /xml "C:\WEFC\task config\UserAccountCreationTask.xml"
	schtasks.exe /create /tn "WEFC_User Deletion_4726" /xml "C:\WEFC\task config\UserAccountDeletionTask.xml"
	schtasks.exe /create /tn "WEFC_User Added to Global Security Group_4728" /xml "C:\WEFC\task config\UserAddedToGlobalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Removed from Global Security Group_4729" /xml "C:\WEFC\task config\UserRemovedFromGlobalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Added to Local Security Group_4732" /xml "C:\WEFC\task config\UserAddedToLocalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Removed from Local Security Group_4733" /xml "C:\WEFC\task config\UserRemovedFromLocalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_Domain Policy was changed_4739" /xml "C:\WEFC\task config\DomainPolicyChangedTask.xml"
	schtasks.exe /create /tn "WEFC_User Account Locked Out_4740" /xml "C:\WEFC\task config\UserAccountLockedOutTask.xml"
	schtasks.exe /create /tn "WEFC_User Added to Universal Security Group_4756" /xml "C:\WEFC\task config\UserAddedToUniversalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_User Removed from Universal Security Group_4757" /xml "C:\WEFC\task config\UserRemovedFromUniversalSecurityGroupTask.xml"
	schtasks.exe /create /tn "WEFC_The password hash of an account was accessed_4782" /xml "C:\WEFC\task config\PasswordHashAccessedTask.xml"
	schtasks.exe /create /tn "WEFC_A trusted forest information entry was added_4865" /xml "C:\WEFC\task config\TrustedForestEntryAddedTask.xml"
	schtasks.exe /create /tn "WEFC_A trusted forest information entry was removed_4866" /xml "C:\WEFC\task config\TrustedForestEntryRemovedTask.xml"
	schtasks.exe /create /tn "WEFC_A trusted forest information entry was modified_4867" /xml "C:\WEFC\task config\TrustedForestEntryModifiedTask.xml"
	schtasks.exe /create /tn "WEFC_The CrashOnAuditFail value has changed_4906" /xml "C:\WEFC\task config\CrashOnAuditFailValueChangedTask.xml"
	schtasks.exe /create /tn "WEFC_Credential Manager credentials were backed up_5376" /xml "C:\WEFC\task config\CredentialManagerBackupUpTask.xml"
	schtasks.exe /create /tn "WEFC_Credential Manager credentials were restored from backup_5377" /xml "C:\WEFC\task config\CredentialManagerRestoredTask.xml"
} else {
	Write-Warning "Configure the scripts in .\scripts\ first before setting up alerts."
}
