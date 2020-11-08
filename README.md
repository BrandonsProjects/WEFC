# WEFC
Windows Event Forwarding and Collection

## About WEFC
WEFC (Windows Event Forwarding/Collection) is my own idea that borrows a lot of resources from [Palantir's windows-event-forwarding](https://github.com/palantir/windows-event-forwarding) and from [Jessica Payne @MSFT](https://docs.microsoft.com/en-us/archive/blogs/jepayne/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem). 

This repository is designed to be an easy initial Windows log collection system for those who do not currently collect logs or for those who want to supplement their existing log collection systems. I have also included optional Scheduled Tasks and PowerShell scripts that send basic email alerts to your security team. The PowerShell scripts will need to customized to fit your needs first.

## How to use WEFC
First, decide if you need the optional email alerts. If you currently do not have a SIEM or other log alerting system, this may be useful. If you already have alerting capabilities, you should skip it.

1. Download this repository onto the machine you will use for log collection.
2. Launch PowerShell as an administrator and navigate to the downloaded WEFC directory
3. Set the Execution Policy to Unrestricted and execute the Setup.ps1 script
```
Set-ExecutionPolicy Unrestricted
.\Setup.ps1
```
4. OPTIONAL: Execute the Alerts.ps1 script to create the scheduled tasks for alerting.
```
C:\WEFC\Alerts.ps1
```
5. Create and link a new Group Policy Object to the Organizational Unit containing the computers from which you would like to collect logs. Import the settings from the included GPO backup. Once the GPO is applied to the computers, it can take up to an hour for events to start being forwarded to the collector.

## References
* [Palantir's windows-event-forwarding](https://github.com/palantir/windows-event-forwarding)
* [Monitoring What Matters](https://docs.microsoft.com/en-us/archive/blogs/jepayne/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem)
* [Intrusion Detection with Windows Event Forwarding](https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection)
