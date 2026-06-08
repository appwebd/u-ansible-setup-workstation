#### Role name: 
    enable_systemd_timesyncd
#### Wazuh ID : 
    35589
#### Title    : 
    Ensure systemd-timesyncd is enabled and running

#### Description:
    This Ansible role ensures that the systemd-timesyncd service is installed, enabled, and running to provide time synchronization. This role addresses security rule **35589** (Wazuh), promoting system time integrity which is crucial for log correlation, authentication (e.g., Kerberos), and forensic analysis.

#### Rationale:
    Accurate system time is essential for security operations. Time synchronization helps ensure synchronized logs across systems, supports certificate validation, and maintains audit trail integrity. Disabling or misconfiguring systemd-timesyncd may lead to time drift, undermining security monitoring and compliance.

#### Remediation:
    Run the following commands to enable and start systemd-timesyncd:

```bash
systemctl enable systemd-timesyncd
systemctl start systemd-timesyncd

```
Verify status with:
```bash
timedatectl status
timedatectl show-timesync
```

#### Requirements
 
    - Ansible 2.16 or higher
    - Root/sudo privileges (become: true)
    - Debian/Ubuntu-based systems
    - systemd >= 219 (standard in Ubuntu 16.04+, Debian 9+)

#### Variables

| Variable     | Default           | Description  |
|--------------|-------------------|--------------|
| package_name | systemd-timesyncd | Package name |

#### Dependencies
    None

#### Compliance mapping

        - `cmmc`: ['AC.L2-4.3.8', 'SI.L2-4.14.2']
        - `fedramp`: ['AU-8', 'SI-4']
        - `gdpr`: ['32']
        - `hipaa`: ['164.308(a)(1)(ii)(D)']
        - `iso_27001`: ['A.12.1.1', 'A.12.1.2', 'A.12.4.5']
        - `nis2`: ['21.2.e']
        - `nist_800_171`: ['3.14.2', '3.14.3']
        - `nist_800_53`: ['AU-8', 'SI-4']
        - `pci_dss`: ['10.3', '10.4']
        - `tsc`: ['CC6.6', 'CC6.1', 'CC6.3', 'CC6.7']

#### Mitre
 
        - `tactic`: ['TA0040']
        - `technique`: ['T1562.006']

#### Conditions
All Ubuntu/Debian servers where time synchronization is required.

#### Rules
- `c:systemctl is-enabled systemd-timesyncd.service → r:enabled`
- `c:timedatectl show-timesync --property=SystemClockSynchronized → r:1`

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - enable_systemd_timesyncd
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
