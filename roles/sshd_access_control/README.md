#### Role name:
    sshd_access_control

#### Wazuh ID: 
    35643

#### Title: 
    Ensure sshd access is configured.

#### Description:
    There are several options available to limit which users and group can access the system via SSH. It is recommended that at least one of the following options be leveraged: - AllowUsers: o The AllowUsers variable gives the system administrator the option of allowing specific users to ssh into the system. The list consists of space separated user names. Numeric user IDs are not recognized with this variable. If a system administrator wants to restrict user access further by only allowing the allowed users to log in from a particular host, the entry can be specified in the form of user@host. - AllowGroups: o The AllowGroups variable gives the system administrator the option of allowing specific groups of users to ssh into the system. The list consists of space separated group names. Numeric group IDs are not recognized with this variable. - DenyUsers: o The DenyUsers variable gives the system administrator the option of denying specific users to ssh into the system. The list consists of space separated user names. Numeric user IDs are not recognized with this variable. If a system administrator wants to restrict user access further by specifically denying a user's access from a particular host, the entry can be specified in the form of user@host. - DenyGroups: o The DenyGroups variable gives the system administrator the option of denying specific groups of users to ssh into the system. The list consists of space separated group names. Numeric group IDs are not recognized with this variable.

#### Rationale:
    Restricting which users can remotely access the system via SSH will help ensure that only authorized users access the system.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set one or more of the parameters above any Include and Match set statements as follows: AllowUsers <userlist> - AND/OR - AllowGroups <grouplist> Note: - First occurrence of a option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a .conf file in an Include directory. - Be advised that these options are "ANDed" together. If both AllowUsers and AllowGroups are set, connections will be limited to the list of users that are also a member of an allowed group. It is recommended that only one be set for clarity and ease of administration. It is easier to manage an allow list than a deny list. In a deny list, you could potentially add a user or group and forget to add it to the deny list. -.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server installed (sshd)
    - /etc/ssh/sshd_config or /etc/ssh/sshd_config.d/ directory must be writable

#### Variables

| Variable                  | Default                                                         | Description                                                                | file              |
|---------------------------|-----------------------------------------------------------------|----------------------------------------------------------------------------|-------------------|
| `ssh_access_allow_groups` | `[]`                                                            | List of groups whose members are explicitly allowed to SSH into the system | defaults/main.yml |
| `ssh_access_allow_users`  | `['pro']` (IMPORTANT review/update this user account)           | List of users explicitly allowed to SSH into the system                    | defaults/main.yml |
| `ssh_access_config_file`  | `{{ ssh_config_include_dir }}/99-ssh-access-control.conf`       | Path to the generated SSH access control configuration file                | vars/main.yml     |
| `ssh_access_deny_groups`  | `[]`                                                            | List of groups whose members are explicitly denied SSH access              | defaults/main.yml |
| `ssh_access_deny_users`   | `[]`        (IMPORTANT review/update the list of user accounts) | List of users explicitly denied SSH access                                 | defaults/main.yml |
| `ssh_config_include_dir`  | `/etc/ssh/sshd_config.d`                                        | Directory for additional SSH configuration files                           | defaults/main.yml |
| `ssh_service_name`        | `ssh`                                                           | Name of the SSH service to restart when configuration changes              | defaults/main.yml |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']
    - 'fedramp': ['AC-5', 'AC-6']
    - 'gdpr': ['32', '25', '30']
    - 'hipaa': ['164.312(a)(1)']
    - 'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.8.3.3']
    - 'nis2': ['21.2.a', '21.2.b', '21.2.e']
    - 'nist_800-171': ['3.5.1', '3.5.2', '3.5.3', '3.13.1']
    - 'nist_800-53': ['AC-3', 'AC-5', 'AC-6', 'AC-17']
    - 'pci_dss': ['7.1', '7.2', '8.2']
    - 'tsc': ['CC6.1', 'CC6.2', 'CC6.3', 'CC6.6', 'CC7.2']

#### Mitre
    - 'tactic': ['TA0001', 'TA0011']
    - 'technique': ['T1078', 'T1136', 'T1548']

#### Conditions
    all

#### Rules
    - "c:grep -E '^\s*(AllowUsers|AllowGroups|DenyUsers|DenyGroups)' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/* 2>/dev/null | grep -v '^#' -> r:at least one of AllowUsers, AllowGroups, DenyUsers, or DenyGroups is set in sshd_config or sshd_config.d/*"
    - "c:systemctl is-enabled sshd -> r:service 'sshd' is enabled"
    - "c:sshd -t -> r:exit code 0"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - ssh_access_control
```

Or override variables:

```code
- hosts: servers
  become: true
  roles:
    - role: ssh_access_control
      ssh_access_allow_users:
        - admin
        - deploy
      ssh_access_deny_groups:
        - guests
        - temp_users
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
