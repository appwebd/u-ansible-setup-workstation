#### Role name:
    sshd_logingracetime

#### Wazuh ID: 
    35652

#### Title: 
    Ensure sshd LoginGraceTime is configured.

#### Description:
    The LoginGraceTime parameter specifies the time allowed for successful authentication to the SSH server. The longer the Grace period is the more open unauthenticated connections can exist. Like other session controls in this session the Grace Period should be limited to appropriate organizational limits to ensure the service is available for needed access.

#### Rationale:
    Setting the LoginGraceTime parameter to a low number will minimize the risk of successful brute force attacks to the SSH server. It will also limit the number of concurrent unauthenticated connections While the recommended setting is 60 seconds (1 Minute), set the number based on site policy.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the LoginGraceTime parameter to 60 seconds or less above any Include entry as follows: LoginGraceTime 60 Note: First occurrence of a option takes precedence. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server (`sshd`) installed
    - `/etc/ssh/sshd_config` file must exist and be writable

#### Variables

| Variable                    | Default                | Description                                          | file              |
|-----------------------------|------------------------|------------------------------------------------------|-------------------|
| `sshd_config_file`          | `/etc/ssh/sshd_config` | Path to the SSH daemon configuration file            | defaults/main.yml |
| `sshd_logingracetime_value` | `60`                   | Value (in seconds) for the LoginGraceTime parameter  | defaults/main.yml |
| `sshd_service_name`         | `sshd`                 | Name of the SSH service (used for restart if needed) | vars/main.yml     |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['CM.L2-3.4.1', 'CA.L2-3.12.4']
    - 'fedramp': ['CM-8']
    - 'gdpr': ['30', '32']
    - 'hipaa': ['164.308(a)(4)', '164.312(a)(1)']
    - 'iso_27001': ['A.8.1.1', 'A.8.1.2']
    - 'nis2': ['21.2.j', '21.2.a']
    - 'nist_800_171': ['3.4.1', '3.12.4']
    - 'nist_800_53': ['CM-8']
    - 'pci_dss': ['2.4', '9.1', '9.2', '9.3', '11.1', '9.5', '11.2', '12.5']
    - 'tsc': ['CC6.1', 'CC3.2', 'CC5.1', 'CC5.2', 'CC5.3', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8']

#### Mitre
    - 'tactic': ['TA0007']
    - 'technique': ['T1595', 'T1046', 'T1087']

#### Conditions
    all

#### Rules
    - `c:sshd -T -> n:^\\s*logingracetime\\s*(\\d+) compare <= 60 && n:^logingracetime\\s*(\\d+) compare >= 1`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*LoginGraceTime\\s*\\t*(\\d+) compare > 60`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*LoginGraceTime\\s*\\t*(\\d+) compare == 0`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_logingracetime
```

Optionally override the default value:

```code
- hosts: servers
  become: true
  vars:
    sshd_logingracetime_value: 30
  roles:
    - sshd_logingracetime
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
