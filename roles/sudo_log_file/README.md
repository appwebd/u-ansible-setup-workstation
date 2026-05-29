#### Role name:
    sudo_log_file

#### Wazuh ID:
    35664

#### Title:
    Ensure sudo log file exists.

#### Description:
    This role ensures that sudo is configured to log to a dedicated log file by creating a dedicated configuration file in `/etc/sudoers.d/` and ensuring the log file itself exists. It creates the `/etc/sudoers.d/` directory (if missing) with secure permissions, writes a `Defaults logfile="..."` directive to a file named `01-sudo-log` in `/etc/sudoers.d/`, and touches the specified log file (default: `/var/log/sudo.log`) with appropriate ownership and permissions. The role uses `visudo -cf` to validate the sudoers snippet before applying it, and defines a handler to reload sudo configuration (via `systemctl reload sudo` or equivalent). All operations require root privileges.

#### Rationale:
    A sudo log file simplifies auditing of sudo commands.

#### Remediation:
    Edit the file `/etc/sudoers` or a file in `/etc/sudoers.d/` with `visudo` or `visudo -f <PATH TO FILE>` and add the following line:  
    `Defaults logfile="/var/log/sudo.log"`  
    Note:  
    - sudo will read each file in `/etc/sudoers.d`, skipping file names that end in `~` or contain a `.` character to avoid causing problems with package manager or editor temporary/backup files.  
    - Files are parsed in sorted lexical order. That is, `/etc/sudoers.d/01_first` will be parsed before `/etc/sudoers.d/10_second`.  
    - Be aware that because the sorting is lexical, not numeric, `/etc/sudoers.d/1_whoops` would be loaded after `/etc/sudoers.d/10_second`.  
    - Using a consistent number of leading zeroes in the file names can be used to avoid such problems.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify `/etc/sudoers.d/`, create log files, and manage service configuration)  
    - OS: Linux distributions using `sudo` (tested on Ubuntu/Debian; Red Hat/CentOS likely supported)  
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.service` (via handler)  
    - `visudo` must be available on the target host (used for validation)  
    - `systemctl` or equivalent service manager for handler notification

#### Variables
| Variable               | Default                      | Description                                                                                     | Source     |
|------------------------|------------------------------|-------------------------------------------------------------------------------------------------|------------|
| `sudo_log_file_path`   | `/var/log/sudo.log`          | Path to the sudo log file to be created and referenced in sudoers configuration.                | `defaults` |
| `sudoers_d_file_group` | `root`                       | Group owner of the sudoers drop-in file.                                                        | `vars`     |
| `sudoers_d_file_mode`  | `0440`                       | File permissions for the sudoers drop-in file (read-only for owner, read-only for group).       | `vars`     |
| `sudoers_d_file_owner` | `root`                       | Owner of the sudoers drop-in file.                                                              | `vars`     |

#### Dependencies
    Handlers: `handlers/main.yml` *(not provided in input; assumed to exist and define `Reload sudo configuration` handler using `ansible.builtin.service`)*  
    Dependencies on other roles: none

#### Compliance mapping
    cmmc: ['AU.L2-3.3.1'], fedramp: ['AU-3', 'AU-7'], gdpr: ['32', '33'], hipaa: ['164.312(b)', '164.308(a)(6)'], iso_27001: ['A.12.4.1', 'A.12.4.2', 'A.12.4.3', 'A.16.1.2'], nis2: ['21.2.a', '23', '21.2.b'], nist_800_171: ['3.3.1'], nist_800_53: ['AU-3', 'AU-7'], pci_dss: ['10.1', '10.2', '10.3', '9.4'], tsc: ['CC5.2', 'CC7.2', 'CC7.1', 'CC7.3', 'CC7.4', 'CC7.5', 'CC4.1', 'CC4.2']

#### Mitre
    tactic: ['TA0005', 'TA0006', 'TA0007'], technique: ['T1562', 'T1070', 'T1059', 'T1040'], subtechnique: ['T1562.002', 'T1070.001']

#### Conditions
    any

#### Rules
    f:/etc/sudoers -> r:^\\s*\\t*Defaults\\s*\\t*logfile=\\S+\\.log, d:/etc/sudoers.d -> \\.* -> r:^\\s*\\t*Defaults\\s*\\t*logfile=\\S+\\.log

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - sudo_log_file
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
