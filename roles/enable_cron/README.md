#### Role name:
    enable_cron_daemon

#### Wazuh ID: 
    35593

#### Title: 
    Ensure cron daemon is enabled and active.

#### Description:
    This Ansible role ensures that the cron daemon is enabled and active on the system. The cron daemon is used to execute batch jobs on the system.

#### Rationale:
    While there may not be user jobs that need to be run on the system, the system does have maintenance jobs that may include security monitoring that have to run, and cron is used to execute them.

#### Remediation:
    - IF - cron is installed on the system: Run the following commands to unmask, enable, and start cron:  
      `# systemctl unmask "$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $1}')"`  
      `# systemctl --now enable "$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $1}')"`

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux systems using `systemd` (e.g., RHEL/CentOS 7+, Ubuntu 16.04+, Debian 8+)
    - `cron` package installed (role handles both presence and absence of the service)

#### Variables

| Variable | Default | Description | file |
|----------|---------|-------------|------|
| `cron_service_name` | `auto` | Service name to manage (`auto` detects via `systemctl list-unit-files`) | defaults/main.yml |

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
    - "c:systemctl show cron.service -> r:^LoadState=loaded"
    - "c:systemctl show cron.service -> r:^ActiveState=active"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - enable_cron_daemon
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
