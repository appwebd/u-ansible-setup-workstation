#### Role name:
    remove_nis_client

#### Wazuh ID:
    35582

#### Title:
    Ensure NIS Client is not installed.

#### Description:
    The Network Information Service (NIS), formerly known as Yellow Pages, is a client-server directory service protocol used to distribute system configuration files. The NIS client was used to bind a machine to an NIS server and receive the distributed configuration files.

#### Rationale:
    The NIS service is inherently an insecure system that has been vulnerable to DOS attacks, buffer overflows and has poor authentication for querying NIS maps. NIS generally has been replaced by such protocols as Lightweight Directory Access Protocol (LDAP). It is recommended that the service be removed.

#### Remediation:
    Uninstall nis: # apt purge nis

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu family (inferred from `tasks/main.yml`)
    - Required Ansible collections/modules:
      - `ansible.builtin.assert`
      - `ansible.builtin.package_facts`
      - `ansible.builtin.set_fact`
      - `ansible.builtin.systemd`
      - `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable           | Default | Description |
|--------------------|---------|-------------|
| `nis_package_name` | `nis`   | Name of the NIS client package to remove (default: `nis`) |

### vars/main.yml
No variables defined.

#### Dependencies
Handlers: `handlers/main.yml` *(present but unused in current implementation)*  
Dependencies on other roles: *none*

#### Compliance mapping
- cmmc: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6
- fedramp: CM-2, CM-3, CM-6, CM-7
- gdpr: 32
- hipaa: 164.308(a)(1)
- iso_27001: A.12.1.1, A.12.1.2, A.14.2.1
- nis2: 21.2.e, 21.2.a
- nist_800_171: 3.4.7, 3.4.8, 3.13.6
- nist_800_53: CM-2, CM-3, CM-6, CM-7
- pci_dss: 1.1, 1.2, 2.2, 6.4
- tsc: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

#### Mitre
- tactic: TA0005
- technique: T1036, T1564

#### Conditions
all

#### Rules
c:dpkg-query -s nis -> r:package 'nis' is not installed

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - remove_nis_client
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-23_17:48:21
