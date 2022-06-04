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

If you are going to use the alerts, modify the email properties in each of the scripts before running the Alerts.ps1 script.

```
PS C:\> C:\WEFC\Alerts.ps1
```

## References
* [Palantir's windows-event-forwarding](https://github.com/palantir/windows-event-forwarding)
* [Monitoring What Matters](https://docs.microsoft.com/en-us/archive/blogs/jepayne/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem)
* [Intrusion Detection with Windows Event Forwarding](https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection)
* [Microsoft Security Auditing](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/security-auditing-overview)