#### Role name:
    sshd_hostbasedauthentication_disabled

#### Wazuh ID: 
    35649

#### Title: 
    Ensure sshd HostbasedAuthentication is disabled.

#### Description:
    The HostbasedAuthentication parameter specifies if authentication is allowed through trusted hosts via the user of .rhosts, or /etc/hosts.equiv, along with successful public key client host authentication.

#### Rationale:
    Even though the .rhosts files are ineffective if support is disabled in /etc/pam.conf, disabling the ability to use .rhosts files in SSH provides an additional layer of protection.

#### Remediation:
    Edit the /etc/ssh/sshd_config file to set the HostbasedAuthentication parameter to no above any Include and Match entries as follows: HostbasedAuthentication no Note: First occurrence of a option takes precedence, Match set statements withstanding. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server (`sshd`) installed
    - Read/write access to `/etc/ssh/sshd_config` or included configuration files

#### Variables

| Variable                             | Default                | Description                                                 | file              |
|--------------------------------------|------------------------|-------------------------------------------------------------|-------------------|
| `sshd_config_file`                   | `/etc/ssh/sshd_config` | Path to the main SSH daemon configuration file              | defaults/main.yml |
| `sshd_hostbasedauthentication_value` | `"no"`                 | Value to set for `HostbasedAuthentication` directive        | defaults/main.yml |
| `sshd_service_name`                  | `sshd`                 | Name of the SSH daemon service (used for restart if needed) | vars/main.yml     |

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
    - `c:sshd -T -> r:^hostbasedauthentication no`
    - `not f:/etc/ssh/sshd_config -> r:^\\s*\\t*HostBasedAuthentication\\s*\\t*yes`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - sshd_hostbasedauthentication_disabled
```

Optionally override variables:

```code
- hosts: servers
  become: true
  vars:
    sshd_config_file: /etc/ssh/sshd_config.d/custom.conf
  roles:
    - sshd_hostbasedauthentication_disabled
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
