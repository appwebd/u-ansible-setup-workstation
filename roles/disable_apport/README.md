#### Role name:
    disable_apport

#### Wazuh ID: 
    35545

#### Title: 
    Ensure Automatic Error Reporting is not enabled.

#### Description:
    This Ansible role ensures that the Apport Error Reporting Service is disabled on the system to prevent the automatic generation of crash reports. This role addresses security rule **35545** (Wazuh).

#### Rationale:
    Apport collects potentially sensitive data, such as core dumps, stack traces, and log files. They can contain passwords, credit card numbers, serial numbers, and other private material.

#### Remediation:
    Edit /etc/default/apport and add or edit the enabled parameter to equal 0: enabled=0  
    Run the following commands to stop and mask the apport service:  
    # systemctl stop apport.service  
    # systemctl mask apport.service  
    - OR -  
    Run the following command to remove the apport package:  
    # apt purge apport

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Debian-based systems (Ubuntu, Debian)
    - `apport` package installed (optional — role handles both presence and absence)

#### Variables

| Variable               | Default               | Description                                         | file              |
|------------------------|-----------------------|-----------------------------------------------------|-------------------|
| `apport_enabled_value` | `0`                   | Value to set for `enabled` in `/etc/default/apport` | defaults/main.yml |
| `apport_config_file`   | `/etc/default/apport` | Path to Apport configuration file                   | defaults/main.yml |
| `apport_service_name`  | `apport.service`      | Systemd service name for Apport                     | defaults/main.yml |
| `apport_package_name`  | `apport`              | Package name for Apport (internal use)              | vars/main.yml     |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6']
    - 'fedramp': ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    - 'gdpr': ['32']
    - 'hipaa': ['164.308(a)(1)']
    - 'iso_27001': ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']
    - 'nis2': ['21.2.e', '21.2.a']
    - 'nist_800_171': ['3.4.7', '3.4.8', '3.13.6']
    - 'nist_800_53': ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    - 'pci_dss': ['1.1', '1.2', '2.2', '6.4']
    - 'tsc': ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']

#### Mitre
    - 'tactic': ['TA0005']
    - 'technique': ['T1036', 'T1564']

#### Conditions
    all

#### Rules
    - "c:systemctl is-enabled apport.service -> r:disabled|not-found"
    - "not f:/etc/default/apport -> n:enabled=(\\d+) compare != 0"
    - "not c:systemctl is-active apport.service -> r:^active$"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - disable_apport
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
