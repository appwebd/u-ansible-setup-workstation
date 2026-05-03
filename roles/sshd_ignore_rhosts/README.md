#### Role name:
    sshd_ignore_rhosts

#### Wazuh ID: 
    35650

#### Title: 
    Ensure sshd IgnoreRhosts is enabled.

#### Description:
    The IgnoreRhosts parameter specifies that .rhosts and .shosts files will not be used in RhostsRSAAuthentication or HostbasedAuthentication. This Ansible role ensures that the `IgnoreRhosts` option is set to `yes` in the SSH daemon configuration file (`/etc/ssh/sshd_config`).

#### Rationale:
    Setting this parameter forces users to enter a password when authenticating with SSH.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the IgnoreRhosts parameter to yes above any Include and Match entries as follows: IgnoreRhosts yes Note: First occurrence of a option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server installed (`sshd`)
    - `/etc/ssh/sshd_config` file must exist

#### Variables

| Variable                   | Default                                        | Description                                                  | file              |
|----------------------------|------------------------------------------------|--------------------------------------------------------------|-------------------|
| `sshd_config_file`         | `/etc/ssh/sshd_config`                         | Path to the SSH daemon configuration file                    | defaults/main.yml |
| `sshd_ignore_rhosts_value` | `"yes"`                                        | Value to set for the `IgnoreRhosts` directive                | defaults/main.yml |
| `sshd_service_name`        | `sshd`                                         | Name of the SSH service to restart if configuration changes  | defaults/main.yml |

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
    - 'c:sshd -T -> r:^ignorerhosts yes'
    - 'not f:/etc/ssh/sshd_config -> r:^\\s*\\t*IgnoreRhosts\\s*\\t*no'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_ignore_rhosts
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
