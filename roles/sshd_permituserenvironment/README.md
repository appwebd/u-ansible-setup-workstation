#### Role name:
    sshd_permituserenvironment

#### Wazuh ID: 
    35660

#### Title: 
    Ensure sshd PermitUserEnvironment is disabled.

#### Description:
    This Ansible role ensures that the `PermitUserEnvironment` option in the SSH daemon configuration is set to `no`. This addresses security rule **35660** (Wazuh).

#### Rationale:
    Permitting users the ability to set environment variables through the SSH daemon could potentially allow users to bypass security controls (e.g. setting an execution path that has SSH executing trojan'd programs).

#### Remediation:
    Edit the `/etc/ssh/sshd_config` file to set the `PermitUserEnvironment` parameter to `no` above any `Include` entries as follows:  
    `PermitUserEnvironment no`  
    Note: First occurrence of an option takes precedence. If `Include` locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in `Include` location.

#### Requirements            
    - Ansible 2.9 or higher  
    - Root/sudo privileges (`become: true`)  
    - Linux systems with OpenSSH server (`sshd`) installed  
    - `/etc/ssh/sshd_config` file must exist and be writable  

#### Variables

| Variable | Default | Description | file |
|---------|---------|-------------|------|
| `sshd_config_file` | `/etc/ssh/sshd_config` | Path to the SSH daemon configuration file | defaults/main.yml |
| `sshd_permituserenvironment_value` | `"no"` | Value to set for `PermitUserEnvironment` | defaults/main.yml |
| `sshd_service_name` | `sshd` | Name of the SSH service (used for restart if needed) | vars/main.yml |

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
    - `c:sshd -T -> r:^permituserenvironment no`  
    - `not f:/etc/ssh/sshd_config -> r:^\\s*\\t*PermitUserEnvironment\\s*\\t*yes`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_permituserenvironment
```

Optionally override variables:

```code
- hosts: servers
  become: true
  vars:
    sshd_permituserenvironment_value: "no"
  roles:
    - sshd_permituserenvironment
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
