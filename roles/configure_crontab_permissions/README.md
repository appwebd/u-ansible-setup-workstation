#### Role name:
    configure_crontab_permissions

#### Wazuh ID: 
    35594

#### Title: 
    Ensure permissions on /etc/crontab are configured.

#### Description:
    This Ansible role ensures that the `/etc/crontab` file has correct ownership and permissions to prevent unauthorized access. Specifically, it sets the owner and group to `root` and restricts access to read/write for the owner only. This role addresses security rule **35594** (Wazuh).

#### Rationale:
    This file contains information on what system jobs are run by cron. Write access to these files could provide unprivileged users with the ability to elevate their privileges. Read access to these files could provide users with the ability to gain insight on system jobs that run on the system and could provide them a way to gain unauthorized privileged access.

#### Remediation:
    - IF - cron is installed on the system: Run the following commands to set ownership and permissions on `/etc/crontab`:  
      `# chown root:root /etc/crontab`  
      `# chmod og-rwx /etc/crontab`

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux-based systems with `/etc/crontab` present (typically systems with `cron` installed)

#### Variables

| Variable            | Default        | Description                                         | File              |
|---------------------|----------------|-----------------------------------------------------|-------------------|
| `crontab_file_path` | `/etc/crontab` | Path to the /etc/crontab file                       | defaults/main.yml |
| `crontab_owner`     | `root`         | Desired owner of the crontab file                   | defaults/main.yml |
| `crontab_group`     | `root`         | Desired group of the crontab file                   | defaults/main.yml |
| `crontab_mode`      | `0600`         | Desired permissions (octal) for the crontab file    | defaults/main.yml |

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
    - `"c:stat /etc/crontab -> r:Access:\\s*\\t*\\(0600/-rw-------\\)\\s*\\t*Uid:\\s*\\t*\\(\\s*\\t*0/\\s*\\t*root\\)\\s*\\t*Gid:\\s*\\t*\\(\\s*\\t*0/\\s*\\t*root\\)"`

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - configure_crontab_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
