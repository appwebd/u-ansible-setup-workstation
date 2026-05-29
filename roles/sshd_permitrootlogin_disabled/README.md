#### Role name:
    sshd_permitrootlogin_disabled

#### Wazuh ID: 
    35659

#### Title: 
    Ensure sshd PermitRootLogin is disabled.

#### Description:
    The PermitRootLogin parameter specifies if the root user can log in using SSH. The default is prohibit-password.

#### Rationale:
    Disallowing root logins over SSH requires system admins to authenticate using their own individual account, then escalating to root. This limits opportunity for non-repudiation and provides a clear audit trail in the event of a security incident.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the PermitRootLogin parameter to no above any Include and Match entries as follows: PermitRootLogin no Note: First occurrence of an option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.16 or higher
    - Root/sudo privileges (become: true)
    - Ubuntu systems with OpenSSH server installed (`ssh` service)
    - Read/write access to `/etc/ssh/sshd_config` or included configuration files

#### Variables

| Variable                     | Default                 | Description                                                                          | file             |
|------------------------------|-------------------------|--------------------------------------------------------------------------------------|-------------------|
| `sshd_config_file`           | `/etc/ssh/sshd_config`  | Path to the main SSH daemon configuration file                                       | defaults/main.yml |
| `sshd_permitrootlogin_value` | `"no"`                  | Value to set for `PermitRootLogin` directive                                         | defaults/main.yml |
| `sshd_service_name`          | `ssh`                   | Name of the SSH daemon service to restart if changed (Ubuntu uses `ssh`, not `sshd`) | defaults/main.yml |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.5', 'AC.L2-3.1.6', 'AC.L2-3.1.7', 'SC.L2-3.13.3']
    - 'fedramp': ['AC-6']
    - 'gdpr': ['32']
    - 'hipaa': ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)']
    - 'iso_27001': ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2']
    - 'nis2': ['21.2.i', '21.2.k']
    - 'nist_800_171': ['3.1.5', '3.1.6', '3.1.7', '3.13.3']
    - 'nist_800_53': ['AC-6']
    - 'pci_dss': ['7.1']
    - 'tsc': ['CC6.1', 'CC6.3', 'CC6.2', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']

#### Mitre
    - 'tactic': ['TA0006', 'TA0003']
    - 'technique': ['T1078', 'T1098', 'T1110', 'T1136', 'T1556']
    - 'subtechnique': ['T1556.001', 'T1550.001', 'T1550.002']

#### Conditions
    all

#### Rules
    - 'c:sshd -T -> r:^permitrootlogin no'
    - 'f:/etc/ssh/sshd_config -> r:^\\s*\\t*PermitRootLogin\\s*\\t*no'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_permitrootlogin_disabled
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
