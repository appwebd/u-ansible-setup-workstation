#### Role name:
    sudo_timestamp_timeout

#### Wazuh ID:
    35667

#### Title:
    Ensure sudo authentication timeout is configured correctly.

#### Description:
    This role ensures that the sudo authentication timestamp timeout is configured to a secure value (≤15 minutes) by creating a dedicated configuration file in `/etc/sudoers.d/`. It enforces the timeout via a `Defaults timestamp_timeout=<value>` entry, validates the sudoers syntax using `visudo`, and explicitly checks for and fails on conflicting `timestamp_timeout` entries in both `/etc/sudoers` and `/etc/sudoers.d/` to prevent inconsistent or insecure configurations.

#### Rationale:
    Setting a timeout value reduces the window of opportunity for unauthorized privileged access to another user.

#### Remediation:
    If the currently configured timeout is larger than 15 minutes, edit the file listed in the audit section with `visudo -f <PATH TO FILE>` and modify the entry `timestamp_timeout=` to 15 minutes or less as per your site policy. The value is in minutes. This particular entry may appear on its own, or on the same line as `env_reset`. See the following two examples:  
    `Defaults env_reset, timestamp_timeout=15`  
    `Defaults timestamp_timeout=15`  
    `Defaults env_reset`.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify system files in `/etc/sudoers.d/` and `/etc/sudoers`)  
    - OS: Linux distributions using `sudo` with `/etc/sudoers` and `/etc/sudoers.d/` (e.g. Debian/Ubuntu)  
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.lineinfile`, `ansible.builtin.find`, `ansible.builtin.fail`  
    - `visudo` must be available on the target host (used in `validate` parameter)

#### Variables
| Variable                       | Default                                  | Description                                                                                  | Source     |
|--------------------------------|------------------------------------------|----------------------------------------------------------------------------------------------|------------|
| `sudo_timestamp_timeout_value` | `15`                                     | Desired sudo authentication timestamp timeout in minutes (must be ≥0 and ≤15 per Wazuh rule) | `defaults` |
| `sudoers_d_dir`                | `/etc/sudoers.d`                         | Directory where sudo drop-in configuration files reside                                      | `defaults` |
| `sudoers_d_file_group`         | `root`                                   | Group owner of the drop-in sudoers file                                                      | `vars`     |
| `sudoers_d_file_mode`          | `0440`                                   | File permissions for the drop-in sudoers file (read-only for root, group-readable)           | `vars`     |
| `sudoers_d_file_owner`         | `root`                                   | Owner of the drop-in sudoers file                                                            | `vars`     |
| `sudoers_d_file`               | `/etc/sudoers.d/wazuh_timestamp_timeout` | Full path to the drop-in file created by this role                                           | `defaults` |
| `sudoers_file`                 | `/etc/sudoers`                           | Path to the main sudoers file to scan for conflicting entries                                | `defaults` |

#### Dependencies
    Handlers: `handlers/main.yml` *(not provided in input; not used in tasks)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    cmmc: ['AC.L2-3.1.5', 'AC.L2-3.1.6', 'AC.L2-3.1.7', 'SC.L2-3.13.3']  
    fedramp: ['AC-6']  
    gdpr: ['32']  
    hipaa: ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)']  
    iso_27001: ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2']  
    nis2: ['21.2.i', '21.2.k']  
    nist_800_171: ['3.1.5', '3.1.6', '3.1.7', '3.13.3']  
    nist_800_53: ['AC-6']  
    pci_dss: ['7.1']  
    tsc: ['CC6.1', 'CC6.3', 'CC6.2', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']

#### Mitre
    tactic: ['TA0006', 'TA0003']  
    technique: ['T1078', 'T1098', 'T1110', 'T1136', 'T1556']  
    subtechnique: ['T1556.001', 'T1550.001', 'T1550.002']

#### Conditions
    any

#### Rules
    f:/etc/sudoers -> !r:^\\s*\\t*# && n:^\\s*\\t*timestamp_timeout=(\\d+) compare <= 15 && n:^\\s*\\t*timestamp_timeout=(\\d+) compare >= 0  
    d:/etc/sudoers.d -> r:.* -> !r:^\\s*\\t*# && n:^\\s*\\t*timestamp_timeout=(\\d+) compare <= 15 && n:^\\s*\\t*timestamp_timeout=(\\d+) compare >= 0  
    c:sudo -V -> n:Authentication timestamp timeout:\\s*\\t*(\\d+) compare <= 15 && n:Authentication timestamp timeout:\\s*\\t*(\\d+) compare >= 0

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - sudo_timestamp_timeout
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
