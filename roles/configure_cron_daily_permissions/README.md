#### Role name:
    configure_cron_daily_permissions

#### Wazuh ID: 
    35596

#### Title: 
    Ensure permissions on /etc/cron.daily are configured.

#### Description:
    This Ansible role ensures that the /etc/cron.daily directory has secure ownership and permissions to prevent unauthorized access or modification. This role addresses security rule **35596** (Wazuh).

#### Rationale:
    Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls.

#### Remediation:
    - IF - cron is installed on the system: Run the following commands to set ownership and permissions on the /etc/cron.daily directory:  
      `# chown root:root /etc/cron.daily/`  
      `# chmod og-rwx /etc/cron.daily/.`

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux-based systems with `/etc/cron.daily` directory (typically systems with `cron` or `cronie` installed)

#### Variables

| Variable | Default | Description | file |
|---------|---------|-------------|------|
| `cron_daily_path` | `/etc/cron.daily` | Path to the cron daily directory | defaults/main.yml |
| `owner` | `root` | Owner of the directory | defaults/main.yml |
| `group` | `root` | Group owner of the directory | defaults/main.yml |
| `mode` | `0700` | Permissions mode for the directory (octal string) | defaults/main.yml |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']
    - 'fedramp': ['AC-5', 'AC-6']
    - 'gdpr': ['32', '25', '30']
    - 'hipaa': ['164.312(a)(1)']
    - 'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']
    - 'nis2': ['21.2.g', '21.2.j', '21.2.i']
    - 'nist_800_171': ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']
    - 'nist_800_53': ['AC-5', 'AC-6']
    - 'pci_dss': ['7.1', '1.3']
    - 'tsc': ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']

#### Mitre
    - 'tactic': ['TA0009', 'TA0010']
    - 'technique': ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']
    - 'subtechnique': ['T1048.003', 'T1552.001']

#### Conditions
    all

#### Rules
    - `c:stat /etc/cron.daily/ -> r:Access:\s*\t*\(0700/drwx------\)\\s*\t*Uid:\s*\t*\(\s*\t*0/\s*\t*root\)\\s*\t*Gid:\s*\t*\(\s*\t*0/\s*\t*root\)`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_cron_daily_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
