#### Role name: 
    configure_gshadow_permissions

#### Wazuh ID : 
    35767

#### Title: 
    Ensure /etc/gshadow permissions are configured.
    
#### Description:
    This Ansible role ensures that the /etc/gshadow file (which stores group password hash data in encrypted form)
    has proper ownership and permissions to protect sensitive credentials and meet compliance requirements.
    It sets owner to `root`, group to `shadow`, and mode to `0640`.

#### Rationale:
    The /etc/gshadow file contains encrypted group passwords and must be protected from unauthorized access.
    Incorrect permissions (e.g., world-readable) could allow privilege escalation or reconnaissance by attackers.

#### Remediation:
    Run the following command to set the correct permissions:
    # chown root:shadow /etc/gshadow  
    # chmod 0640 /etc/gshadow

#### Requirements            
    - Ansible 2.16 or higher
    - Root/sudo privileges (`become: true`)
    - Systems with `/etc/gshadow` (Unix-like OS with shadow group support)

#### Variables

| Variable            | Default        | Description                       | file               |
|---------------------|----------------|-----------------------------------|--------------------|
| `expected_group`    | `shadow`       | Group ownership of `/etc/gshadow` | defaults/main.yml  |
| `expected_mode`     | `0640`         | File permissions (octal)          | defaults/main.yml  |
| `expected_owner`    | `root`         | Owner of `/etc/gshadow`           | defaults/main.yml  |
| `gshadow_file_path` | `/etc/gshadow` | Full path to the gshadow file     | defaults/main.yml  |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L1-3.1.20', 'AC.L2-3.5.2'], 
    - 'fedramp': ['AC-6', 'AC-6(1)'], 
    - 'gdpr': ['32'], 
    - 'hipaa': ['164.308(a)(4)(i)'], 
    - 'iso_27001': ['A.9.2.1', 'A.9.2.3', 'A.9.4.1'], 
    - 'nis2': ['18.2.a', '18.2.b'], 
    - 'nist_800_171': ['3.5.1', '3.5.2'], 
    - 'nist_800_53': ['AC-6', 'AC-6(1)'], 
    - 'pci_dss': ['7.1', '7.2', '8.2'], 
    - 'tsc': ['CC6.1', 'CC6.6', 'CC7.2']

#### Mitre
    - 'tactic': ['TA0001', 'TA0005'], 
    - 'technique': ['T1005', 'T1552']

#### Conditions
     all (systems with gshadow file)

#### Rules
    - "c:stat -c '%a:%U:%G' /etc/gshadow -> r:0640:root:shadow"

#### Usage

Include this role in your playbook:

```yaml
- hosts: all
  become: true
  roles:
    - configure_gshadow_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
