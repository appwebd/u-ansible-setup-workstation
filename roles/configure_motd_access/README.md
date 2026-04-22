#### Role name: 
    configure_motd_access

#### Wazuh ID : 
    35549

#### Title: 
    Ensure access to /etc/motd is configured.
    
#### Description:
    This Ansible role ensures that the `/etc/motd` file is configured with proper access controls to prevent unauthorized modification. It verifies that the file is owned by root:root and has permissions set to `0644`, or alternatively removes the file entirely if not needed.

#### Rationale:
    If the `/etc/motd` file does not have the correct access configured, it could be modified by unauthorized users with incorrect or misleading information, potentially misleading authenticated users or being exploited for social engineering.

#### Remediation:

    Run the following commands to set mode, owner, and group on /etc/motd:

    `chown root:root $(readlink -e /etc/motd)`  
    `chmod u-x,go-wx $(readlink -e /etc/motd)`  

    - OR -  

    Run the following command to remove the /etc/motd file:  

    `rm /etc/motd`.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux-based operating systems (tested on Debian, RHEL, Ubuntu, CentOS)
    - `stat` command available (standard on most Unix-like systems)

#### Variables

| Variable                 | Default                                                                                            | Description                                                         | file              |
|--------------------------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------|-------------------|
| `motd_file_path`         | `/etc/motd`                                                                                        | Path to the MOTD file to check and configure                        | defaults/main.yml |
| `motd_owner`             | `root`                                                                                             | Desired owner of the MOTD file                                      | defaults/main.yml |
| `motd_group`             | `root`                                                                                             | Desired group of the MOTD file                                      | defaults/main.yml |
| `motd_mode`              | `0644`                                                                                             | Desired permission mode for the MOTD file (octal)                   | defaults/main.yml |
| `motd_remove_file`       | `false`                                                                                            | When `true`, the role removes `/etc/motd` instead of configuring it | defaults/main.yml |
| `motd_file_stat_pattern` | `Access:\\s*\\(0644/-rw-r--r--\\)\\s*Uid:\\s*\\(\\s*0/\\s*root\\)\\s*Gid:\\s*\\(\\s*0/\\s*root\\)` | Regex pattern used by Wazuh for compliance checks (internal)        | vars/main.yml     |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']
    - 'fedramp': ['AC-5', 'AC-6']
    - 'gdpr': ['32', '25', '30']
    - 'hipaa': ['164.312(a)(1)']
    - 'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']
    - 'nis2': ['21.2.g', '21.2.j', '21.2.i']
    - 'nist_800_171': ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']
    - 'nist_800_53': ['AC-5', 'AC-6']
    - 'pci_dss': ['7.1', '1.3']
    - 'tsc': ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']

#### Mitre
    - 'tactic': ['TA0009', 'TA0010']
    - 'technique': ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']
    - 'subtechnique': ['T1048.003', 'T1552.001']

#### Conditions
    any

#### Rules
    - "c:stat /etc/motd -> r:Access:\\s*\\(0644/-rw-r--r--\\)\\s*Uid:\\s*\\(\\s*0/\\s*root\\)\\s*\\t*Gid:\\s*\\(\\s*0/\\s*root\\)"
    - "not f:/etc/motd"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_motd_access
```

To remove `/etc/motd` instead of configuring it, set the variable:

```code
- hosts: servers
  become: true
  vars:
    motd_remove_file: true
  roles:
    - configure_motd_access
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
