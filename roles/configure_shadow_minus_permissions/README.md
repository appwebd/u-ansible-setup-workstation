#### Role name: 
    configure_shadow_backup_permissions

#### Wazuh ID : 
    35766

#### Title    : 
    Ensure permissions on /etc/shadow- are configured.

#### Description:
    This Ansible role ensures that the `/etc/shadow-` file (backup shadow file) is protected with correct ownership and permissions to prevent unauthorized access to critical account security information.

#### Rationale:
    It is critical to ensure that the `/etc/shadow-` file is protected from unauthorized access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions.

#### Remediation:
    Run one of the following commands to set ownership of `/etc/shadow-` to root and group to either root or shadow:

    ```bash
        # chown root:shadow /etc/shadow-  
    
        -OR-  
    
        # chown root:root /etc/shadow-  
            
        Run the following command to remove excess permissions from `/etc/shadow-:  
        
        # chmod u-x,g-wx,o-rwx /etc/shadow-
    ```

#### Requirements

    - Ansible 2.9 or higher  
    - Root/sudo privileges (`become: true`)  
    - Linux systems with `/etc/shadow-` file present (typically after `shadow-utils` or `passwd` package operations)  
    - `stat` command available (standard on virtually all Linux systems)

#### Variables

| Variable                      | Default        | Description                                              | File              |
|-------------------------------|----------------|----------------------------------------------------------|-------------------|
| `shadow_file_path`            | `/etc/shadow-` | Path to the shadow backup file to validate and configure | defaults/main.yml |
| `expected_owner`              | `root`         | Expected user owner of the file                          | defaults/main.yml |
| `expected_group`              | `shadow`       | Expected group owner of the file                         | defaults/main.yml |
| `expected_mode`               | `0600`         | Expected file permissions (octal)                        | defaults/main.yml |

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
    - `c:stat /etc/shadow- -> r:^Access:\s*\(0640/-rw-r-----\)|Access:\s*\(0600/-rw-------\) && r:\s*Uid:\s*\(\s*\t*0/\s*\t*root\)s*\t*Gid:\s*\(\s*\t*0/\s*\t*root\)`  
    - `c:stat /etc/shadow- -> r:^Access:\s*\(0640/-rw-r-----\)|Access:\s*\(0600/-rw-------\) && r:\s*Uid:\s*\(\s*\t*0/\s*\t*root\)s*\t*Gid:\s*\(\s*\t*\d+/\s*\t*shadow\)`

#### Usage

Include this role in your playbook:

```code
- hosts: all
  become: true
  roles:
    - configure_shadow_backup_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
