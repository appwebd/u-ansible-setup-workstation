#### Role name:
    enforce_sudo_password

#### Wazuh ID:
    35665

#### Title:
    Ensure users must provide password for privilege escalation.

#### Description:
    The operating system must be configured so that users must provide a password for privilege escalation.

#### Rationale:
    Without (re-)authentication, users may access resources or perform tasks for which they do not have authorization. When operating systems provide the capability to escalate a functional capability, it is critical the user (re-)authenticate.

#### Remediation:
    Based on the outcome of the audit procedure, use visudo -f <PATH TO FILE> to edit the relevant sudoers file. Remove any line with occurrences of NOPASSWD tags in the file.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system configuration files under `/etc`)
    - OS: Linux distributions with `sudo` package (Debian/Ubuntu) — inferred from use of `ansible.builtin.package_facts` and `/etc/sudoers` paths
    - Required Ansible modules: `ansible.builtin.package_facts`, `ansible.builtin.debug`, `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.find`, `ansible.builtin.lineinfile`, `ansible.builtin.fail`
    - `visudo` must be available on target hosts (used in `validate` parameter)

#### Variables

### defaults/main.yml

| Variable                   | Default                              | Description                                                                                |
|----------------------------|--------------------------------------|--------------------------------------------------------------------------------------------|
| `sudoers_backup_dir`       | `/etc/sudoers.d.bak`                 | Directory to store sudoers backups (overridden in `vars/main.yml`).                        |
| `sudoers_backup_enabled`   | `true`                               | Whether to create backups of sudoers files before modification.                            |
| `sudoers_backup_timestamp` | `false`                              | Whether to append ISO8601 timestamp to backup filenames.                                   |
| `sudoers_files`            | `['/etc/sudoers', '/etc/sudoers.d']` | List of sudoers file paths to process; includes main sudoers file and sudoers.d directory. |


#### Dependencies
    Handlers: `handlers/main.yml` — *not provided in input; not referenced in `tasks/main.yml`* (notify: "Validate sudoers syntax" appears, but no handler defined — likely missing or external; cannot confirm existence from input).
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: AC.L2-3.1.5, AC.L2-3.1.6, AC.L2-3.1.7, SC.L2-3.13.3
    - FedRAMP: AC-6
    - GDPR: 32
    - HIPAA: 164.308(a)(4), 164.312(a)(1), 164.312(d), 164.312(b)
    - ISO 27001: A.9.2.1, A.9.2.2, A.9.2.5, A.9.2.6, A.9.2.4, A.9.4.2
    - NIS2: 21.2.i, 21.2.k
    - NIST 800-171: 3.1.5, 3.1.6, 3.1.7, 3.13.3
    - NIST 800-53: AC-6
    - PCI DSS: 7.1
    - TSC: CC6.1, CC6.2, CC6.3, CC6.4, CC6.5, CC6.6, CC6.7, CC6.8, CC7.1, CC7.2, CC7.3, CC7.4, CC7.5

#### Mitre
    - Tactics: TA0006 (Credential Access), TA0003 (Persistence)
    - Techniques: T1078 (Valid Accounts), T1098 (Account Manipulation), T1110 (Brute Force), T1136 (Create Account), T1556 (Modify Authentication Process)  
    - Sub-techniques: T1556.001 (Modify Authentication Process: Configure SSH Key-Based Authentication), T1550.001 (Use Alternate Authentication Material: Application Access Token), T1550.002 (Use Alternate Authentication Material: Pass the Hash)  

#### Conditions
    none

#### Rules
    - `f:/etc/sudoers -> r:^\\s*\\t*NOPASSWD`  
    - `d:/etc/sudoers.d -> r:.* -> r:^\\s*\\t*NOPASSWD`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - enforce_sudo_password
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
