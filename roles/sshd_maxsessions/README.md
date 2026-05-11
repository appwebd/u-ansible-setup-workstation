#### Role name:
    configure_sshd_maxsessions

#### Wazuh ID: 
    35656

#### Title: 
    Ensure sshd MaxSessions is configured.

#### Description:
    The MaxSessions parameter specifies the maximum number of open sessions permitted from a given connection. This Ansible role ensures the `MaxSessions` parameter in `/etc/ssh/sshd_config` is set to a value of 10 or less, in accordance with security best practices.

#### Rationale:
    To protect a system from denial of service due to a large number of concurrent sessions, use the rate limiting function of MaxSessions to protect availability of sshd logins and prevent overwhelming the daemon.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the MaxSessions parameter to 10 or less above any Include and Match entries as follows: MaxSessions 10. Note: First occurrence of an option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux systems with OpenSSH server (`sshd`) installed
    - Read/write access to `/etc/ssh/sshd_config` or included configuration files

#### Variables

| Variable | Default | Description | File |
|----------|---------|-------------|------|
| `sshd_maxsessions_value` | `10` | Value for `MaxSessions` parameter in sshd_config | defaults/main.yml |
| `sshd_config_file` | `/etc/ssh/sshd_config` | Path to the main sshd configuration file | defaults/main.yml |
| `sshd_service_name` | `sshd` | Name of the SSH daemon service (used for restart if needed) | defaults/main.yml |

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
    - `c:sshd -T -> n:^maxsessions\s*\t*(\d+) compare <= 10`
    - `not f:/etc/ssh/sshd_config -> n:^^\s*\t*MaxSessions\s+(\d+) compare > 10`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_sshd_maxsessions
```

Optionally override the default `MaxSessions` value:

```code
- hosts: servers
  become: true
  roles:
    - role: configure_sshd_maxsessions
      sshd_maxsessions_value: 5
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
