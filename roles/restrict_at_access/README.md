#### Role name:
    restrict_at_access

#### Wazuh ID: 
    35601

#### Title: 
    Ensure at is restricted to authorized users.

#### Description:
    This Ansible role ensures that the `at` command is restricted to authorized users by properly configuring `/etc/at.allow` and `/etc/at.deny` files. It enforces the principle of least privilege by allowing only specified users to schedule `at` and `batch` jobs.

#### Rationale:
    On many systems, only the system administrator is authorized to schedule at jobs. Using the at.allow file to control who can run at jobs enforces this policy. It is easier to manage an allow list than a deny list. In a deny list, you could potentially add a user ID to the system and forget to add it to the deny files.

#### Remediation:
    - IF at is installed on the system:
        - Create `/etc/at.allow` if it does not exist
        - Set owner to `root`
        - Set group to `daemon` if it exists, otherwise `root`
        - Set permissions to `640` or more restrictive (e.g., `600`, `400`)
    - IF `/etc/at.deny` exists:
        - Set owner to `root`
        - Set group to `daemon` if it exists, otherwise `root`
        - Set permissions to `640` or more restrictive

#### Requirements
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux systems with `at` package (role handles both presence and absence of `at`)
    - `stat`, `grep`, `chown`, `chmod`, and `touch` utilities available

#### Variables

| Variable             | Default         | Description                                                                      | source            |
|----------------------|-----------------|----------------------------------------------------------------------------------|-------------------|
| `at_allow_file`      | `/etc/at.allow` | Path to the at allow file                                                        | defaults/main.yml |
| `at_allow_group`     | `daemon`        | Preferred group for at configuration files (falls back to `root` if not present) | defaults/main.yml |
| `at_allow_mode`      | `0640`          | Desired permissions for `/etc/at.allow` (must be octal string)                   | defaults/main.yml |
| `at_allow_owner`     | `root`          | Owner of at configuration files                                                  | defaults/main.yml |
| `at_deny_file`       | `/etc/at.deny`  | Path to the at deny file                                                         | defaults/main.yml |
| `at_deny_mode`       | `0640`          | Desired permissions for `/etc/at.deny` (must be octal string)                    | defaults/main.yml |
| `at_package_name`    | `at`            | Package name for `at` utility                                                    | vars/main.yml     |

#### Dependencies
    None

#### Compliance mapping
    - cmmc: ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']
    - fedramp: ['AC-5', 'AC-6']
    - gdpr: ['32', '25', '30']
    - hipaa: ['164.312(a)(1)']
    - iso_27001: ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']
    - nis2: ['21.2.g', '21.2.j', '21.2.i']
    - nist_800_171: ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']
    - nist_800_53: ['AC-5', 'AC-6']
    - pci_dss: ['7.1', '1.3']
    - tsc: ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']

#### Mitre
    - tactic: ['TA0009', 'TA0010']
    - technique: ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']
    - subtechnique: ['T1048.003', 'T1552.001']

#### Conditions
    all

#### Rules
    - "f:/etc/at.allow"
    - "c:stat -Lc "%a" /etc/at.allow -> r:640|600|400"
    - "c:stat -Lc "%U %G" /etc/at.allow -> r:^root root$|^root daemon$"
    - "c:dpkg-query -s at -> r:Status: install ok installed"

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - restrict_at_access
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
