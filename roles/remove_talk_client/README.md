```markdown
#### Role name:
    remove_talk_client

#### Wazuh ID:
    35584

#### Title:
    Ensure talk client is not installed.

#### Description:
    The talk software makes it possible for users to send and receive messages across systems through a terminal session. The talk client, which allows initialization of talk sessions, is installed by default.

#### Rationale:
    The software presents a security risk as it uses unencrypted protocols for communication.

#### Remediation:
    Uninstall talk: # apt purge talk.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages via `ansible.builtin.apt`)
    - OS: Debian/Ubuntu family (inferred from `tasks/main.yml`; role asserts `ansible_os_family == "Debian"`)
    - Required Ansible modules: `ansible.builtin.assert`, `ansible.builtin.apt`, `ansible.builtin.package_facts`, `ansible.builtin.set_fact`, `ansible.builtin.debug`

#### Variables

### defaults/main.yml

| Variable              | Default | Description |
|-----------------------|---------|-------------|
| `talk_package_name`   | talk    | Name of the package to remove (talk client). Used in `ansible.builtin.apt` tasks to purge the package. |

### vars/main.yml
No variables defined.

#### Dependencies
    Handlers: `handlers/main.yml` — present but empty; no handlers used as role performs only package removal and does not manage services.
    Dependencies on other roles: none

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
    - Tactic: TA0005 (Defense Evasion)  
    - Technique: T1036 (Masquerading), T1564 (Hide Artifacts)

#### Conditions
    all

#### Rules
    c:dpkg-query -s talk -> r:package 'talk' is not installed

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - remove_talk_client
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
```

### Date
    2026-06-23_17:50:37
