#### Role name:
    secure_opasswd_permissions

#### Wazuh ID: 
    35770

#### Title: 
    Ensure permissions on /etc/security/opasswd are configured.

#### Description:
    /etc/security/opasswd and its backup /etc/security/opasswd.old hold user's previous passwords if pam_unix or pam_pwhistory is in use on the system.

#### Rationale:
    It is critical to ensure that /etc/security/opasswd is protected from unauthorized access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions.

#### Remediation:
    Run the following commands to remove excess permissions, set owner, and set group on /etc/security/opasswd and /etc/security/opasswd.old if they exist:  
    # [ -e "/etc/security/opasswd" ] && chmod u-x,go-rwx /etc/security/opasswd  
    # [ -e "/etc/security/opasswd" ] && chown root:root /etc/security/opasswd  
    # [ -e "/etc/security/opasswd.old" ] && chmod u-x,go-rwx /etc/security/opasswd.old  
    # [ -e "/etc/security/opasswd.old" ] && chown root:root /etc/security/opasswd.old

#### Requirements            
    - Ansible 2.9 or higher  
    - Root/sudo privileges (become: true)  
    - Linux-based operating systems with PAM (Pluggable Authentication Modules) support  
    - Files /etc/security/opasswd and/or /etc/security/opasswd.old may exist (role handles conditional presence)

#### Variables

| Variable              | Default                     | Description                                | file              |
|-----------------------|-----------------------------|--------------------------------------------|-------------------|
| `opasswd_backup_file` | `/etc/security/opasswd.old` | Path to the opasswd backup file            | defaults/main.yml |
| `opasswd_file`        | `/etc/security/opasswd`     | Path to the opasswd file                   | defaults/main.yml |
| `opasswd_group`       | `root`                      | Group of the opasswd files                 | defaults/main.yml |
| `opasswd_mode`        | `0600`                      | File permissions (octal) for opasswd files | defaults/main.yml |
| `opasswd_owner`       | `root`                      | Owner of the opasswd files                 | defaults/main.yml |

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
    all

#### Rules
    - "c:stat -c \"%a %U %G\" /etc/security/opasswd -> r:^600\\s+root\\s+root$"  
    - "c:stat -c \"%a %U %G\" /etc/security/opasswd.old -> r:^600\\s+root\\s+root$"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - secure_opasswd_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
