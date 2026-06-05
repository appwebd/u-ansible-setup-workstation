#### Role name:
    restrict_su_access

#### Wazuh ID:
    35668

#### Title:
    Ensure access to the su command is restricted.

#### Description:
    This role ensures that access to the `su` command is restricted by configuring PAM to require membership in a designated group (by default `sugroup`) for `su` usage. It creates the group (if not present), ensures no conflicting or duplicate `pam_wheel.so` lines exist in `/etc/pam.d/su`, and enforces a single, correctly formatted `auth required pam_wheel.so use_uid group=<group>` line. The role modifies system configuration files and group definitions using `ansible.builtin.group`, `ansible.builtin.copy`, and `ansible.builtin.lineinfile` modules, and requires `become: yes` due to system-level changes.

#### Rationale:
    Restricting the use of `su`, and using `sudo` in its place, provides system administrators better control of the escalation of user privileges to execute privileged commands. The `sudo` utility also provides a better logging and audit mechanism, as it can log each command executed via `sudo`, whereas `su` can only record that a user executed the `su` program.

#### Remediation:
    Create an empty group that will be specified for use of the `su` command. The group should be named according to site policy. Example:  
    `# groupadd sugroup`  
    Add the following line to the `/etc/pam.d/su` file, specifying the empty group:  
    `auth required pam_wheel.so use_uid group=sugroup`

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to create system groups and modify `/etc/pam.d/su`)  
    - OS: Linux distributions using PAM (e.g., RHEL/CentOS, Debian/Ubuntu) — inferred from use of `/etc/pam.d/su`  
    - Required Ansible modules: `ansible.builtin.group`, `ansible.builtin.copy`, `ansible.builtin.lineinfile`  
    - Handler `Restart Systemd PAM` must be defined in `handlers/main.yml` (referenced in tasks but not provided; assumed present for idempotency)

#### Variables
| Variable                    | Default                                                          | Description                                                                                                                             | Source     |
|-----------------------------|------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|------------|
| `pam_su_file`               | `"/etc/pam.d/su"`                                                | Path to the PAM configuration file for `su`.                                                                                            | `defaults` |
| `pam_wheel_active_regex`    | *derived*                                                        | Regex pattern to match and remove existing uncommented `pam_wheel.so` lines (e.g., `^auth.*required.*pam_wheel\\.so.*use_uid.*group=`). | `vars`     |
| `pam_wheel_commented_regex` | *derived*                                                        | Regex pattern to match and remove commented `pam_wheel.so` lines (e.g., `^#.*auth.*required.*pam_wheel\\.so.*use_uid.*group=`).         | `vars`     |
| `pam_wheel_line`            | `"auth required pam_wheel.so use_uid group={{ su_group_name }}"` | The exact PAM line to enforce for `su` access restriction.                                                                              | `defaults` |
| `su_group_name`             | `"sugroup"`                                                      | Name of the group that will be required for `su` access; should be empty to enforce `sudo` usage.                                       | `defaults` |

#### Dependencies
    Handlers: `handlers/main.yml` *(must define `Restart Systemd PAM` handler; not provided in input, but referenced in tasks)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    cmmc: ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']  
    fedramp: ['AC-5', 'AC-6']  
    gdpr: ['32', '25', '30']  
    hipaa: ['164.312(a)(1)']  
    iso_27001: ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']  
    nis2: ['21.2.g', '21.2.j', '21.2.i']  
    nist_800_171: ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']  
    nist_800_53: ['AC-5', 'AC-6']  
    pci_dss: ['7.1', '1.3']  
    tsc: ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']

#### Mitre
    tactic: ['TA0009', 'TA0010']  
    technique: ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']  
    subtechnique: ['T1048.003', 'T1552.001']

#### Conditions
    all

#### Rules
    f:/etc/pam.d/su -> !r:^# && r:auth\s*required\s*pam_wheel\.so && r:use_uid && r:group=

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - restrict_su_access
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
