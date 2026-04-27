#### Role name: 
    configure_group_minus_permissions  
#### Wazuh ID: 
    35764  
#### Title: 
    Ensure permissions on /etc/group- are configured
    
#### Description:
    This Ansible role ensures that the backup group file `/etc/group-` has secure ownership and permissions to protect group password hashes from unauthorized access. This addresses Wazuh security rule **35764**.

#### Rationale:
    The `/etc/group-` file may contain group password hashes (though rarely used in modern systems). Regardless, leaving it with permissive ownership or permissions increases the attack surface and violates security best practices.

#### Remediation:
    Set the ownership to root:root and permissions to `0640` (`u-x,go-wx`) on `/etc/group-`.

#### Requirements

    - Ansible 2.16 or higher  
    - Root/sudo privileges (`become: true`)  
    - Debian/Ubuntu systems (where `/etc/group-` may exist)  

#### Variables

| Variable                  | Default       | Description                       | file               |
|---------------------------|---------------|-----------------------------------|--------------------|
| `group_backup_file`       | `/etc/group-` | Path to the group backup file     | defaults/main.yml  |
| `group_backup_file_mode`  | `0640`        | Required file permissions (octal) | defaults/main.yml  |
| `group_backup_file_owner` | `root`        | Owner of the file                 | defaults/main.yml  |
| `group_backup_file_group` | `root`        | Group of the file                 | defaults/main.yml  |

#### Dependencies
    None

#### Compliance mapping
    'cmmc': ['AC.L2-3.5.1', 'AC.L2-3.5.2'],  
    'fedramp': ['AC-6', 'AC-6.1'],  
    'gdpr': ['32'],  
    'hipaa': ['164.308(a)(1)'],  
    'iso_27001': ['A.9.2.1', 'A.9.2.3', 'A.9.4.1'],  
    'nis2': ['21.2.a', '21.2.e'],  
    'nist_800_171': ['3.5.1', '3.5.2'],  
    'nist_800_53': ['AC-6', 'AC-6.1'],  
    'pci_dss': ['7.1', '7.2', '8.2'],  
    'tsc': ['CC6.1', 'CC6.3', 'CC6.6', 'CC7.2']

#### Mitre
    'tactic': ['TA0001', 'TA0005'],  
    'technique': ['T1222', 'T1548']

#### Conditions
     All Debian/Ubuntu hosts (tasks only run if `/etc/group-` exists)

#### Rules
    - "c:stat -c '%U:%G %a' /etc/group- -> r:file '/etc/group-' owner is 'root:root' and mode '0640'"

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - configure_group_minus_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
