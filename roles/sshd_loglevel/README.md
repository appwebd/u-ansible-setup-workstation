#### Role name:
    configure_sshd_loglevel

#### Wazuh ID: 
    35653

#### Title: 
    Ensure sshd LogLevel is configured.

#### Description:
    SSH provides several logging levels with varying amounts of verbosity. The DEBUG options are specifically not recommended other than strictly for debugging SSH communications. These levels provide so much data that it is difficult to identify important security information, and may violate the privacy of users.

#### Rationale:
    The INFO level is the basic level that only records login activity of SSH users. In many situations, such as Incident Response, it is important to determine when a particular user was active on a system. The logout record can eliminate those users who disconnected, which helps narrow the field. The VERBOSE level specifies that login and logout activity as well as the key fingerprint for any SSH key used for login will be logged. This information is important for SSH key management, especially in legacy environments.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the LogLevel parameter to VERBOSE or INFO above any Include and Match entries as follows: LogLevel VERBOSE - OR - LogLevel INFO Note: First occurrence of an option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Systems with OpenSSH server installed (`sshd` package)
    - `/etc/ssh/sshd_config` file must exist

#### Variables

| Variable            | Default                  | Description                                              | file              |
|---------------------|--------------------------|----------------------------------------------------------|-------------------|
| `sshd_config_file`  | `"/etc/ssh/sshd_config"` | Path to the SSH daemon configuration file                | defaults/main.yml |
| `sshd_loglevel`     | `"VERBOSE"`              | Desired SSH LogLevel value (must be `VERBOSE` or `INFO`) | defaults/main.yml |
| `sshd_service_name` | `"ssh"`                  | Name of the SSH service (used for restart if needed)     | vars/main.yml     |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AU.L2-3.3.1']
    - 'fedramp': ['AU-7']
    - 'gdpr': ['32', '33']
    - 'hipaa': ['164.312(b)']
    - 'iso_27001': ['A.12.4.1', 'A.12.4.2', 'A.12.4.3', 'A.16.1.2']
    - 'nis2': ['21.2.a', '23', '21.2.b']
    - 'nist_800_171': ['3.3.1']
    - 'nist_800_53': ['AU-7']
    - 'pci_dss': ['10.2', '10.3', '5.3', '6.4']
    - 'tsc': ['CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5', 'CC4.1', 'CC4.2']

#### Mitre
    - 'tactic': ['TA0005', 'TA0006', 'TA0007']
    - 'technique': ['T1562', 'T1070', 'T1059', 'T1040']
    - 'subtechnique': ['T1562.002', 'T1070.001']

#### Conditions
    any

#### Rules
    - `c:sshd -T -> r:^loglevel VERBOSE|^loglevel INFO`
    - `not f:/etc/ssh/sshd_config -> !r:^\\s*\\t*loglevel\\s*\\t*VERBOSE|^\\s*\\t*loglevel\\s*\\t*INFO`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_sshd_loglevel
```

Optionally override the log level:

```code
- hosts: servers
  become: true
  vars:
    sshd_loglevel: "INFO"
  roles:
    - configure_sshd_loglevel
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
