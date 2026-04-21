#### Role name: 
    restrict_core_dumps
#### Wazuh ID : 
    35543
#### Title    : 
    Restrict core dumps to prevent memory leaks
    
#### Description:
    This Ansible role disables core dumps on the system to prevent leakage of sensitive memory contents (e.g., passwords, encryption keys).
    Core dumps contain a snapshot of a process's memory and can expose critical information if not properly restricted.

#### Rationale:
    Core dumps are useful for debugging, but on production systems they pose a security risk. An attacker gaining access to a core dump 
    could extract sensitive data such as credentials, tokens, or cryptographic keys.

#### Remediation:
    - Set `* hard core 0` in `/etc/security/limits.d/99-core-dump-restrict.conf`
    - Set `fs.suid_dumpable = 0` in `/etc/sysctl.d/60-fs-sysctl.conf`
    - Configure systemd-coredump to disable storage (`Storage=none`)

#### Requirements            
    - Ansible 2.16 or higher
    - Root/sudo privileges (become: true)
    - Linux-based OS (Ubuntu/Debian tested)
    - `coreutils` and `systemd` (for sysctl and systemd-coredump)

#### Variables

| Variable                                      | Default  | Description                                 |
|-----------------------------------------------|----------|---------------------------------------------|
| `restrict_core_dumps_enabled`                 | `true`   | Enable/disable the role                     |
| `restrict_core_dumps_core_limit`              | `0`      | Core file size limit (soft/hard)            |
| `restrict_core_dumps_hard_limit`              | `true`   | Apply hard limit                            |
| `restrict_core_dumps_sysctl_value`            | `0`      | Value for `fs.suid_dumpable`                |
| `restrict_core_dumps_remove_systemd_coredump` | `false`  | Whether to disable systemd-coredump service |

#### Dependencies
    None

#### Compliance mapping
    'cmmc': ['SI.L2-4.4.1', 'SI.L2-4.4.2'], 
    'fedramp': ['SI-4', 'SI-4-2'], 
    'gdpr': ['32'], 
    'hipaa': ['164.308(a)(1)'], 
    'iso_27001': ['A.12.1.1', 'A.12.1.2'], 
    'nist_800_171': ['3.13.1', '3.13.2'], 
    'nist_800_53': ['SI-4'], 
    'pci_dss': ['2.2', '6.4'], 
    'tsc': ['CC6.3', 'CC6.6', 'CC5.1']

#### Mitre
    'tactic': ['TA0001', 'TA0011'], 
    'technique': ['T1005', 'T1212']

#### Conditions
     all

#### Rules
    - "c:ulimit -H -c 0 -> r:core file size (blocks, -c) 0"
    - "c:sysctl fs.suid_dumpable -> r:value is 0"
    - "c:systemctl is-enabled systemd-coredump -> r:unit not enabled"

#### Usage

```yaml
- hosts: servers
  become: true
  roles:
    - restrict_core_dumps
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
