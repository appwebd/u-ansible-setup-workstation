#### Role name:
    sshd_config_permissions

#### Wazuh ID: 
    35640

#### Title: 
    Ensure permissions on /etc/ssh/sshd_config are configured.

#### Description:
    The file /etc/ssh/sshd_config, and files ending in .conf in the /etc/ssh/sshd_config.d directory, contain configuration specifications for sshd.

#### Rationale:
    configuration specifications for sshd need to be protected from unauthorized changes by non-privileged users.

#### Remediation:
    Run the following script to set ownership and permissions on /etc/ssh/sshd_config and files ending in .conf in the /etc/ssh/sshd_config.d directory:  
    ```bash
    #!/usr/bin/env bash
    chmod u-x,og-rwx /etc/ssh/sshd_config
    chown root:root /etc/ssh/sshd_config
    while IFS= read -r -d $'\0' l_file; do
      if [ -e "$l_file" ]; then
        chmod u-x,og-rwx "$l_file"
        chown root:root "$l_file"
      fi
    done < <(find /etc/ssh/sshd_config.d -type f -print0 2>/dev/null)
    ```  
    - IF - other locations are listed in an Include statement, *.conf files in these locations access should also be modified.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux-based systems with OpenSSH server installed
    - Presence of `/etc/ssh/sshd_config` and/or `/etc/ssh/sshd_config.d/` directory

#### Variables

| Variable                  | Default                                  | Description                                                   | file              |
|---------------------------|------------------------------------------|---------------------------------------------------------------|-------------------|
| `sshd_config_file`        | `/etc/ssh/sshd_config`                   | Path to the main SSH daemon configuration file                | defaults/main.yml |
| `sshd_config_dir`         | `/etc/ssh/sshd_config.d`                 | Path to the SSH configuration drop-in directory               | defaults/main.yml |
| `sshd_config_owner`       | `root`                                   | Owner for SSH config files                                    | defaults/main.yml |
| `sshd_config_group`       | `root`                                   | Group for SSH config files                                    | defaults/main.yml |
| `sshd_config_mode`        | `0600`                                   | File permissions for SSH config files (octal string)          | defaults/main.yml |
| `sshd_config_dir_mode`    | `0700`                                   | Directory permissions for SSH config directory (octal string) | defaults/main.yml |
| `sshd_config_permissions` | - `sshd_config_file` -`sshd_config_dir`  | List of files and directories to check permissions for        | vars/main.yml     |

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
    - "c:stat /etc/ssh/sshd_config -> r:Access:\\s*\\t*\\(0600/-rw-------\\)\\s*\\t*Uid:\\s*\\t*\\(\\s*\\t*0/\\s*root\\)\\s*Gid:\\s*\\t*\\(\\s*\\t*0/\\s*\\t*root\\)"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_config_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
