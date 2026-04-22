#### Role name: 
    configure_remote_login_banner

#### Wazuh ID : 
    35548

#### Title    : 
    Ensure remote login warning banner is configured properly.

#### Description:
    The contents of the /etc/issue.net file are displayed to users prior to login for remote connections from configured services. Unix-based systems have typically displayed information about the OS release and patch level upon logging in to the system. This information can be useful to developers who are developing software for a particular OS platform. If mingetty(8) supports the following options, they display operating system information: \m - machine architecture \r - operating system release \s - operating system name \v - operating system version.

#### Rationale:
    Warning messages inform users who are attempting to login to the system of their legal status regarding the system and must include the name of the organization that owns the system and any monitoring policies that are in place. Displaying OS and patch level information in login banners also has the side effect of providing detailed system information to attackers attempting to target specific exploits of a system. Authorized users can easily get this information by running the " uname -a " command once they have logged in.

#### Requirements            
  - Ansible 2.9 or higher
  - Root/sudo privileges (become: true)
  - Unix-based operating systems (Linux distributions)
  - /etc/issue.net file must exist or be creatable (typically managed by sshd or getty)

#### Variables

| Variable                              | Default                                                                | Description                                  | file              |
|---------------------------------------|------------------------------------------------------------------------|----------------------------------------------|-------------------|
| `remote_login_warning_banner_path`    | `/etc/issue.net`                                                       | Path to the remote login warning banner file | defaults/main.yml |
| `remote_login_warning_banner_content` | `"Authorized users only. All activity may be monitored and reported."` | Content to write to the banner file          | defaults/main.yml |
| `remote_login_warning_banner_owner`   | `root`                                                                 | Owner of the banner file                     | defaults/main.yml |
| `remote_login_warning_banner_group`   | `root`                                                                 | Group of the banner file                     | defaults/main.yml |
| `remote_login_warning_banner_mode`    | `"0644"`                                                               | Permissions mode for the banner file         | defaults/main.yml |

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
  - 'f:/etc/issue.net -> r:\\v|\\r|\\m|\\s|Debian|Ubuntu'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_remote_login_warning_banner
```

Optionally, override the banner content in your inventory or playbook:

```code
- hosts: servers
  become: true
  vars:
    remote_login_warning_banner_content: "CONFIDENTIAL. Authorized users only. All activities are monitored and logged."
  roles:
    - configure_remote_login_warning_banner
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
