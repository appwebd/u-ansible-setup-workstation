#### Role name:
    sshd_permitemptypasswords_disabled

#### Wazuh ID: 
    35658

#### Title: 
    Ensure sshd PermitEmptyPasswords is disabled.

#### Description:
    The PermitEmptyPasswords parameter specifies if the SSH server allows login to accounts with empty password strings.

#### Rationale:
    Disallowing remote shell access to accounts that have an empty password reduces the probability of unauthorized access to the system.

#### Remediation:
    Edit /etc/ssh/sshd_config and set the PermitEmptyPasswords parameter to no above any Include and Match entries as follows: PermitEmptyPasswords no Note: First occurrence of an option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server installed
    - `/etc/ssh/sshd_config` file must exist

#### Variables

| Variable | Default | Description | file |
|---------|---------|-------------|------|
| `sshd_config_file` | `/etc/ssh/sshd_config` | Path to the SSH daemon configuration file | defaults/main.yml |
| `sshd_permit_empty_passwords_value` | `"no"` | Value to enforce for PermitEmptyPasswords | defaults/main.yml |
| `sshd_service_name` | `sshd` | Name of the SSH service to restart if configuration changes | vars/main.yml |


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
    - 'c:sshd -T -> r:^permitemptypasswords no'
    - 'not f:/etc/ssh/sshd_config -> r:^\\s*\\t*PermitEmptyPasswords\\s*\\t*yes'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_permitemptypasswords_disabled
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
