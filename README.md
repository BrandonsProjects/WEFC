# WEFC
WEFC (Windows Event Forwarding/Collection) is my own generic idea for automating the setup of Windows Event Collection that borrows a lot of resources from [Palantir's windows-event-forwarding](https://github.com/palantir/windows-event-forwarding) and from [Jessica Payne @MSFT](https://docs.microsoft.com/en-us/archive/blogs/jepayne/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem). 

This repository is designed to be an easy initial Windows log collection system for those who do not currently collect logs or for those who want to supplement their existing log collection systems. I have also included optional Scheduled Tasks and PowerShell scripts that send basic email alerts to your security team. The PowerShell scripts will need to customized to fit your needs first.

## Prerequsites
To implement Windows Event Collection, there are a few requirements:
- You will need one or more Windows machines to be the collector(s). Either client or server versions of Windows can work as the collector. I recommend using the latest LTSC release of Windows Server Core to better control maintenance and to minimize storage requirements.
- Ensure your collector(s) have enough storage space to accomodate logs. By default, the Windows Event Channels are confifured to roll over previous logs. If you would like to configure the collector(s) to retain logs, you will either need to change the included scripts or edit the Windows Event Channels accordingly. If you opt to retain logs on the collector, ensure it has enough storage space. In my environment (see next bullet point), I see about 10-20GB per day.
- CPU and network requirements heavily depend on your environment. I use this in a 24/7 environment with 2 Domain Controllers, 50ish servers, and 300ish workstations. The 4-core CPU is typically around 50% utilization with about 60Mbps of inbound network traffic.
- [Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon#:~:text=System%20Monitor%20(Sysmon)%20is%20a,changes%20to%20file%20creation%20time.) is not strictly required, but it dramatically assists in visibility and threat hunting. I recommend modifying [SwiftOnSecurity's Sysmon configuration](https://github.com/SwiftOnSecurity/sysmon-config) to fit your environment and then deploy that everywhere via Group Policy, SCCM, Intune, etc.

## How to use WEFC
1. Download this repository and copy it onto the machine you will use for log collection
2. Launch PowerShell as an administrator and navigate to the downloaded WEFC directory
3. Set the Execution Policy to Unrestricted and execute the Setup.ps1 script
```
PS C:\> Set-ExecutionPolicy Unrestricted
PS C:\> .\Setup.ps1
```
4. Create and link new Group Policy Objects to the Organizational Unit(s) containing the client computers, member servers, and domain controllers from which you would like to collect logs. Import the settings from the included GPO backups. Some settings within the GPO such as the FQDN of the collector(s) will need to be changed to match your specific organization. Once the GPOs are applied to the computers, it can take up to an hour for events to start being forwarded to the collector. More information can be found in the README under the Group Policies directory.

## Alerts
This section is completely optional based on your own needs.

The alerting capabilities of this project are great in a pinch, but are not suited for high volumes of the corresponding alerts. For example, if 10 user accounts are added to the Domain Admins group, there will be 10 emails sent containing the last user account added to that group. This happens because PowerShell is slow and the scripts are not tied to a specific event. Even though these alerts can't be 100% accurate with high volumes, they should absolutely get someone's attention for further investigation.

These alerts are controlled via Scheduled Tasks and can be enables or disabled through the Task Scheduler (taskschd.msc).

List of alerts currently available:
| Event ID | Event Description | Why Alert? |
| --- | --- | --- |
| [1102](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-1102) | Security Log File Cleared | Clearing the Security Log could be someone trying to cover their tracks. There's almost never a legitimate reason to clear this log. |
| [4621](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4621) | Administrator recovered system from CrashOnAuditFail | CrashOnAuditFail is a security protection that intentionally crashes the system when security events were unable to be written to the event log. It is rare for this to occur, so this should be investigated. |
| [4649](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4649) | A replay attack was detected | Could be evidence of a Kerberos replay attack or indication of a network problem. |
| [4706](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4706) | A new trust was created to a domain | Trusts allow trusted access to your domain from a different (potentially malicious) domain. All relevant personnel should know about all trusts as they pose a massive potential security risk. |
| [4707](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4707) | A trust to a domain was removed | Trusts allow trusted access to your domain from a different (potentially malicious) domain. All relevant personnel should know about all trusts as they pose a massive potential security risk. |
| [4713](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4713) | Kerberos Policy was changed | The Kerberos Policy is what controls how authentication function across the domain. Changes to this should be monitored, alerted on, and investigated for malicious intent. |
| [4716](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4716) | Trusted domain information was modified | Trusts allow trusted access to your domain from a different (potentially malicious) domain. All relevant personnel should know about all trusts as they pose a massive potential security risk. |
| [4720](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4720) | User Creation | This is most useful in a smaller network. Unplanned user accounts created could indicate an attempt to maintain unauthorized access to the domain. |
| [4726](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4726) | User Deleted | This is most useful in a small network. User account deletions could cause a Denial of Service if the account is critical to a service. |
| [4728](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=4728) | User Added to Global Security Group | Groups that grant administrative permissions should be monitored for any unauthorized modifications |
| [4729](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventID=4729) | User Removed from Global Security Group | Groups that grant administrative permissions should be monitored for any unauthorized modifications |
| [4732](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4732) | User Added to Local Security Group | Groups that grant administrative permissions should be monitored for any unauthorized modifications |
| [4733](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4733) | User Removed from Local Security Group | Groups that grant administrative permissions should be monitored for any unauthorized modifications |
| [4739](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4739) | Domain Policy was changed | The Domain Policy is applied to all computers in the domain. Any unplanned/unauthorized changes should be monitored and investigated. |
| [4740](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4740) | User Account Locked Out | This should be monitored for high volumes. Could be an indication of brute forcing or password spraying attacks. |
| [4756](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventID=4756) | User Added to Universal Security Group | Groups that grant administrative permissions should be monitored for any unauthorized modifications |
| [4757](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventID=4757) | User Removed from Universal Security Group | Groups that grant administrative permissions should be monitored for any unauthorized modifications |
| [4782](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4782) | The password hash of an account was accessed | Accessing an account's password hash is almost never legitimate. These events should be investigated for malicious intent. |
| [4865](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4865) | A trusted forest information entry was added | Trusts allow trusted access to your forest from a different (potentially malicious) forest. All relevant personnel should know about all trusts as they pose a massive potential security risk. |
| [4866](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4866) | A trusted forest information entry was removed | A trusted forest information entry was added | Trusts allow trusted access to your forest from a different (potentially malicious) forest. All relevant personnel should know about all trusts as they pose a massive potential security risk. |
| [4867](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4867) | A trusted forest information entry was modified | A trusted forest information entry was added | Trusts allow trusted access to your forest from a different (potentially malicious) forest. All relevant personnel should know about all trusts as they pose a massive potential security risk. |
| [4906](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4906) | The CrashOnAuditFail value has changed | CrashOnAuditFail is a security protection that intentionally crashes the system when security events were unable to be written to the event log. It is rare for this to occur, so this should be investigated. |
| [5376](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5376) | Credential Manager credentials were backed up | This action is rare and could indicate malicious behavior. |
| [5377](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5377) | Credential Manager credentials were restored from backup | This action is rare and could indicate malicious behavior. |

***If you are going to use the alerts, modify the email properties in each of the scripts before running the Alerts.ps1 script.***
```
PS C:\> C:\WEFC\Alerts.ps1
```

## References
* [Palantir's windows-event-forwarding](https://github.com/palantir/windows-event-forwarding)
* [Monitoring What Matters](https://docs.microsoft.com/en-us/archive/blogs/jepayne/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem)
* [Intrusion Detection with Windows Event Forwarding](https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection)
* [Microsoft Security Auditing](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/security-auditing-overview)