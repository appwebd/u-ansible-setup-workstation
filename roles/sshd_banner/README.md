#### Role name:
    sshd_banner

#### Wazuh ID: 
    35644

#### Title: 
    Ensure sshd Banner is configured.

#### Description:
    The Banner parameter specifies a file whose contents must be sent to the remote user before authentication is permitted. By default, no banner is displayed. This Ansible role ensures the SSH daemon (`sshd`) is configured to display a warning banner prior to authentication.

#### Rationale:
    Banners are used to warn connecting users of the particular site's policy regarding connection. Presenting a warning message prior to the normal user login may assist the prosecution of trespassers on the computer system.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the Banner parameter above any Include and Match entries as follows: Banner /etc/issue.net Note: First occurrence of a option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location. Edit the file being called by the Banner argument with the appropriate contents according to your site policy, remove any instances of \m , \r , \s , \v or references to the OS platform Example: # printf '%s\n' "Authorized users only. All activity may be monitored and reported." > "$(sshd -T | awk '$1 == "banner" {print $2}')".

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux systems with OpenSSH server (`sshd`) installed
    - Write access to `/etc/ssh/sshd_config` and the banner file path

#### Variables

| Variable              | Default                                                                | Description                                | File              |
|-----------------------|------------------------------------------------------------------------|--------------------------------------------|-------------------|
| `sshd_banner_content` | `"Authorized users only. All activity may be monitored and reported."` | Content to write to the banner file        | defaults/main.yml |
| `sshd_banner_enabled` | `true`                                                                 | Whether to enforce banner configuration    | defaults/main.yml |
| `sshd_banner_file`    | `/etc/issue.net`                                                       | Path to the banner file to be used by sshd | defaults/main.yml |
| `sshd_config_dir`     | `/etc/ssh`                                                             | Directory containing sshd configuration    | vars/main.yml     |
| `sshd_config_path`    | `/etc/ssh/sshd_config`                                                 | Path to the SSH daemon configuration file  | defaults/main.yml |
| `sshd_service_name`   | `sshd`                                                                 | Name of the SSH service (used for restart) | vars/main.yml     |

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
    - "c:sshd -T -> r:^banner && r:/etc/issue\\.net$"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_banner
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
