#### Role name:
    sshd_usepam

#### Wazuh ID: 
    35661

#### Title: 
    Ensure sshd UsePAM is enabled.

#### Description:
    The UsePAM directive enables the Pluggable Authentication Module (PAM) interface. If set to yes this will enable PAM authentication using ChallengeResponseAuthentication and PasswordAuthentication directives in addition to PAM account and session module processing for all authentication types.

#### Rationale:
    When usePAM is set to yes, PAM runs through account and session types properly. This is important if you want to restrict access to services based off of IP, time or other factors of the account. Additionally, you can make sure users inherit certain environment variables on login or disallow access to the server.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the UsePAM parameter to yes above any Include entries as follows: UsePAM yes Note: First occurrence of an option takes precedence. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server installed (`sshd` service)
    - Read/write access to `/etc/ssh/sshd_config`

#### Variables

| Variable            | Default                 | Description                                             | file              |
|---------------------|-------------------------|---------------------------------------------------------|-------------------|
| `sshd_config_file`  | `/etc/ssh/sshd_config`  | Path to the SSH daemon configuration file               | defaults/main.yml |
| `sshd_usepam_value` | `yes`                   | Value to set for the UsePAM directive                   | defaults/main.yml |
| `sshd_usepam_line`  | `UsePAM yes`            | Full configuration line to ensure (computed from above) | defaults/main.yml |
| `sshd_service_name` | `sshd`                  | Name of the SSH service (used for restart if needed)    | vars/main.yml     |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['IA.L2-3.5.7']
    - 'fedramp': ['AC-2', 'IA-2', 'IA-5', 'AC-11', 'AC-7', 'AU-6']
    - 'gdpr': ['32']
    - 'hipaa': ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)']
    - 'iso_27001': ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2']
    - 'nis2': ['21.2.i', '21.2.k']
    - 'nist_800_171': ['3.5.7']
    - 'nist_800_53': ['AC-2', 'IA-2', 'IA-5', 'AC-11', 'AC-7', 'AU-6']
    - 'pci_dss': ['2.2', '8.3', '8.1', '8.2']
    - 'tsc': ['CC6.1', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']

#### Mitre
    - 'tactic': ['TA0006', 'TA0003']
    - 'technique': ['T1078', 'T1098', 'T1110', 'T1136', 'T1556']
    - 'subtechnique': ['T1556.001', 'T1550.001', 'T1550.002']

#### Conditions
    all

#### Rules
    - 'c:sshd -T -> r:^usepam yes'
    - 'not f:/etc/ssh/sshd_config -> r:^\\s*\\t*UsePAM\\s*\\t*no'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_usepam
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
