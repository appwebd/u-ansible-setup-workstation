#### Role name: 
    configure_local_login_banner

#### Wazuh ID : 
    35547

#### Title    : 
    Ensure local login warning banner is configured properly.

#### Description:
    This Ansible role ensures that the `/etc/issue` file is configured with an appropriate legal warning banner for local logins, removing system information exposure (e.g., OS release, architecture) and aligning with organizational security policy. This role addresses security rule **35547** (Wazuh).

#### Rationale:
    Warning messages inform users who are attempting to login to the system of their legal status regarding the system and must include the name of the organization that owns the system and any monitoring policies that are in place. Displaying OS and patch level information in login banners also has the side effect of providing detailed system information to attackers attempting to target specific exploits of a system. Authorized users can easily get this information by running the `uname -a` command once they have logged in.

#### Remediation:
    Edit the `/etc/issue` file with the appropriate contents according to your site policy, remove any instances of `\m`, `\r`, `\s`, `\v` or references to the OS platform.  
    Example: `# echo "Authorized users only. All activity may be monitored and reported." > /etc/issue`

#### Requirements
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux-based systems (tested on Debian, Ubuntu, RHEL, CentOS, Rocky Linux, AlmaLinux)
    - `/etc/issue` file must be writable (no immutable attributes)

#### Variables

| Variable               | Default                                                                | Description                                    | file              |
|------------------------|------------------------------------------------------------------------|------------------------------------------------|-------------------|
| `local_banner_content` | `"Authorized users only. All activity may be monitored and reported."` | Content to write to `/etc/issue`               | defaults/main.yml |
| `ensure_file_exists`   | `true`                                                                 | Whether to create `/etc/issue` if missing      | defaults/main.yml |
| `backup`               | `true`                                                                 | Whether to create a backup before modification | defaults/main.yml |

#### Dependencies
    No dependencies

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
    none

#### Rules
    - "f:/etc/issue -> r:\\\\v|\\\\r|\\\\m|\\\\s|Debian|Ubuntu"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_local_login_banner
```

Optionally override the banner content:

```code
- hosts: servers
  become: true
  vars:
    local_banner_content: "COMPANY NAME. AUTHORIZED ACCESS ONLY. ALL ACTIVITY MAY BE MONITORED."
  roles:
    - configure_local_login_banner
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
