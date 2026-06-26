#### Role name:
    remove_ldap_client

#### Wazuh ID:
    35586

#### Title:
    Ensure ldap client is not installed

#### Description:
    The Lightweight Directory Access Protocol (LDAP) was introduced as a replacement for NIS/YP. It is a service that provides a method for looking up information from a central database.

#### Rationale:
    If the system will not need to act as an LDAP client, it is recommended that the software be removed to reduce the potential attack surface.

#### Remediation:
    Uninstall ldap-utils: # apt purge ldap-utils

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: e.g., `ansible.builtin.assert`, `ansible.builtin.package_facts`, `ansible.builtin.set_fact`, `ansible.builtin.apt`, `ansible.builtin.debug`, `ansible.builtin.lineinfile`, etc., used explicitly in tasks

#### Variables

### defaults/main.yml

| Variable           | Default     | Description                          |
|--------------------|-------------|--------------------------------------|
| ldap_package_name  | ldap-utils  | Package name to remove (LDAP client) |

### vars/main.yml
| Variable               | Default | Description |
|------------------------|---------|-------------|
| No variables defined.  |         |             |

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists)*
    Dependencies on other roles: *none / list*

#### Compliance mapping
    cmmc: ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6']
    fedramp: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    gdpr: ['32']
    hipaa: ['164.308(a)(1)']
    iso_27001: ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']
    nis2: ['21.2.e', '21.2.a']
    nist_800_171: ['3.4.7', '3.4.8', '3.13.6']
    nist_800_53: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    pci_dss: ['1.1', '1.2', '2.2', '6.4']
    tsc: ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']

#### Mitre
    tactic: ['TA0005']
    technique: ['T1036', 'T1564']

#### Conditions
    all

#### Rules
    c:dpkg-query -s ldap-utils -> r:package 'ldap-utils' is not installed

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - remove_ldap_client
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-26_15:30:03
