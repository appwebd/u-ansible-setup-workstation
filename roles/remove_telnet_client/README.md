#### Role name:
    remove_telnet_client

#### Wazuh ID:
    35585

#### Title:
    Ensure telnet client is not installed.

#### Description:
    The inetutils-telnet package contains the telnet client, which allows users to start connections to other systems via the telnet protocol.

#### Rationale:
    The telnet protocol is insecure and unencrypted. The use of an unencrypted transmission medium could allow an unauthorized user to steal credentials. The ssh package provides an encrypted session and stronger security and is included in most Linux distributions.

#### Remediation:
    Run the following commands to uninstall telnet & inetutils-telnet:  
    ```bash
    # apt purge telnet  
    # apt purge inetutils-telnet
    ```

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages and configuration)
    - OS: Debian/Ubuntu family (inferred from `tasks/main.yml`)
    - Required Ansible modules:
      - `ansible.builtin.assert`
      - `ansible.builtin.package_facts`
      - `ansible.builtin.set_fact`
      - `ansible.builtin.apt`
      - `ansible.builtin.shell`

#### Variables

### defaults/main.yml

| Variable                    | Default                             | Description |
|-----------------------------|-------------------------------------|-------------|
| `telnet_package_names`      | `['telnet', 'inetutils-telnet']`    | List of telnet client package names to remove. |

### vars/main.yml
No variables defined.

#### Dependencies
    Handlers: `handlers/main.yml` *(present but unused in current tasks)*  
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
    - Tactic: TA0005  
    - Technique: T1036, T1564

#### Conditions
    all

#### Rules
    not c:dpkg-query -s telnet inetutils-telnet -> r:^Status: install ok installed

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - remove_telnet_client
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-22_18:54:36
