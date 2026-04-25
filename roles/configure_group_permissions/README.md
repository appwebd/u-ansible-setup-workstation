#### Role name:  
    configure_group_permissions

#### Wazuh ID :  
    35763

#### Title    :  
    Ensure permissions on /etc/group are configured.

#### Description:  
    This Ansible role ensures that the `/etc/group` file has correct permissions, ownership, and group ownership configured to prevent unauthorized modifications while maintaining necessary read access for system processes. This role addresses security rule **35763** (Wazuh).

#### Rationale:  
    The `/etc/group` file needs to be protected from unauthorized changes by non-privileged users, but needs to be readable as this information is used with many non-privileged programs.

#### Remediation:  
    Run the following commands to remove excess permissions, set owner, and set group on `/etc/group`:

  ```bash
  # chmod u-x,go-wx /etc/group  
  # chown root:root /etc/group
  ```

#### Requirements          
  - Ansible 2.9 or higher  
  - Root/sudo privileges (`become: true`)  
  - POSIX-compliant Unix-like operating systems (e.g., Linux distributions such as Ubuntu, Debian)  
  - Presence of `/etc/group` file (standard on all Unix-like systems)

#### Variables

| Variable                 | Default      | Description                                                         | file              |
|--------------------------|--------------|---------------------------------------------------------------------|-------------------|
| `etc_group_path`         | `/etc/group` | Path to the group file to secure                                    | defaults/main.yml |
| `etc_group_owner`        | `root`       | Owner of `/etc/group`                                               | defaults/main.yml |
| `etc_group_group`        | `root`       | Group owner of `/etc/group`                                         | defaults/main.yml |
| `etc_group_mode`         | `"0644"`     | Octal file mode (permissions) for `/etc/group`                      | defaults/main.yml |

#### Dependencies  
    No dependencies

#### Compliance mapping  
  - `'cmmc': ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']`  
  - `'fedramp': ['AC-5', 'AC-6']`  
  - `'gdpr': ['32', '25', '30']`  
  - `'hipaa': ['164.312(a)(1)']`  
  - `'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']`  
  - `'nis2': ['21.2.g', '21.2.j', '21.2.i']`  
  - `'nist_800_171': ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']`  
  - `'nist_800_53': ['AC-5', 'AC-6']`  
  - `'pci_dss': ['7.1', '1.3']`  
  - `'tsc': ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']`

#### Mitre  
  - `'tactic': ['TA0009', 'TA0010']`  
  - `'technique': ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']`  
  - `'subtechnique': ['T1048.003', 'T1552.001']`

#### Conditions  
    all

#### Rules  
  - `"c:stat /etc/group -> r:^Access:\\s*\\(0644/-rw-r--r--\\) && r:\\s*Uid:\\s*\\(\\s*\\t*0/\\s*\\t*root\\)\\s*\\t*Gid:\\s*\\(\\s*\\t*0/\\s*\\t*root\\)"`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_etc_group_permissions
```

#### License  
    Apache 2.0

#### Author  
    Patricio Rojas Ortiz
