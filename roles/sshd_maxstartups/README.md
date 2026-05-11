#### Role name:
    sshd_maxstartups

#### Wazuh ID: 
    35657

#### Title: 
    Ensure sshd MaxStartups is configured.

#### Description:
    The MaxStartups parameter specifies the maximum number of concurrent unauthenticated connections to the SSH daemon.

#### Rationale:
    To protect a system from denial of service due to a large number of pending authentication connection attempts, use the rate limiting function of MaxStartups to protect availability of sshd logins and prevent overwhelming the daemon.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the MaxStartups parameter to 10:30:60 or more restrictive above any Include entries as follows: MaxStartups 10:30:60 Note: First occurrence of a option takes precedence. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server installed (`sshd`)
    - `sshd -T` command available (standard in OpenSSH ≥ 4.0)

#### Variables

| Variable | Default | Description | file |
|----------|---------|-------------|------|
| `sshd_maxstartups_value` | `"10:30:60"` | Value for the `MaxStartups` parameter (format: `start:rate:full`) | defaults/main.yml |
| `sshd_config_file` | `/etc/ssh/sshd_config` | Path to the SSH daemon configuration file | defaults/main.yml |
| `sshd_service_name` | `sshd` | Name of the SSH service (used for restart if needed) | defaults/main.yml |

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
    - `c:sshd -T -> n:^\\s*maxstartups\\s+(\\d+):\\d+:\\d+ compare <= 10 && n:^maxstartups\\s+(\\d+):\\d+:\\d+ compare >= 1`
    - `c:sshd -T -> n:^\\s*maxstartups\\s+\\d+:(\\d+):\\d+ compare <= 30 && n:^maxstartups\\s+(\\d+):\\d+:\\d+ compare >= 1`
    - `c:sshd -T -> n:^\\s*maxstartups\\s+\\d+:\\d+:(\\d+) compare <= 60 && n:^maxstartups\\s+(\\d+):\\d+:\\d+ compare >= 1`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*MaxStartups\\s*\\t*(\\d+):\\d+:\\d+ compare > 10`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*MaxStartups\\s*\\t*(\\d+):\\d+:\\d+ compare == 0`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*MaxStartups\\s*\\t*\\d+:(\\d+):\\d+ compare > 30`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*MaxStartups\\s*\\t*\\d+:(\\d+):\\d+ compare == 0`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*MaxStartups\\s*\\t*\\d+:\\d+:(\\d+) compare > 60`
    - `not f:/etc/ssh/sshd_config -> n:^\\s*\\t*MaxStartups\\s*\\t*\\d+:\\d+:(\\d+) compare == 0`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_maxstartups
```

Optionally override the default value:

```code
- hosts: servers
  become: true
  vars:
    sshd_maxstartups_value: "5:20:30"
  roles:
    - sshd_maxstartups
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
