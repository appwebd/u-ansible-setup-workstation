#### Role name:
    sshd_maxauthtries

#### Wazuh ID: 
    35655

#### Title: 
    Ensure sshd MaxAuthTries is configured.

#### Description:
    The MaxAuthTries parameter specifies the maximum number of authentication attempts permitted per connection. When the login failure count reaches half the number, error messages will be written to the syslog file detailing the login failure.

#### Rationale:
    Setting the MaxAuthTries parameter to a low number will minimize the risk of successful brute force attacks to the SSH server. While the recommended setting is 4, set the number based on site policy.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the MaxAuthTries parameter to 4 or less above any Include and Match entries as follows: MaxAuthTries 4 Note: First occurrence of an option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server (`sshd`) installed
    - `/etc/ssh/sshd_config` file must exist and be writable

#### Variables
### defaults/main.yml

| Variable                  | Default                | Description                                          |
|---------------------------|------------------------|------------------------------------------------------|
| `sshd_maxauthtries_value` | `4`                    | Desired value for `MaxAuthTries` parameter           |
| `sshd_config_file`        | `/etc/ssh/sshd_config` | Path to the SSH daemon configuration file            |

### vars/main.yml
| Variable                  | Default                | Description                                          |
|---------------------------|------------------------|------------------------------------------------------|
| `sshd_service_name`       | `sshd`                 | Name of the SSH service (used for restart if needed) |

#### Dependencies
    No dependencies

#### Compliance mapping
    - 'cmmc': ['AU.L2-3.3.1']
    - 'fedramp': ['AU-3', 'AU-7']
    - 'gdpr': ['32', '33']
    - 'hipaa': ['164.312(b)', '164.308(a)(6)']
    - 'iso_27001': ['A.12.4.1', 'A.12.4.2', 'A.12.4.3', 'A.16.1.2']
    - 'nis2': ['21.2.a', '23', '21.2.b']
    - 'nist_800_171': ['3.3.1']
    - 'nist_800_53': ['AU-3', 'AU-7']
    - 'pci_dss': ['10.1', '10.2', '10.3', '9.4']
    - 'tsc': ['CC5.2', 'CC7.2', 'CC7.1', 'CC7.3', 'CC7.4', 'CC7.5', 'CC4.1', 'CC4.2']

#### Mitre
    - 'tactic': ['TA0005', 'TA0006', 'TA0007']
    - 'technique': ['T1562', 'T1070', 'T1059', 'T1040']
    - 'subtechnique': ['T1562.002', 'T1070.001']

#### Conditions
    all

#### Rules
    - `c:sshd -T -> n:^maxauthtries\s+(\d+) compare <= 4`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*maxauthtries\s+(\d+) compare > 4`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_maxauthtries
```

Optionally override the default value:

```code
- hosts: servers
  become: true
  vars:
    sshd_maxauthtries_value: 3
  roles:
    - sshd_maxauthtries
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
