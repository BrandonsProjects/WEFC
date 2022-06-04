# Group Policy
The included Group Policy Objects are meant to be imported into Active Directory and applied to Domain Controllers, Member Servers, and Workstations in the domain. These GPOs configure the Advanced Audit Policies, adds the NETWORK SERVICE account to the Event Log Readers group, enables some event channels that are disabled by default, and configures the Windows Event Collector target.

The GPOs need to be implemented for this project to work.

Names of included GPOs:
- **WEFC_Domain Controllers** - {62307896-FCBE-48C4-BE84-388E3E9FCBD3}
- **WEFC_Member Servers** - {8D2D182F-EC5F-4B5B-88A8-847125593218}
- **WEFC_Workstations** - {4068E5B2-08F0-4387-9BBD-99E742FEE12D}

## How to use
1. In the Group Policy Management Console, create 3 new GPOs and name them something similar to the provided names above.
2. Import each of the included GPOs from this repository onto each of the GPOs you created.
3. Edit the **Configure target Subscription Manager** (located at *Computer Configuration > Administrative Templates > Windows Components > Event Forwarding*) setting in each of the GPOs to point to your own Windows Event Collector.
4. Link each GPO to the respective Organizational Unit that includes the class of device to which it's meant to be applied (e.g. WEFC_Domain Controllers should be linked to the Domain Controllers OU)
