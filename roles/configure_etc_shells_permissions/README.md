#### Role name:
    configure_etc_shells_permissions

#### Wazuh ID : 
  35769

#### Title    : 
  Ensure permissions on /etc/shells are configured

#### Description:
    This Ansible role ensures that the /etc/shells file has secure permissions, ownership, and group settings. The /etc/shells file contains the full pathnames of valid login shells and is consulted by chsh and other programs. This role addresses security rule **35769** (Wazuh).

#### Rationale:
    It is critical to ensure that the /etc/shells file is protected from unauthorized access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions.

#### Remediation:
    Run the following commands to remove excess permissions, set owner, and set group on /etc/shells:  
    `# chmod u-x,go-wx /etc/shells`  
    `# chown root:root /etc/shells`

#### Requirements            
    - Ansible 2.9 or higher  
    - Root/sudo privileges (`become: true`)  
    - Linux-based operating systems with `/etc/shells` present  
    - `stat` command available (standard on most Linux systems)

#### Variables

| Variable              | Default       | Description                                                                    | file              |
|-----------------------|---------------|--------------------------------------------------------------------------------|-------------------|
| `etc_shells_group`    | `root`        | Group of /etc/shells                                                           | defaults/main.yml |
| `etc_shells_mode`     | `0644`        | File permissions in octal notation                                             | defaults/main.yml |
| `etc_shells_owner`    | `root`        | Owner of /etc/shells                                                           | defaults/main.yml |
| `etc_shells_path`     | `/etc/shells` | Path to the shells configuration file                                          | defaults/main.yml |

#### Dependencies
    No dependencies

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
     all

#### Rules
    - "c:stat /etc/shells -> r:Access:\\s*\\(0644/-rw-r--r--\\)\\s*Uid:\\s*\\(\\s*\\t*0/\\s*\\t*root\\)\\s*\\t*Gid:\\s*\\(\\s*\\t*0/\\s*\\t*root\\)"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_etc_shells_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
