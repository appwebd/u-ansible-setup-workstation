#### Role name:
    ensure_chrony

#### Wazuh ID :  
    35592  

#### Title:  
    Ensure chrony is enabled and running.

#### Description:
    This Ansible role ensures that the chrony time synchronization service is properly configured, enabled, and running on target systems. This aligns with Wazuh requirement **35592** to maintain accurate system clocks across an enterprise network.

#### Rationale:
    chrony needs to be enabled and running in order to synchronize the system to a timeserver. Time synchronization is important to support time sensitive security mechanisms and to ensure log files have consistent time records across the enterprise to aid in forensic investigations.

#### Remediation:
    - IF - chrony is in use on the system, run the following commands:  
        # systemctl unmask chrony.service  
        # systemctl --now enable chrony.service  
    - OR 
    - If another time synchronization service is in use on the system, run the following command to remove chrony:  
        # apt purge chrony  
        # apt autoremove chrony  

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Ubuntu/Debian-based systems
    - `chrony` package installed

#### Variables

| Variable                          | Default                                      | Description                                                       | file                                                                   |
|-----------------------------------|----------------------------------------------|-------------------------------------------------------------------|------------------------------------------------------------------------|
| `chrony_package_name`             | `"chrony"`                                   | Name of the chrony package to install                             | defaults/main.yml                                                      |
| `systemd_timesyncd_service`       | `"systemd-timesyncd.service"`                | Systemd service name for alternative time synchronization service | defaults/main.yml                                                      |
| `chrony_service_name`             | `"chrony.service"`                           | Systemd service name for chrony                                   | vars/main.yml                                                          |
| `chrony_service_state`            | `"active"`                                   | Desired state of chrony service                                   | vars/main.yml                                                          |
| `systemd_timesyncd_check_command` | `"systemctl show systemd-timesyncd.service   | grep 'ActiveState=active'"`                                       | Command to check if alternative time synchronization service is active | vars/main.yml |
| `chrony_install_state`            | `"present"`                                  | Desired installation state of chrony package                      | vars/main.yml                                                          |

#### Dependencies
    No dependencies

#### Compliance mapping
    - 'cmmc': ['AU.L2-3.3.7']  
    - 'fedramp': ['AU-7']  
    - 'gdpr': ['32', '33']  
    - 'hipaa': ['164.312(b)', '164.308(a)(6)']  
    - 'iso_27001': ['A.12.4.1', 'A.12.4.2', 'A.12.4.3', 'A.16.1.2']  
    - 'nis2': ['21.2.a', '23', '21.2.b']  
    - 'nist_800_171': ['3.3.7']  
    - 'nist_800_53': ['AU-7']  
    - 'pci_dss': ['10.4', '10.6']  
    - 'tsc': ['CC4.1', 'CC5.2', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5', 'CC4.2']

#### Mitre
    - 'tactic': ['TA0005', 'TA0006', 'TA0007']
    - 'technique': ['T1562', 'T1070', 'T1059', 'T1040']
    - 'subtechnique': ['T1562.002', 'T1070.001']

#### Conditions
     all

#### Rules
    - "c:systemctl show chrony.service -> r:^LoadState=loaded"
    - "c:systemctl show chrony.service -> r:^ActiveState=active"
    - "not c:systemctl show systemd-timesyncd.service -> r:^LoadState=loaded|^ActiveState=active"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - ensure_chrony               
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
