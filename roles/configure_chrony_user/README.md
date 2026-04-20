#### Role name: 
  configure_chrony_user

#### Wazuh ID : 
  35591

#### Title    : 
  Ensure chrony is running as user _chrony.

#### Description:
    This Ansible role ensures that the chronyd service runs under the dedicated system user `_chrony` as defined by the chrony package installation. It validates and enforces the `user _chrony` directive in the chrony configuration to prevent the service from running with excessive privileges.

#### Rationale:
    The chronyd service should run with only the required privileges to minimize the impact of potential security compromises.

#### Remediation:
    Add or edit the user line to `/etc/chrony/chrony.conf` or a file ending in `.conf` in `/etc/chrony/conf.d/`: `user _chrony`  
    - OR -  
    If another time synchronization service is in use on the system, run the following command to remove chrony from the system:  
    `# apt purge chrony`  
    `# apt autoremove chrony`

#### Requirements
    - Ansible 2.9 or higher  
    - Root/sudo privileges (`become: true`)  
    - Linux distributions supporting chrony (e.g., Ubuntu, Debian, RHEL, CentOS)  
    - `chrony` package installed (role handles configuration only; installation is out of scope)  

#### Variables

| Variable | Default | Description | File |
|----------|---------|-------------|------|
| `chrony_conf_dir` | `/etc/chrony` | Base directory for chrony configuration | vars/main.yml |
| `chrony_conf_file` | `/etc/chrony/chrony.conf` | Main chrony configuration file path | defaults/main.yml |
| `chrony_user` | `_chrony` | System user under which chronyd should run | defaults/main.yml |
| `chrony_user_line` | `user { { chrony_user } }` | Template line to ensure in config (not used directly; rendered) | defaults/main.yml |
| `chrony_service_name` | `chrony` | Name of the chrony service | vars/main.yml |
| `chrony_package_name` | `chrony` | Name of the chrony package | vars/main.yml |
| `chrony_conf_d_dir` | `/etc/chrony/conf.d` | Directory for additional .conf fragments | vars/main.yml |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AU.L2-3.3.7']  
    - 'fedramp': ['AU-7']  
    - 'gdpr': ['32', '33']  
    - 'hipaa': ['164.312(b)', '164.308(a)(6)']  
    - 'iso_27001': ['A.12.4.1', 'A.12.4.2', 'A.12.4.3', 'A.16.1.2']  
    - 'nis2': ['21.2.a', '23', '21.2.b']  
    - 'nist_800_171': ['3.3.7']  
    - 'nist_800_53': ['AU-7']  
    - 'pci_dss': ['10.4', '10.6']  
    - 'tsc': ['CC4.1', 'CC5.2', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5', 'CC4.2']  

#### Mitre
    - 'tactic': ['TA0005', 'TA0006', 'TA0007']  
    - 'technique': ['T1562', 'T1070', 'T1059', 'T1040']  
    - 'subtechnique': ['T1562.002', 'T1070.001']  

#### Conditions
    all

#### Rules
    - `"c:ps -ef -> r:_chrony.+chronyd"`  
    - `"not c:systemctl show systemd-timesyncd.service -> r:^LoadState=loaded|^ActiveState=active"`  

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_chrony_user
```

#### License
  Apache 2.0

#### Author
Patricio Rojas Ortiz
