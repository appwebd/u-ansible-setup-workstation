## Role name: enable_aslr
## Wazuh ID : 35542
## Title    : Ensure Address Space Layout Randomization (ASLR) is enabled

## Description:
    This Ansible role enables Address Space Layout Randomization (ASLR), a core Linux kernel security feature that randomizes the memory layout of processes to make exploitation of memory corruption vulnerabilities significantly more difficult. This role addresses security rule **35542** (Wazuh/CIS).

## Rationale:
    ASLR is a critical defense-in-depth mechanism that randomizes the location of key memory areas (stack, heap, libraries, etc.) to prevent attackers from reliably predicting memory addresses for code execution or data exploitation. Disabling or weakening ASLR (e.g., setting `kernel.randomize_va_space` to 0 or 1) greatly increases system vulnerability to memory corruption attacks.

## Remediation:
    Set `kernel.randomize_va_space = 2` (full ASLR) in `/etc/sysctl.d/60-aslr.conf` and reload sysctl settings.  
    Run: `echo "kernel.randomize_va_space = 2" > /etc/sysctl.d/60-aslr.conf` and `sysctl --system`.

## Requirements
    - Ansible 2.16 or higher
    - Root/sudo privileges (`become: true`)
    - Linux kernel ≥ 2.6.12 (ASLR support)
    - `/proc/sys/kernel/randomize_va_space` writable (standard on modern kernels)

## Variables

| Variable           | Default                      | Description                                           |
|--------------------|------------------------------|-------------------------------------------------------|
| `aslr_enabled`     | `true`                       | Whether to enable ASLR (must be true for any effect)  |
| `aslr_level`       | `2`                          | ASLR policy level: 0=disabled, 1=conservative, 2=full |
| `aslr_sysctl_file` | `/etc/sysctl.d/60-aslr.conf` | Path to sysctl configuration file                     |
| `aslr_sysctl_key`  | `kernel.randomize_va_space`  | Sysctl key name                                       |

## Dependencies
    None

## Compliance mapping
    'cmmc': ['SC.L2-3.13.5'], 
    'fedramp': ['SI-4.2', 'SC-4'], 
    'gdpr': ['32'], 
    'hipaa': ['164.308(a)(1)'], 
    'iso_27001': ['A.12.1.1', 'A.12.5.1', 'A.14.2.1'], 
    'nis2': ['21.2.e', '21.2.a'], 
    'nist_800_171': ['3.13.5'], 
    'nist_800_53': ['SI-4', 'SC-4'], 
    'pci_dss': ['2.2', '6.4'], 
    'tsc': ['CC6.3', 'CC6.6']

## Mitre
    'tactic': ['TA0001', 'TA0005'], 
    'technique': ['T1548', 'T1055', 'T1036']

## Conditions
     all Linux systems with kernel randomization support

## Rules
    - "c:sysctl kernel.randomize_va_space -> r:value >= 2"

## Usage
Include this role in your playbook:
```code
- hosts: servers
  become: true
  roles:
    - enable_aslr
```

## License
  Apache 2.0

## Author
Patricio Rojas Ortiz
